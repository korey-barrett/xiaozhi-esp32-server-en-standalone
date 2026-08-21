package xiaozhi.modules.security.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import lombok.Data;
import lombok.EqualsAndHashCode;
import xiaozhi.common.entity.BaseEntity;

/**
 * SSO identity link — maps an external OAuth2/OIDC identity (provider + provider user id)
 * to a local system user.
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("sys_user_oauth")
public class SysUserOauthEntity extends BaseEntity {
    /**
     * Local system user id
     */
    private Long userId;
    /**
     * Provider name: google, apple, microsoft, github
     */
    private String provider;
    /**
     * Provider's unique user id (subject / uuid)
     */
    private String providerUserId;
}
