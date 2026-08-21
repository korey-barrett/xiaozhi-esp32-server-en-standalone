package xiaozhi.modules.sys.service;

import java.util.List;
import java.util.Map;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.sys.dto.SysParamsDTO;
import xiaozhi.modules.sys.entity.SysParamsEntity;

/**
 * Parameter Management
 */
public interface SysParamsService extends BaseService<SysParamsEntity> {

    PageData<SysParamsDTO> page(Map<String, Object> params);

    List<SysParamsDTO> list(Map<String, Object> params);

    SysParamsDTO get(Long id);

    void save(SysParamsDTO dto);

    void update(SysParamsDTO dto);

    void delete(String[] ids);

    /**
     * Get the value of a parameter by its parameter code
     *
     * @param paramCode the parameter code
     * @param fromCache whether to get it from the cache
     */
    String getValue(String paramCode, Boolean fromCache);

    /**
     * Get the Object of the value by its parameter code
     *
     * @param paramCode the parameter code
     * @param clazz     the Object class
     */
    <T> T getValueObject(String paramCode, Class<T> clazz);

    /**
     * Update the value by its parameter code
     *
     * @param paramCode  the parameter code
     * @param paramValue the parameter value
     */
    int updateValueByCode(String paramCode, String paramValue);

    /**
     * Initialize the server secret
     */
    void initServerSecret();

    /**
     * Get the system feature menu configuration
     *
     * @param fromCache whether to get it from the cache
     * @return the system feature menu configuration JSON string
     */
    String getSystemWebMenu(boolean fromCache);

    /**
     * Update the system feature menu configuration (automatically handles cleanup of feature-related plugins)
     *
     * @param configJson the new system feature menu configuration JSON
     */
    void updateSystemWebMenu(String configJson);
}
