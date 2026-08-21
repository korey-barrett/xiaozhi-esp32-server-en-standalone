package xiaozhi.common.utils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * Tree node; any class that needs to implement a tree node must extend this class
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
@Data
public class TreeNode<T> implements Serializable {

    /**
     * Primary key
     */
    private Long id;
    /**
     * Parent ID
     */
    private Long pid;
    /**
     * List of child nodes
     */
    private List<T> children = new ArrayList<>();

}