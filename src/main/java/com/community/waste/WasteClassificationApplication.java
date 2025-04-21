package com.community.waste;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.community.waste.mapper")
@EnableScheduling
public class WasteClassificationApplication {

    public static void main(String[] args) {
        SpringApplication.run(WasteClassificationApplication.class, args);
    }
} 