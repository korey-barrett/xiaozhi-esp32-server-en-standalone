package xiaozhi.common.service;

import java.io.Serializable;
import java.util.Collection;

import com.baomidou.mybatisplus.core.conditions.Wrapper;

/**
 * Base service interface; every Service interface must extend it.
 * Copyright (c) renren-io All rights reserved.
 * Website: https://www.renren.io
 */
public interface BaseService<T> {
    Class<T> currentModelClass();

    /**
     * <p>
     * Insert a single record (selective fields, strategy-based insert)
     * </p>
     *
     * @param entity the entity object
     */
    boolean insert(T entity);

    /**
     * <p>
     * Insert (batch). This method does not support Oracle or SQL Server.
     * </p>
     *
     * @param entityList collection of entity objects
     */
    boolean insertBatch(Collection<T> entityList);

    /**
     * <p>
     * Insert (batch). This method does not support Oracle or SQL Server.
     * </p>
     *
     * @param entityList collection of entity objects
     * @param batchSize  batch size of each insert
     */
    boolean insertBatch(Collection<T> entityList, int batchSize);

    /**
     * <p>
     * Update by ID (selective update)
     * </p>
     *
     * @param entity the entity object
     */
    boolean updateById(T entity);

    /**
     * <p>
     * Update records according to the whereEntity condition
     * </p>
     *
     * @param entity        the entity object
     * @param updateWrapper the wrapper class that encapsulates entity operations
     *                      {@link com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper}
     */
    boolean update(T entity, Wrapper<T> updateWrapper);

    /**
     * <p>
     * Batch update by ID
     * </p>
     *
     * @param entityList collection of entity objects
     */
    boolean updateBatchById(Collection<T> entityList);

    /**
     * <p>
     * Batch update by ID
     * </p>
     *
     * @param entityList collection of entity objects
     * @param batchSize  batch size of each update
     */
    boolean updateBatchById(Collection<T> entityList, int batchSize);

    /**
     * <p>
     * Query by ID
     * </p>
     *
     * @param id the primary key ID
     */
    T selectById(Serializable id);

    /**
     * <p>
     * Delete by ID
     * </p>
     *
     * @param id the primary key ID
     */
    boolean deleteById(Serializable id);

    /**
     * <p>
     * Delete (batch delete by ID)
     * </p>
     *
     * @param idList list of primary key IDs
     */
    boolean deleteBatchIds(Collection<? extends Serializable> idList);
}