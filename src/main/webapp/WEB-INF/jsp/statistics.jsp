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
        <div id="loginAlert" class="alert alert-warning text-center" style="display: none;">
            <i class="fa fa-exclamation-circle"></i> 请先<a href="${pageContext.request.contextPath}/login">登录</a>后查看详细统计数据
        </div>
    </div>
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.bootcss.com/echarts/5.0.0/echarts.min.js"></script>
    <script>
        $(function() {
            // 检查登录状态
            checkLoginStatus();
            
            // 初始化图表
            initCharts();
            
            // 加载统计数据
            loadStatisticsData();
        });
        
        // 检查登录状态
        function checkLoginStatus() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/user/current",
                type: "GET",
                success: function(res) {
                    if (res.code !== 200) {
                        $("#loginAlert").show();
                        $(".chart-card, .stats-summary").hide();
                    }
                }
            });
        }
        
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