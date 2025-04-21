<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>社区垃圾分类系统 - 登录</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f6e9 0%, #d1f5d3 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 0;
        }
        
        .login-container {
            max-width: 450px;
            width: 100%;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }
        
        .login-header {
            background-color: var(--primary-color);
            color: white;
            padding: 25px 30px;
            text-align: center;
            border-radius: var(--border-radius) var(--border-radius) 0 0;
        }
        
        .login-title {
            margin-bottom: 0;
            font-weight: 600;
            font-size: 1.5rem;
        }
        
        .login-form-container {
            padding: 30px;
        }
        
        .nav-tabs {
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 25px;
        }
        
        .nav-tabs .nav-item {
            margin-bottom: -2px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: var(--text-light);
            font-weight: 500;
            padding: 10px 15px;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
        }
        
        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-group label {
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 30px;
            padding: 12px 20px;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            font-size: 1rem;
        }
        
        .form-control:focus {
            background-color: white;
        }
        
        .input-icon {
            position: absolute;
            top: 43px;
            left: 15px;
            color: var(--text-light);
        }
        
        .input-with-icon {
            padding-left: 45px;
        }
        
        .login-btn {
            margin-top: 15px;
            border-radius: 30px;
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            letter-spacing: 1px;
            box-shadow: 0 5px 15px rgba(57, 181, 74, 0.2);
        }
        
        .login-links {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .login-links a {
            color: var(--primary-color);
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .login-links a:hover {
            color: var(--primary-dark);
            text-decoration: none;
        }
        
        .btn-back {
            position: absolute;
            top: 20px;
            left: 20px;
            color: var(--text-dark);
            background-color: white;
            box-shadow: var(--shadow-sm);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="btn-back">
        <i class="fas fa-arrow-left"></i>
    </a>
    
    <div class="login-container">
        <div class="login-header">
            <div class="mb-3">
                <i class="fas fa-recycle fa-3x"></i>
            </div>
            <h3 class="login-title">欢迎登录社区垃圾分类系统</h3>
        </div>
        
        <div class="login-form-container">
            <ul class="nav nav-tabs" id="loginTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="username-tab" data-toggle="tab" href="#username-login" role="tab">
                        <i class="fas fa-user mr-2"></i>账号密码登录
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="phone-tab" data-toggle="tab" href="#phone-login" role="tab">
                        <i class="fas fa-mobile-alt mr-2"></i>手机密码登录
                    </a>
                </li>
            </ul>
            
            <div class="tab-content" id="loginTabContent">
                <!-- 账号密码登录 -->
                <div class="tab-pane fade show active" id="username-login" role="tabpanel">
                    <form class="login-form" id="usernameLoginForm">
                        <div class="form-group">
                            <label for="username">用户名</label>
                            <input type="text" class="form-control input-with-icon" id="username" name="username" placeholder="请输入用户名" required>
                            <i class="fas fa-user input-icon"></i>
                        </div>
                        <div class="form-group">
                            <label for="password">密码</label>
                            <input type="password" class="form-control input-with-icon" id="password" name="password" placeholder="请输入密码" required>
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                        <button type="button" class="btn btn-success btn-block login-btn" onclick="loginByUsername()">
                            <i class="fas fa-sign-in-alt mr-2"></i>登录
                        </button>
                    </form>
                </div>
                
                <!-- 手机密码登录 -->
                <div class="tab-pane fade" id="phone-login" role="tabpanel">
                    <form class="login-form" id="phoneLoginForm">
                        <div class="form-group">
                            <label for="phone">手机号</label>
                            <input type="text" class="form-control input-with-icon" id="phone" name="phone" placeholder="请输入手机号" required>
                            <i class="fas fa-mobile-alt input-icon"></i>
                        </div>
                        <div class="form-group">
                            <label for="phonePassword">密码</label>
                            <input type="password" class="form-control input-with-icon" id="phonePassword" name="phonePassword" placeholder="请输入密码" required>
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                        <button type="button" class="btn btn-success btn-block login-btn" onclick="loginByPhone()">
                            <i class="fas fa-sign-in-alt mr-2"></i>登录
                        </button>
                    </form>
                </div>
            </div>
            
            <div class="login-links">
                <a href="${pageContext.request.contextPath}/register">
                    <i class="fas fa-user-plus mr-1"></i>没有账号？立即注册
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script>
        // 账号密码登录
        function loginByUsername() {
            var username = $("#username").val();
            var password = $("#password").val();
            
            if (!username) {
                alert("请输入用户名");
                return;
            }
            if (!password) {
                alert("请输入密码");
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/user/login/username",
                type: "POST",
                data: {
                    username: username,
                    password: password
                },
                success: function(res) {
                    if (res.code === 200) {
                        alert("登录成功");
                        window.location.href = "${pageContext.request.contextPath}/index";
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("系统错误，请稍后再试");
                }
            });
        }
        
        // 手机密码登录
        function loginByPhone() {
            var phone = $("#phone").val();
            var password = $("#phonePassword").val();
            
            if (!phone) {
                alert("请输入手机号");
                return;
            }
            if (!password) {
                alert("请输入密码");
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/user/login/phone",
                type: "POST",
                data: {
                    phone: phone,
                    password: password
                },
                success: function(res) {
                    if (res.code === 200) {
                        alert("登录成功");
                        window.location.href = "${pageContext.request.contextPath}/index";
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