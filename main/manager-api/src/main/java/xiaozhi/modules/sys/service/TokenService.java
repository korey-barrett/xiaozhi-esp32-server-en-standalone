package xiaozhi.modules.sys.service;

public interface TokenService {
    /**
     * Generates a token
     *
     * @param userId
     * @return
     */
    String createToken(long userId);
}
