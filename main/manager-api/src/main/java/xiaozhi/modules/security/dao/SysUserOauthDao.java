package xiaozhi.modules.security.dao;

import org.apache.ibatis.annotations.Mapper;

import xiaozhi.common.dao.BaseDao;
import xiaozhi.modules.security.entity.SysUserOauthEntity;

/**
 * SSO identity link
 */
@Mapper
public interface SysUserOauthDao extends BaseDao<SysUserOauthEntity> {

}
