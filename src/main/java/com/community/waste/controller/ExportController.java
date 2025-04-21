package com.community.waste.controller;

import com.community.waste.entity.User;
import com.community.waste.entity.WasteRecord;
import com.community.waste.service.WasteRecordService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 数据导出控制器
 */
@Controller
@RequestMapping("/api/export")
public class ExportController {
    
    @Autowired
    private WasteRecordService wasteRecordService;
    
    /**
     * 导出我的投放记录
     */
    @GetMapping("/my-records")
    public void exportMyRecords(HttpServletResponse response, HttpSession session) throws IOException {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().write("请先登录");
            return;
        }
        
        // 获取用户记录
        List<WasteRecord> records = wasteRecordService.getRecordsByUserId(user.getId());
        
        // 导出Excel
        exportRecordsToExcel(records, "我的垃圾投放记录", response);
    }
    
    /**
     * 导出所有投放记录（管理员权限）
     */
    @GetMapping("/all-records")
    public void exportAllRecords(HttpServletResponse response, HttpSession session) throws IOException {
        // 权限检查
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() < 1) {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().write("无权限");
            return;
        }
        
        // 获取所有记录
        List<WasteRecord> records = wasteRecordService.getAllRecords();
        
        // 导出Excel
        exportRecordsToExcel(records, "所有垃圾投放记录", response);
    }
    
    /**
     * 导出记录为Excel
     */
    private void exportRecordsToExcel(List<WasteRecord> records, String sheetName, HttpServletResponse response) throws IOException {
        // 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet(sheetName);
        
        // 设置列宽
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 20 * 256);
        sheet.setColumnWidth(2, 15 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 30 * 256);
        sheet.setColumnWidth(5, 20 * 256);
        
        // 创建表头
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("ID");
        headerRow.createCell(1).setCellValue("用户名");
        headerRow.createCell(2).setCellValue("垃圾分类");
        headerRow.createCell(3).setCellValue("重量(kg)");
        headerRow.createCell(4).setCellValue("投放地点");
        headerRow.createCell(5).setCellValue("投放时间");
        headerRow.createCell(6).setCellValue("描述");
        
        // 设置表头样式
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        for (int i = 0; i < 7; i++) {
            Cell cell = headerRow.getCell(i);
            cell.setCellStyle(headerStyle);
        }
        
        // 填充数据
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int rowNum = 1;
        for (WasteRecord record : records) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(record.getId().toString());
            row.createCell(1).setCellValue(record.getUser() != null ? record.getUser().getUsername() : "未知用户");
            row.createCell(2).setCellValue(record.getCategory() != null ? record.getCategory().getName() : "未知分类");
            row.createCell(3).setCellValue(record.getWeight());
            row.createCell(4).setCellValue(record.getLocation());
            row.createCell(5).setCellValue(record.getCreateTime() != null ? dateFormat.format(record.getCreateTime()) : "");
            row.createCell(6).setCellValue(record.getDescription() != null ? record.getDescription() : "");
        }
        
        // 设置响应头
        String filename = "waste_records_" + System.currentTimeMillis() + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        
        // 输出Excel文件
        workbook.write(response.getOutputStream());
        workbook.close();
    }
} 