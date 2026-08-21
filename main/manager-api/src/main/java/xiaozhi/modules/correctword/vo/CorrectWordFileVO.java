package xiaozhi.modules.correctword.vo;

import java.util.Date;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Correction word file list VO")
public class CorrectWordFileVO {

    @Schema(description = "Correction word file ID")
    private String id;

    @Schema(description = "Original file name")
    private String fileName;

    @Schema(description = "Number of correction words")
    private Integer wordCount;

    @Schema(description = "Correction word content, one per line")
    private List<String> content;

    @Schema(description = "Creation time")
    private Date createdAt;

    @Schema(description = "Update time")
    private Date updatedAt;
}
