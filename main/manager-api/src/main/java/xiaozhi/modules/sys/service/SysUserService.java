package xiaozhi.modules.sys.service;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.sys.dto.AdminPageUserDTO;
import xiaozhi.modules.sys.dto.PasswordDTO;
import xiaozhi.modules.sys.dto.SysUserDTO;
import xiaozhi.modules.sys.entity.SysUserEntity;
import xiaozhi.modules.sys.vo.AdminPageUserVO;

/**
 * System user
 */
public interface SysUserService extends BaseService<SysUserEntity> {

    SysUserDTO getByUsername(String username);

    SysUserDTO getByUserId(Long userId);

    void save(SysUserDTO dto);

    /**
     * Delete the specified user, along with associated data devices and agents
     * 
     * @param ids
     */
    void deleteById(Long ids);

    /**
     * Verify whether the password change is allowed
     * 
     * @param userId      the user id
     * @param passwordDTO the parameters for verifying the password
     */
    void changePassword(Long userId, PasswordDTO passwordDTO);

    /**
     * Change the password directly, without verification
     * 
     * @param userId   the user id
     * @param password the password
     */
    void changePasswordDirectly(Long userId, String password);

    /**
     * Reset the password
     * 
     * @param userId the user id
     * @return a randomly generated password that conforms to the requirements
     */
    String resetPassword(Long userId);

    /**
     * Admin paginated user information
     * 
     * @param dto the paginated query parameters
     * @return the paginated user list data
     */
    PageData<AdminPageUserVO> page(AdminPageUserDTO dto);

    /**
     * Batch update the user status
     * 
     * @param status  the user status
     * @param userIds the array of user IDs
     */
    void changeStatus(Integer status, String[] userIds);

    /**
     * Get whether user registration is allowed
     * 
     * @return whether user registration is allowed
     */
    boolean getAllowUserRegister();
}
