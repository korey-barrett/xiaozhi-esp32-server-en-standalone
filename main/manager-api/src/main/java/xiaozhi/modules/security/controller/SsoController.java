package xiaozhi.modules.security.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import xiaozhi.common.exception.ErrorCode;
import xiaozhi.common.exception.RenException;
import xiaozhi.common.page.TokenDTO;
import xiaozhi.common.utils.Result;
import xiaozhi.common.validator.ValidatorUtils;
import xiaozhi.modules.security.dto.SsoVerifyDTO;
import xiaozhi.modules.security.service.SsoService;
import xiaozhi.modules.security.sso.SsoProperties;

/**
 * SSO (OAuth2/OIDC) login control layer.
 */
@AllArgsConstructor
@RestController
@RequestMapping("/user/sso")
@Tag(name = "SSO Login Management")
public class SsoController {

    private final SsoService ssoService;
    private final SsoProperties ssoProperties;

    @GetMapping("/providers")
    @Operation(summary = "SSO public configuration")
    public Result<Map<String, Object>> providers() {
        return new Result<Map<String, Object>>().ok(ssoService.getPublicConfig());
    }

    @GetMapping("/render")
    @Operation(summary = "Get the provider authorization URL")
    public Result<Map<String, Object>> render(@RequestParam("provider") String provider) {
        checkEnabled();
        String url = ssoService.getAuthorizeUrl(provider);
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);
        return new Result<Map<String, Object>>().ok(data);
    }

    @GetMapping("/callback")
    @Operation(summary = "OAuth2 callback")
    public void callback(@RequestParam("provider") String provider,
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "state", required = false) String state,
            HttpServletResponse response) throws IOException {
        checkEnabled();
        String redirectUrl = ssoService.handleCallback(provider, code, state);
        response.sendRedirect(redirectUrl);
    }

    @PostMapping("/verify")
    @Operation(summary = "Verify the passcode and complete SSO login")
    public Result<TokenDTO> verify(@RequestBody SsoVerifyDTO dto) {
        checkEnabled();
        ValidatorUtils.validateEntity(dto);
        return ssoService.verifyPasscode(dto.getSsoState(), dto.getPasscode());
    }

    private void checkEnabled() {
        if (!ssoProperties.isEnabled()) {
            throw new RenException(ErrorCode.SSO_DISABLED);
        }
    }
}
