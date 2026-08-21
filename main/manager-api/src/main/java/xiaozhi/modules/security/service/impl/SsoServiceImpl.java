package xiaozhi.modules.security.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.zhyd.oauth.config.AuthConfig;
import me.zhyd.oauth.model.AuthCallback;
import me.zhyd.oauth.model.AuthResponse;
import me.zhyd.oauth.model.AuthUser;
import me.zhyd.oauth.request.AuthAppleRequest;
import me.zhyd.oauth.request.AuthGithubRequest;
import me.zhyd.oauth.request.AuthGoogleRequest;
import me.zhyd.oauth.request.AuthMicrosoftRequest;
import me.zhyd.oauth.request.AuthRequest;
import xiaozhi.common.exception.ErrorCode;
import xiaozhi.common.exception.RenException;
import xiaozhi.common.page.TokenDTO;
import xiaozhi.common.redis.RedisUtils;
import xiaozhi.common.utils.JsonUtils;
import xiaozhi.common.utils.Result;
import xiaozhi.modules.security.dao.SysUserOauthDao;
import xiaozhi.modules.security.entity.SysUserOauthEntity;
import xiaozhi.modules.security.oauth2.TokenGenerator;
import xiaozhi.modules.security.service.SsoService;
import xiaozhi.modules.security.service.SysUserTokenService;
import xiaozhi.modules.security.sso.SsoProperties;
import xiaozhi.modules.sys.dto.SysUserDTO;
import xiaozhi.modules.sys.service.SysUserService;

/**
 * SSO (OAuth2/OIDC) login service implementation.
 */
@Slf4j
@AllArgsConstructor
@Service
public class SsoServiceImpl implements SsoService {

    private final SsoProperties ssoProperties;
    private final RedisUtils redisUtils;
    private final SysUserOauthDao sysUserOauthDao;
    private final SysUserService sysUserService;
    private final SysUserTokenService sysUserTokenService;

    /**
     * Redis key prefix for pending SSO sessions.
     */
    private static final String SSO_PENDING_KEY = "sso:pending:";
    /**
     * Pending SSO session expiry (10 minutes, in seconds).
     */
    private static final long SSO_PENDING_EXPIRE = 60 * 10L;

    private static final String[] PROVIDERS = { "google", "apple", "microsoft", "github" };

    @Override
    public List<String> getEnabledProviders() {
        List<String> enabled = new ArrayList<>();
        for (String provider : PROVIDERS) {
            SsoProperties.Provider cfg = ssoProperties.getProviders().get(provider);
            if (cfg != null && StringUtils.isNotBlank(cfg.getClientId())) {
                enabled.add(provider);
            }
        }
        return enabled;
    }

    @Override
    public String getAuthorizeUrl(String provider) {
        AuthRequest authRequest = buildAuthRequest(provider);
        return authRequest.authorize(TokenGenerator.generateValue());
    }

    @Override
    public String handleCallback(String provider, String code, String state) {
        AuthRequest authRequest = buildAuthRequest(provider);
        AuthCallback callback = AuthCallback.builder().code(code).state(state).build();
        AuthResponse<AuthUser> response = authRequest.login(callback);
        if (response == null || !response.ok() || response.getData() == null) {
            log.warn("SSO login failed for provider {}: {}", provider,
                    response == null ? "null response" : response.getMsg());
            throw new RenException(ErrorCode.SSO_AUTH_FAILED);
        }
        AuthUser authUser = response.getData();

        // Store a pending SSO session so the passcode can be verified later.
        String ssoState = TokenGenerator.generateValue();
        Map<String, Object> pending = new HashMap<>();
        pending.put("provider", provider);
        pending.put("providerUserId", authUser.getUuid());
        pending.put("email", authUser.getEmail());
        pending.put("nickname", authUser.getNickname());
        pending.put("avatar", authUser.getAvatar());
        redisUtils.set(SSO_PENDING_KEY + ssoState, JsonUtils.toJsonString(pending), SSO_PENDING_EXPIRE);

        // Redirect the browser back to the frontend, which prompts for the passcode.
        String base = ssoProperties.getFrontendRedirectUrl();
        if (StringUtils.isBlank(base)) {
            throw new RenException(ErrorCode.SSO_FRONTEND_NOT_CONFIGURED);
        }
        return base + "/sso-callback?sso_state=" + ssoState;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<TokenDTO> verifyPasscode(String ssoState, String passcode) {
        if (StringUtils.isBlank(ssoState) || StringUtils.isBlank(passcode)) {
            throw new RenException(ErrorCode.SSO_PASSCODE_REQUIRED);
        }
        if (!ssoProperties.getPasscode().equals(passcode)) {
            throw new RenException(ErrorCode.SSO_PASSCODE_ERROR);
        }

        Object pendingObj = redisUtils.get(SSO_PENDING_KEY + ssoState);
        if (pendingObj == null) {
            throw new RenException(ErrorCode.SSO_STATE_EXPIRED);
        }
        Map<String, Object> pending = JsonUtils.parseMap(pendingObj.toString());
        if (pending == null) {
            throw new RenException(ErrorCode.SSO_STATE_EXPIRED);
        }
        // Consume the pending session (single use).
        redisUtils.delete(SSO_PENDING_KEY + ssoState);

        String provider = (String) pending.get("provider");
        String providerUserId = (String) pending.get("providerUserId");
        String email = (String) pending.get("email");
        String nickname = (String) pending.get("nickname");

        Long userId = findOrCreateUser(provider, providerUserId, email, nickname);
        return sysUserTokenService.createToken(userId);
    }

    @Override
    public Map<String, Object> getPublicConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("enabled", ssoProperties.isEnabled());
        config.put("providers", getEnabledProviders());
        config.put("passcodeRequired", StringUtils.isNotBlank(ssoProperties.getPasscode()));
        return config;
    }

