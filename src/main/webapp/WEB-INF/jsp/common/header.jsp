<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <i class="fas fa-recycle mr-2" style="color: var(--primary-color); font-size: 1.5rem;"></i>
            <span style="font-weight: 600; color: var(--primary-color);">社区垃圾分类系统</span>
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="fas fa-home mr-1"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/guide"><i class="fas fa-book mr-1"></i> 分类指南</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/record"><i class="fas fa-list-alt mr-1"></i> 投放记录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/activity"><i class="fas fa-calendar-alt mr-1"></i> 社区活动</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/statistics"><i class="fas fa-chart-bar mr-1"></i> 数据统计</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/faq"><i class="fas fa-question-circle mr-1"></i> 常见问题</a>
                </li>
                <c:if test="${empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="nav-link btn btn-sm btn-outline-success ml-2" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt mr-1"></i> 登录</a>
                    </li>
                </c:if>
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-user-circle mr-1"></i> ${sessionScope.user.username}
                        </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-id-card mr-2"></i> 个人信息</a>
                            <c:if test="${sessionScope.user.role > 0}">
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/user"><i class="fas fa-users-cog mr-2"></i> 用户管理</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn mr-2"></i> 公告管理</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/activity"><i class="fas fa-calendar-check mr-2"></i> 活动管理</a>
                            </c:if>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item text-danger" href="javascript:void(0)" onclick="logout()"><i class="fas fa-sign-out-alt mr-2"></i> 退出登录</a>
                        </div>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<!-- 为固定顶部导航栏留出空间 -->
<div style="padding-top: var(--header-height);"></div>

<script>
function logout() {
    $.ajax({
        url: "${pageContext.request.contextPath}/api/user/logout",
        type: "POST",
        success: function(res) {
            if (res.code === 200) {
                alert("已退出登录");
                window.location.href = "${pageContext.request.contextPath}/login";
            } else {
                alert(res.message);
            }
        },
        error: function() {
            alert("系统错误，请稍后再试");
        }
    });
}
</script> 