package com.community.waste.entity;

import java.util.Date;

/**
 * 垃圾投放记录实体类
 */
public class WasteRecord {
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
     * 投放重量(kg)
     */
    private Double weight;
    
    /**
     * 投放描述
     */
    private String description;
    
    /**
     * 投放地点
     */
    private String location;
    
    /**
     * 投放图片（可选）
     */
    private String image;
    
    /**
     * 投放时间
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

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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
        return "WasteRecord{" +
                "id=" + id +
                ", userId=" + userId +
                ", categoryId=" + categoryId +
                ", weight=" + weight +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", image='" + image + '\'' +
                ", createTime=" + createTime +
                '}';
    }
} 