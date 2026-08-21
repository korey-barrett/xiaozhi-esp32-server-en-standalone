package xiaozhi.modules.agent.dto;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Agent create DTO
 * Dedicated to adding a new agent; it does not include the id, agentCode, and sort fields,
 * which are auto-generated / set to default values by the system
 */
@Data
@Schema(description = "Agent create object")
public class AgentCreateDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    @Schema(description = "Agent name", example = "Customer Service Assistant")
    @NotBlank(message = "Agent name cannot be empty")
    private String agentName;
}