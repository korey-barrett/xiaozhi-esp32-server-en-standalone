package xiaozhi.modules.voiceclone.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.voiceclone.dto.VoiceCloneDTO;
import xiaozhi.modules.voiceclone.dto.VoiceCloneResponseDTO;
import xiaozhi.modules.voiceclone.entity.VoiceCloneEntity;

/**
 * Voice Clone Management
 */
public interface VoiceCloneService extends BaseService<VoiceCloneEntity> {

    /**
     * Paginated query
     */
    PageData<VoiceCloneEntity> page(Map<String, Object> params);

    /**
     * Save a voice clone
     */
    void save(VoiceCloneDTO dto);

    /**
     * Batch delete
     */
    void delete(String[] ids);

    /**
     * Query the voice clone list by user ID
     * 
     * @param userId User ID
     * @return Voice clone list
     */
    List<VoiceCloneEntity> getByUserId(Long userId);

    /**
     * Paginated query of the voice clone list with model name and user name
     */
    PageData<VoiceCloneResponseDTO> pageWithNames(Map<String, Object> params);

    /**
     * Query voice clone information with model name and user name by ID
     */
    VoiceCloneResponseDTO getByIdWithNames(String id);

    /**
     * Query the voice clone list with model name by user ID
     */
    List<VoiceCloneResponseDTO> getByUserIdWithNames(Long userId);

    /**
     * Upload an audio file
     */
    void uploadVoice(String id, MultipartFile voiceFile) throws Exception;

    /**
     * Update the voice clone name
     */
    void updateName(String id, String name);

    /**
     * Get audio data
     */
    byte[] getVoiceData(String id);

    /**
     * Clone audio by calling Volcano Engine for voice replication training
     * 
     * @param cloneId The voice clone record ID
     */
    void cloneAudio(String cloneId);
}
