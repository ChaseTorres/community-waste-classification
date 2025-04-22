<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>垃圾分类统计 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 20px;
        }
        .stats-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .page-title {
            color: #28a745;
            margin-bottom: 30px;
            text-align: center;
        }
        .chart-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            padding: 20px;
        }
        .chart-title {
            color: #28a745;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }
        .chart-container {
            width: 100%;
            height: 400px;
        }
        .stats-filter {
            margin-bottom: 20px;
        }
        .back-btn {
            margin-bottom: 20px;
        }
        .stats-summary {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            padding: 20px;
        }
        .summary-title {
            color: #28a745;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .summary-item {
            text-align: center;
            padding: 15px;
        }
        .summary-value {
            font-size: 24px;
            font-weight: bold;
            color: #17a2b8;
            margin-bottom: 5px;
        }
        .summary-label {
            color: #6c757d;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container stats-container">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary back-btn">
            <i class="fa fa-arrow-left"></i> 返回首页
        </a>
        
        <h1 class="page-title">垃圾分类统计</h1>
        
        <!-- 统计摘要 -->
        <div class="stats-summary">
            <div class="summary-title">数据概览</div>
            <div class="row">
                <div class="col-md-3">
                    <div class="summary-item">
                        <div id="totalRecords" class="summary-value">0</div>
                        <div class="summary-label">总投放次数</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div id="totalWeight" class="summary-value">0</div>
                        <div class="summary-label">总投放重量 (kg)</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div id="totalUsers" class="summary-value">0</div>
                        <div class="summary-label">参与用户数</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div id="avgWeight" class="summary-value">0</div>
                        <div class="summary-label">平均每次投放 (kg)</div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 垃圾分类占比 -->
        <div class="chart-card">
            <div class="chart-title">垃圾分类占比</div>
            <div id="categoryChart" class="chart-container"></div>
        </div>
        
        <!-- 每日投放量趋势 -->
        <div class="chart-card">
            <div class="chart-title">
                每日投放量趋势
                <div class="float-right stats-filter">
                    <select id="daysRange" class="form-control-sm" onchange="loadDailyStats()">
                        <option value="7">最近7天</option>
                        <option value="30" selected>最近30天</option>
                        <option value="90">最近90天</option>
                    </select>
                </div>
            </div>
            <div id="dailyChart" class="chart-container"></div>
        </div>
        
        <!-- 未登录提示 -->
        <div id="loginAlert" class="alert text-center" style="display: none; background-color: #f8f9fa; border: 2px solid #28a745; border-radius: 15px; padding: 25px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); animation: fadeIn 0.5s ease-in-out; margin: 30px auto; max-width: 800px;">
            <div class="mb-3">
                <i class="fa fa-lock fa-3x text-success"></i>
            </div>
            <h4 class="mb-3" style="color: #28a745; font-weight: bold;">需要登录</h4>
            <p class="mb-4" style="color: #495057; font-size: 18px;">请先登录后查看详细的垃圾分类统计数据</p>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-success btn-lg" style="border-radius: 30px; padding: 10px 30px; transition: all 0.3s ease;">
                <i class="fa fa-sign-in-alt mr-2"></i> 立即登录
            </a>
        </div>

        <!-- 未登录弹窗 -->
        <div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content" style="border-radius: 15px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                    <div class="modal-body text-center p-5">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="position: absolute; right: 20px; top: 15px;">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <div class="mb-4">
                            <i class="fa fa-lock fa-4x text-success"></i>
                        </div>
                        <h3 class="mb-4" style="color: #28a745; font-weight: bold;">未登录</h3>
                        <p class="mb-4" style="color: #495057; font-size: 18px;">您需要登录才能查看详细的垃圾分类统计数据</p>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-success btn-lg btn-block" style="border-radius: 30px; padding: 12px; transition: all 0.3s ease;">
                            <i class="fa fa-sign-in-alt mr-2"></i> 立即登录
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.bootcss.com/echarts/5.0.0/echarts.min.js"></script>
    <script>
        // 页面初始化时添加控制台日志
        console.log("页面初始化开始");
        
        $(function() {
            console.log("DOM加载完成，准备初始化");
            
            // 在页面加载时检查并隐藏任何可能直接渲染的"未登录"文本
            checkAndRemoveUnauthorizedText();
            
            // 检查登录状态
            checkLoginStatus();
            
            // 初始化图表
            initCharts();
            
            // 加载统计数据
            loadStatisticsData();
        });
        
        // 检查并隐藏页面上任何直接渲染的"未登录"文本
        function checkAndRemoveUnauthorizedText() {
            console.log("检查页面上的未登录文本");
            // 查找包含"未登录"文本的元素并隐藏它们
            $("body").contents().filter(function() {
                return this.nodeType === 3 && this.nodeValue.trim() === "未登录";
            }).remove();
            
            // 也移除任何显示"未登录"的非交互元素
            $("div, span, p").filter(function() {
                return $(this).text().trim() === "未登录";
            }).hide();
        }
        
        // 检查登录状态
        function checkLoginStatus() {
            console.log("开始检查登录状态");
            $.ajax({
                url: "${pageContext.request.contextPath}/api/user/current",
                type: "GET",
                dataType: "json",
                success: function(res) {
                    console.log("登录状态检查成功，响应:", res);
                    if (res.code !== 200) {
                        console.log("用户未登录，显示登录提示");
                        // 如果是未登录错误，显示登录弹窗而不是提示区域
                        $("#loginModal").modal('show');
                        $("#loginAlert").hide(); // 隐藏非弹窗提示
                        $(".chart-card, .stats-summary").hide();
                        
                        // 检查响应是否包含"未登录"消息
                        if (res.msg && res.msg === "未登录") {
                            console.log("检测到'未登录'消息");
                            // 确保不在页面上显示
                            checkAndRemoveUnauthorizedText();
                        }
                    } else {
                        console.log("用户已登录，显示统计数据");
                    }
                },
                error: function(xhr, status, error) {
                    console.log("登录状态检查失败", status, error);
                    console.log("详细错误信息:", xhr);
                    
                    let errorResponse = null;
                    
                    // 尝试解析响应
                    try {
                        if (xhr.responseText) {
                            errorResponse = JSON.parse(xhr.responseText);
                            console.log("解析后的错误响应:", errorResponse);
                        }
                    } catch (e) {
                        console.log("无法解析错误响应:", e);
                    }
                    
                    // 判断是否未登录错误，用多种方式检查
                    const isUnauthorized = 
                        (xhr.status === 401) || 
                        (errorResponse && errorResponse.msg === "未登录") ||
                        (xhr.responseText && xhr.responseText.includes("未登录"));
                    
                    if (isUnauthorized) {
                        console.log("检测到未登录状态，显示登录弹窗");
                        $("#loginModal").modal('show');
                        $("#loginAlert").hide(); // 隐藏非弹窗提示
                        $(".chart-card, .stats-summary").hide();
                        
                        // 确保页面上没有显示"未登录"文本
                        checkAndRemoveUnauthorizedText();
                    }
                }
            });
        }
        
        // 为所有AJAX请求添加全局错误处理
        $(document).ajaxError(function(event, xhr, settings, error) {
            console.log("全局AJAX错误:", error);
            console.log("错误状态:", xhr.status);
            console.log("请求URL:", settings.url);
            console.log("响应内容:", xhr.responseText);
            
            let errorResponse = null;
            
            // 尝试解析响应
            try {
                if (xhr.responseText) {
                    errorResponse = JSON.parse(xhr.responseText);
                    console.log("解析后的错误响应:", errorResponse);
                }
            } catch (e) {
                console.log("无法解析错误响应:", e);
            }
            
            // 用多种方式检查未登录错误
            const isUnauthorized = 
                (xhr.status === 401) || 
                (errorResponse && errorResponse.msg === "未登录") ||
                (xhr.responseText && xhr.responseText.includes("未登录"));
            
            if (isUnauthorized) {
                console.log("全局捕获到未登录错误，显示登录弹窗");
                $("#loginModal").modal('show');
                $("#loginAlert").hide(); // 隐藏非弹窗提示
                $(".chart-card, .stats-summary").hide();
                
                // 确保页面上没有显示"未登录"文本
                checkAndRemoveUnauthorizedText();
                
                // 阻止默认错误消息显示
                event.preventDefault();
                
                // 防止显示任何错误文本到页面上
                setTimeout(checkAndRemoveUnauthorizedText, 100);
                setTimeout(checkAndRemoveUnauthorizedText, 500);
            }
        });
        
        // 图表对象
        var categoryChart, dailyChart;
        
        // 初始化图表
        function initCharts() {
            // 分类占比图表
            categoryChart = echarts.init(document.getElementById('categoryChart'));
            categoryChart.setOption({
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b}: {c} kg ({d}%)'
                },
                legend: {
                    orient: 'vertical',
                    left: 'left',
                    data: []
                },
                series: [
                    {
                        name: '垃圾分类',
                        type: 'pie',
                        radius: ['40%', '70%'],
                        avoidLabelOverlap: false,
                        itemStyle: {
                            borderRadius: 10,
                            borderColor: '#fff',
                            borderWidth: 2
                        },
                        label: {
                            show: false,
                            position: 'center'
                        },
                        emphasis: {
                            label: {
                                show: true,
                                fontSize: '18',
                                fontWeight: 'bold'
                            }
                        },
                        labelLine: {
                            show: false
                        },
                        data: []
                    }
                ]
            });
            
            // 每日投放量图表
            dailyChart = echarts.init(document.getElementById('dailyChart'));
            dailyChart.setOption({
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                legend: {
                    data: ['投放次数', '投放重量(kg)']
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: []
                },
                yAxis: [
                    {
                        type: 'value',
                        name: '投放次数',
                        position: 'left'
                    },
                    {
                        type: 'value',
                        name: '投放重量(kg)',
                        position: 'right'
                    }
                ],
                series: [
                    {
                        name: '投放次数',
                        type: 'bar',
                        yAxisIndex: 0,
                        data: []
                    },
                    {
                        name: '投放重量(kg)',
                        type: 'line',
                        yAxisIndex: 1,
                        smooth: true,
                        data: []
                    }
                ]
            });
            
            // 窗口大小改变时，重新调整图表大小
            window.addEventListener('resize', function() {
                categoryChart.resize();
                dailyChart.resize();
            });
        }
        
        // 加载统计数据
        function loadStatisticsData() {
            // 加载分类统计
            loadCategoryStats();
            
            // 加载每日统计
            loadDailyStats();
            
            // 加载摘要数据
            loadSummaryData();
        }
        
        // 加载分类统计
        function loadCategoryStats() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/stats/category-statistics",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var data = res.data;
                        var chartData = [];
                        var legendData = [];
                        
                        $.each(data, function(index, item) {
                            chartData.push({
                                value: item.totalWeight,
                                name: item.categoryName
                            });
                            legendData.push(item.categoryName);
                        });
                        
                        // 更新图表数据
                        categoryChart.setOption({
                            legend: {
                                data: legendData
                            },
                            series: [{
                                data: chartData
                            }]
                        });
                    }
                }
            });
        }
        
        // 加载每日统计
        function loadDailyStats() {
            var days = $("#daysRange").val();
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/stats/daily-statistics",
                type: "GET",
                data: { days: days },
                success: function(res) {
                    if (res.code === 200) {
                        var data = res.data;
                        var dates = [];
                        var counts = [];
                        var weights = [];
                        
                        $.each(data, function(index, item) {
                            dates.push(item.date);
                            counts.push(item.recordCount);
                            weights.push(item.totalWeight);
                        });
                        
                        // 更新图表数据
                        dailyChart.setOption({
                            xAxis: {
                                data: dates
                            },
                            series: [
                                {
                                    data: counts
                                },
                                {
                                    data: weights
                                }
                            ]
                        });
                    }
                }
            });
        }
        
        // 加载摘要数据
        function loadSummaryData() {
            // 模拟数据（实际项目中应当从后端获取）
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/stats/summary",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var data = res.data;
                        $("#totalRecords").text(data.totalRecords);
                        $("#totalWeight").text(data.totalWeight.toFixed(2));
                        $("#totalUsers").text(data.totalUsers);
                        $("#avgWeight").text(data.avgWeight.toFixed(2));
                    } else {
                        // 如果接口不存在，使用模拟数据
                        simulateSummaryData();
                    }
                },
                error: function() {
                    // 如果接口不存在，使用模拟数据
                    simulateSummaryData();
                }
            });
        }
        
        // 模拟摘要数据
        function simulateSummaryData() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/my",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var records = res.data;
                        var totalWeight = 0;
                        
                        $.each(records, function(index, record) {
                            totalWeight += record.weight;
                        });
                        
                        $("#totalRecords").text(records.length);
                        $("#totalWeight").text(totalWeight.toFixed(2));
                        $("#totalUsers").text(1); // 当前用户
                        $("#avgWeight").text(records.length > 0 ? (totalWeight / records.length).toFixed(2) : "0.00");
                    }
                }
            });
        }
    </script>
</body>
</html> 