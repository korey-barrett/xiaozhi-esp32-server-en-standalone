package xiaozhi.modules.agent.service;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.extension.repository.IRepository;

import xiaozhi.common.page.PageData;
import xiaozhi.modules.agent.dto.AgentChatHistoryDTO;
import xiaozhi.modules.agent.dto.AgentChatSessionDTO;
import xiaozhi.modules.agent.entity.AgentChatHistoryEntity;
import xiaozhi.modules.agent.vo.AgentChatHistoryUserVO;

/**
 * Service handling the Agent chat history table
 *
 * @author Goody
 * @version 1.0, 2025/4/30
 * @since 1.0.0
 */
public interface AgentChatHistoryService extends IRepository<AgentChatHistoryEntity> {

    /**
     * Get the session list by Agent ID
     *
     * @param params query parameters, including agentId, page, limit
     * @return the paginated session list
     */
    PageData<AgentChatSessionDTO> getSessionListByAgentId(Map<String, Object> params);

    /**
     * Get the chat history list by session ID
     *
     * @param agentId   the Agent ID
     * @param sessionId the session ID
     * @return the chat history list
     */
    List<AgentChatHistoryDTO> getChatHistoryBySessionId(String agentId, String sessionId);

    /**
     * Get the Agent ID by session ID
     *
     * @param sessionId the session ID
     * @return the Agent ID
     */
    String getAgentIdBySessionId(String sessionId);

    /**
     * Delete chat history by Agent ID
     *
     * @param agentId     the Agent ID
     * @param deleteAudio whether to delete audio
     * @param deleteText  whether to delete text
     */
    void deleteByAgentId(String agentId, Boolean deleteAudio, Boolean deleteText);

    /**
     * Get the most recent 50 user chat history records for the Agent (including audio data)
     *
     * @param agentId the Agent ID
     * @return the chat history list (users only)
     */
    List<AgentChatHistoryUserVO> getRecentlyFiftyByAgentId(String agentId);

    /**
     * Get the chat content by audio data ID
     *
     * @param audioId the audio ID
     * @return the chat content
     */
    String getContentByAudioId(String audioId);

    /**
     * Get the Agent ID by audio ID
     *
     * @param audioId the audio ID
     * @return the Agent ID
     */
    String getAgentIdByAudioId(String audioId);


    /**
     * Check whether this audio ID belongs to this Agent
     *
     * @param audioId the audio ID
     * @param agentId the Agent ID
     * @return T: belongs, F: does not belong
     */
    boolean isAudioOwnedByAgent(String audioId,String agentId);
}
