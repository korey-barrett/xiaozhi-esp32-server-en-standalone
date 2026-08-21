package xiaozhi.modules.config.service;

import java.util.List;
import java.util.Map;

public interface ConfigService {
    /**
     * Get the server configuration
     *
     * @param isCache whether to use the cache
     * @return configuration info
     */
    Map<String, Object> getConfig(Boolean isCache);

    /**
     * Get the agent model configuration
     *
     * @param macAddress     MAC address
     * @param selectedModule models already instantiated by the client
     * @return model configuration info
     */
    Map<String, Object> getAgentModels(String macAddress, Map<String, String> selectedModule);

    /**
     * Get the agent's correct words
     *
     * @param macAddress device MAC address
     * @return correct word list, e.g. ["template1|template01", "template2|template02"]
     */
    List<String> getCorrectWords(String macAddress);
}
