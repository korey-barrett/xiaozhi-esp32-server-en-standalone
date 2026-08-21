package xiaozhi.modules.security.service;

import java.io.IOException;

import jakarta.servlet.http.HttpServletResponse;

/**
 * Captcha
 * Copyright (c) renren.io All rights reserved.
 * Website: https://www.renren.io
 */
public interface CaptchaService {

    /**
     * Image captcha
     */
    void create(HttpServletResponse response, String uuid) throws IOException;

    /**
     * Validate captcha
     * 
     * @param uuid   uuid
     * @param code   captcha
     * @param delete whether to delete the captcha
     * @return true: success false: failure
     */
    boolean validate(String uuid, String code, Boolean delete);

    /**
     * Send SMS verification code
     * 
     * @param phone phone number
     */
    void sendSMSValidateCode(String phone);

    /**
     * Validate SMS verification code
     * 
     * @param phone  phone number
     * @param code   verification code
     * @param delete whether to delete the verification code
     * @return true: success false: failure
     */
    boolean validateSMSValidateCode(String phone, String code, Boolean delete);
}
