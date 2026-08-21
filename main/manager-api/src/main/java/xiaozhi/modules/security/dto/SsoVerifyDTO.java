package xiaozhi.modules.security.dto;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * SSO passcode verification form.
 */
@Data
@Schema(description = "SSO passcode verification form")
public class SsoVerifyDTO implements Serializable {

    @Schema(description = "Pending SSO session id")
    @NotBlank(message = "{sso.state.require}")
    private String ssoState;

    @Schema(description = "Passcode")
    @NotBlank(message = "{sso.passcode.require}")
    private String passcode;
}
