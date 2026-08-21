package xiaozhi.modules.agent.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * The object returned by the voiceprint identification interface
 */
@Data
public class IdentifyVoicePrintResponse {
    /**
     * The best-matching voiceprint id
     */
    @JsonProperty("speaker_id")
    private String speakerId;
    /**
     * The voiceprint score
     */
    private Double score;
}
