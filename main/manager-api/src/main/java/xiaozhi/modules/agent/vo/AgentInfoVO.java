package xiaozhi.modules.agent.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import xiaozhi.modules.agent.dto.ContextProviderDTO;
import xiaozhi.modules.agent.entity.AgentEntity;
import xiaozhi.modules.agent.entity.AgentPluginMapping;

import java.util.List;

/**
 * Agent information response VO
 * It directly extends the Agent entity class AgentEntity here; fields can be copied out later if the returned fields need to be standardized
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class AgentInfoVO extends AgentEntity
{
    @Schema(description = "Plugin list IDs")
    private List<AgentPluginMapping> functions;

    @Schema(description = "Context source configuration")
    private List<ContextProviderDTO> contextProviders;

    @Schema(description = "Correction word file ID list")
    private List<String> correctWordFileIds;

    @Schema(description = "Current configuration version number")
    private Integer currentVersionNo;
}
