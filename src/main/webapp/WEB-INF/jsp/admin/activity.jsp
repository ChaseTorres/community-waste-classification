<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>活动管理 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .activity-table th, .activity-table td {
            vertical-align: middle;
        }
        .activity-title {
            font-weight: 600;
            color: var(--text-dark);
        }
        .badge-status {
            padding: 5px 10px;
            border-radius: 20px;
        }
        .activity-card {
            border: none;
            transition: all var(--transition-speed);
        }
        .activity-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        .info-box {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        .info-box .icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--primary-bg);
            color: var(--primary-color);
            border-radius: 50%;
            margin-right: 1rem;
            font-size: 1.2rem;
        }
        .info-box .info-content {
            flex: 1;
        }
        .info-box .info-label {
            color: var(--text-light);
            font-size: 0.85rem;
            margin-bottom: 0.2rem;
        }
        .info-box .info-value {
            color: var(--text-dark);
            font-weight: 500;
        }
        .participant-table {
            border-radius: var(--border-radius);
            overflow: hidden;
        }
        .section-card {
            margin-bottom: 1.5rem;
            border-radius: var(--border-radius);
            overflow: hidden;
            border: none;
            box-shadow: var(--shadow-sm);
        }
        .section-card .card-header {
            background-color: var(--primary-bg);
            color: var(--primary-color);
            font-weight: 600;
            border-bottom: none;
        }
        .activity-content {
            background-color: var(--bg-light);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container">
        <div class="page-title">
            <h2>活动管理</h2>
        </div>
        
        <div class="card activity-card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-calendar-check mr-2"></i>活动列表</span>
                <button class="btn btn-success btn-sm" id="addActivityBtn">
                    <i class="fas fa-plus-circle mr-1"></i>创建活动
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover activity-table">
                        <thead>
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
                <div class="modal-header">
                    <h5 class="modal-title" id="activityModalLabel">创建活动</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
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
                <div class="modal-header">
                    <h5 class="modal-title" id="viewActivityModalLabel">查看活动</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h4 id="viewTitle" class="text-center mb-4 activity-title"></h4>
                    
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="info-box">
                                <div class="icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">活动时间</div>
                                    <div class="info-value" id="viewTime"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-box">
                                <div class="icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">活动地点</div>
                                    <div class="info-value" id="viewLocation"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="info-box">
                                <div class="icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">参与人数</div>
                                    <div class="info-value" id="viewParticipants"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-box">
                                <div class="icon">
                                    <i class="fas fa-star"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">奖励积分</div>
                                    <div class="info-value" id="viewPoints"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-card">
                        <div class="card-header">
                            <i class="fas fa-info-circle mr-2"></i>活动详情
                        </div>
                        <div class="card-body">
                            <div id="viewContent" class="activity-content"></div>
                        </div>
                    </div>
                    
                    <div class="section-card">
                        <div class="card-header">
                            <i class="fas fa-users mr-2"></i>参与人员
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm table-striped participant-table">
                                    <thead>
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
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    
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
                    html += '<td class="activity-title">' + activity.title + '</td>';
                    html += '<td>' + activity.activityTime + '</td>';
                    html += '<td>' + activity.location + '</td>';
                    html += '<td>' + activity.currentParticipants + '/' + activity.maxParticipants + '</td>';
                    
                    // 活动状态显示
                    var statusHtml = '';
                    if(activity.status === 0) {
                        statusHtml = '<span class="badge badge-secondary badge-status">草稿</span>';
                    } else {
                        var now = new Date();
                        var actTime = new Date(activity.activityTime);
                        
                        if(now < actTime) {
                            statusHtml = '<span class="badge badge-success badge-status">进行中</span>';
                        } else {
                            statusHtml = '<span class="badge badge-info badge-status">已结束</span>';
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
                            html += '<td>' + (p.status === 1 ? '<span class="badge badge-success badge-status">已参与</span>' : '<span class="badge badge-warning badge-status">已报名</span>') + '</td>';
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