package xiaozhi.modules.agent.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.agent.dto.AgentCreateDTO;
import xiaozhi.modules.agent.dto.AgentDTO;
import xiaozhi.modules.agent.dto.AgentMemoryDTO;
import xiaozhi.modules.agent.dto.AgentUpdateDTO;
import xiaozhi.modules.agent.entity.AgentEntity;
import xiaozhi.modules.agent.vo.AgentInfoVO;

/**
 * Agent table processing service
 *
 * @author Goody
 * @version 1.0, 2025/4/30
 * @since 1.0.0
 */
public interface AgentService extends BaseService<AgentEntity> {
    /**
     * Get the list of agents for the admin
     *
     * @param params query parameters
     * @return paged data
     */
    PageData<AgentEntity> adminAgentList(Map<String, Object> params);

    /**
     * Get the agent by ID
     *
     * @param id agent ID
     * @return the agent entity
     */
    AgentInfoVO getAgentById(String id);

    /**
     * Get the agent that the current user has access to by ID
     *
     * @param id     agent ID
     * @param userId current user ID
     * @return the agent entity
     */
    AgentInfoVO getAgentById(String id, Long userId);

    /**
     * Insert an agent
     *
     * @param entity the agent entity
     * @return whether it succeeded
     */
    boolean insert(AgentEntity entity);

    /**
     * Delete the agents by user ID
     *
     * @param userId user ID
     */
    void deleteAgentByUserId(Long userId);

    /**
     * Delete an agent and its associated data
     *
     * @param agentId agent ID
     */
    void deleteAgent(String agentId);

    /**
     * Get the list of user agents
     *
     * @param userId user ID
     * @param keyword search keyword
     * @param searchType search type (name - search by name, mac - search by MAC address)
     * @return the agent list
     */
    List<AgentDTO> getUserAgents(Long userId, String keyword, String searchType);

    /**
     * Get the device count by agent ID
     *
     * @param agentId agent ID
     * @return the device count
     */
    Integer getDeviceCountByAgentId(String agentId);

    /**
     * Query the default agent information for the corresponding device by its MAC address
     *
     * @param macAddress device MAC address
     * @return the default agent information, or null if it does not exist
     */
    AgentEntity getDefaultAgentByMacAddress(String macAddress);

    /**
     * Check whether the user has permission to access the agent
     *
     * @param agentId agent ID
     * @param userId  user ID
     * @return whether the user has permission
     */
    boolean checkAgentPermission(String agentId, Long userId);

    /**
     * Update an agent
     *
     * @param agentId agent ID
     * @param dto     the information required to update the agent
     */
    void updateAgentById(String agentId, AgentUpdateDTO dto);

    /**
     * Update the agent that the current user has access to
     *
     * @param agentId agent ID
     * @param dto     the information required to update the agent
     * @param userId  current user ID
     */
    void updateAgentById(String agentId, AgentUpdateDTO dto, Long userId);

    /**
     * Update the memory of the agent that the current user has access to by the device MAC address
     *
     * @param macAddress device MAC address
     * @param dto        agent memory
     * @param userId     current user ID
     */
    void updateAgentMemoryByDeviceMacAddress(String macAddress, AgentMemoryDTO dto, Long userId);

    /**
     * Delete the agent that the current user has access to
     *
     * @param agentId agent ID
     * @param userId  current user ID
     */
    void deleteAgentById(String agentId, Long userId);

    /**
     * Update an agent
     *
     * @param agentId        agent ID
     * @param dto            the information required to update the agent
     * @param createSnapshot whether to create a configuration snapshot
     */
    void updateAgentById(String agentId, AgentUpdateDTO dto, boolean createSnapshot);

    /**
     * Create an agent
     *
     * @param dto the information required to create the agent
     * @return the created agent ID
     */
    String createAgent(AgentCreateDTO dto);


}
