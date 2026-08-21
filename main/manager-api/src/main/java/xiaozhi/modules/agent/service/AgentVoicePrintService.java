package xiaozhi.modules.agent.service;

import java.util.List;

import xiaozhi.modules.agent.dto.AgentVoicePrintSaveDTO;
import xiaozhi.modules.agent.dto.AgentVoicePrintUpdateDTO;
import xiaozhi.modules.agent.vo.AgentVoicePrintVO;

/**
 * Service for processing Agent voice prints
 *
 * @author zjy
 */
public interface AgentVoicePrintService {
    /**
     * Add a new voice print for the Agent
     *
     * @param dto the data for saving the Agent voice print
     * @return T: success F: failure
     */
    boolean insert(AgentVoicePrintSaveDTO dto);

    /**
     * Delete the specified voice print of the Agent
     *
     * @param userId       the ID of the currently logged-in user
     * @param voicePrintId the voice print ID
     * @return whether it succeeded T: success F: failure
     */
    boolean delete(Long userId, String voicePrintId);

    /**
     * Get all voice print data of the specified Agent
     *
     * @param userId  the ID of the currently logged-in user
     * @param agentId the Agent ID
     * @return the collection of voice print data
     */
    List<AgentVoicePrintVO> list(Long userId, String agentId);

    /**
     * Update the specified voice print data of the Agent
     *
     * @param userId the ID of the currently logged-in user
     * @param dto    the modified voice print data
     * @return whether it succeeded T: success F: failure
     */
    boolean update(Long userId, AgentVoicePrintUpdateDTO dto);

}
