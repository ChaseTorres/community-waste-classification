<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>活动管理 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/fontawesome.all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <style>
        .card {
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .card-header {
            border-top-left-radius: 15px !important;
            border-top-right-radius: 15px !important;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .btn-outline-success {
            border-radius: 20px;
            font-weight: 500;
            padding: 8px 20px;
            transition: all 0.3s;
        }
        .btn-outline-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .table-hover tbody tr:hover {
            background-color: rgba(40, 167, 69, 0.05);
        }
        .thead-light th {
            background-color: #f8f9fa;
            color: #495057;
            border-color: #e9ecef;
        }
        .table td, .table th {
            vertical-align: middle;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: 500;
        }
        .modal-content {
            border-radius: 15px;
            border: none;
        }
        .modal-header {
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .form-control {
            border-radius: 20px;
            padding: 10px 20px;
            border: 1px solid #ced4da;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            border-color: #28a745;
        }
        textarea.form-control {
            border-radius: 15px;
        }
        .btn-sm {
            border-radius: 20px;
            padding: 4px 10px;
        }
        .pagination .page-link {
            border-radius: 20px;
            margin: 0 3px;
            color: #28a745;
        }
        .pagination .page-item.active .page-link {
            background-color: #28a745;
            border-color: #28a745;
        }
        .pagination .page-link:focus {
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 20px;
            padding: 8px 25px;
            font-weight: 500;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.1);
        }
        .btn-secondary {
            border-radius: 20px;
            padding: 8px 25px;
            font-weight: 500;
        }
        label {
            font-weight: 500;
            color: #495057;
        }
        #viewTitle {
            font-weight: 600;
            color: #343a40;
        }
        #viewContent {
            background-color: #f8f9fa;
            line-height: 1.6;
            color: #343a40;
        }
        .text-muted i {
            color: #20c997;
        }
        .info-icon {
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(40, 167, 69, 0.1);
            border-radius: 50%;
            margin-right: 10px;
            color: #28a745;
        }
        .activity-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .activity-info span {
            font-weight: 500;
        }
        .table-bordered {
            border-radius: 10px;
            overflow: hidden;
        }
        .table-bordered thead th {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white py-3">
                <h5 class="mb-0"><i class="fas fa-calendar-check mr-2"></i>活动管理</h5>
            </div>
            <div class="card-body py-4 px-4">
                <div class="mb-4">
                    <button class="btn btn-outline-success" id="addActivityBtn">
                        <i class="fas fa-plus-circle mr-1"></i>创建活动
                    </button>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>标题</th>
                                <th>活动时间</th>
                                <th>地点</th>
                                <th>参与人数</th>
                                <th>状态</th>
                                <th>创建时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="activityTableBody">
                            <!-- 活动数据将通过Ajax加载 -->
                        </tbody>
                    </table>
                </div>
                
                <div class="d-flex justify-content-center mt-4">
                    <ul class="pagination" id="activityPagination">
                        <!-- 分页控件将通过JavaScript动态生成 -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 添加/编辑活动模态框 -->
    <div class="modal fade" id="activityModal" tabindex="-1" role="dialog" aria-labelledby="activityModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="activityModalLabel">创建活动</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body py-4">
                    <form id="activityForm">
                        <input type="hidden" id="activityId">
                        <div class="form-group">
                            <label for="title">活动标题</label>
                            <input type="text" class="form-control" id="title" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="activityTime">活动时间</label>
                                <input type="datetime-local" class="form-control" id="activityTime" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="location">活动地点</label>
                                <input type="text" class="form-control" id="location" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="maxParticipants">最大参与人数</label>
                                <input type="number" class="form-control" id="maxParticipants" min="1" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="points">奖励积分</label>
                                <input type="number" class="form-control" id="points" min="0" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="content">活动内容</label>
                            <textarea class="form-control" id="content" rows="8" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="status">状态</label>
                            <select class="form-control" id="status">
                                <option value="1">发布</option>
                                <option value="0">草稿</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-success" id="saveActivityBtn">保存</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 查看活动模态框 -->
    <div class="modal fade" id="viewActivityModal" tabindex="-1" role="dialog" aria-labelledby="viewActivityModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="viewActivityModalLabel">查看活动</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body py-4">
                    <h4 id="viewTitle" class="text-center mb-4"></h4>
                    
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="activity-info">
                                        <span class="info-icon"><i class="fas fa-clock"></i></span>
                                        <span id="viewTime"></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="activity-info">
                                        <span class="info-icon"><i class="fas fa-map-marker-alt"></i></span>
                                        <span id="viewLocation"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="activity-info">
                                        <span class="info-icon"><i class="fas fa-users"></i></span>
                                        参与人数: <span id="viewParticipants"></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="activity-info">
                                        <span class="info-icon"><i class="fas fa-star"></i></span>
                                        奖励积分: <span id="viewPoints"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">活动详情</h5>
                        </div>
                        <div class="card-body">
                            <div id="viewContent" class="p-3"></div>
                        </div>
                    </div>
                    
                    <div class="card" id="participantsContainer">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">参与人员列表</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm table-bordered">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>用户名</th>
                                            <th>姓名</th>
                                            <th>手机号</th>
                                            <th>报名时间</th>
                                            <th>状态</th>
                                        </tr>
                                    </thead>
                                    <tbody id="participantsTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/fontawesome.all.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // 加载活动数据
            loadActivities(1);
            
            // 添加活动按钮点击事件
            $("#addActivityBtn").click(function() {
                $("#activityModalLabel").text("创建活动");
                $("#activityForm")[0].reset();
                $("#activityId").val("");
                $("#activityModal").modal("show");
            });
            
            // 保存活动按钮点击事件
            $("#saveActivityBtn").click(function() {
                saveActivity();
            });
        });
        
        // 加载活动列表
        function loadActivities(page) {
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/list",
                type: "GET",
                data: { page: page, size: 10 },
                dataType: "json",
                success: function(response) {
                    renderActivityTable(response.content);
                    renderPagination(response.totalPages, page);
                },
                error: function(xhr) {
                    alert("加载活动数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 渲染活动表格
        function renderActivityTable(activities) {
            var html = '';
            
            if(activities.length === 0) {
                html = '<tr><td colspan="8" class="text-center py-4">没有活动数据</td></tr>';
            } else {
                $.each(activities, function(index, activity) {
                    html += '<tr>';
                    html += '<td>' + activity.id + '</td>';
                    html += '<td class="font-weight-bold">' + activity.title + '</td>';
                    html += '<td>' + activity.activityTime + '</td>';
                    html += '<td>' + activity.location + '</td>';
                    html += '<td>' + activity.currentParticipants + '/' + activity.maxParticipants + '</td>';
                    
                    // 活动状态显示
                    var statusHtml = '';
                    if(activity.status === 0) {
                        statusHtml = '<span class="badge badge-secondary">草稿</span>';
                    } else {
                        var now = new Date();
                        var actTime = new Date(activity.activityTime);
                        
                        if(now < actTime) {
                            statusHtml = '<span class="badge badge-success">进行中</span>';
                        } else {
                            statusHtml = '<span class="badge badge-info">已结束</span>';
                        }
                    }
                    html += '<td>' + statusHtml + '</td>';
                    
                    html += '<td>' + activity.createTime + '</td>';
                    html += '<td>';
                    html += '<button class="btn btn-sm btn-outline-info mr-1" onclick="viewActivity(' + activity.id + ')" title="查看"><i class="fas fa-eye"></i></button>';
                    html += '<button class="btn btn-sm btn-outline-primary mr-1" onclick="editActivity(' + activity.id + ')" title="编辑"><i class="fas fa-edit"></i></button>';
                    
                    if(activity.status === 0) {
                        html += '<button class="btn btn-sm btn-outline-success mr-1" onclick="changeActivityStatus(' + activity.id + ', 1)" title="发布"><i class="fas fa-check-circle"></i></button>';
                    } else {
                        html += '<button class="btn btn-sm btn-outline-warning mr-1" onclick="changeActivityStatus(' + activity.id + ', 0)" title="设为草稿"><i class="fas fa-ban"></i></button>';
                    }
                    
                    html += '<button class="btn btn-sm btn-outline-danger" onclick="deleteActivity(' + activity.id + ')" title="删除"><i class="fas fa-trash-alt"></i></button>';
                    html += '</td>';
                    html += '</tr>';
                });
            }
            
            $("#activityTableBody").html(html);
        }
        
        // 渲染分页控件
        function renderPagination(totalPages, currentPage) {
            var html = '';
            
            if(totalPages > 1) {
                html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadActivities(' + (currentPage - 1) + ')">&laquo;</a>';
                html += '</li>';
                
                for(var i = 1; i <= totalPages; i++) {
                    html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">';
                    html += '<a class="page-link" href="javascript:void(0)" onclick="loadActivities(' + i + ')">' + i + '</a>';
                    html += '</li>';
                }
                
                html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadActivities(' + (currentPage + 1) + ')">&raquo;</a>';
                html += '</li>';
            }
            
            $("#activityPagination").html(html);
        }
        
        // 保存活动
        function saveActivity() {
            var activityId = $("#activityId").val();
            var activityData = {
                title: $("#title").val(),
                activityTime: $("#activityTime").val(),
                location: $("#location").val(),
                maxParticipants: $("#maxParticipants").val(),
                points: $("#points").val(),
                content: $("#content").val(),
                status: $("#status").val()
            };
            
            if(activityId) {
                activityData.id = activityId;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/" + (activityId ? "update" : "save"),
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(activityData),
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        $("#activityModal").modal("hide");
                        loadActivities(1);
                    } else {
                        alert("保存失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
        
        // 查看活动
        function viewActivity(activityId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/get",
                type: "GET",
                data: { id: activityId },
                dataType: "json",
                success: function(activity) {
                    $("#viewTitle").text(activity.title);
                    $("#viewTime").text(activity.activityTime);
                    $("#viewLocation").text(activity.location);
                    $("#viewParticipants").text(activity.currentParticipants + '/' + activity.maxParticipants);
                    $("#viewPoints").text(activity.points);
                    $("#viewContent").html(activity.content.replace(/\n/g, "<br>"));
                    
                    // 加载参与人员列表
                    loadParticipants(activityId);
                    
                    $("#viewActivityModal").modal("show");
                },
                error: function(xhr) {
                    alert("获取活动数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 加载活动参与人员
        function loadParticipants(activityId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/participants",
                type: "GET",
                data: { activityId: activityId },
                dataType: "json",
                success: function(participants) {
                    var html = '';
                    
                    if(participants.length === 0) {
                        html = '<tr><td colspan="5" class="text-center py-3">暂无参与人员</td></tr>';
                    } else {
                        $.each(participants, function(index, p) {
                            html += '<tr>';
                            html += '<td>' + p.username + '</td>';
                            html += '<td>' + (p.realName || '-') + '</td>';
                            html += '<td>' + (p.phone || '-') + '</td>';
                            html += '<td>' + p.joinTime + '</td>';
                            html += '<td>' + (p.status === 1 ? '<span class="badge badge-success">已参与</span>' : '<span class="badge badge-warning">已报名</span>') + '</td>';
                            html += '</tr>';
                        });
                    }
                    
                    $("#participantsTableBody").html(html);
                },
                error: function(xhr) {
                    $("#participantsTableBody").html('<tr><td colspan="5" class="text-center text-danger">加载参与人员失败</td></tr>');
                }
            });
        }
        
        // 编辑活动
        function editActivity(activityId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/get",
                type: "GET",
                data: { id: activityId },
                dataType: "json",
                success: function(activity) {
                    $("#activityModalLabel").text("编辑活动");
                    $("#activityId").val(activity.id);
                    $("#title").val(activity.title);
                    
                    // 处理日期时间格式
                    var actTime = new Date(activity.activityTime);
                    var formattedDateTime = actTime.toISOString().slice(0, 16);
                    $("#activityTime").val(formattedDateTime);
                    
                    $("#location").val(activity.location);
                    $("#maxParticipants").val(activity.maxParticipants);
                    $("#points").val(activity.points);
                    $("#content").val(activity.content);
                    $("#status").val(activity.status);
                    $("#activityModal").modal("show");
                },
                error: function(xhr) {
                    alert("获取活动数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 更改活动状态
        function changeActivityStatus(activityId, status) {
            var action = status === 1 ? "发布" : "设为草稿";
            if(!confirm("确定要" + action + "该活动吗？")) {
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/status",
                type: "POST",
                data: { id: activityId, status: status },
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        loadActivities(1);
                    } else {
                        alert("操作失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
        
        // 删除活动
        function deleteActivity(activityId) {
            if(!confirm("确定要删除该活动吗？此操作不可恢复！")) {
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/activity/delete",
                type: "POST",
                data: { id: activityId },
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        loadActivities(1);
                    } else {
                        alert("删除失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
    </script>
</body>
</html> 