package xiaozhi.modules.agent.service;

import com.baomidou.mybatisplus.extension.repository.IRepository;

import xiaozhi.modules.agent.entity.AgentChatAudioEntity;

/**
 * Service handling the Agent chat audio data table
 *
 * @author Goody
 * @version 1.0, 2025/5/8
 * @since 1.0.0
 */
public interface AgentChatAudioService extends IRepository<AgentChatAudioEntity> {
    /**
     * Save audio data
     *
     * @param audioData the audio data
     * @return the audio ID
     */
    String saveAudio(byte[] audioData);

    /**
     * Get audio data
     *
     * @param audioId the audio ID
     * @return the audio data
     */
    byte[] getAudio(String audioId);
}
