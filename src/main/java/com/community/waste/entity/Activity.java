package com.community.waste.entity;

import java.util.Date;

/**
 * 活动信息实体类
 */
public class Activity {
    /**
     * 活动ID
     */
    private Integer id;
    
    /**
     * 活动标题
     */
    private String title;
    
    /**
     * 活动内容
     */
    private String content;
    
    /**
     * 活动地点
     */
    private String location;
    
    /**
     * 开始时间
     */
    private Date startTime;
    
    /**
     * 结束时间
     */
    private Date endTime;
    
    /**
     * 报名方式
     */
    private String registrationMethod;
    
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
     * 发布者信息（非数据库字段）
     */
    private User publisher;
    
    /**
     * 是否已过期（非数据库字段）
     */
    private Boolean expired;

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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getRegistrationMethod() {
        return registrationMethod;
    }

    public void setRegistrationMethod(String registrationMethod) {
        this.registrationMethod = registrationMethod;
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

    public Boolean getExpired() {
        return expired;
    }

    public void setExpired(Boolean expired) {
        this.expired = expired;
    }

    @Override
    public String toString() {
        return "Activity{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", location='" + location + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", registrationMethod='" + registrationMethod + '\'' +
                ", publisherId=" + publisherId +
                ", publishTime=" + publishTime +
                ", updateTime=" + updateTime +
                ", expired=" + expired +
                '}';
    }
} 