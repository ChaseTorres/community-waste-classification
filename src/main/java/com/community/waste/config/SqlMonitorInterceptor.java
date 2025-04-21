package com.community.waste.config;

import org.apache.ibatis.cache.CacheKey;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.type.TypeHandlerRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

/**
 * SQL监控拦截器
 */
@Component
@Intercepts({
    @Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class}),
    @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
    @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class, CacheKey.class, BoundSql.class})
})
public class SqlMonitorInterceptor implements Interceptor {
    
    private static final Logger log = LoggerFactory.getLogger(SqlMonitorInterceptor.class);
    private static final Logger slowLog = LoggerFactory.getLogger(SqlMonitorInterceptor.class.getName() + ".slow");

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        // 获取SQL相关信息
        MappedStatement mappedStatement = (MappedStatement) invocation.getArgs()[0];
        Object parameter = invocation.getArgs()[1];
        BoundSql boundSql = mappedStatement.getBoundSql(parameter);
        String sqlId = mappedStatement.getId();
        Configuration configuration = mappedStatement.getConfiguration();
        
        // 获取完整SQL
        String sql = getSql(configuration, boundSql, sqlId);
        
        // 执行SQL
        Object result = invocation.proceed();
        
        // 计算执行时间
        long endTime = System.currentTimeMillis();
        long sqlCost = endTime - startTime;
        
        // 记录日志
        log.info("执行SQL: {}", sql);
        log.info("SQL ID: {}", sqlId);
        log.info("执行耗时: {} 毫秒", sqlCost);
        
        // 记录慢SQL
        if (sqlCost > 1000) {
            slowLog.warn("发现慢SQL，执行耗时: {} 毫秒, SQL: {}", sqlCost, sql);
        }
        
        return result;
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
    }
    
    /**
     * 获取完整SQL
     */
    private String getSql(Configuration configuration, BoundSql boundSql, String sqlId) {
        String sql = boundSql.getSql();
        if (sql == null || sql.length() == 0) {
            return "";
        }
        
        // 格式化SQL
        sql = sql.replaceAll("[\\s]+", " ").trim();
        
        // 获取参数
        Object parameterObject = boundSql.getParameterObject();
        List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();
        
        // 没有参数，直接返回SQL
        if (parameterObject == null || parameterMappings == null || parameterMappings.size() == 0) {
            return sql;
        }
        
        // 替换参数
        TypeHandlerRegistry typeHandlerRegistry = configuration.getTypeHandlerRegistry();
        if (typeHandlerRegistry.hasTypeHandler(parameterObject.getClass())) {
            sql = sql.replaceFirst("\\?", getParameterValue(parameterObject));
        } else {
            MetaObject metaObject = configuration.newMetaObject(parameterObject);
            for (ParameterMapping parameterMapping : parameterMappings) {
                String propertyName = parameterMapping.getProperty();
                if (metaObject.hasGetter(propertyName)) {
                    Object obj = metaObject.getValue(propertyName);
                    sql = sql.replaceFirst("\\?", getParameterValue(obj));
                } else if (boundSql.hasAdditionalParameter(propertyName)) {
                    Object obj = boundSql.getAdditionalParameter(propertyName);
                    sql = sql.replaceFirst("\\?", getParameterValue(obj));
                } else {
                    sql = sql.replaceFirst("\\?", "缺失参数");
                }
            }
        }
        
        return sql;
    }
    
    /**
     * 获取参数值
     */
    private String getParameterValue(Object obj) {
        String value = null;
        if (obj instanceof String) {
            value = "'" + obj.toString() + "'";
        } else if (obj instanceof Date) {
            DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.DEFAULT, DateFormat.DEFAULT, Locale.CHINA);
            value = "'" + formatter.format(obj) + "'";
        } else {
            if (obj != null) {
                value = obj.toString();
            } else {
                value = "null";
            }
        }
        return value;
    }
} 