<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>垃圾投放记录 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 20px;
        }
        .record-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .page-title {
            color: #28a745;
            margin-bottom: 30px;
            text-align: center;
        }
        .record-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .record-header {
            background-color: #28a745;
            color: white;
            padding: 15px 20px;
        }
        .record-body {
            padding: 20px;
        }
        .record-info {
            margin-bottom: 15px;
        }
        .record-label {
            font-weight: bold;
            margin-right: 10px;
        }
        .record-actions {
            margin-top: 15px;
        }
        .filter-panel {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .btn-add-record {
            margin-bottom: 20px;
        }
        .modal-header {
            background-color: #28a745;
            color: white;
        }
        .record-image {
            max-width: 100%;
            max-height: 200px;
            border-radius: 5px;
            margin-top: 10px;
        }
        .back-btn {
            margin-bottom: 20px;
        }
        .weight-badge {
            background-color: #17a2b8;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: bold;
        }
        .stats-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .stats-title {
            color: #28a745;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .total-weight {
            font-size: 24px;
            font-weight: bold;
            color: #17a2b8;
        }
    </style>
</head>
<body>
    <div class="container record-container">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary back-btn">
            <i class="fa fa-arrow-left"></i> 返回首页
        </a>
        
        <h1 class="page-title">垃圾投放记录</h1>
        
        <!-- 统计信息 -->
        <div class="row">
            <div class="col-md-6">
                <div class="stats-card">
                    <div class="stats-title">我的总投放量</div>
                    <div class="total-weight"><span id="totalWeight">0</span> 公斤</div>
                </div>
            </div>
            <div class="col-md-6 text-right">
                <button class="btn btn-success btn-add-record" data-toggle="modal" data-target="#addRecordModal">
                    <i class="fa fa-plus"></i> 添加投放记录
                </button>
            </div>
        </div>
        
        <!-- 筛选面板 -->
        <div class="filter-panel">
            <form id="searchForm">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="categoryId">垃圾分类</label>
                            <select class="form-control" id="categoryId" name="categoryId">
                                <option value="">全部分类</option>
                                <!-- 分类选项将通过AJAX加载 -->
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="startTime">开始日期</label>
                            <input type="text" class="form-control datepicker" id="startTime" name="startTime" placeholder="开始日期">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="endTime">结束日期</label>
                            <input type="text" class="form-control datepicker" id="endTime" name="endTime" placeholder="结束日期">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="location">投放地点</label>
                            <input type="text" class="form-control" id="location" name="location" placeholder="输入地点关键词">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 text-center">
                        <button type="button" class="btn btn-primary" onclick="searchRecords()">
                            <i class="fa fa-search"></i> 搜索
                        </button>
                        <button type="button" class="btn btn-secondary ml-2" onclick="resetSearch()">
                            <i class="fa fa-redo"></i> 重置
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- 记录列表 -->
        <div id="recordList">
            <!-- 记录将通过AJAX加载 -->
        </div>
    </div>
    
    <!-- 添加记录弹窗 -->
    <div class="modal fade" id="addRecordModal" tabindex="-1" role="dialog" aria-labelledby="addRecordModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addRecordModalLabel">添加垃圾投放记录</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addRecordForm">
                        <div class="form-group">
                            <label for="addCategoryId">垃圾分类 <span class="text-danger">*</span></label>
                            <select class="form-control" id="addCategoryId" name="categoryId" required>
                                <option value="">请选择垃圾分类</option>
                                <!-- 分类选项将通过AJAX加载 -->
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="weight">投放重量(kg) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.01" class="form-control" id="weight" name="weight" required>
                        </div>
                        <div class="form-group">
                            <label for="addLocation">投放地点 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="addLocation" name="location" required>
                        </div>
                        <div class="form-group">
                            <label for="description">投放描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="image">投放照片 (URL)</label>
                            <input type="text" class="form-control" id="image" name="image">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-success" onclick="addRecord()">保存</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 查看记录详情弹窗 -->
    <div class="modal fade" id="viewRecordModal" tabindex="-1" role="dialog" aria-labelledby="viewRecordModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewRecordModalLabel">垃圾投放记录详情</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="viewRecordBody">
                    <!-- 记录详情将通过AJAX加载 -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.bootcss.com/moment.js/2.24.0/moment.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap-datepicker/1.9.0/locales/bootstrap-datepicker.zh-CN.min.js"></script>
    <script>
        $(function() {
            // 初始化日期选择器
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true
            });
            
            // 加载垃圾分类数据
            loadCategories();
            
            // 加载投放记录
            loadMyRecords();
            
            // 加载总投放量
            loadTotalWeight();
        });
        
        // 加载垃圾分类
        function loadCategories() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/waste/list",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var categories = res.data;
                        var options = '<option value="">全部分类</option>';
                        var addOptions = '<option value="">请选择垃圾分类</option>';
                        
                        $.each(categories, function(index, category) {
                            options += '<option value="' + category.id + '">' + category.name + '</option>';
                            addOptions += '<option value="' + category.id + '">' + category.name + '</option>';
                        });
                        
                        $("#categoryId").html(options);
                        $("#addCategoryId").html(addOptions);
                    }
                }
            });
        }
        
        // 加载我的投放记录
        function loadMyRecords() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/my",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        renderRecords(res.data);
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("加载记录失败，请稍后再试");
                }
            });
        }
        
        // 加载总投放量
        function loadTotalWeight() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/weight/total",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        $("#totalWeight").text(res.data.toFixed(2));
                    }
                }
            });
        }
        
        // 渲染记录列表
        function renderRecords(records) {
            var html = '';
            
            if (records.length === 0) {
                html = '<div class="alert alert-info">暂无投放记录</div>';
            } else {
                $.each(records, function(index, record) {
                    html += '<div class="record-card">';
                    html += '  <div class="record-header d-flex justify-content-between">';
                    html += '    <div><i class="fa fa-recycle"></i> ' + (record.category ? record.category.name : '未知分类') + '</div>';
                    html += '    <div><span class="weight-badge">' + record.weight + ' kg</span></div>';
                    html += '  </div>';
                    html += '  <div class="record-body">';
                    html += '    <div class="row">';
                    html += '      <div class="col-md-6">';
                    html += '        <div class="record-info"><span class="record-label">投放地点:</span> ' + record.location + '</div>';
                    html += '        <div class="record-info"><span class="record-label">投放时间:</span> ' + moment(record.createTime).format('YYYY-MM-DD HH:mm') + '</div>';
                    html += '      </div>';
                    html += '      <div class="col-md-6">';
                    if (record.description) {
                        html += '    <div class="record-info"><span class="record-label">描述:</span> ' + record.description + '</div>';
                    }
                    if (record.image) {
                        html += '    <img src="' + record.image + '" class="record-image" alt="投放照片">';
                    }
                    html += '      </div>';
                    html += '    </div>';
                    html += '    <div class="record-actions">';
                    html += '      <button class="btn btn-sm btn-info" onclick="viewRecord(' + record.id + ')"><i class="fa fa-eye"></i> 查看</button>';
                    html += '      <button class="btn btn-sm btn-danger ml-2" onclick="deleteRecord(' + record.id + ')"><i class="fa fa-trash"></i> 删除</button>';
                    html += '    </div>';
                    html += '  </div>';
                    html += '</div>';
                });
            }
            
            $("#recordList").html(html);
        }
        
        // 搜索记录
        function searchRecords() {
            var params = {
                categoryId: $("#categoryId").val(),
                startTime: $("#startTime").val(),
                endTime: $("#endTime").val(),
                location: $("#location").val()
            };
            
            // 移除空值
            Object.keys(params).forEach(key => {
                if (!params[key]) {
                    delete params[key];
                }
            });
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/search",
                type: "GET",
                data: params,
                success: function(res) {
                    if (res.code === 200) {
                        renderRecords(res.data);
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("搜索失败，请稍后再试");
                }
            });
        }
        
        // 重置搜索条件
        function resetSearch() {
            $("#searchForm")[0].reset();
            loadMyRecords();
        }
        
        // 添加记录
        function addRecord() {
            var data = {
                categoryId: $("#addCategoryId").val(),
                weight: $("#weight").val(),
                location: $("#addLocation").val(),
                description: $("#description").val(),
                image: $("#image").val()
            };
            
            // 表单验证
            if (!data.categoryId) {
                alert("请选择垃圾分类");
                return;
            }
            if (!data.weight || data.weight <= 0) {
                alert("请输入有效的投放重量");
                return;
            }
            if (!data.location) {
                alert("请输入投放地点");
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/add",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(data),
                success: function(res) {
                    if (res.code === 200) {
                        alert("添加成功");
                        $("#addRecordModal").modal("hide");
                        $("#addRecordForm")[0].reset();
                        loadMyRecords();
                        loadTotalWeight();
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("添加失败，请稍后再试");
                }
            });
        }
        
        // 查看记录详情
        function viewRecord(id) {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/record/" + id,
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var record = res.data;
                        var html = '<div class="record-info"><span class="record-label">垃圾分类:</span> ' + (record.category ? record.category.name : '未知分类') + '</div>';
                        html += '<div class="record-info"><span class="record-label">投放重量:</span> ' + record.weight + ' kg</div>';
                        html += '<div class="record-info"><span class="record-label">投放地点:</span> ' + record.location + '</div>';
                        html += '<div class="record-info"><span class="record-label">投放时间:</span> ' + moment(record.createTime).format('YYYY-MM-DD HH:mm:ss') + '</div>';
                        
                        if (record.description) {
                            html += '<div class="record-info"><span class="record-label">描述:</span> ' + record.description + '</div>';
                        }
                        
                        if (record.image) {
                            html += '<div class="text-center mt-3"><img src="' + record.image + '" class="record-image" alt="投放照片"></div>';
                        }
                        
                        $("#viewRecordBody").html(html);
                        $("#viewRecordModal").modal("show");
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("获取记录详情失败，请稍后再试");
                }
            });
        }
        
        // 删除记录
        function deleteRecord(id) {
            if (confirm("确定要删除这条记录吗？")) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/record/delete/" + id,
                    type: "DELETE",
                    success: function(res) {
                        if (res.code === 200) {
                            alert("删除成功");
                            loadMyRecords();
                            loadTotalWeight();
                        } else {
                            alert(res.message);
                        }
                    },
                    error: function() {
                        alert("删除失败，请稍后再试");
                    }
                });
            }
        }
    </script>
</body>
</html> 