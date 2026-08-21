package xiaozhi.modules.voiceclone.entity;

import java.util.Date;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("ai_voice_clone")
@Schema(description = "Voice Clone")
public class VoiceCloneEntity {

    @TableId(type = IdType.ASSIGN_UUID)
    @Schema(description = "Unique ID")
    private String id;

    @Schema(description = "Voice Name")
    private String name;

    @Schema(description = "Model ID")
    private String modelId;

    @Schema(description = "Voice ID")
    private String voiceId;

    @Schema(description = "Language")
    private String languages;

    @Schema(description = "User ID (associated with the user table)")
    private Long userId;

    @Schema(description = "Voice")
    private byte[] voice;

    @Schema(description = "Training Status: 0 Pending, 1 In Progress, 2 Succeeded, 3 Failed")
    private Integer trainStatus;

    @Schema(description = "Training Error Reason")
    private String trainError;

    @Schema(description = "Creator")
    @TableField(fill = FieldFill.INSERT)
    private Long creator;

    @Schema(description = "Creation Time")
    @TableField(fill = FieldFill.INSERT)
    private Date createDate;
}
