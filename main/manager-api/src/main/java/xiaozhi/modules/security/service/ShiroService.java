package xiaozhi.modules.security.service;

import xiaozhi.modules.security.entity.SysUserTokenEntity;
import xiaozhi.modules.sys.entity.SysUserEntity;

/**
 * Shiro-related interfaces
 * Copyright (c) renren.io All rights reserved.
 * Website: https://www.renren.io
 */
public interface ShiroService {

    SysUserTokenEntity getByToken(String token);

    /**
     * Query the user by user ID
     *
     * @param userId
     */
    SysUserEntity getUser(Long userId);

}
