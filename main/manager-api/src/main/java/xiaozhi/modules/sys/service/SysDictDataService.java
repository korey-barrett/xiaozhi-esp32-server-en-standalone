package xiaozhi.modules.sys.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.sys.dto.SysDictDataDTO;
import xiaozhi.modules.sys.entity.SysDictDataEntity;
import xiaozhi.modules.sys.vo.SysDictDataItem;
import xiaozhi.modules.sys.vo.SysDictDataVO;

/**
 * Data dictionary
 */
public interface SysDictDataService extends BaseService<SysDictDataEntity> {

    /**
     * Paginated query of data dictionary information
     *
     * @param params the query parameters, including pagination information and query conditions
     * @return the paginated query result of the data dictionary
     */
    PageData<SysDictDataVO> page(Map<String, Object> params);

    /**
     * Get the data dictionary entity by ID
     *
     * @param id the unique identifier of the data dictionary entity
     * @return the detailed information of the data dictionary entity
     */
    SysDictDataVO get(Long id);

    /**
     * Save a new data dictionary item
     *
     * @param dto the data transfer object for saving a data dictionary item
     */
    void save(SysDictDataDTO dto);

    /**
     * Update a data dictionary item
     *
     * @param dto the data transfer object for updating a data dictionary item
     */
    void update(SysDictDataDTO dto);

    /**
     * Delete data dictionary items
     *
     * @param ids the array of IDs of the data dictionary items to delete
     */
    void delete(Long[] ids);

    /**
     * Delete the dictionary data corresponding to a dictionary type ID
     *
     * @param dictTypeId the dictionary type ID
     */
    void deleteByTypeId(Long dictTypeId);

    /**
     * Get the list of dictionary data by dictionary type
     *
     * @param dictType the dictionary type
     * @return the list of dictionary data
     */
    List<SysDictDataItem> getDictDataByType(String dictType);

}