package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.User;
import com.community.waste.mapper.UserMapper;
import com.community.waste.service.UserService;
import com.community.waste.util.DbLogUtil;
import com.community.waste.util.MD5Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);

    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private DbLogUtil dbLogUtil;

    @Override
    @Transactional
    public User register(User user) {
        log.info("开始用户注册流程，用户名: {}", user.getUsername());
        
        // 检查用户名是否已存在
        log.debug("检查用户名是否已存在: {}", user.getUsername());
        User existUser = userMapper.selectByUsername(user.getUsername());
        if (existUser != null) {
            log.warn("用户名已存在: {}", user.getUsername());
            throw new BusinessException("用户名已存在");
        }
        
        // 检查手机号是否已存在
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            log.debug("检查手机号是否已存在: {}", user.getPhone());
            User existPhone = userMapper.selectByPhone(user.getPhone());
            if (existPhone != null) {
                log.warn("手机号已注册: {}", user.getPhone());
                throw new BusinessException("手机号已注册");
            }
        }
        
        // 设置默认角色和注册时间
        if (user.getRole() == null) {
            user.setRole(0); // 默认为普通用户
        }
        user.setRegisterTime(new Date());
        
        // 密码加密
        log.debug("对密码进行MD5加密");
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        
        // 插入用户
        log.info("开始插入用户数据到数据库");
        userMapper.insert(user);
        log.info("用户注册成功，用户ID: {}", user.getId());
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        return user;
    }

    @Override
    public User loginByUsername(String username, String password) {
        log.info("开始用户名登录流程，用户名: {}", username);
        
        // 查询用户信息
        log.debug("根据用户名查询用户: {}", username);
        User user = userMapper.selectByUsername(username);
        if (user == null) {
            log.warn("用户不存在: {}", username);
            throw new BusinessException("用户不存在");
        }
        
        // 校验密码
        log.debug("校验密码");
        if (!user.getPassword().equals(MD5Util.encrypt(password))) {
            log.warn("密码错误，用户名: {}", username);
            throw new BusinessException("密码错误");
        }
        
        // 更新最后登录时间
        log.info("更新用户最后登录时间，用户ID: {}", user.getId());
        userMapper.updateLastLoginTime(user.getId());
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        log.info("用户登录成功，用户ID: {}", user.getId());
        return user;
    }

    @Override
    public User loginByPhone(String phone, String password) {
        log.info("开始手机号登录流程，手机号: {}", phone);
        
        // 查询用户信息
        log.debug("根据手机号查询用户: {}", phone);
        User user = userMapper.selectByPhone(phone);
        if (user == null) {
            log.warn("用户不存在，手机号: {}", phone);
            throw new BusinessException("用户不存在");
        }
        
        // 校验密码
        log.debug("校验密码");
        if (!user.getPassword().equals(MD5Util.encrypt(password))) {
            log.warn("密码错误，手机号: {}", phone);
            throw new BusinessException("密码错误");
        }
        
        // 更新最后登录时间
        log.info("更新用户最后登录时间，用户ID: {}", user.getId());
        userMapper.updateLastLoginTime(user.getId());
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        log.info("用户登录成功，用户ID: {}", user.getId());
        return user;
    }

    @Override
    public User getUserById(Integer id) {
        log.debug("根据ID查询用户: {}", id);
        return userMapper.selectById(id);
    }

    @Override
    public User getUserByUsername(String username) {
        log.debug("根据用户名查询用户: {}", username);
        return userMapper.selectByUsername(username);
    }

    @Override
    public User getUserByPhone(String phone) {
        log.debug("根据手机号查询用户: {}", phone);
        return userMapper.selectByPhone(phone);
    }

    @Override
    public List<User> getAllUsers() {
        log.debug("查询所有用户");
        return userMapper.selectAll();
    }

    @Override
    public List<User> getUserList(String username, String phone, String email) {
        log.debug("条件查询用户列表, 用户名: {}, 手机号: {}, 邮箱: {}", username, phone, email);
        return userMapper.selectList(username, phone, email);
    }

    @Override
    @Transactional
    public User addUser(User user) {
        log.info("开始添加用户流程，用户名: {}", user.getUsername());
        
        // 检查用户名是否已存在
        log.debug("检查用户名是否已存在: {}", user.getUsername());
        User existUser = userMapper.selectByUsername(user.getUsername());
        if (existUser != null) {
            log.warn("用户名已存在: {}", user.getUsername());
            throw new BusinessException("用户名已存在");
        }
        
        // 检查手机号是否已存在
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            log.debug("检查手机号是否已存在: {}", user.getPhone());
            User existPhone = userMapper.selectByPhone(user.getPhone());
            if (existPhone != null) {
                log.warn("手机号已注册: {}", user.getPhone());
                throw new BusinessException("手机号已注册");
            }
        }
        
        // 设置默认角色和注册时间
        if (user.getRole() == null) {
            user.setRole(0); // 默认为普通用户
        }
        user.setRegisterTime(new Date());
        
        // 密码加密
        log.debug("对密码进行MD5加密");
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        
        // 插入用户
        log.info("开始插入用户数据到数据库");
        userMapper.insert(user);
        log.info("用户添加成功，用户ID: {}", user.getId());
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        return user;
    }

    @Override
    @Transactional
    public User updateUser(User user) {
        log.info("开始更新用户流程，用户ID: {}", user.getId());
        
        // 检查用户是否存在
        log.debug("检查用户是否存在，用户ID: {}", user.getId());
        User existUser = userMapper.selectById(user.getId());
        if (existUser == null) {
            log.warn("用户不存在，用户ID: {}", user.getId());
            throw new BusinessException("用户不存在");
        }
        
        // 如果修改了密码，进行加密
        if (user.getPassword() != null && !user.getPassword().isEmpty() && !user.getPassword().equals(existUser.getPassword())) {
            log.debug("用户修改了密码，进行MD5加密");
            user.setPassword(MD5Util.encrypt(user.getPassword()));
        }
        
        // 更新用户
        log.info("开始更新用户数据到数据库");
        userMapper.update(user);
        log.info("用户更新成功，用户ID: {}", user.getId());
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        return userMapper.selectById(user.getId());
    }

    @Override
    @Transactional
    public boolean deleteUser(Integer id) {
        log.info("开始删除用户流程，用户ID: {}", id);
        
        // 删除用户
        boolean result = userMapper.deleteById(id) > 0;
        log.info("用户删除{}, 用户ID: {}", result ? "成功" : "失败", id);
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        return result;
    }

    @Override
    @Transactional
    public boolean deleteUsers(List<Integer> ids) {
        log.info("开始批量删除用户流程，用户IDs: {}", ids);
        
        // 批量删除用户
        boolean result = userMapper.deleteBatch(ids) > 0;
        log.info("批量删除用户{}", result ? "成功" : "失败");
        
        // 记录数据库连接信息
        dbLogUtil.logActiveConnections();
        
        // 记录数据库性能信息
        dbLogUtil.logPerformanceMetrics();
        
        return result;
    }
} 