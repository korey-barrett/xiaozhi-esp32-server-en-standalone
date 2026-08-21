package xiaozhi.modules.timbre.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Timbre Paging Parameter DTO
 * 
 * @author zjy
 * @since 2025-3-21
 */
@Data
@Schema(description = "Timbre paging parameters")
public class TimbrePageDTO {

    @Schema(description = "Corresponding TTS model primary key")
    @NotBlank(message = "{timbre.ttsModelId.require}")
    private String ttsModelId;

    @Schema(description = "Timbre name")
    private String name;

    @Schema(description = "Page number")
    private String page;

    @Schema(description = "Display limit")
    private String limit;
}
