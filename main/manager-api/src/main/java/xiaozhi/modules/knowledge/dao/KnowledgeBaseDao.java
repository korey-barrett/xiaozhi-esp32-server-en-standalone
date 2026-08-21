package xiaozhi.modules.knowledge.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import xiaozhi.common.dao.BaseDao;
import xiaozhi.modules.knowledge.entity.KnowledgeBaseEntity;

/**
 * Knowledge base knowledge base
 */
@Mapper
public interface KnowledgeBaseDao extends BaseDao<KnowledgeBaseEntity> {

    /**
     * Delete the related plugin mapping records by knowledge base ID
     * 
     * @param knowledgeBaseId knowledge base ID
     */
    void deletePluginMappingByKnowledgeBaseId(@Param("knowledgeBaseId") String knowledgeBaseId);

    /**
     * Atomically update knowledge base statistics on common dimensions
     * 
     * @param datasetId  dataset ID
     * @param docDelta   document count delta
     * @param chunkDelta chunk count delta
     * @param tokenDelta token count delta
     */
    void updateStatsAfterChange(@Param("datasetId") String datasetId,
            @Param("docDelta") Integer docDelta,
            @Param("chunkDelta") Long chunkDelta,
            @Param("tokenDelta") Long tokenDelta);

}