package xiaozhi.modules.knowledge.service;

import java.util.List;

/**
 * Knowledge base module domain orchestration service.
 * Handles complex business flows that span KnowledgeBase and KnowledgeFiles,
 * fully resolving circular dependency issues between services.
 */
public interface KnowledgeManagerService {

    /**
     * Cascade delete a knowledge base and all of its documents (including local DB and RAGFlow remote data).
     * 
     * @param datasetId Knowledge base ID
     */
    void deleteDatasetWithFiles(String datasetId);

    /**
     * Batch cascade delete knowledge bases.
     * 
     * @param datasetIds List of knowledge base IDs
     */
    void batchDeleteDatasetsWithFiles(List<String> datasetIds);
}
