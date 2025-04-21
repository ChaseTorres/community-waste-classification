package com.community.waste.service;

import com.community.waste.entity.User;
import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {
    
    /**
     * 用户注册
     */
    User register(User user);
    
    /**
     * 用户名密码登录
     */
    User loginByUsername(String username, String password);
    
    /**
     * 手机号密码登录
     */
    User loginByPhone(String phone, String password);
    
    /**
     * 根据ID查询用户
     */
    User getUserById(Integer id);
    
    /**
     * 根据用户名查询用户
     */
    User getUserByUsername(String username);
    
    /**
     * 根据手机号查询用户
     */
    User getUserByPhone(String phone);
    
    /**
     * 查询所有用户
     */
    List<User> getAllUsers();
    
    /**
     * 条件查询用户列表
     */
    List<User> getUserList(String username, String phone, String email);
    
    /**
     * 添加用户
     */
    User addUser(User user);
    
    /**
     * 更新用户
     */
    User updateUser(User user);
    
    /**
     * 删除用户
     */
    boolean deleteUser(Integer id);
    
    /**
     * 批量删除用户
     */
    boolean deleteUsers(List<Integer> ids);
} 