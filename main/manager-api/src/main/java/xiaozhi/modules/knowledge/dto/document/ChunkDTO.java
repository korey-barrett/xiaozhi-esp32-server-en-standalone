package xiaozhi.modules.knowledge.dto.document;

import lombok.*;
import io.swagger.v3.oas.annotations.media.Schema;
import java.io.Serializable;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.*;

/**
 * Chunk Management Aggregation DTO
 */
@Schema(description = "Chunk Management Aggregation DTO")
@JsonIgnoreProperties(ignoreUnknown = true)
public class ChunkDTO {

    /**
     * Add chunk request parameters
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Add Chunk Request Parameters")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class AddReq implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "Chunk content", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "Chunk content cannot be empty")
        private String content;

        @Schema(description = "Important keywords list")
        @JsonProperty("important_keywords")
        private List<String> importantKeywords;

        @Schema(description = "Predefined questions list")
        private List<String> questions;
    }

    /**
     * Update chunk request parameters
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Update Chunk Request Parameters")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UpdateReq implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "New chunk content")
        private String content;

        @Schema(description = "Updated keywords list (replaces the original list)")
        @JsonProperty("important_keywords")
        private List<String> importantKeywords;

        @Schema(description = "Enable/Disable (true: enabled, false: disabled)")
        private Boolean available;
    }

    /**
     * Get chunk list request parameters
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Get Chunk List Request Parameters")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ListReq implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "Page number (default 1)")
        private Integer page;

        @Schema(description = "Number of items per page (default 30)")
        @JsonProperty("page_size")
        private Integer pageSize;

        @Schema(description = "Search keywords (full-text search)")
        private String keywords;

        @Schema(description = "Exact chunk ID")
        private String id;
    }

    /**
     * Batch delete chunk request parameters
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Batch Delete Chunk Request Parameters")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RemoveReq implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "Chunk ID list", requiredMode = Schema.RequiredMode.REQUIRED)
        @JsonProperty("chunk_ids")
        @NotEmpty(message = "Chunk ID list cannot be empty")
        private List<String> chunkIds;
    }

    /**
     * Document chunk info VO
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Document Chunk Info")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class InfoVO implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "Chunk ID (usually document_id + index)", requiredMode = Schema.RequiredMode.REQUIRED)
        private String id;

        @Schema(description = "Chunk text content (primary target of full-text search)", requiredMode = Schema.RequiredMode.REQUIRED)
        private String content;

        @Schema(description = "Owning document ID", requiredMode = Schema.RequiredMode.REQUIRED)
        @JsonProperty("document_id")
        private String documentId;

        @Schema(description = "Document name / keywords")
        @JsonProperty("docnm_kwd")
        private String docnmKwd;

        @Schema(description = "Important keywords list (used for keyword-enhanced retrieval)")
        @JsonProperty("important_keywords")
        private List<String> importantKeywords;

        @Schema(description = "Predefined questions list (used for Q&A mode enhancement)")
        private List<String> questions;

        @Schema(description = "Associated image ID")
        @JsonProperty("image_id")
        private String imageId;

        @Schema(description = "Owning knowledge base ID")
        @JsonProperty("dataset_id")
        private String datasetId;

        @Schema(description = "Whether the chunk is available (true: participates in retrieval, false: disabled)")
        private Boolean available;

        @Schema(description = "Position index list of the chunk in the original text (RAGFlow returns a nested array, e.g. [[start, end, filename]])")
        private List<List<Object>> positions;

        @Schema(description = "Token ID list")
        @JsonProperty("token")
        private List<Integer> token;
    }

    /**
     * Chunk list aggregation response
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Chunk List Aggregation Response")
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ListVO implements Serializable {
        private static final long serialVersionUID = 1L;

        @Schema(description = "Chunk info list")
        private List<InfoVO> chunks;

        @Schema(description = "Associated document detail info")
        private DocumentDTO.InfoVO doc;

        @Schema(description = "Total record count")
        private Long total;
    }
}
