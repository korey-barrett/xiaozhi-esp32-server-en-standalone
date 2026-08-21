package xiaozhi.modules.correctword.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.modules.correctword.dto.CorrectWordFileCreateDTO;
import xiaozhi.modules.correctword.vo.CorrectWordFileVO;
import xiaozhi.modules.correctword.vo.CorrectWordSimpleVO;

public interface CorrectWordFileService {

    /**
     * Create a correct word file
     *
     * @param dto create parameters
     * @return file VO
     */
    CorrectWordFileVO createFile(CorrectWordFileCreateDTO dto);

    /**
     * Update a correct word file (full replacement of entries)
     *
     * @param fileId file ID
     * @param dto    update parameters
     */
    void updateFile(String fileId, CorrectWordFileCreateDTO dto);

    /**
     * Get the current user's list of correct word files
     *
     * @param params pagination parameters
     * @return paged data
     */
    PageData<CorrectWordFileVO> listFiles(Map<String, Object> params);

    /**
     * Get the current user's list of correct word files (unpaged, for dropdown selection)
     *
     * @return file list
     */
    List<CorrectWordFileVO> listAllFiles();

    /**
     * Get the raw content of a file (for download)
     *
     * @param fileId file ID
     * @return file entity
     */
    CorrectWordFileVO getFileContent(String fileId);

    /**
     * Delete a correct word file along with all its entries and related records
     *
     * @param fileId file ID
     */
    void deleteFile(String fileId);

    /**
     * Delete the correct word file mapping records associated with an agent (does not delete the files themselves)
     *
     * @param agentId agent ID
     */
    void deleteMappingsByAgentId(String agentId);

    /**
     * Get all correct word entries for an agent (simplified, for use on the device side)
     *
     * @param agentId agent ID
     * @return correct word list
     */
    List<CorrectWordSimpleVO> getAllItemsByAgentId(String agentId);

    /**
     * Get the list of correct word file IDs associated with an agent
     *
     * @param agentId agent ID
     * @return file ID list
     */
    List<String> getAgentCorrectWordFileIds(String agentId);

    /**
     * Save the correct word files associated with an agent (full replacement)
     *
     * @param agentId agent ID
     * @param fileIds file ID list
     */
    void saveAgentCorrectWords(String agentId, List<String> fileIds);

    /**
     * Batch delete correct word files
     *
     * @param fileIds file ID list
     */
    void batchDeleteFiles(List<String> fileIds);
}
