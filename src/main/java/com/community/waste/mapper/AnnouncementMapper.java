package com.community.waste.mapper;

import com.community.waste.entity.Announcement;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 公告Mapper接口
 */
public interface AnnouncementMapper {
    
    /**
     * 查询所有公告
     * 
     * @return 公告列表
     */
    List<Announcement> selectAll();
    
    /**
     * 根据ID查询公告
     * 
     * @param id 公告ID
     * @return 公告信息
     */
    Announcement selectById(@Param("id") Integer id);
    
    /**
     * 新增公告
     * 
     * @param announcement 公告信息
     * @return 影响行数
     */
    int insert(Announcement announcement);
    
    /**
     * 更新公告
     * 
     * @param announcement 公告信息
     * @return 影响行数
     */
    int update(Announcement announcement);
    
    /**
     * 删除公告
     * 
     * @param id 公告ID
     * @return 影响行数
     */
    int deleteById(@Param("id") Integer id);
    
    /**
     * 查询最新的公告列表
     * 
     * @param limit 限制数量
     * @return 公告列表
     */
    List<Announcement> selectLatest(@Param("limit") Integer limit);
} 