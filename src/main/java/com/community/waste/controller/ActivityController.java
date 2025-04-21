package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.Activity;
import com.community.waste.entity.User;
import com.community.waste.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 活动控制器
 */
@RestController
@RequestMapping("/api/activity")
public class ActivityController {
    
    @Autowired
    private ActivityService activityService;
    
    /**
     * 获取所有活动
     */
    @GetMapping("/list")
    public Result<List<Activity>> getActivityList(@RequestParam(required = false) Boolean expired) {
        List<Activity> activities;
        if (expired != null) {
            activities = activityService.getActivitiesByExpired(expired);
        } else {
            activities = activityService.getAllActivities();
        }
        return Result.success(activities);
    }
    
    /**
     * 获取单个活动详情
     */
    @GetMapping("/{id}")
    public Result<Activity> getActivityDetail(@PathVariable Integer id) {
        Activity activity = activityService.getActivityById(id);
        if (activity == null) {
            return Result.error("活动不存在");
        }
        return Result.success(activity);
    }
    
    /**
     * 获取未过期活动
     */
    @GetMapping("/active")
    public Result<List<Activity>> getActiveActivities() {
        List<Activity> activities = activityService.getNotExpiredActivities();
        return Result.success(activities);
    }
    
    /**
     * 添加活动（管理员权限）
     */
    @PostMapping("/add")
    public Result<Activity> addActivity(@RequestBody Activity activity, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        activity.setPublisherId(currentUser.getId());
        Activity addedActivity = activityService.addActivity(activity);
        return Result.success("活动添加成功", addedActivity);
    }
    
    /**
     * 更新活动（管理员权限）
     */
    @PutMapping("/update")
    public Result<Activity> updateActivity(@RequestBody Activity activity, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        Activity updatedActivity = activityService.updateActivity(activity);
        return Result.success("活动更新成功", updatedActivity);
    }
    
    /**
     * 删除活动（管理员权限）
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteActivity(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        activityService.deleteActivity(id);
        return Result.success("活动删除成功", "");
    }
} 