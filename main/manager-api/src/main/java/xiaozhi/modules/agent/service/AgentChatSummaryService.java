package xiaozhi.modules.agent.service;

/**
 * Agent chat history summary service interface
 */
public interface AgentChatSummaryService {

    /**
     * Generate a chat history summary based on the session ID and save it to the agent memory
     * 
     * @param sessionId session ID
     * @return the save result
     */
    boolean generateAndSaveChatSummary(String sessionId);

    /**
     * Generate a chat title based on the session ID and save it
     *
     * @param sessionId session ID
     * @return whether it succeeded
     */
    boolean generateAndSaveChatTitle(String sessionId);
}