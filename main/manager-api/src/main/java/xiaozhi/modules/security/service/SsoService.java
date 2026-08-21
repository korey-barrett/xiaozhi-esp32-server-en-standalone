package xiaozhi.modules.security.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.TokenDTO;
import xiaozhi.common.utils.Result;

/**
 * SSO (OAuth2/OIDC) login service.
 */
public interface SsoService {

    /**
     * List the enabled SSO providers (those with a configured client-id).
     *
     * @return list of provider names
     */
    List<String> getEnabledProviders();

    /**
     * Build the provider's authorization URL for the given provider.
     *
     * @param provider provider name (google, apple, microsoft, github)
     * @return the authorization URL
     */
    String getAuthorizeUrl(String provider);

    /**
     * Handle the OAuth2 callback: exchange the code for the provider user, store a pending
     * SSO session, and return the frontend redirect URL (with the sso_state).
     *
     * @param provider provider name
     * @param code     authorization code
     * @param state    OAuth state
     * @return the frontend redirect URL
     */
    String handleCallback(String provider, String code, String state);

    /**
     * Verify the passcode for a pending SSO session, link/create the local user, and issue a token.
     *
     * @param ssoState pending SSO session id
     * @param passcode the passcode entered by the user
     * @return the login token
     */
    Result<TokenDTO> verifyPasscode(String ssoState, String passcode);

    /**
     * Return the SSO public configuration for the frontend (enabled providers + whether a passcode is required).
     */
    Map<String, Object> getPublicConfig();
}
