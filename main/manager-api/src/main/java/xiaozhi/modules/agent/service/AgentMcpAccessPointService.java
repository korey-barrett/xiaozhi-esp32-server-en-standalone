package xiaozhi.modules.agent.service;


import java.util.List;

/**
 * Agent MCP access point processing service
 *
 * @author zjy
 */
public interface AgentMcpAccessPointService {
    /**
     * Get the agent's MCP access point address
     * @param id agent id
     * @return MCP access point address
     */
   String getAgentMcpAccessAddress(String id);

    /**
     * Get the list of existing tools for the agent's MCP access point
     * @param id agent id
     * @return tool list
     */
   List<String> getAgentMcpToolsList(String id);
}