    /**
     * Build the JustAuth {@link AuthRequest} for the given provider.
     */
    private AuthRequest buildAuthRequest(String provider) {
        SsoProperties.Provider cfg = ssoProperties.getProviders().get(provider);
        if (cfg == null || StringUtils.isBlank(cfg.getClientId())) {
            throw new RenException(ErrorCode.SSO_PROVIDER_NOT_CONFIGURED);
        }
        AuthConfig.AuthConfigBuilder builder = AuthConfig.builder()
                .clientId(cfg.getClientId())
                .clientSecret(cfg.getClientSecret())
                .redirectUri(cfg.getRedirectUri());
        return switch (provider) {
            case "google" -> new AuthGoogleRequest(builder.build());
            case "github" -> new AuthGithubRequest(builder.build());
            case "microsoft" -> new AuthMicrosoftRequest(builder.build());
            case "apple" -> new AuthAppleRequest(builder
                    .teamId(cfg.getTeamId())
                    .kid(cfg.getKeyId())
                    .build());
            default -> throw new RenException(ErrorCode.SSO_PROVIDER_NOT_SUPPORTED);
        };
    }

    /**
     * Find the local user linked to this provider identity, or create + link a new one.
     */
    private Long findOrCreateUser(String provider, String providerUserId, String email, String nickname) {
        QueryWrapper<SysUserOauthEntity> qw = new QueryWrapper<>();
        qw.eq("provider", provider).eq("provider_user_id", providerUserId);
        SysUserOauthEntity link = sysUserOauthDao.selectOne(qw);
        if (link != null) {
            return link.getUserId();
        }

        String username = StringUtils.isNotBlank(email) ? email : "sso_" + provider + "_" + providerUserId;
        username = ensureUniqueUsername(username);

        SysUserDTO dto = new SysUserDTO();
        dto.setUsername(username);
        dto.setPassword(generateRandomPassword());
        sysUserService.save(dto);

        SysUserDTO saved = sysUserService.getByUsername(username);
        if (saved == null) {
            throw new RenException(ErrorCode.SSO_USER_CREATE_FAILED);
        }

        SysUserOauthEntity newLink = new SysUserOauthEntity();
        newLink.setUserId(saved.getId());
        newLink.setProvider(provider);
        newLink.setProviderUserId(providerUserId);
        sysUserOauthDao.insert(newLink);
        return saved.getId();
    }

    /**
     * Ensure the username is unique; append a numeric suffix if it is already taken.
     */
    private String ensureUniqueUsername(String username) {
        String candidate = username;
        int suffix = 1;
        while (sysUserService.getByUsername(candidate) != null) {
            candidate = username + "_" + suffix;
            suffix++;
        }
        return candidate;
    }

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
    private static final Random RANDOM = new Random();

    /**
     * Generate a random strong password (meets the project's strength rules).
     */
    private String generateRandomPassword() {
        StringBuilder password = new StringBuilder();
        password.append("0123456789".charAt(RANDOM.nextInt(10)));
        password.append("abcdefghijklmnopqrstuvwxyz".charAt(RANDOM.nextInt(26)));
        password.append("ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(RANDOM.nextInt(26)));
        password.append("!@#$%^&*()".charAt(RANDOM.nextInt(10)));
        for (int i = 4; i < 12; i++) {
            password.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        char[] chars = password.toString().toCharArray();
        for (int i = 0; i < chars.length; i++) {
            int randomIndex = RANDOM.nextInt(chars.length);
            char tmp = chars[i];
            chars[i] = chars[randomIndex];
            chars[randomIndex] = tmp;
        }
        return new String(chars);
    }
}
