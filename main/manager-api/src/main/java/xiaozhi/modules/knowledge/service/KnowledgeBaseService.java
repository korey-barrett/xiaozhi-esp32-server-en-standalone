package xiaozhi.modules.knowledge.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.knowledge.dto.KnowledgeBaseDTO;
import xiaozhi.modules.knowledge.entity.KnowledgeBaseEntity;
import xiaozhi.modules.model.entity.ModelConfigEntity;

/**
 * Knowledge base service interface.
 */
public interface KnowledgeBaseService extends BaseService<KnowledgeBaseEntity> {

    /**
     * Paginated query of the knowledge base list.
     * 
     * @param knowledgeBaseDTO Query conditions
     * @param page             Page number
     * @param limit            Number of items per page
     * @return Paginated data
     */
    PageData<KnowledgeBaseDTO> getPageList(KnowledgeBaseDTO knowledgeBaseDTO, Integer page, Integer limit);

    /**
     * Get knowledge base details by ID.
     * 
     * @param id Knowledge base ID
     * @return Knowledge base details
     */
    KnowledgeBaseDTO getById(String id);

    /**
     * Add a knowledge base.
     * 
     * @param knowledgeBaseDTO Knowledge base information
     * @return The newly added knowledge base
     */
    KnowledgeBaseDTO save(KnowledgeBaseDTO knowledgeBaseDTO);

    /**
     * Update a knowledge base.
     * 
     * @param knowledgeBaseDTO Knowledge base information
     * @return The updated knowledge base
     */
    KnowledgeBaseDTO update(KnowledgeBaseDTO knowledgeBaseDTO);

    /**
     * Get the knowledge base by dataset ID.
     * 
     * @param datasetId Knowledge base ID
     * @return Knowledge base details
     */
    KnowledgeBaseDTO getByDatasetId(String datasetId);

    /**
     * Get knowledge bases by a set of dataset IDs.
     *
     * @param datasetIdList Set of knowledge base IDs
     * @return Knowledge base details
     */
    List<KnowledgeBaseDTO> getByDatasetIdList(List<String> datasetIdList);

    /**
     * Delete the knowledge base by dataset ID.
     * 
     * @param datasetId Knowledge base ID
     */
    void deleteByDatasetId(String datasetId);

    /**
     * Get RAG configuration information.
     * 
     * @param ragModelId RAG model configuration ID
     * @return RAG configuration information
     */
    Map<String, Object> getRAGConfig(String ragModelId);

    /**
     * Get the corresponding RAG configuration by knowledge base ID.
     * 
     * @param datasetId Knowledge base ID
     * @return RAG configuration
     */
    Map<String, Object> getRAGConfigByDatasetId(String datasetId);

    /**
     * Get the list of RAG models.
     * 
     * @return RAG model list
     */
    List<ModelConfigEntity> getRAGModels();

    /**
     * Update knowledge base statistics (called back by the file service).
     * 
     * @param datasetId   Knowledge base ID
     * @param docDelta    Document count delta
     * @param chunkDelta  Chunk count delta
     * @param tokenDelta  Token count delta
     */
    void updateStatistics(String datasetId, Integer docDelta, Long chunkDelta, Long tokenDelta);
}