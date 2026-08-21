package xiaozhi.modules.agent.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@TableName("ai_agent")
@Schema(description = "Agent information")
public class AgentEntity {

    @TableId(type = IdType.ASSIGN_UUID)
    @Schema(description = "Agent unique identifier")
    private String id;

    @Schema(description = "Owning user ID")
    private Long userId;

    @Schema(description = "Agent code")
    private String agentCode;

    @Schema(description = "Agent name")
    private String agentName;

    @Schema(description = "Speech recognition model identifier")
    private String asrModelId;

    @Schema(description = "Voice activity detection identifier")
    private String vadModelId;

    @Schema(description = "Large language model identifier")
    private String llmModelId;

    @Schema(description = "Small language model identifier")
    private String slmModelId;

    @Schema(description = "VLLM model identifier")
    private String vllmModelId;

    @Schema(description = "Speech synthesis model identifier")
    private String ttsModelId;

    @Schema(description = "Timbre identifier")
    private String ttsVoiceId;

    @Schema(description = "Timbre language")
    private String ttsLanguage;

    @Schema(description = "TTS volume")
    private Integer ttsVolume;

    @Schema(description = "TTS speed")
    private Integer ttsRate;

    @Schema(description = "TTS pitch")
    private Integer ttsPitch;

    @Schema(description = "Memory model identifier")
    private String memModelId;

    @Schema(description = "Intent recognition model identifier")
    private String intentModelId;

    @Schema(description = "Chat history configuration (0 - do not record, 1 - record text only, 2 - record text and audio)")
    private Integer chatHistoryConf;

    @Schema(description = "Role setting parameters")
    private String systemPrompt;

    @Schema(description = "Summary memory", example = "Build a growing dynamic memory network that retains key information within limited space while intelligently maintaining the evolution trajectory of information\n" +
            "Based on the conversation records, summarize the user's important information to provide more personalized services in future conversations", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    private String summaryMemory;

    @Schema(description = "Language code")
    private String langCode;

    @Schema(description = "Interaction language")
    private String language;

    @Schema(description = "Sort order")
    private Integer sort;

    @Schema(description = "Creator")
    private Long creator;

    @Schema(description = "Creation time")
    private Date createdAt;

    @Schema(description = "Updater")
    private Long updater;

    @Schema(description = "Update time")
    private Date updatedAt;
}
