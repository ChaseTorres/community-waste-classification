package com.community.waste.mapper;

import com.community.waste.entity.Faq;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 常见问题Mapper接口
 */
public interface FaqMapper {
    
    /**
     * 查询所有常见问题
     */
    List<Faq> selectAll();
    
    /**
     * 根据ID查询常见问题
     */
    Faq selectById(@Param("id") Integer id);
    
    /**
     * 新增常见问题
     */
    int insert(Faq faq);
    
    /**
     * 更新常见问题
     */
    int update(Faq faq);
    
    /**
     * 删除常见问题
     */
    int deleteById(@Param("id") Integer id);
} 