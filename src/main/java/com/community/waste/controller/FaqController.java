package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.Faq;
import com.community.waste.entity.User;
import com.community.waste.service.FaqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 常见问题控制器
 */
@RestController
@RequestMapping("/api/faq")
public class FaqController {
    
    @Autowired
    private FaqService faqService;
    
    /**
     * 获取所有常见问题
     */
    @GetMapping("/list")
    public Result<List<Faq>> getFaqList() {
        List<Faq> faqs = faqService.getAllFaqs();
        return Result.success(faqs);
    }
    
    /**
     * 获取单个常见问题详情
     */
    @GetMapping("/{id}")
    public Result<Faq> getFaqDetail(@PathVariable Integer id) {
        Faq faq = faqService.getFaqById(id);
        if (faq == null) {
            return Result.error("常见问题不存在");
        }
        return Result.success(faq);
    }
    
    /**
     * 添加常见问题（管理员权限）
     */
    @PostMapping("/add")
    public Result<Faq> addFaq(@RequestBody Faq faq, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        Faq addedFaq = faqService.addFaq(faq);
        return Result.success("添加成功", addedFaq);
    }
    
    /**
     * 更新常见问题（管理员权限）
     */
    @PutMapping("/update")
    public Result<Faq> updateFaq(@RequestBody Faq faq, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        Faq updatedFaq = faqService.updateFaq(faq);
        return Result.success("更新成功", updatedFaq);
    }
    
    /**
     * 删除常见问题（管理员权限）
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteFaq(@PathVariable Integer id, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        faqService.deleteFaq(id);
        return Result.success("删除成功", "");
    }
} 