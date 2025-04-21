package com.community.waste.task;

import com.community.waste.util.DbLogUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 数据库监控定时任务
 */
@Component
public class DatabaseMonitorTask {

    private static final Logger log = LoggerFactory.getLogger(DatabaseMonitorTask.class);

    @Autowired
    private DbLogUtil dbLogUtil;
    
    /**
     * 每10分钟记录一次数据库连接情况
     */
    @Scheduled(fixedRate = 600000)
    public void monitorDatabaseConnections() {
        log.info("开始执行数据库连接监控任务");
        dbLogUtil.logActiveConnections();
        log.info("数据库连接监控任务执行完成");
    }
    
    /**
     * 每小时记录一次数据库性能指标
     */
    @Scheduled(fixedRate = 3600000)
    public void monitorDatabasePerformance() {
        log.info("开始执行数据库性能监控任务");
        dbLogUtil.logPerformanceMetrics();
        log.info("数据库性能监控任务执行完成");
    }
    
    /**
     * 每天凌晨1点执行一次数据库连接信息详细记录
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void dailyDatabaseLog() {
        log.info("开始执行每日数据库信息记录任务");
        dbLogUtil.logDbConnectionInfo();
        log.info("每日数据库信息记录任务执行完成");
    }
} 