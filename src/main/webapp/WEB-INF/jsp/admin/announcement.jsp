<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - 社区垃圾分类系统</title>
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
        #viewInfo {
            color: #6c757d;
        }
        #viewContent {
            background-color: #f8f9fa;
            line-height: 1.6;
            color: #343a40;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white py-3">
                <h5 class="mb-0"><i class="fas fa-bullhorn mr-2"></i>公告管理</h5>
            </div>
            <div class="card-body py-4 px-4">
                <div class="mb-4">
                    <button class="btn btn-outline-success" id="addAnnouncementBtn">
                        <i class="fas fa-plus-circle mr-1"></i>发布公告
                    </button>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-light">
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
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="announcementModalLabel">发布公告</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body py-4">
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
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="viewAnnouncementModalLabel">查看公告</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body py-4">
                    <h4 id="viewTitle" class="text-center mb-3"></h4>
                    <p class="text-muted text-center mb-4">
                        <small id="viewInfo"></small>
                    </p>
                    <div id="viewContent" class="p-4 border rounded bg-light"></div>
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
                    html += '<td class="font-weight-bold">' + announcement.title + '</td>';
                    html += '<td>' + announcement.createBy + '</td>';
                    html += '<td>' + announcement.createTime + '</td>';
                    html += '<td>' + (announcement.status === 1 ? '<span class="badge badge-success">已发布</span>' : '<span class="badge badge-secondary">草稿</span>') + '</td>';
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