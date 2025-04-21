package com.community.waste.entity;

import java.util.Date;

/**
 * 垃圾投放记录实体类
 */
public class DisposalRecord {
    /**
     * 记录ID
     */
    private Integer id;
    
    /**
     * 用户ID
     */
    private Integer userId;
    
    /**
     * 垃圾分类ID
     */
    private Integer categoryId;
    
    /**
     * 投放时间
     */
    private Date disposalTime;
    
    /**
     * 创建时间
     */
    private Date createTime;
    
    /**
     * 用户信息（非数据库字段）
     */
    private User user;
    
    /**
     * 垃圾分类信息（非数据库字段）
     */
    private WasteCategory category;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Date getDisposalTime() {
        return disposalTime;
    }

    public void setDisposalTime(Date disposalTime) {
        this.disposalTime = disposalTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public WasteCategory getCategory() {
        return category;
    }

    public void setCategory(WasteCategory category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "DisposalRecord{" +
                "id=" + id +
                ", userId=" + userId +
                ", categoryId=" + categoryId +
                ", disposalTime=" + disposalTime +
                ", createTime=" + createTime +
                '}';
    }
} 