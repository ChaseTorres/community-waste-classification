package com.community.waste.mapper;

import com.community.waste.entity.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 用户Mapper接口
 */
public interface UserMapper {
    
    /**
     * 根据ID查询用户
     */
    User selectById(Integer id);
    
    /**
     * 根据用户名查询用户
     */
    User selectByUsername(String username);
    
    /**
     * 根据手机号查询用户
     */
    User selectByPhone(String phone);
    
    /**
     * 查询所有用户
     */
    List<User> selectAll();
    
    /**
     * 条件查询用户列表
     */
    List<User> selectList(@Param("username") String username, @Param("phone") String phone, @Param("email") String email);
    
    /**
     * 新增用户
     */
    int insert(User user);
    
    /**
     * 更新用户
     */
    int update(User user);
    
    /**
     * 删除用户
     */
    int deleteById(Integer id);
    
    /**
     * 批量删除用户
     */
    int deleteBatch(List<Integer> ids);
    
    /**
     * 更新用户最后登录时间
     */
    int updateLastLoginTime(Integer id);
} 