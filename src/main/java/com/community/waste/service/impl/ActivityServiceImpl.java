package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.Activity;
import com.community.waste.mapper.ActivityMapper;
import com.community.waste.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 活动服务实现类
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public Activity getActivityById(Integer id) {
        Activity activity = activityMapper.selectById(id);
        if (activity != null) {
            // 判断活动是否过期
            activity.setExpired(new Date().after(activity.getEndTime()));
        }
        return activity;
    }

    @Override
    public List<Activity> getAllActivities() {
        List<Activity> activities = activityMapper.selectAll();
        // 判断每个活动是否过期
        Date now = new Date();
        for (Activity activity : activities) {
            activity.setExpired(now.after(activity.getEndTime()));
        }
        return activities;
    }

    @Override
    public List<Activity> getNotExpiredActivities() {
        return activityMapper.selectNotExpired(new Date());
    }

    @Override
    public List<Activity> getActivitiesByExpired(Boolean expired) {
        return activityMapper.selectByTimeOrder(expired);
    }

    @Override
    @Transactional
    public Activity addActivity(Activity activity) {
        // 校验活动信息
        validateActivity(activity);
        
        // 设置发布时间
        activity.setPublishTime(new Date());
        
        // 插入活动
        activityMapper.insert(activity);
        
        return activityMapper.selectById(activity.getId());
    }

    @Override
    @Transactional
    public Activity updateActivity(Activity activity) {
        // 检查活动是否存在
        Activity existActivity = activityMapper.selectById(activity.getId());
        if (existActivity == null) {
            throw new BusinessException("活动不存在");
        }
        
        // 校验活动信息
        validateActivity(activity);
        
        // 更新活动
        activityMapper.update(activity);
        
        return activityMapper.selectById(activity.getId());
    }

    @Override
    @Transactional
    public boolean deleteActivity(Integer id) {
        return activityMapper.deleteById(id) > 0;
    }
    
    /**
     * 校验活动信息
     */
    private void validateActivity(Activity activity) {
        if (activity.getTitle() == null || activity.getTitle().trim().isEmpty()) {
            throw new BusinessException("活动标题不能为空");
        }
        
        if (activity.getContent() == null || activity.getContent().trim().isEmpty()) {
            throw new BusinessException("活动内容不能为空");
        }
        
        if (activity.getStartTime() == null) {
            throw new BusinessException("开始时间不能为空");
        }
        
        if (activity.getEndTime() == null) {
            throw new BusinessException("结束时间不能为空");
        }
        
        if (activity.getStartTime().after(activity.getEndTime())) {
            throw new BusinessException("开始时间不能晚于结束时间");
        }
    }
} 