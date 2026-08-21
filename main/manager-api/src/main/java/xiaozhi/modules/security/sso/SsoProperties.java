package xiaozhi.modules.security.sso;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

/**
 * SSO (OAuth2/OIDC) configuration.
 * <p>
 * Configured under the {@code xiaozhi.sso} prefix in application.yml. Each provider
 * (google, apple, microsoft, github) is enabled by supplying its client-id, client-secret
 * and redirect-uri. The {@code passcode} is a required second factor that the user must
 * enter after authenticating with the provider.
 */
@Data
@Component
@ConfigurationProperties(prefix = "xiaozhi.sso")
public class SsoProperties {

    /**
     * Master switch for SSO login. When false, the SSO endpoints are disabled.
     */
    private boolean enabled = false;

    /**
     * Required passcode (second factor) that the user must enter after SSO authentication.
     */
    private String passcode = "";

    /**
     * Frontend base URL to redirect the browser back to after the OAuth callback
     * (e.g. {@code http://192.168.0.195:8002}). The callback appends {@code /sso-callback?sso_state=...}.
     */
    private String frontendRedirectUrl = "";

    /**
     * Per-provider OAuth2 configuration keyed by provider name (google, apple, microsoft, github).
     */
    private Map<String, Provider> providers = new LinkedHashMap<>();

    @Data
    public static class Provider {
        private String clientId = "";
        private String clientSecret = "";
        private String redirectUri = "";
        /**
         * Apple only: team id (10-char team identifier).
         */
        private String teamId = "";
        /**
         * Apple only: key id (10-char key identifier).
         */
        private String keyId = "";
    }
}
