<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .user-table th, .user-table td {
            vertical-align: middle;
        }
        .badge-role {
            padding: 5px 10px;
            border-radius: 20px;
        }
        .user-search-box {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .user-search-box .form-control {
            padding-left: 2.5rem;
        }
        .user-search-box .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
        }
        .user-card {
            border: none;
            transition: all var(--transition-speed);
        }
        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container">
        <div class="page-title">
            <h2>用户管理</h2>
        </div>
        
        <div class="card user-card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-users-cog mr-2"></i>用户列表</span>
                <button class="btn btn-success btn-sm" id="addUserBtn">
                    <i class="fas fa-user-plus mr-1"></i>添加用户
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover user-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>用户名</th>
                                <th>姓名</th>
                                <th>手机号</th>
                                <th>角色</th>
                                <th>积分</th>
                                <th>状态</th>
                                <th>注册时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                            <!-- 用户数据将通过Ajax加载 -->
                        </tbody>
                    </table>
                </div>
                
                <div class="d-flex justify-content-center mt-4">
                    <ul class="pagination" id="userPagination">
                        <!-- 分页控件将通过JavaScript动态生成 -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 添加/编辑用户模态框 -->
    <div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalLabel">添加用户</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId">
                        <div class="form-group">
                            <label for="username">用户名</label>
                            <input type="text" class="form-control" id="username" required>
                        </div>
                        <div class="form-group">
                            <label for="password">密码</label>
                            <input type="password" class="form-control" id="password">
                            <small class="form-text text-muted">编辑时留空表示不修改密码</small>
                        </div>
                        <div class="form-group">
                            <label for="realName">姓名</label>
                            <input type="text" class="form-control" id="realName">
                        </div>
                        <div class="form-group">
                            <label for="phone">手机号</label>
                            <input type="text" class="form-control" id="phone">
                        </div>
                        <div class="form-group">
                            <label for="role">角色</label>
                            <select class="form-control" id="role">
                                <option value="ROLE_USER">普通用户</option>
                                <option value="ROLE_ADMIN">管理员</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">状态</label>
                            <select class="form-control" id="status">
                                <option value="1">正常</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-success" id="saveUserBtn">保存</button>
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
            // 加载用户数据
            loadUsers(1);
            
            // 添加用户按钮点击事件
            $("#addUserBtn").click(function() {
                $("#userModalLabel").text("添加用户");
                $("#userForm")[0].reset();
                $("#userId").val("");
                $("#userModal").modal("show");
            });
            
            // 保存用户按钮点击事件
            $("#saveUserBtn").click(function() {
                saveUser();
            });
        });
        
        // 加载用户列表
        function loadUsers(page) {
            $.ajax({
                url: "${pageContext.request.contextPath}/user/list",
                type: "GET",
                data: { page: page, size: 10 },
                dataType: "json",
                success: function(response) {
                    renderUserTable(response.content);
                    renderPagination(response.totalPages, page);
                },
                error: function(xhr) {
                    alert("加载用户数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 渲染用户表格
        function renderUserTable(users) {
            var html = '';
            
            if(users.length === 0) {
                html = '<tr><td colspan="9" class="text-center py-4">没有用户数据</td></tr>';
            } else {
                $.each(users, function(index, user) {
                    html += '<tr>';
                    html += '<td>' + user.id + '</td>';
                    html += '<td>' + user.username + '</td>';
                    html += '<td>' + (user.realName || '-') + '</td>';
                    html += '<td>' + (user.phone || '-') + '</td>';
                    html += '<td>' + (user.role === 'ROLE_ADMIN' ? '<span class="badge badge-info badge-role">管理员</span>' : '<span class="badge badge-secondary badge-role">普通用户</span>') + '</td>';
                    html += '<td>' + user.points + '</td>';
                    html += '<td>' + (user.status === 1 ? '<span class="badge badge-success badge-role">正常</span>' : '<span class="badge badge-danger badge-role">禁用</span>') + '</td>';
                    html += '<td>' + user.createTime + '</td>';
                    html += '<td>';
                    html += '<button class="btn btn-sm btn-outline-primary mr-1" onclick="editUser(' + user.id + ')" title="编辑"><i class="fas fa-edit"></i></button>';
                    if(user.status === 1) {
                        html += '<button class="btn btn-sm btn-outline-danger" onclick="changeUserStatus(' + user.id + ', 0)" title="禁用"><i class="fas fa-user-slash"></i></button>';
                    } else {
                        html += '<button class="btn btn-sm btn-outline-success" onclick="changeUserStatus(' + user.id + ', 1)" title="启用"><i class="fas fa-user-check"></i></button>';
                    }
                    html += '</td>';
                    html += '</tr>';
                });
            }
            
            $("#userTableBody").html(html);
        }
        
        // 渲染分页控件
        function renderPagination(totalPages, currentPage) {
            var html = '';
            
            if(totalPages > 1) {
                html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadUsers(' + (currentPage - 1) + ')">&laquo;</a>';
                html += '</li>';
                
                for(var i = 1; i <= totalPages; i++) {
                    html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">';
                    html += '<a class="page-link" href="javascript:void(0)" onclick="loadUsers(' + i + ')">' + i + '</a>';
                    html += '</li>';
                }
                
                html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadUsers(' + (currentPage + 1) + ')">&raquo;</a>';
                html += '</li>';
            }
            
            $("#userPagination").html(html);
        }
        
        // 保存用户
        function saveUser() {
            var userId = $("#userId").val();
            var userData = {
                username: $("#username").val(),
                password: $("#password").val(),
                realName: $("#realName").val(),
                phone: $("#phone").val(),
                role: $("#role").val(),
                status: $("#status").val()
            };
            
            $.ajax({
                url: "${pageContext.request.contextPath}/user/" + (userId ? "update" : "save"),
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(userData),
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        $("#userModal").modal("hide");
                        loadUsers(1);
                    } else {
                        alert("保存失败：" + response.message);
                    }
                },
                error: function(xhr) {
                    alert("操作失败：" + xhr.responseText);
                }
            });
        }
        
        // 编辑用户
        function editUser(userId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/user/get",
                type: "GET",
                data: { id: userId },
                dataType: "json",
                success: function(user) {
                    $("#userModalLabel").text("编辑用户");
                    $("#userId").val(user.id);
                    $("#username").val(user.username);
                    $("#password").val(""); // 清空密码字段
                    $("#realName").val(user.realName);
                    $("#phone").val(user.phone);
                    $("#role").val(user.role);
                    $("#status").val(user.status);
                    $("#userModal").modal("show");
                },
                error: function(xhr) {
                    alert("获取用户数据失败：" + xhr.responseText);
                }
            });
        }
        
        // 更改用户状态
        function changeUserStatus(userId, status) {
            if(!confirm("确定要" + (status === 1 ? "启用" : "禁用") + "该用户吗？")) {
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/user/status",
                type: "POST",
                data: { id: userId, status: status },
                dataType: "json",
                success: function(response) {
                    if(response.success) {
                        loadUsers(1);
                    } else {
                        alert("操作失败：" + response.message);
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