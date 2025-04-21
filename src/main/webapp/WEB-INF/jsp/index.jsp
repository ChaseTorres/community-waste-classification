<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>社区垃圾分类系统 - 首页</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, var(--primary-bg), #d1f5d3);
            border-radius: var(--border-radius);
            padding: 3rem 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        
        .hero-title {
            color: var(--primary-color);
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .hero-text {
            color: var(--text-dark);
            font-size: 1.1rem;
            max-width: 700px;
            margin: 0 auto 1.5rem;
        }
        
        .stats-counter {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            text-align: center;
            padding: 1.5rem;
            height: 100%;
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
            border-bottom: 3px solid var(--primary-color);
        }
        
        .stats-counter:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        
        .counter-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .counter-label {
            font-size: 1rem;
            color: var(--text-light);
            margin-top: 0.5rem;
        }
        
        .feature-card {
            padding: 1.5rem;
            text-align: center;
            height: 100%;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            line-height: 60px;
            font-size: 1.8rem;
            color: white;
            background-color: var(--primary-color);
            border-radius: 50%;
            margin: 0 auto 1rem;
        }
        
        .feature-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }
        
        .feature-text {
            color: var(--text-light);
            font-size: 0.95rem;
        }
        
        .announcement-card {
            border-left: 4px solid var(--primary-color);
            border-radius: var(--border-radius);
            padding: 1.25rem;
            background-color: white;
            box-shadow: var(--shadow-sm);
            margin-bottom: 1rem;
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
        }
        
        .announcement-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        .announcement-title {
            color: var(--text-dark);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .announcement-date {
            color: var(--text-light);
            font-size: 0.85rem;
            margin-bottom: 0.75rem;
        }
        
        .activity-card {
            display: flex;
            background-color: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            margin-bottom: 1rem;
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
        }
        
        .activity-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        .activity-date {
            flex: 0 0 80px;
            background: var(--primary-color);
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1rem 0;
        }
        
        .date-day {
            font-size: 1.8rem;
            font-weight: 700;
            line-height: 1;
        }
        
        .date-month {
            font-size: 0.9rem;
            text-transform: uppercase;
        }
        
        .activity-content {
            flex: 1;
            padding: 1rem;
        }
        
        .activity-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }
        
        .activity-location {
            display: flex;
            align-items: center;
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .activity-description {
            color: var(--text-dark);
            font-size: 0.95rem;
            margin-bottom: 0.75rem;
        }
        
        .user-card {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
        }
        
        .user-welcome {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .user-info {
            margin-bottom: 1.5rem;
        }
        
        .user-info p {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }
        
        .user-info p i {
            width: 20px;
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <!-- 引入页眉 -->
    <jsp:include page="common/header.jsp" />
    
    <div class="container">
        <!-- 英雄区域 -->
        <div class="hero-section">
            <h1 class="hero-title">共建美好环境，从垃圾分类开始</h1>
            <p class="hero-text">社区垃圾分类系统旨在帮助社区居民了解垃圾分类知识，提高垃圾分类意识，实现社区垃圾分类管理的信息化。</p>
            <div class="d-flex justify-content-center">
                <a href="${pageContext.request.contextPath}/guide" class="btn btn-success mr-3"><i class="fas fa-book mr-2"></i>分类指南</a>
                <a href="${pageContext.request.contextPath}/record" class="btn btn-outline-success"><i class="fas fa-plus mr-2"></i>记录投放</a>
            </div>
        </div>
        
        <!-- 数据统计 -->
        <div class="row mb-4">
            <div class="col-md-4 mb-4 mb-md-0">
                <div class="stats-counter">
                    <div class="counter-value">4</div>
                    <div class="counter-label">已注册用户</div>
                </div>
            </div>
            <div class="col-md-4 mb-4 mb-md-0">
                <div class="stats-counter">
                    <div class="counter-value">4</div>
                    <div class="counter-label">垃圾分类数</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-counter">
                    <div class="counter-value">2</div>
                    <div class="counter-label">活动数量</div>
                </div>
            </div>
        </div>
        
        <!-- 主要内容 -->
        <div class="row">
            <!-- 左侧内容 -->
            <div class="col-lg-8">
                <!-- 功能特色 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-star mr-2"></i>核心功能</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-book"></i>
                                    </div>
                                    <h3 class="feature-title">垃圾分类指南</h3>
                                    <p class="feature-text">详细的垃圾分类知识，帮助您正确投放各类垃圾</p>
                                    <a href="${pageContext.request.contextPath}/guide" class="btn btn-sm btn-outline-success mt-2">查看指南</a>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-list-alt"></i>
                                    </div>
                                    <h3 class="feature-title">投放记录</h3>
                                    <p class="feature-text">记录您的垃圾投放情况，查看投放历史数据</p>
                                    <a href="${pageContext.request.contextPath}/record" class="btn btn-sm btn-outline-success mt-2">我的记录</a>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-chart-bar"></i>
                                    </div>
                                    <h3 class="feature-title">数据统计</h3>
                                    <p class="feature-text">查看垃圾分类统计数据，了解社区环保成果</p>
                                    <a href="${pageContext.request.contextPath}/statistics" class="btn btn-sm btn-outline-success mt-2">查看统计</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 公告 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-bullhorn mr-2"></i>最新公告</h5>
                    </div>
                    <div class="card-body">
                        <div class="announcement-card">
                            <h3 class="announcement-title">社区垃圾分类实施通知</h3>
                            <div class="announcement-date"><i class="far fa-calendar-alt mr-1"></i> 2023-04-15</div>
                            <p>亲爱的居民：为响应国家垃圾分类政策，我社区将于下月1日起正式实施垃圾分类制度。请各位居民积极配合，将垃圾分类投放到指定的收集容器中。</p>
                            <a href="${pageContext.request.contextPath}/announcement" class="btn btn-sm btn-outline-success">查看详情</a>
                        </div>
                        <div class="announcement-card">
                            <h3 class="announcement-title">垃圾分类知识宣传</h3>
                            <div class="announcement-date"><i class="far fa-calendar-alt mr-1"></i> 2023-04-10</div>
                            <p>垃圾分类知识宣传活动将于本周六上午9点在社区活动中心举行，欢迎居民参加学习垃圾分类知识。</p>
                            <a href="${pageContext.request.contextPath}/announcement" class="btn btn-sm btn-outline-success">查看详情</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 右侧内容 -->
            <div class="col-lg-4">
                <!-- 用户信息卡片 -->
                <div class="user-card mb-4">
                    <c:if test="${empty sessionScope.user}">
                        <div class="text-center">
                            <i class="fas fa-user-circle fa-4x text-success mb-3"></i>
                            <p>您尚未登录，请先登录系统。</p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-success btn-block mb-2"><i class="fas fa-sign-in-alt mr-2"></i>登录</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-success btn-block"><i class="fas fa-user-plus mr-2"></i>注册</a>
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.user}">
                        <div class="user-welcome">
                            <i class="fas fa-user-circle mr-2"></i>欢迎，${sessionScope.user.username}
                        </div>
                        <div class="user-info">
                            <p><i class="fas fa-user-tag"></i>角色：
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 2}">超级管理员</c:when>
                                    <c:when test="${sessionScope.user.role == 1}">管理员</c:when>
                                    <c:otherwise>普通用户</c:otherwise>
                                </c:choose>
                            </p>
                            <p><i class="fas fa-envelope"></i>邮箱：${sessionScope.user.email}</p>
                            <p><i class="fas fa-phone"></i>手机：${sessionScope.user.phone}</p>
                        </div>
                        <button class="btn btn-outline-danger btn-block" onclick="logout()"><i class="fas fa-sign-out-alt mr-2"></i>退出登录</button>
                        
                        <c:if test="${sessionScope.user.role > 0}">
                            <hr>
                            <h5 class="mb-3"><i class="fas fa-cogs mr-2 text-success"></i>管理功能</h5>
                            <div class="row">
                                <div class="col-6 mb-2">
                                    <a href="${pageContext.request.contextPath}/admin/user" class="btn btn-outline-success btn-block btn-sm"><i class="fas fa-users-cog mr-1"></i>用户管理</a>
                                </div>
                                <div class="col-6 mb-2">
                                    <a href="${pageContext.request.contextPath}/admin/announcement" class="btn btn-outline-success btn-block btn-sm"><i class="fas fa-bullhorn mr-1"></i>公告管理</a>
                                </div>
                                <div class="col-12">
                                    <a href="${pageContext.request.contextPath}/admin/activity" class="btn btn-outline-success btn-block btn-sm"><i class="fas fa-calendar-check mr-1"></i>活动管理</a>
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                </div>
                
                <!-- 最新活动 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-calendar-alt mr-2"></i>最新活动</h5>
                    </div>
                    <div class="card-body">
                        <div class="activity-card">
                            <div class="activity-date">
                                <span class="date-day">15</span>
                                <span class="date-month">四月</span>
                            </div>
                            <div class="activity-content">
                                <h3 class="activity-title">垃圾分类知识讲座</h3>
                                <div class="activity-location">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    社区活动中心
                                </div>
                                <p class="activity-description">本次讲座将邀请环保专家为大家讲解垃圾分类的重要性和具体分类方法。</p>
                                <a href="${pageContext.request.contextPath}/activity" class="btn btn-sm btn-outline-success">查看详情</a>
                            </div>
                        </div>
                        <div class="activity-card">
                            <div class="activity-date">
                                <span class="date-day">22</span>
                                <span class="date-month">四月</span>
                            </div>
                            <div class="activity-content">
                                <h3 class="activity-title">垃圾分类实践活动</h3>
                                <div class="activity-location">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    社区广场
                                </div>
                                <p class="activity-description">本次活动将组织居民实践垃圾分类，通过游戏和互动形式，提高居民垃圾分类意识。</p>
                                <a href="${pageContext.request.contextPath}/activity" class="btn btn-sm btn-outline-success">查看详情</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入页脚 -->
    <jsp:include page="common/footer.jsp" />
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
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
</body>
</html> 