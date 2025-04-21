package com.community.waste.service;

import com.community.waste.entity.WasteCategory;
import java.util.List;

/**
 * 垃圾分类服务接口
 */
public interface WasteCategoryService {
    
    /**
     * 获取所有垃圾分类
     */
    List<WasteCategory> getAllCategories();
    
    /**
     * 根据ID获取垃圾分类
     */
    WasteCategory getCategoryById(Integer id);
    
    /**
     * 添加垃圾分类
     */
    WasteCategory addCategory(WasteCategory category);
    
    /**
     * 更新垃圾分类
     */
    WasteCategory updateCategory(WasteCategory category);
    
    /**
     * 删除垃圾分类
     */
    void deleteCategory(Integer id);
    
    /**
     * 根据关键词搜索垃圾分类
     */
    List<WasteCategory> searchCategories(String keyword);
} 