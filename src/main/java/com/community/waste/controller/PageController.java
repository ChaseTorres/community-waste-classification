package com.community.waste.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 页面控制器
 */
@Controller
public class PageController {
    
    /**
     * 登录页面
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }
    
    /**
     * 注册页面
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }
    
    /**
     * 首页
     */
    @GetMapping({"/", "/index"})
    public String index() {
        return "index";
    }
    
    /**
     * 垃圾分类指南页面
     */
    @GetMapping("/guide")
    public String guide() {
        return "guide";
    }
    
    /**
     * 常见问题页面
     */
    @GetMapping("/faq")
    public String faq() {
        return "faq";
    }
    
    /**
     * 垃圾投放记录页面
     */
    @GetMapping("/record")
    public String record() {
        return "record";
    }
    
    /**
     * 社区公告页面
     */
    @GetMapping("/announcement")
    public String announcement() {
        return "announcement";
    }
    
    /**
     * 社区活动页面
     */
    @GetMapping("/activity")
    public String activity() {
        return "activity";
    }
    
    /**
     * 数据统计页面
     */
    @GetMapping("/statistics")
    public String statistics() {
        return "statistics";
    }
    
    /**
     * 用户管理页面
     */
    @GetMapping("/admin/user")
    public String userManagement() {
        return "admin/user";
    }
    
    /**
     * 公告管理页面
     */
    @GetMapping("/admin/announcement")
    public String announcementManagement() {
        return "admin/announcement";
    }
    
    /**
     * 活动管理页面
     */
    @GetMapping("/admin/activity")
    public String activityManagement() {
        return "admin/activity";
    }
    
    /**
     * 系统状态检查（开发模式）
     */
    @GetMapping("/dev/status")
    @ResponseBody
    public String status() {
        return "系统正常运行中 - " + System.currentTimeMillis();
    }
}