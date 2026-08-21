package xiaozhi.modules.voiceclone.dto;

import java.util.Date;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * Voice Clone Response DTO
 * Used to display voice clone information to the frontend, including the model name and user name
 */
@Data
@Schema(description = "Voice Clone Response DTO")
public class VoiceCloneResponseDTO {

    @Schema(description = "Unique ID")
    private String id;

    @Schema(description = "Voice Name")
    private String name;

    @Schema(description = "Model ID")
    private String modelId;

    @Schema(description = "Model Name")
    private String modelName;

    @Schema(description = "Voice ID")
    private String voiceId;

    @Schema(description = "Language")
    private String languages;

    @Schema(description = "User ID (associated with the user table)")
    private Long userId;

    @Schema(description = "User Name")
    private String userName;

    @Schema(description = "Training Status: 0 Pending, 1 In Progress, 2 Succeeded, 3 Failed")
    private Integer trainStatus;

    @Schema(description = "Training Error Reason")
    private String trainError;

    @Schema(description = "Creation Time")
    private Date createDate;

    @Schema(description = "Whether audio data exists")
    private Boolean hasVoice;
}