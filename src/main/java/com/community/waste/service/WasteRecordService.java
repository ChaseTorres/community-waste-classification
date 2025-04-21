package com.community.waste.service;

import com.community.waste.entity.WasteRecord;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 垃圾投放记录服务接口
 */
public interface WasteRecordService {
    
    /**
     * 获取所有垃圾投放记录
     */
    List<WasteRecord> getAllRecords();
    
    /**
     * 获取指定用户的投放记录
     */
    List<WasteRecord> getRecordsByUserId(Integer userId);
    
    /**
     * 获取指定垃圾分类的投放记录
     */
    List<WasteRecord> getRecordsByCategoryId(Integer categoryId);
    
    /**
     * 获取指定ID的投放记录
     */
    WasteRecord getRecordById(Integer id);
    
    /**
     * 添加投放记录
     */
    WasteRecord addRecord(WasteRecord record);
    
    /**
     * 更新投放记录
     */
    WasteRecord updateRecord(WasteRecord record);
    
    /**
     * 删除投放记录
     */
    void deleteRecord(Integer id);
    
    /**
     * 按条件查询投放记录
     * @param userId 用户ID，可为null
     * @param categoryId 分类ID，可为null
     * @param startTime 开始时间，可为null
     * @param endTime 结束时间，可为null
     * @param location 地点关键词，可为null
     */
    List<WasteRecord> getRecordsByCondition(Integer userId, Integer categoryId, 
                                        Date startTime, Date endTime, String location);
    
    /**
     * 获取用户的总投放重量
     */
    Double getUserTotalWeight(Integer userId);
    
    /**
     * 获取各分类投放统计数据
     */
    List<Map<String, Object>> getCategoryStatistics();
    
    /**
     * 获取最近n天的每日投放统计
     */
    List<Map<String, Object>> getDailyStatistics(Integer days);
} 