package com.community.waste.service;

import com.community.waste.entity.Faq;
import java.util.List;

/**
 * 常见问题服务接口
 */
public interface FaqService {
    /**
     * 获取所有常见问题
     */
    List<Faq> getAllFaqs();
    
    /**
     * 根据ID获取常见问题
     */
    Faq getFaqById(Integer id);
    
    /**
     * 添加常见问题
     */
    Faq addFaq(Faq faq);
    
    /**
     * 更新常见问题
     */
    Faq updateFaq(Faq faq);
    
    /**
     * 删除常见问题
     */
    void deleteFaq(Integer id);
} 