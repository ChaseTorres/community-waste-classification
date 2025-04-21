package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.WasteCategory;
import com.community.waste.service.WasteCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 垃圾分类控制器
 */
@RestController
@RequestMapping("/api/waste")
public class WasteCategoryController {
    
    @Autowired
    private WasteCategoryService wasteCategoryService;
    
    /**
     * 获取所有垃圾分类
     */
    @GetMapping("/list")
    public Result<List<WasteCategory>> getWasteCategoryList() {
        List<WasteCategory> categories = wasteCategoryService.getAllCategories();
        return Result.success(categories);
    }
    
    /**
     * 获取单个垃圾分类详情
     */
    @GetMapping("/{id}")
    public Result<WasteCategory> getWasteCategoryDetail(@PathVariable Integer id) {
        WasteCategory category = wasteCategoryService.getCategoryById(id);
        if (category == null) {
            return Result.error("垃圾分类不存在");
        }
        return Result.success(category);
    }
    
    /**
     * 添加垃圾分类（管理员权限）
     */
    @PostMapping("/add")
    public Result<WasteCategory> addWasteCategory(@RequestBody WasteCategory category, HttpSession session) {
        // 权限检查
        if (!checkAdminPermission(session)) {
            return Result.error("无权限");
        }
        
        WasteCategory addedCategory = wasteCategoryService.addCategory(category);
        return Result.success("添加成功", addedCategory);
    }
    
    /**
     * 更新垃圾分类（管理员权限）
     */
    @PutMapping("/update")
    public Result<WasteCategory> updateWasteCategory(@RequestBody WasteCategory category, HttpSession session) {
        // 权限检查
        if (!checkAdminPermission(session)) {
            return Result.error("无权限");
        }
        
        WasteCategory updatedCategory = wasteCategoryService.updateCategory(category);
        return Result.success("更新成功", updatedCategory);
    }
    
    /**
     * 删除垃圾分类（管理员权限）
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteWasteCategory(@PathVariable Integer id, HttpSession session) {
        // 权限检查
        if (!checkAdminPermission(session)) {
            return Result.error("无权限");
        }
        
        wasteCategoryService.deleteCategory(id);
        return Result.success("删除成功", "");
    }
    
    /**
     * 检查管理员权限
     */
    private boolean checkAdminPermission(HttpSession session) {
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            return false;
        }
        
        // 将对象转为User类型
        com.community.waste.entity.User user = (com.community.waste.entity.User) userObj;
        // 管理员角色值大于0
        return user.getRole() > 0;
    }
    
    /**
     * 搜索垃圾分类
     */
    @GetMapping("/search")
    public Result<List<WasteCategory>> searchCategories(@RequestParam String keyword) {
        List<WasteCategory> categories = wasteCategoryService.searchCategories(keyword);
        return Result.success(categories);
    }
} 