package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.WasteRecord;
import com.community.waste.mapper.WasteRecordMapper;
import com.community.waste.service.WasteRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 垃圾投放记录服务实现类
 */
@Service
public class WasteRecordServiceImpl implements WasteRecordService {
    
    @Autowired
    private WasteRecordMapper wasteRecordMapper;
    
    @Override
    public List<WasteRecord> getAllRecords() {
        return wasteRecordMapper.selectAll();
    }
    
    @Override
    public List<WasteRecord> getRecordsByUserId(Integer userId) {
        if (userId == null) {
            throw new BusinessException("用户ID不能为空");
        }
        return wasteRecordMapper.selectByUserId(userId);
    }
    
    @Override
    public List<WasteRecord> getRecordsByCategoryId(Integer categoryId) {
        if (categoryId == null) {
            throw new BusinessException("垃圾分类ID不能为空");
        }
        return wasteRecordMapper.selectByCategoryId(categoryId);
    }
    
    @Override
    public WasteRecord getRecordById(Integer id) {
        if (id == null) {
            throw new BusinessException("记录ID不能为空");
        }
        return wasteRecordMapper.selectById(id);
    }
    
    @Override
    public WasteRecord addRecord(WasteRecord record) {
        // 参数校验
        if (record == null) {
            throw new BusinessException("投放记录不能为空");
        }
        if (record.getUserId() == null) {
            throw new BusinessException("用户ID不能为空");
        }
        if (record.getCategoryId() == null) {
            throw new BusinessException("垃圾分类ID不能为空");
        }
        if (record.getWeight() == null || record.getWeight() <= 0) {
            throw new BusinessException("投放重量必须大于0");
        }
        
        // 设置创建时间
        record.setCreateTime(new Date());
        
        // 插入数据库
        wasteRecordMapper.insert(record);
        
        return record;
    }
    
    @Override
    public WasteRecord updateRecord(WasteRecord record) {
        // 参数校验
        if (record == null || record.getId() == null) {
            throw new BusinessException("记录ID不能为空");
        }
        
        // 检查是否存在
        WasteRecord existingRecord = wasteRecordMapper.selectById(record.getId());
        if (existingRecord == null) {
            throw new BusinessException("投放记录不存在");
        }
        
        // 更新数据库
        wasteRecordMapper.update(record);
        
        return record;
    }
    
    @Override
    public void deleteRecord(Integer id) {
        // 参数校验
        if (id == null) {
            throw new BusinessException("记录ID不能为空");
        }
        
        // 检查是否存在
        WasteRecord existingRecord = wasteRecordMapper.selectById(id);
        if (existingRecord == null) {
            throw new BusinessException("投放记录不存在");
        }
        
        // 删除数据库记录
        wasteRecordMapper.deleteById(id);
    }
    
    @Override
    public List<WasteRecord> getRecordsByCondition(Integer userId, Integer categoryId, 
                                                Date startTime, Date endTime, String location) {
        // 构建查询条件
        Map<String, Object> params = new HashMap<>();
        if (userId != null) {
            params.put("userId", userId);
        }
        if (categoryId != null) {
            params.put("categoryId", categoryId);
        }
        if (startTime != null) {
            params.put("startTime", startTime);
        }
        if (endTime != null) {
            params.put("endTime", endTime);
        }
        if (location != null && !location.trim().isEmpty()) {
            params.put("location", location);
        }
        
        return wasteRecordMapper.selectByCondition(params);
    }
    
    @Override
    public Double getUserTotalWeight(Integer userId) {
        if (userId == null) {
            throw new BusinessException("用户ID不能为空");
        }
        return wasteRecordMapper.sumWeightByUserId(userId);
    }
    
    @Override
    public List<Map<String, Object>> getCategoryStatistics() {
        return wasteRecordMapper.countGroupByCategory();
    }
    
    @Override
    public List<Map<String, Object>> getDailyStatistics(Integer days) {
        if (days == null || days <= 0) {
            days = 30; // 默认统计最近30天的数据
        }
        return wasteRecordMapper.countGroupByDate(days);
    }
} 