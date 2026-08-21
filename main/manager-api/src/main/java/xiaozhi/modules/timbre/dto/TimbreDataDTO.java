package xiaozhi.modules.timbre.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Timbre Table Data DTO
 * 
 * @author zjy
 * @since 2025-3-21
 */
@Data
@Schema(description = "Timbre table information")
public class TimbreDataDTO {

    @Schema(description = "Language")
    @NotBlank(message = "{timbre.languages.require}")
    private String languages;

    @Schema(description = "Timbre name")
    @NotBlank(message = "{timbre.name.require}")
    private String name;

    @Schema(description = "Remark")
    private String remark;

    @Schema(description = "Reference audio path")
    private String referenceAudio;

    @Schema(description = "Reference text")
    private String referenceText;

    @Schema(description = "Sort order")
    @Min(value = 0, message = "{sort.number}")
    private Long sort;

    @Schema(description = "Corresponding TTS model primary key")
    @NotBlank(message = "{timbre.ttsModelId.require}")
    private String ttsModelId;

    @Schema(description = "Timbre code")
    @NotBlank(message = "{timbre.ttsVoice.require}")
    private String ttsVoice;

    @Schema(description = "Audio playback address")
    private String voiceDemo;
}
