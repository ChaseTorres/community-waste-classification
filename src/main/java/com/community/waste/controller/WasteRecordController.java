package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.User;
import com.community.waste.entity.WasteRecord;
import com.community.waste.service.WasteRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 垃圾投放记录控制器
 */
@RestController
@RequestMapping("/api/record")
public class WasteRecordController {
    
    @Autowired
    private WasteRecordService wasteRecordService;
    
    /**
     * 获取所有投放记录（管理员权限）
     */
    @GetMapping("/list")
    public Result<List<WasteRecord>> getAllRecords(HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        List<WasteRecord> records = wasteRecordService.getAllRecords();
        return Result.success(records);
    }
    
    /**
     * 获取当前用户的投放记录
     */
    @GetMapping("/my")
    public Result<List<WasteRecord>> getMyRecords(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        List<WasteRecord> records = wasteRecordService.getRecordsByUserId(user.getId());
        return Result.success(records);
    }
    
    /**
     * 获取指定垃圾分类的投放记录（管理员权限）
     */
    @GetMapping("/category/{categoryId}")
    public Result<List<WasteRecord>> getRecordsByCategory(@PathVariable Integer categoryId, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        List<WasteRecord> records = wasteRecordService.getRecordsByCategoryId(categoryId);
        return Result.success(records);
    }
    
    /**
     * 获取指定用户的投放记录（管理员权限）
     */
    @GetMapping("/user/{userId}")
    public Result<List<WasteRecord>> getRecordsByUser(@PathVariable Integer userId, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        List<WasteRecord> records = wasteRecordService.getRecordsByUserId(userId);
        return Result.success(records);
    }
    
    /**
     * 获取单个投放记录详情
     */
    @GetMapping("/{id}")
    public Result<WasteRecord> getRecordDetail(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        WasteRecord record = wasteRecordService.getRecordById(id);
        if (record == null) {
            return Result.error("投放记录不存在");
        }
        
        // 非管理员只能查看自己的记录
        if (user.getRole() < 1 && !user.getId().equals(record.getUserId())) {
            return Result.error("无权限");
        }
        
        return Result.success(record);
    }
    
    /**
     * 添加投放记录
     */
    @PostMapping("/add")
    public Result<WasteRecord> addRecord(@RequestBody WasteRecord record, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 设置当前用户ID
        record.setUserId(user.getId());
        
        WasteRecord addedRecord = wasteRecordService.addRecord(record);
        return Result.success("添加成功", addedRecord);
    }
    
    /**
     * 更新投放记录
     */
    @PutMapping("/update")
    public Result<WasteRecord> updateRecord(@RequestBody WasteRecord record, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 查询原记录
        WasteRecord existingRecord = wasteRecordService.getRecordById(record.getId());
        if (existingRecord == null) {
            return Result.error("投放记录不存在");
        }
        
        // 非管理员只能修改自己的记录
        if (user.getRole() < 1 && !user.getId().equals(existingRecord.getUserId())) {
            return Result.error("无权限");
        }
        
        WasteRecord updatedRecord = wasteRecordService.updateRecord(record);
        return Result.success("更新成功", updatedRecord);
    }
    
    /**
     * 删除投放记录
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteRecord(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 查询原记录
        WasteRecord existingRecord = wasteRecordService.getRecordById(id);
        if (existingRecord == null) {
            return Result.error("投放记录不存在");
        }
        
        // 非管理员只能删除自己的记录
        if (user.getRole() < 1 && !user.getId().equals(existingRecord.getUserId())) {
            return Result.error("无权限");
        }
        
        wasteRecordService.deleteRecord(id);
        return Result.success("删除成功", "");
    }
    
    /**
     * 按条件搜索投放记录
     */
    @GetMapping("/search")
    public Result<List<WasteRecord>> searchRecords(
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
            @RequestParam(required = false) String location,
            HttpSession session) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 非管理员只能查询自己的记录
        Integer userId = user.getRole() < 1 ? user.getId() : null;
        
        List<WasteRecord> records = wasteRecordService.getRecordsByCondition(
                userId, categoryId, startTime, endTime, location);
        
        return Result.success(records);
    }
    
    /**
     * 获取用户总投放重量
     */
    @GetMapping("/weight/total")
    public Result<Double> getTotalWeight(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        Double totalWeight = wasteRecordService.getUserTotalWeight(user.getId());
        return Result.success(totalWeight);
    }
    
    /**
     * 获取各分类投放统计（管理员权限）
     */
    @GetMapping("/stats/category")
    public Result<List<Map<String, Object>>> getCategoryStats(HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        List<Map<String, Object>> stats = wasteRecordService.getCategoryStatistics();
        return Result.success(stats);
    }
    
    /**
     * 获取每日投放统计
     */
    @GetMapping("/stats/daily")
    public Result<List<Map<String, Object>>> getDailyStats(
            @RequestParam(required = false, defaultValue = "30") Integer days,
            HttpSession session) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        List<Map<String, Object>> stats = wasteRecordService.getDailyStatistics(days);
        return Result.success(stats);
    }
} 