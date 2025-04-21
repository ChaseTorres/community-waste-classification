package com.community.waste.mapper;

import com.community.waste.entity.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 活动Mapper接口
 */
public interface ActivityMapper {
    
    /**
     * 根据ID查询活动
     */
    Activity selectById(Integer id);
    
    /**
     * 查询所有活动
     */
    List<Activity> selectAll();
    
    /**
     * 查询未过期活动
     */
    List<Activity> selectNotExpired(Date currentTime);
    
    /**
     * 按时间排序查询活动列表
     */
    List<Activity> selectByTimeOrder(@Param("expired") Boolean expired);
    
    /**
     * 新增活动
     */
    int insert(Activity activity);
    
    /**
     * 更新活动
     */
    int update(Activity activity);
    
    /**
     * 删除活动
     */
    int deleteById(Integer id);
} 