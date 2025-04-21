package com.community.waste.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

/**
 * Web MVC配置
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Value("${file.upload.path:/upload}")
    private String uploadPath;
    
    @Value("${file.upload.url-prefix:/upload}")
    private String urlPrefix;
    
    /**
     * 配置静态资源处理器
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的访问路径
        String uploadRealPath;
        if (uploadPath.startsWith("/")) {
            // 绝对路径
            uploadRealPath = uploadPath;
        } else {
            // 相对路径
            uploadRealPath = System.getProperty("user.dir") + File.separator + uploadPath;
        }
        
        // 添加资源处理器
        registry.addResourceHandler(urlPrefix + "/**")
                .addResourceLocations("file:" + uploadRealPath + File.separator);
    }
} 