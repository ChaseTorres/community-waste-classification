package com.community.waste.service;

import com.community.waste.entity.Activity;
import java.util.List;

/**
 * 活动服务接口
 */
public interface ActivityService {
    
    /**
     * 根据ID查询活动
     */
    Activity getActivityById(Integer id);
    
    /**
     * 查询所有活动
     */
    List<Activity> getAllActivities();
    
    /**
     * 查询未过期活动
     */
    List<Activity> getNotExpiredActivities();
    
    /**
     * 查询活动列表（可按是否过期筛选）
     */
    List<Activity> getActivitiesByExpired(Boolean expired);
    
    /**
     * 添加活动
     */
    Activity addActivity(Activity activity);
    
    /**
     * 更新活动
     */
    Activity updateActivity(Activity activity);
    
    /**
     * 删除活动
     */
    boolean deleteActivity(Integer id);
} 