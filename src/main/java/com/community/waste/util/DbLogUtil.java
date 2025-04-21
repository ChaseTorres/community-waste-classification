package com.community.waste.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 数据库连接日志工具类
 */
@Component
public class DbLogUtil {

    private static final Logger logger = LoggerFactory.getLogger(DbLogUtil.class);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 初始化时记录数据库连接信息
     */
    @PostConstruct
    public void logDbConnectionInfo() {
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            
            logger.info("数据库连接成功！");
            logger.info("数据库产品名称: {}", metaData.getDatabaseProductName());
            logger.info("数据库产品版本: {}", metaData.getDatabaseProductVersion());
            logger.info("数据库驱动名称: {}", metaData.getDriverName());
            logger.info("数据库驱动版本: {}", metaData.getDriverVersion());
            logger.info("数据库URL: {}", metaData.getURL());
            logger.info("数据库用户名: {}", metaData.getUserName());
            logger.info("JDBC主版本: {}", metaData.getJDBCMajorVersion());
            logger.info("JDBC次版本: {}", metaData.getJDBCMinorVersion());
            logger.info("数据库连接是否自动提交: {}", connection.getAutoCommit());
            logger.info("数据库连接事务隔离级别: {}", getTransactionIsolationLevelName(connection.getTransactionIsolation()));
            
            // 查询数据库版本信息
            List<Map<String, Object>> result = jdbcTemplate.queryForList("SELECT VERSION() as version");
            if (!result.isEmpty()) {
                logger.info("MySQL服务器版本: {}", result.get(0).get("version"));
            }
            
            // 查询当前数据库
            result = jdbcTemplate.queryForList("SELECT DATABASE() as current_db");
            if (!result.isEmpty()) {
                logger.info("当前数据库: {}", result.get(0).get("current_db"));
            }
            
            // 查询数据库表信息
            result = jdbcTemplate.queryForList(
                "SELECT TABLE_NAME, TABLE_ROWS, CREATE_TIME, ENGINE " +
                "FROM information_schema.TABLES " +
                "WHERE TABLE_SCHEMA = DATABASE() " +
                "ORDER BY CREATE_TIME"
            );
            
            logger.info("数据库表信息：");
            for (Map<String, Object> row : result) {
                logger.info("表名: {}, 行数: {}, 创建时间: {}, 存储引擎: {}", 
                    row.get("TABLE_NAME"), 
                    row.get("TABLE_ROWS"), 
                    row.get("CREATE_TIME"), 
                    row.get("ENGINE")
                );
            }
        } catch (SQLException e) {
            logger.error("获取数据库连接信息时发生错误: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 获取事务隔离级别名称
     */
    private String getTransactionIsolationLevelName(int level) {
        switch (level) {
            case Connection.TRANSACTION_NONE:
                return "TRANSACTION_NONE";
            case Connection.TRANSACTION_READ_UNCOMMITTED:
                return "TRANSACTION_READ_UNCOMMITTED";
            case Connection.TRANSACTION_READ_COMMITTED:
                return "TRANSACTION_READ_COMMITTED";
            case Connection.TRANSACTION_REPEATABLE_READ:
                return "TRANSACTION_REPEATABLE_READ";
            case Connection.TRANSACTION_SERIALIZABLE:
                return "TRANSACTION_SERIALIZABLE";
            default:
                return "UNKNOWN";
        }
    }
    
    /**
     * 记录当前活动连接数
     */
    public void logActiveConnections() {
        try {
            List<Map<String, Object>> result = jdbcTemplate.queryForList(
                "SELECT COUNT(*) as connections FROM information_schema.PROCESSLIST WHERE DB = DATABASE()"
            );
            if (!result.isEmpty()) {
                logger.info("当前活动连接数: {}", result.get(0).get("connections"));
            }
        } catch (Exception e) {
            logger.error("获取活动连接数时发生错误: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 记录数据库性能信息
     */
    public void logPerformanceMetrics() {
        try {
            List<Map<String, Object>> result = jdbcTemplate.queryForList(
                "SHOW GLOBAL STATUS WHERE Variable_name IN ('Threads_connected', 'Threads_running', 'Queries', 'Slow_queries')"
            );
            
            logger.info("数据库性能指标：");
            for (Map<String, Object> row : result) {
                logger.info("{}: {}", row.get("Variable_name"), row.get("Value"));
            }
        } catch (Exception e) {
            logger.error("获取性能指标时发生错误: {}", e.getMessage(), e);
        }
    }
} 