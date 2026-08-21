package xiaozhi.common.page;

import java.io.Serializable;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * Paging utility class
 * Copyright (c) renren.io All rights reserved.
 * Website: https://www.renren.io
 */
@Data
@Schema(description = "Page data")
public class PageData<T> implements Serializable {
    @Schema(description = "Total record count")
    private int total;

    @Schema(description = "List data")
    private List<T> list;

    /**
     * Paging
     *
     * @param list  list data
     * @param total total record count
     */
    public PageData(List<T> list, long total) {
        this.list = list;
        this.total = (int) total;
    }
}