package com.community.waste.mapper;

import com.community.waste.entity.WasteRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 垃圾投放记录Mapper接口
 */
public interface WasteRecordMapper {
    
    /**
     * 查询所有垃圾投放记录
     */
    List<WasteRecord> selectAll();
    
    /**
     * 根据用户ID查询投放记录
     */
    List<WasteRecord> selectByUserId(@Param("userId") Integer userId);
    
    /**
     * 根据垃圾分类ID查询投放记录
     */
    List<WasteRecord> selectByCategoryId(@Param("categoryId") Integer categoryId);
    
    /**
     * 根据ID查询投放记录
     */
    WasteRecord selectById(@Param("id") Integer id);
    
    /**
     * 新增投放记录
     */
    int insert(WasteRecord record);
    
    /**
     * 更新投放记录
     */
    int update(WasteRecord record);
    
    /**
     * 删除投放记录
     */
    int deleteById(@Param("id") Integer id);
    
    /**
     * 按条件查询投放记录
     */
    List<WasteRecord> selectByCondition(Map<String, Object> params);
    
    /**
     * 统计投放总重量
     */
    Double sumWeightByUserId(@Param("userId") Integer userId);
    
    /**
     * 统计各分类投放数量
     */
    List<Map<String, Object>> countGroupByCategory();
    
    /**
     * 统计每日投放数量
     */
    List<Map<String, Object>> countGroupByDate(@Param("days") Integer days);
} 