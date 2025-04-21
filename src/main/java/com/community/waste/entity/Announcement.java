package com.community.waste.entity;

import java.util.Date;

/**
 * 公告实体类
 */
public class Announcement {
    /**
     * 公告ID
     */
    private Integer id;
    
    /**
     * 公告标题
     */
    private String title;
    
    /**
     * 公告内容
     */
    private String content;
    
    /**
     * 发布者ID
     */
    private Integer publisherId;
    
    /**
     * 发布时间
     */
    private Date publishTime;
    
    /**
     * 更新时间
     */
    private Date updateTime;
    
    /**
     * 发布者（非数据库字段）
     */
    private User publisher;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(Integer publisherId) {
        this.publisherId = publisherId;
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public User getPublisher() {
        return publisher;
    }

    public void setPublisher(User publisher) {
        this.publisher = publisher;
    }

    @Override
    public String toString() {
        return "Announcement{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", publisherId=" + publisherId +
                ", publishTime=" + publishTime +
                ", updateTime=" + updateTime +
                '}';
    }
} 