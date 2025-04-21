package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.User;
import com.community.waste.entity.WasteRecord;
import com.community.waste.service.UserService;
import com.community.waste.service.WasteRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 统计数据控制器
 */
@RestController
@RequestMapping("/api/record/stats")
public class StatisticsController {
    
    @Autowired
    private WasteRecordService wasteRecordService;
    
    @Autowired
    private UserService userService;
    
    /**
     * 获取汇总统计数据
     */
    @GetMapping("/summary")
    public Result<Map<String, Object>> getSummaryStats(HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 是否为管理员
        boolean isAdmin = user.getRole() > 0;
        Map<String, Object> stats = new HashMap<>();
        
        if (isAdmin) {
            // 管理员可以看所有统计
            // 获取所有记录
            List<WasteRecord> allRecords = wasteRecordService.getAllRecords();
            
            // 计算数据
            int totalRecords = allRecords.size();
            double totalWeight = 0;
            
            // 统计参与的用户
            Map<Integer, Boolean> userMap = new HashMap<>();
            
            for (WasteRecord record : allRecords) {
                totalWeight += record.getWeight();
                userMap.put(record.getUserId(), true);
            }
            
            int totalUsers = userMap.size();
            double avgWeight = totalRecords > 0 ? totalWeight / totalRecords : 0;
            
            // 设置统计数据
            stats.put("totalRecords", totalRecords);
            stats.put("totalWeight", totalWeight);
            stats.put("totalUsers", totalUsers);
            stats.put("avgWeight", avgWeight);
        } else {
            // 普通用户只能看自己的统计
            List<WasteRecord> userRecords = wasteRecordService.getRecordsByUserId(user.getId());
            
            int totalRecords = userRecords.size();
            double totalWeight = 0;
            
            for (WasteRecord record : userRecords) {
                totalWeight += record.getWeight();
            }
            
            double avgWeight = totalRecords > 0 ? totalWeight / totalRecords : 0;
            
            // 设置统计数据
            stats.put("totalRecords", totalRecords);
            stats.put("totalWeight", totalWeight);
            stats.put("totalUsers", 1); // 只有当前用户
            stats.put("avgWeight", avgWeight);
        }
        
        return Result.success(stats);
    }
    
    /**
     * 获取各分类投放统计
     */
    @GetMapping("/category-statistics")
    public Result<List<Map<String, Object>>> getCategoryStats(HttpSession session) {
        // 直接复用WasteRecordController中的方法
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        List<Map<String, Object>> stats = wasteRecordService.getCategoryStatistics();
        return Result.success(stats);
    }
    
    /**
     * 获取每日投放统计
     */
    @GetMapping("/daily-statistics")
    public Result<List<Map<String, Object>>> getDailyStats(Integer days, HttpSession session) {
        // 直接复用WasteRecordController中的方法
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        if (days == null || days <= 0) {
            days = 30; // 默认30天
        }
        
        List<Map<String, Object>> stats = wasteRecordService.getDailyStatistics(days);
        return Result.success(stats);
    }
} 