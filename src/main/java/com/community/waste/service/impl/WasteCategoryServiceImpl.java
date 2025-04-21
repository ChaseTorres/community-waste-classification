package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.WasteCategory;
import com.community.waste.mapper.WasteCategoryMapper;
import com.community.waste.service.WasteCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 垃圾分类服务实现类
 */
@Service
public class WasteCategoryServiceImpl implements WasteCategoryService {
    
    @Autowired
    private WasteCategoryMapper wasteCategoryMapper;
    
    @Override
    public List<WasteCategory> getAllCategories() {
        return wasteCategoryMapper.selectAll();
    }
    
    @Override
    public WasteCategory getCategoryById(Integer id) {
        if (id == null) {
            throw new BusinessException("垃圾分类ID不能为空");
        }
        return wasteCategoryMapper.selectById(id);
    }
    
    @Override
    public WasteCategory addCategory(WasteCategory category) {
        // 参数校验
        if (category == null) {
            throw new BusinessException("垃圾分类信息不能为空");
        }
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new BusinessException("垃圾分类名称不能为空");
        }
        
        // 设置创建时间和更新时间
        Date now = new Date();
        category.setCreateTime(now);
        category.setUpdateTime(now);
        
        // 插入数据库
        wasteCategoryMapper.insert(category);
        
        return category;
    }
    
    @Override
    public WasteCategory updateCategory(WasteCategory category) {
        // 参数校验
        if (category == null || category.getId() == null) {
            throw new BusinessException("垃圾分类ID不能为空");
        }
        
        // 检查是否存在
        WasteCategory existingCategory = wasteCategoryMapper.selectById(category.getId());
        if (existingCategory == null) {
            throw new BusinessException("垃圾分类不存在");
        }
        
        // 设置更新时间
        category.setUpdateTime(new Date());
        
        // 更新数据库
        wasteCategoryMapper.update(category);
        
        return category;
    }
    
    @Override
    public void deleteCategory(Integer id) {
        // 参数校验
        if (id == null) {
            throw new BusinessException("垃圾分类ID不能为空");
        }
        
        // 检查是否存在
        WasteCategory existingCategory = wasteCategoryMapper.selectById(id);
        if (existingCategory == null) {
            throw new BusinessException("垃圾分类不存在");
        }
        
        // 删除数据库记录
        wasteCategoryMapper.deleteById(id);
    }
    
    @Override
    public List<WasteCategory> searchCategories(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return wasteCategoryMapper.selectAll();
        }
        return wasteCategoryMapper.searchByKeyword(keyword.trim());
    }
} 