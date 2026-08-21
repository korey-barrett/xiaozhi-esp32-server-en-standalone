package xiaozhi.modules.knowledge.entity;

import java.util.Date;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@TableName(value = "ai_rag_dataset", autoResultMap = true)
@Schema(description = "Knowledge Base Table")
public class KnowledgeBaseEntity {

    @TableId(type = IdType.ASSIGN_UUID)
    @Schema(description = "Unique ID")
    private String id;

    @Schema(description = "Knowledge Base ID")
    private String datasetId;

//    @Deprecated
    @Schema(description = "RAG model configuration ID (credential pointer for connecting to RAGFlow)")
    private String ragModelId;

    @Schema(description = "Tenant ID")
    private String tenantId;

    @Schema(description = "Knowledge Base Name")
    private String name;

    @Schema(description = "Knowledge Base Avatar (Base64)")
    private String avatar;

    @Schema(description = "Knowledge Base Description")
    private String description;

    @Schema(description = "Embedding Model Name")
    private String embeddingModel;

    @Schema(description = "Permission Setting: me/team")
    private String permission;

    @Schema(description = "Chunking Method")
    private String chunkMethod;

    @Schema(description = "Parser Configuration (JSON String)")
    private String parserConfig;

    @Schema(description = "Total Chunks")
    private Long chunkCount;

    @Schema(description = "Total Document Count")
    private Long documentCount;

    @Schema(description = "Total Token Count")
    private Long tokenNum;

    @Schema(description = "Status (0: Disabled 1: Enabled)")
    private Integer status;

    @Schema(description = "Creator")
    @TableField(fill = FieldFill.INSERT)
    private Long creator;

    @Schema(description = "Created At")
    @TableField(fill = FieldFill.INSERT)
    private Date createdAt;

    @Schema(description = "Updater")
    @TableField(fill = FieldFill.UPDATE)
    private Long updater;

    @Schema(description = "Updated At")
    @TableField(fill = FieldFill.UPDATE)
    private Date updatedAt;
}