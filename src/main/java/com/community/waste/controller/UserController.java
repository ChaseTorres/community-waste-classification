package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.User;
import com.community.waste.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/api/user")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<User> register(@RequestBody User user) {
        User registeredUser = userService.register(user);
        return Result.success("注册成功", registeredUser);
    }
    
    /**
     * 用户名密码登录
     */
    @PostMapping("/login/username")
    public Result<User> loginByUsername(@RequestParam String username, @RequestParam String password, HttpSession session) {
        User user = userService.loginByUsername(username, password);
        // 将用户信息存入session
        session.setAttribute("user", user);
        return Result.success("登录成功", user);
    }
    
    /**
     * 手机号密码登录
     */
    @PostMapping("/login/phone")
    public Result<User> loginByPhone(@RequestParam String phone, @RequestParam String password, HttpSession session) {
        User user = userService.loginByPhone(phone, password);
        // 将用户信息存入session
        session.setAttribute("user", user);
        return Result.success("登录成功", user);
    }
    
    /**
     * 退出登录
     */
    @PostMapping("/logout")
    public Result<String> logout(HttpSession session) {
        session.removeAttribute("user");
        return Result.success("退出成功", "");
    }
    
    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/current")
    public Result<User> getCurrentUser(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        return Result.success(user);
    }
    
    /**
     * 获取用户列表（管理员权限）
     */
    @GetMapping("/list")
    public Result<List<User>> getUserList(@RequestParam(required = false) String username,
                                          @RequestParam(required = false) String phone,
                                          @RequestParam(required = false) String email,
                                          HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        List<User> userList = userService.getUserList(username, phone, email);
        return Result.success(userList);
    }
    
    /**
     * 添加用户（管理员权限）
     */
    @PostMapping("/add")
    public Result<User> addUser(@RequestBody User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        User addedUser = userService.addUser(user);
        return Result.success("添加成功", addedUser);
    }
    
    /**
     * 更新用户（管理员权限）
     */
    @PutMapping("/update")
    public Result<User> updateUser(@RequestBody User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        User updatedUser = userService.updateUser(user);
        return Result.success("更新成功", updatedUser);
    }
    
    /**
     * 删除用户（管理员权限）
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteUser(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        userService.deleteUser(id);
        return Result.success("删除成功", "");
    }
    
    /**
     * 批量删除用户（管理员权限）
     */
    @DeleteMapping("/delete/batch")
    public Result<String> deleteUsers(@RequestBody List<Integer> ids, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() < 1) {
            return Result.error("无权限");
        }
        
        userService.deleteUsers(ids);
        return Result.success("批量删除成功", "");
    }
}