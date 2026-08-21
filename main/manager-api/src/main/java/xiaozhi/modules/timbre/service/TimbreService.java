package xiaozhi.modules.timbre.service;

import java.util.List;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.model.dto.VoiceDTO;
import xiaozhi.modules.timbre.dto.TimbreDataDTO;
import xiaozhi.modules.timbre.dto.TimbrePageDTO;
import xiaozhi.modules.timbre.entity.TimbreEntity;
import xiaozhi.modules.timbre.vo.TimbreDetailsVO;

/**
 * Definition of the business layer for timbre
 * 
 * @author zjy
 * @since 2025-3-21
 */
public interface TimbreService extends BaseService<TimbreEntity> {
    /**
     * Paginate the timbres under the specified TTS model
     * 
     * @param dto Pagination query parameters
     * @return Paged timbre list data
     */
    PageData<TimbreDetailsVO> page(TimbrePageDTO dto);

    /**
     * Get the detail information of the timbre with the specified id
     * 
     * @param timbreId The id of the timbre record
     * @return Timbre information
     */
    TimbreDetailsVO get(String timbreId);

    /**
     * Save timbre information
     * 
     * @param dto The data to be saved
     */
    void save(TimbreDataDTO dto);

    /**
     * Update timbre information
     * 
     * @param timbreId The id to be updated
     * @param dto      The data to be updated
     */
    void update(String timbreId, TimbreDataDTO dto);

    /**
     * Batch delete timbres
     * 
     * @param ids The list of timbre ids to be deleted
     */
    void delete(String[] ids);

    List<VoiceDTO> getVoiceNames(String ttsModelId, String voiceName);

    /**
     * Get the first valid language configured for a normal or cloned timbre.
     *
     * @param id Timbre ID
     * @return The default language; returns null when the timbre does not exist or no valid language is configured
     */
    String getDefaultLanguageById(String id);

    /**
     * Get the timbre name by ID
     * 
     * @param id Timbre ID
     * @return Timbre name
     */
    String getTimbreNameById(String id);

    /**
     * Get timbre information by voice code
     * 
     * @param ttsModelId Timbre model ID
     * @param voiceCode  Voice code
     * @return Timbre information
     */
    VoiceDTO getByVoiceCode(String ttsModelId, String voiceCode);
}
