package xiaozhi.modules.sms.service;

/**
 * Interface defining the methods of the SMS service
 *
 * @author zjy
 * @since 2025-05-12
 */
public interface SmsService {

    /**
     * Send a verification code SMS
     * @param phone the phone number
     * @param VerificationCode the verification code
     */
    void sendVerificationCodeSms(String phone, String VerificationCode) ;
}
