<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>常见问题 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 20px;
        }
        .faq-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        .page-title {
            color: #28a745;
            margin-bottom: 30px;
            text-align: center;
        }
        .back-btn {
            margin-bottom: 20px;
        }
        .card {
            margin-bottom: 15px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: none;
            cursor: pointer;
        }
        .card-header:hover {
            background-color: #e9f7ef;
        }
        .card-header h5 {
            margin-bottom: 0;
            color: #28a745;
            font-weight: 600;
        }
        .card-body {
            background-color: #ffffff;
            padding: 20px;
        }
        .card-body p {
            color: #666;
            margin-bottom: 0;
        }
        .search-container {
            margin-bottom: 30px;
        }
        .search-input {
            border-radius: 20px;
            padding-left: 15px;
        }
        .search-btn {
            border-radius: 20px;
        }
    </style>
</head>
<body>
    <div class="container faq-container">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary back-btn">
            <i class="fa fa-arrow-left"></i> 返回首页
        </a>
        
        <h1 class="page-title">常见问题</h1>
        
        <div class="search-container">
            <div class="input-group">
                <input type="text" class="form-control search-input" id="searchInput" placeholder="输入关键词搜索问题...">
                <div class="input-group-append">
                    <button class="btn btn-success search-btn" type="button" onclick="searchFaqs()">
                        <i class="fa fa-search"></i> 搜索
                    </button>
                </div>
            </div>
        </div>
        
        <div id="accordion">
            <!-- FAQ列表将通过AJAX加载 -->
        </div>
    </div>
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.bootcss.com/font-awesome/5.15.1/js/all.min.js"></script>
    <script>
        $(function() {
            // 页面加载时获取FAQ数据
            loadFaqs();
            
            // 搜索框回车触发搜索
            $("#searchInput").keypress(function(e) {
                if (e.which === 13) {
                    searchFaqs();
                }
            });
        });
        
        // 加载FAQ列表
        function loadFaqs() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/faq/list",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        var faqs = res.data;
                        var html = '';
                        
                        // 遍历FAQ数据
                        $.each(faqs, function(index, faq) {
                            html += '<div class="card">';
                            html += '  <div class="card-header" id="heading' + faq.id + '" data-toggle="collapse" data-target="#collapse' + faq.id + '" aria-expanded="' + (index === 0 ? 'true' : 'false') + '" aria-controls="collapse' + faq.id + '">';
                            html += '    <h5><i class="fa fa-question-circle text-success mr-2"></i> ' + faq.question + '</h5>';
                            html += '  </div>';
                            
                            html += '  <div id="collapse' + faq.id + '" class="collapse ' + (index === 0 ? 'show' : '') + '" aria-labelledby="heading' + faq.id + '" data-parent="#accordion">';
                            html += '    <div class="card-body">';
                            html += '      <p>' + faq.answer + '</p>';
                            html += '    </div>';
                            html += '  </div>';
                            html += '</div>';
                        });
                        
                        $("#accordion").html(html);
                    } else {
                        alert(res.message || "获取常见问题数据失败");
                    }
                },
                error: function() {
                    alert("系统错误，请稍后再试");
                }
            });
        }
        
        // 搜索FAQ
        function searchFaqs() {
            var keyword = $("#searchInput").val().toLowerCase();
            
            // 如果关键词为空，显示所有内容
            if (!keyword) {
                $(".card").show();
                return;
            }
            
            // 遍历所有FAQ项，根据关键词过滤
            $(".card").each(function() {
                var question = $(this).find(".card-header h5").text().toLowerCase();
                var answer = $(this).find(".card-body p").text().toLowerCase();
                
                if (question.indexOf(keyword) > -1 || answer.indexOf(keyword) > -1) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }
    </script>
</body>
</html> 