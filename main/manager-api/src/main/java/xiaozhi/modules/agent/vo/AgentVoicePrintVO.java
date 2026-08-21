package xiaozhi.modules.agent.vo;

import lombok.Data;

import java.util.Date;

/**
 * VO for displaying the agent voice print list
 */
@Data
public class AgentVoicePrintVO {

    /**
     * Primary key id
     */
    private String id;
    /**
     * Audio file id
     */
    private String audioId;
    /**
     * Name of the person the voice print originates from
     */
    private String sourceName;
    /**
     * Description of the person the voice print originates from
     */
    private String introduce;
    /**
     * Creation time
     */
    private Date createDate;
}
