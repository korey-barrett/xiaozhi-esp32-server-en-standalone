package xiaozhi.modules.voiceclone.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import xiaozhi.modules.model.dto.VoiceDTO;
import xiaozhi.modules.voiceclone.entity.VoiceCloneEntity;

/**
 * Voice Clone
 */
@Mapper
public interface VoiceCloneDao extends BaseMapper<VoiceCloneEntity> {
    /**
     * Get the list of voices trained successfully by the user
     * 
     * @param modelId Model ID
     * @param userId  User ID
     * @return List of voices trained successfully
     */
    List<VoiceDTO> getTrainSuccess(String modelId, Long userId);

}
