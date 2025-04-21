<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 50px;
        }
        .register-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .register-title {
            text-align: center;
            margin-bottom: 20px;
            color: #28a745;
        }
        .register-form {
            margin-top: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .register-links {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <h3 class="register-title">社区垃圾分类系统 - 用户注册</h3>
            <form class="register-form" id="registerForm">
                <div class="form-group">
                    <label for="username">用户名 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                    <small class="form-text text-muted">用户名长度为3-20个字符</small>
                </div>
                <div class="form-group">
                    <label for="password">密码 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                    <small class="form-text text-muted">密码长度为6-20个字符</small>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">确认密码 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
                </div>
                <div class="form-group">
                    <label for="phone">手机号</label>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入手机号">
                    <small class="form-text text-muted">手机号用于找回密码</small>
                </div>
                <div class="form-group">
                    <label for="email">邮箱</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱">
                </div>
                <button type="button" class="btn btn-success btn-block" onclick="register()">注册</button>
            </form>
            <div class="register-links">
                <a href="${pageContext.request.contextPath}/login">已有账号？立即登录</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script>
        function register() {
            // 表单验证
            var username = $("#username").val();
            var password = $("#password").val();
            var confirmPassword = $("#confirmPassword").val();
            var phone = $("#phone").val();
            var email = $("#email").val();
            
            if (!username) {
                alert("请输入用户名");
                return;
            }
            if (username.length < 3 || username.length > 20) {
                alert("用户名长度应为3-20个字符");
                return;
            }
            if (!password) {
                alert("请输入密码");
                return;
            }
            if (password.length < 6 || password.length > 20) {
                alert("密码长度应为6-20个字符");
                return;
            }
            if (password !== confirmPassword) {
                alert("两次输入的密码不一致");
                return;
            }
            
            // 发送注册请求
            $.ajax({
                url: "${pageContext.request.contextPath}/api/user/register",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    username: username,
                    password: password,
                    phone: phone,
                    email: email
                }),
                success: function(res) {
                    if (res.code === 200) {
                        alert("注册成功，请登录");
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