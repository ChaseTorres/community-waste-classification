package com.community.waste.service.impl;

import com.community.waste.common.BusinessException;
import com.community.waste.entity.Faq;
import com.community.waste.mapper.FaqMapper;
import com.community.waste.service.FaqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 常见问题服务实现类
 */
@Service
public class FaqServiceImpl implements FaqService {
    
    @Autowired
    private FaqMapper faqMapper;
    
    @Override
    public List<Faq> getAllFaqs() {
        return faqMapper.selectAll();
    }
    
    @Override
    public Faq getFaqById(Integer id) {
        if (id == null) {
            throw new BusinessException("常见问题ID不能为空");
        }
        return faqMapper.selectById(id);
    }
    
    @Override
    public Faq addFaq(Faq faq) {
        // 参数校验
        if (faq == null) {
            throw new BusinessException("常见问题信息不能为空");
        }
        if (faq.getQuestion() == null || faq.getQuestion().trim().isEmpty()) {
            throw new BusinessException("问题不能为空");
        }
        if (faq.getAnswer() == null || faq.getAnswer().trim().isEmpty()) {
            throw new BusinessException("回答不能为空");
        }
        
        // 设置创建时间和更新时间
        Date now = new Date();
        faq.setCreateTime(now);
        faq.setUpdateTime(now);
        
        // 插入数据库
        faqMapper.insert(faq);
        
        return faq;
    }
    
    @Override
    public Faq updateFaq(Faq faq) {
        // 参数校验
        if (faq == null || faq.getId() == null) {
            throw new BusinessException("常见问题ID不能为空");
        }
        
        // 检查是否存在
        Faq existingFaq = faqMapper.selectById(faq.getId());
        if (existingFaq == null) {
            throw new BusinessException("常见问题不存在");
        }
        
        // 设置更新时间
        faq.setUpdateTime(new Date());
        
        // 更新数据库
        faqMapper.update(faq);
        
        return faq;
    }
    
    @Override
    public void deleteFaq(Integer id) {
        // 参数校验
        if (id == null) {
            throw new BusinessException("常见问题ID不能为空");
        }
        
        // 检查是否存在
        Faq existingFaq = faqMapper.selectById(id);
        if (existingFaq == null) {
            throw new BusinessException("常见问题不存在");
        }
        
        // 删除数据库记录
        faqMapper.deleteById(id);
    }
} 