package com.community.waste.service;

import com.community.waste.entity.Announcement;
import java.util.List;

/**
 * 公告服务接口
 */
public interface AnnouncementService {
    
    /**
     * 获取所有公告
     */
    List<Announcement> getAllAnnouncements();
    
    /**
     * 根据ID获取公告
     */
    Announcement getAnnouncementById(Integer id);
    
    /**
     * 添加公告
     */
    Announcement addAnnouncement(Announcement announcement);
    
    /**
     * 更新公告
     */
    Announcement updateAnnouncement(Announcement announcement);
    
    /**
     * 删除公告
     */
    void deleteAnnouncement(Integer id);
} 