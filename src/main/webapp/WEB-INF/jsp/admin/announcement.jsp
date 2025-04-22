<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .announcement-table th, .announcement-table td {
            vertical-align: middle;
        }
        .announcement-title {
            font-weight: 600;
            color: var(--text-dark);
        }
        .badge-status {
            padding: 5px 10px;
            border-radius: 20px;
        }
        .announcement-card {
            border: none;
            transition: all var(--transition-speed);
        }
        .announcement-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        .view-content {
            background-color: var(--bg-light);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            line-height: 1.6;
        }
        .view-meta {
            color: var(--text-light);
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container">
        <div class="page-title">
            <h2>公告管理</h2>
        </div>
        
        <div class="card announcement-card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-bullhorn mr-2"></i>公告列表</span>
                <button class="btn btn-success btn-sm" id="addAnnouncementBtn">
                    <i class="fas fa-plus-circle mr-1"></i>发布公告
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover announcement-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>标题</th>
                                <th>发布人</th>
                                <th>发布时间</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="announcementTableBody">
                            <!-- 公告数据将通过Ajax加载 -->
                        </tbody>
                    </table>
                </div>
                
                <div class="d-flex justify-content-center mt-4">
                    <ul class="pagination" id="announcementPagination">
                        <!-- 分页控件将通过JavaScript动态生成 -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 添加/编辑公告模态框 -->
    <div class="modal fade" id="announcementModal" tabindex="-1" role="dialog" aria-labelledby="announcementModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="announcementModalLabel">发布公告</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="announcementForm">
                        <input type="hidden" id="announcementId">
                        <div class="form-group">
                            <label for="title">标题</label>
                            <input type="text" class="form-control" id="title" required>
                        </div>
                        <div class="form-group">
                            <label for="content">内容</label>
                            <textarea class="form-control" id="content" rows="10" required></textarea>
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
                    <button type="button" class="btn btn-success" id="saveAnnouncementBtn">保存</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 查看公告模态框 -->
    <div class="modal fade" id="viewAnnouncementModal" tabindex="-1" role="dialog" aria-labelledby="viewAnnouncementModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewAnnouncementModalLabel">查看公告</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h4 id="viewTitle" class="text-center mb-3 announcement-title"></h4>
                    <p class="text-center mb-4 view-meta">
                        <small id="viewInfo"></small>
                    </p>
                    <div id="viewContent" class="view-content"></div>
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
            // 加载公告数据
            loadAnnouncements(1);
            
            // 添加公告按钮点击事件
            $("#addAnnouncementBtn").click(function() {
                $("#announcementModalLabel").text("发布公告");
                $("#announcementForm")[0].reset();
                $("#announcementId").val("");
                $("#announcementModal").modal("show");
            });
            
            // 保存公告按钮点击事件
            $("#saveAnnouncementBtn").click(function() {
                saveAnnouncement();
            });
        });
        
        // 加载公告列表
        function loadAnnouncements(page) {
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/list",
                type: "GET",
                data: { page: page, size: 10 },
                dataType: "json",
                success: function(response) {
                    renderAnnouncementTable(response.content);
                    renderPagination(response.totalPages, page);
                },
                error: function(xhr) {
                    alert("加载公告数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 渲染公告表格
        function renderAnnouncementTable(announcements) {
            var html = '';
            
            if(announcements.length === 0) {
                html = '<tr><td colspan="6" class="text-center py-4">没有公告数据</td></tr>';
            } else {
                $.each(announcements, function(index, announcement) {
                    html += '<tr>';
                    html += '<td>' + announcement.id + '</td>';
                    html += '<td class="announcement-title">' + announcement.title + '</td>';
                    html += '<td>' + announcement.createBy + '</td>';
                    html += '<td>' + announcement.createTime + '</td>';
                    html += '<td>' + (announcement.status === 1 ? '<span class="badge badge-success badge-status">已发布</span>' : '<span class="badge badge-secondary badge-status">草稿</span>') + '</td>';
                    html += '<td>';
                    html += '<button class="btn btn-sm btn-outline-info mr-1" onclick="viewAnnouncement(' + announcement.id + ')" title="查看"><i class="fas fa-eye"></i></button>';
                    html += '<button class="btn btn-sm btn-outline-primary mr-1" onclick="editAnnouncement(' + announcement.id + ')" title="编辑"><i class="fas fa-edit"></i></button>';
                    if(announcement.status === 1) {
                        html += '<button class="btn btn-sm btn-outline-warning mr-1" onclick="changeAnnouncementStatus(' + announcement.id + ', 0)" title="设为草稿"><i class="fas fa-ban"></i></button>';
                    } else {
                        html += '<button class="btn btn-sm btn-outline-success mr-1" onclick="changeAnnouncementStatus(' + announcement.id + ', 1)" title="发布"><i class="fas fa-check-circle"></i></button>';
                    }
                    html += '<button class="btn btn-sm btn-outline-danger" onclick="deleteAnnouncement(' + announcement.id + ')" title="删除"><i class="fas fa-trash-alt"></i></button>';
                    html += '</td>';
                    html += '</tr>';
                });
            }
            
            $("#announcementTableBody").html(html);
        }
        
        // 渲染分页控件
        function renderPagination(totalPages, currentPage) {
            var html = '';
            
            if(totalPages > 1) {
                html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadAnnouncements(' + (currentPage - 1) + ')">&laquo;</a>';
                html += '</li>';
                
                for(var i = 1; i <= totalPages; i++) {
                    html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">';
                    html += '<a class="page-link" href="javascript:void(0)" onclick="loadAnnouncements(' + i + ')">' + i + '</a>';
                    html += '</li>';
                }
                
                html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadAnnouncements(' + (currentPage + 1) + ')">&raquo;</a>';
                html += '</li>';
            }
            
            $("#announcementPagination").html(html);
        }
        
        // 保存公告
        function saveAnnouncement() {
            var announcementId = $("#announcementId").val();
            var announcementData = {
                title: $("#title").val(),
                content: $("#content").val(),
                status: $("#status").val()
            };
            
            if(announcementId) {
                announcementData.id = announcementId;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/" + (announcementId ? "update" : "save"),
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(announcementData),
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        $("#announcementModal").modal("hide");
                        loadAnnouncements(1);
                    } else {
                        alert("保存失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
        
        // 查看公告
        function viewAnnouncement(announcementId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/get",
                type: "GET",
                data: { id: announcementId },
                dataType: "json",
                success: function(announcement) {
                    $("#viewTitle").text(announcement.title);
                    $("#viewInfo").text("发布人：" + announcement.createBy + " | 发布时间：" + announcement.createTime);
                    $("#viewContent").html(announcement.content.replace(/\n/g, "<br>"));
                    $("#viewAnnouncementModal").modal("show");
                },
                error: function(xhr) {
                    alert("获取公告数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 编辑公告
        function editAnnouncement(announcementId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/get",
                type: "GET",
                data: { id: announcementId },
                dataType: "json",
                success: function(announcement) {
                    $("#announcementModalLabel").text("编辑公告");
                    $("#announcementId").val(announcement.id);
                    $("#title").val(announcement.title);
                    $("#content").val(announcement.content);
                    $("#status").val(announcement.status);
                    $("#announcementModal").modal("show");
                },
                error: function(xhr) {
                    alert("获取公告数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 更改公告状态
        function changeAnnouncementStatus(announcementId, status) {
            var action = status === 1 ? "发布" : "设为草稿";
            if(!confirm("确定要" + action + "该公告吗？")) {
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/status",
                type: "POST",
                data: { id: announcementId, status: status },
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        loadAnnouncements(1);
                    } else {
                        alert("操作失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
        
        // 删除公告
        function deleteAnnouncement(announcementId) {
            if(!confirm("确定要删除该公告吗？此操作不可恢复！")) {
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/announcement/delete",
                type: "POST",
                data: { id: announcementId },
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        loadAnnouncements(1);
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