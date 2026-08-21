package xiaozhi.modules.sys.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.sys.dto.SysDictTypeDTO;
import xiaozhi.modules.sys.entity.SysDictTypeEntity;
import xiaozhi.modules.sys.vo.SysDictTypeVO;

/**
 * Data dictionary
 */
public interface SysDictTypeService extends BaseService<SysDictTypeEntity> {

    /**
     * Paginated query of dictionary type information
     *
     * @param params the query parameters, including pagination information and query conditions
     * @return the paginated dictionary type data
     */
    PageData<SysDictTypeVO> page(Map<String, Object> params);

    /**
     * Get dictionary type information by ID
     *
     * @param id the dictionary type ID
     * @return the dictionary type object
     */
    SysDictTypeVO get(Long id);

    /**
     * Save dictionary type information
     *
     * @param dto the dictionary type data transfer object
     */
    void save(SysDictTypeDTO dto);

    /**
     * Update dictionary type information
     *
     * @param dto the dictionary type data transfer object
     */
    void update(SysDictTypeDTO dto);

    /**
     * Delete dictionary type information
     *
     * @param ids the array of IDs of the dictionary types to delete
     */
    void delete(Long[] ids);

    /**
     * List all dictionary type information
     *
     * @return the list of dictionary types
     */
    List<SysDictTypeVO> list(Map<String, Object> params);
}