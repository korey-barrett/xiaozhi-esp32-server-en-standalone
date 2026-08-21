package xiaozhi.modules.agent.service.biz;

import xiaozhi.modules.agent.dto.AgentChatHistoryReportDTO;

/**
 * Business logic layer for Agent chat history
 *
 * @author Goody
 * @version 1.0, 2025/4/30
 * @since 1.0.0
 */
public interface AgentChatHistoryBizService {

    /**
     * Chat report method
     *
     * @param agentChatHistoryReportDTO the input object containing the information needed for the chat report,
     *                                  e.g. device MAC address, file type, content, etc.
     * @return the upload result, true indicates success, false indicates failure
     */
    Boolean report(AgentChatHistoryReportDTO agentChatHistoryReportDTO);
}
