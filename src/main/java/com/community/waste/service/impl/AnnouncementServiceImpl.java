package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.Announcement;
import com.community.waste.entity.User;
import com.community.waste.mapper.AnnouncementMapper;
import com.community.waste.mapper.UserMapper;
import com.community.waste.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 公告服务实现类
 */
@Service
public class AnnouncementServiceImpl implements AnnouncementService {
    
    @Autowired
    private AnnouncementMapper announcementMapper;
    
    @Autowired
    private UserMapper userMapper;
    
    @Override
    public List<Announcement> getAllAnnouncements() {
        List<Announcement> announcements = announcementMapper.selectAll();
        
        // 查询发布者信息
        for (Announcement announcement : announcements) {
            User publisher = userMapper.selectById(announcement.getPublisherId());
            announcement.setPublisher(publisher);
        }
        
        return announcements;
    }
    
    @Override
    public Announcement getAnnouncementById(Integer id) {
        if (id == null) {
            throw new BusinessException("公告ID不能为空");
        }
        
        Announcement announcement = announcementMapper.selectById(id);
        if (announcement != null) {
            // 查询发布者信息
            User publisher = userMapper.selectById(announcement.getPublisherId());
            announcement.setPublisher(publisher);
        }
        
        return announcement;
    }
    
    @Override
    public Announcement addAnnouncement(Announcement announcement) {
        // 参数校验
        if (announcement == null) {
            throw new BusinessException("公告信息不能为空");
        }
        if (announcement.getTitle() == null || announcement.getTitle().trim().isEmpty()) {
            throw new BusinessException("公告标题不能为空");
        }
        if (announcement.getContent() == null || announcement.getContent().trim().isEmpty()) {
            throw new BusinessException("公告内容不能为空");
        }
        if (announcement.getPublisherId() == null) {
            throw new BusinessException("发布者不能为空");
        }
        
        // 设置发布时间和更新时间
        Date now = new Date();
        announcement.setPublishTime(now);
        announcement.setUpdateTime(now);
        
        // 插入数据库
        announcementMapper.insert(announcement);
        
        return announcement;
    }
    
    @Override
    public Announcement updateAnnouncement(Announcement announcement) {
        // 参数校验
        if (announcement == null || announcement.getId() == null) {
            throw new BusinessException("公告ID不能为空");
        }
        
        // 检查是否存在
        Announcement existingAnnouncement = announcementMapper.selectById(announcement.getId());
        if (existingAnnouncement == null) {
            throw new BusinessException("公告不存在");
        }
        
        // 设置更新时间
        announcement.setUpdateTime(new Date());
        
        // 更新数据库
        announcementMapper.update(announcement);
        
        return announcement;
    }
    
    @Override
    public void deleteAnnouncement(Integer id) {
        // 参数校验
        if (id == null) {
            throw new BusinessException("公告ID不能为空");
        }
        
        // 检查是否存在
        Announcement existingAnnouncement = announcementMapper.selectById(id);
        if (existingAnnouncement == null) {
            throw new BusinessException("公告不存在");
        }
        
        // 删除数据库记录
        announcementMapper.deleteById(id);
    }
} 