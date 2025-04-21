package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.Announcement;
import com.community.waste.entity.User;
import com.community.waste.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 公告控制器
 */
@RestController
@RequestMapping("/api/announcement")
public class AnnouncementController {
    
    @Autowired
    private AnnouncementService announcementService;
    
    /**
     * 获取所有公告
     */
    @GetMapping("/list")
    public Result<List<Announcement>> getAnnouncementList() {
        List<Announcement> announcements = announcementService.getAllAnnouncements();
        return Result.success(announcements);
    }
    
    /**
     * 获取单个公告详情
     */
    @GetMapping("/{id}")
    public Result<Announcement> getAnnouncementDetail(@PathVariable Integer id) {
        Announcement announcement = announcementService.getAnnouncementById(id);
        if (announcement == null) {
            return Result.error("公告不存在");
        }
        return Result.success(announcement);
    }
    
    /**
     * 添加公告（管理员权限）
     */
    @PostMapping("/add")
    public Result<Announcement> addAnnouncement(@RequestBody Announcement announcement, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        // 设置发布者ID
        announcement.setPublisherId(user.getId());
        
        Announcement addedAnnouncement = announcementService.addAnnouncement(announcement);
        return Result.success("添加成功", addedAnnouncement);
    }
    
    /**
     * 更新公告（管理员权限）
     */
    @PutMapping("/update")
    public Result<Announcement> updateAnnouncement(@RequestBody Announcement announcement, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        Announcement updatedAnnouncement = announcementService.updateAnnouncement(announcement);
        return Result.success("更新成功", updatedAnnouncement);
    }
    
    /**
     * 删除公告（管理员权限）
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteAnnouncement(@PathVariable Integer id, HttpSession session) {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            return Result.error("无权限");
        }
        
        announcementService.deleteAnnouncement(id);
        return Result.success("删除成功", "");
    }
} 