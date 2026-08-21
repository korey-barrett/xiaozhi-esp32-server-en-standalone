package xiaozhi.modules.correctword.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Replacement word simplified VO (used on the device side)")
public class CorrectWordSimpleVO {

    @Schema(description = "Source word")
    private String sourceWord;

    @Schema(description = "Replacement word")
    private String targetWord;
}
