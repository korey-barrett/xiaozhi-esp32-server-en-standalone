package xiaozhi.modules.sys.service;


import java.util.function.Consumer;

/**
 * Defines a system user utility class to avoid circular dependencies with the user module
 * For example, users and devices depend on each other: users need to retrieve all devices, and devices need the username of each user
 * @author zjy
 * @since 2025-4-2
 */
public interface SysUserUtilService {
    /**
     * Assigns the username
     * @param userId user id
     * @param setter assignment method
     */
    void assignUsername( Long userId, Consumer<String> setter);
}
