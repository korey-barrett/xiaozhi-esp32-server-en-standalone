package xiaozhi.modules.agent.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.repository.IRepository;

import xiaozhi.modules.agent.entity.AgentPluginMapping;

/**
 * @description Database operation service for table [ai_agent_plugin_mapping (unique mapping table of Agent and Plugin)]
 * @createDate 2025-05-25 22:33:17
 */
public interface AgentPluginMappingService extends IRepository<AgentPluginMapping> {

    /**
     * Get the plugin parameters by agent id
     *
     * @param agentId
     * @return
     */
    List<AgentPluginMapping> agentPluginParamsByAgentId(String agentId);

    /**
     * Delete the plugin parameters by agent id
     *
     * @param agentId
     */
    void deleteByAgentId(String agentId);

    /**
     * Delete the plugin mappings of all agents by plugin ID
     *
     * @param pluginId plugin ID
     */
    void deleteByPluginId(String pluginId);
}
