package com.community.waste.controller;

import com.community.waste.common.Result;
import com.community.waste.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 文件上传控制器
 */
@RestController
@RequestMapping("/api/upload")
public class FileUploadController {
    
    @Value("${file.upload.path:/upload}")
    private String uploadPath;
    
    @Value("${file.upload.url-prefix:/upload}")
    private String urlPrefix;
    
    /**
     * 上传图片
     */
    @PostMapping("/image")
    public Result<Map<String, String>> uploadImage(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request,
            HttpSession session) {
        
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        
        // 检查文件类型
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isEmpty()) {
            return Result.error("文件名不能为空");
        }
        
        // 校验文件类型
        String lowerFilename = originalFilename.toLowerCase();
        if (!lowerFilename.endsWith(".jpg") && !lowerFilename.endsWith(".jpeg") 
                && !lowerFilename.endsWith(".png") && !lowerFilename.endsWith(".gif")) {
            return Result.error("仅支持JPG、JPEG、PNG、GIF格式图片");
        }
        
        // 校验文件大小
        if (file.getSize() > 10 * 1024 * 1024) {
            return Result.error("文件大小不能超过10MB");
        }
        
        try {
            // 创建年月日文件夹
            SimpleDateFormat dirFormat = new SimpleDateFormat("yyyy/MM/dd");
            String datePath = dirFormat.format(new Date());
            
            // 文件保存路径
            String realUploadPath = getUploadRealPath(request);
            File dateDir = new File(realUploadPath + File.separator + datePath);
            if (!dateDir.exists()) {
                boolean created = dateDir.mkdirs();
                if (!created) {
                    return Result.error("创建上传目录失败");
                }
            }
            
            // 使用UUID生成唯一文件名
            String fileSuffix = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString().replaceAll("-", "") + fileSuffix;
            
            // 保存文件
            File destFile = new File(dateDir.getAbsolutePath() + File.separator + newFilename);
            file.transferTo(destFile);
            
            // 生成访问URL
            String fileUrl = urlPrefix + "/" + datePath + "/" + newFilename;
            
            // 返回结果
            Map<String, String> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("filename", originalFilename);
            
            return Result.success("上传成功", result);
        } catch (IOException e) {
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取文件上传的实际路径
     */
    private String getUploadRealPath(HttpServletRequest request) {
        // 优先使用配置的路径
        if (uploadPath.startsWith("/")) {
            // 绝对路径
            return uploadPath;
        } else {
            // 相对路径，在项目目录下
            String basePath = request.getServletContext().getRealPath("/");
            return basePath + uploadPath;
        }
    }
} 