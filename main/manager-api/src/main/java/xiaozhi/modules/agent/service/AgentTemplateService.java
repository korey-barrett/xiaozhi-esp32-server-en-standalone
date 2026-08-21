package xiaozhi.modules.agent.service;

import com.baomidou.mybatisplus.extension.repository.IRepository;

import xiaozhi.modules.agent.entity.AgentTemplateEntity;

/**
 * @author chenerlei
 * @description Database operation Service for table [ai_agent_template (Agent Configuration Template Table)]
 * @createDate 2025-03-22 11:48:18
 */
public interface AgentTemplateService extends IRepository<AgentTemplateEntity> {

    /**
     * Get the default template
     * 
     * @return the default template entity
     */
    AgentTemplateEntity getDefaultTemplate();

    /**
     * Update the model ID in the default template
     * 
     * @param modelType the model type
     * @param modelId   the model ID
     */
    void updateDefaultTemplateModelId(String modelType, String modelId);

    /**
     * Reorder the remaining templates after a template is deleted
     * 
     * @param deletedSort the sort value of the deleted template
     */
    void reorderTemplatesAfterDelete(Integer deletedSort);

    /**
     * Get the next available sort number (find the smallest unused number)
     * 
     * @return the next available sort number
     */
    Integer getNextAvailableSort();
}
