package com.community.waste.mapper;

import com.community.waste.entity.WasteCategory;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 垃圾分类Mapper接口
 */
public interface WasteCategoryMapper {
    
    /**
     * 查询所有垃圾分类
     */
    List<WasteCategory> selectAll();
    
    /**
     * 根据ID查询垃圾分类
     */
    WasteCategory selectById(@Param("id") Integer id);
    
    /**
     * 新增垃圾分类
     */
    int insert(WasteCategory category);
    
    /**
     * 更新垃圾分类
     */
    int update(WasteCategory category);
    
    /**
     * 删除垃圾分类
     */
    int deleteById(@Param("id") Integer id);
    
    /**
     * 根据关键词搜索垃圾分类
     */
    List<WasteCategory> searchByKeyword(@Param("keyword") String keyword);
} 