<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>社区活动 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 20px;
        }
        .activity-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        .activity-title {
            color: #28a745;
            margin-bottom: 30px;
            text-align: center;
        }
        .activity-card {
            margin-bottom: 20px;
            border-left: 5px solid #28a745;
            transition: transform 0.3s;
        }
        .activity-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .activity-card.expired {
            border-left-color: #6c757d;
            opacity: 0.7;
        }
        .card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .badge-expired {
            background-color: #6c757d;
        }
        .badge-active {
            background-color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container activity-container">
        <h2 class="activity-title">社区垃圾分类活动</h2>
        
        <div class="btn-group mb-4" role="group">
            <button type="button" class="btn btn-outline-success active" onclick="loadActivities('active')">进行中活动</button>
            <button type="button" class="btn btn-outline-secondary" onclick="loadActivities('expired')">已结束活动</button>
        </div>
        
        <div id="activityList">
            <!-- 活动列表将通过AJAX加载 -->
        </div>
    </div>
    
    <!-- 活动详情模态框 -->
    <div class="modal fade" id="activityModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="activityModalTitle"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>活动时间：</strong><span id="activityTime"></span></p>
                            <p><strong>活动地点：</strong><span id="activityLocation"></span></p>
                            <p><strong>发布者：</strong><span id="activityPublisher"></span></p>
                            <p><strong>报名方式：</strong><span id="activityRegistration"></span></p>
                        </div>
                        <div class="col-md-6">
                            <div id="activityStatus" class="mb-3"></div>
                        </div>
                    </div>
                    <hr>
                    <div id="activityContent"></div>
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
    <script>
        $(document).ready(function() {
            // 默认加载未过期活动
            loadActivities('active');
        });
        
        // 加载活动列表
        function loadActivities(type) {
            // 设置按钮选中状态
            $('.btn-group .btn').removeClass('active');
            if (type === 'active') {
                $('.btn-outline-success').addClass('active');
            } else {
                $('.btn-outline-secondary').addClass('active');
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/activity/list",
                type: "GET",
                data: {
                    expired: type === 'expired'
                },
                success: function(res) {
                    if (res.code === 200) {
                        renderActivityList(res.data, type);
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("加载活动失败，请稍后再试");
                }
            });
        }
        
        // 渲染活动列表
        function renderActivityList(activities, type) {
            var html = '';
            
            if (activities && activities.length > 0) {
                for (var i = 0; i < activities.length; i++) {
                    var activity = activities[i];
                    var startTime = new Date(activity.startTime).toLocaleString();
                    var endTime = new Date(activity.endTime).toLocaleString();
                    var isExpired = type === 'expired';
                    
                    html += '<div class="card activity-card ' + (isExpired ? 'expired' : '') + '">';
                    html += '   <div class="card-body">';
                    html += '       <h5 class="card-title">' + activity.title + '</h5>';
                    html += '       <p class="card-text">' + (activity.content.length > 100 ? activity.content.substring(0, 100) + '...' : activity.content) + '</p>';
                    html += '   </div>';
                    html += '   <div class="card-footer">';
                    html += '       <small class="text-muted">活动时间: ' + startTime + ' 至 ' + endTime + '</small>';
                    html += '       <div>';
                    html += '           <span class="badge ' + (isExpired ? 'badge-expired' : 'badge-active') + ' mr-2">' + (isExpired ? '已结束' : '进行中') + '</span>';
                    html += '           <button class="btn btn-sm btn-outline-primary" onclick="viewActivityDetail(' + activity.id + ')">查看详情</button>';
                    html += '       </div>';
                    html += '   </div>';
                    html += '</div>';
                }
            } else {
                html = '<div class="alert alert-info">暂无' + (type === 'active' ? '进行中' : '已结束') + '的活动</div>';
            }
            
            $("#activityList").html(html);
        }
        
        // 查看活动详情
        function viewActivityDetail(id) {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/activity/" + id,
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var activity = res.data;
                        
                        // 设置模态框内容
                        $("#activityModalTitle").text(activity.title);
                        $("#activityTime").text(new Date(activity.startTime).toLocaleString() + " 至 " + new Date(activity.endTime).toLocaleString());
                        $("#activityLocation").text(activity.location || "暂未设置");
                        $("#activityPublisher").text(activity.publisher ? activity.publisher.username : "管理员");
                        $("#activityRegistration").text(activity.registrationMethod || "活动现场报名");
                        
                        var now = new Date();
                        var endTime = new Date(activity.endTime);
                        var statusHtml = '';
                        
                        if (now > endTime) {
                            statusHtml = '<div class="alert alert-secondary">此活动已结束</div>';
                        } else {
                            statusHtml = '<div class="alert alert-success">此活动正在进行中</div>';
                        }
                        
                        $("#activityStatus").html(statusHtml);
                        $("#activityContent").html(activity.content);
                        
                        // 显示模态框
                        $("#activityModal").modal('show');
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("获取活动详情失败，请稍后再试");
                }
            });
        }
    </script>
</body>
</html> 