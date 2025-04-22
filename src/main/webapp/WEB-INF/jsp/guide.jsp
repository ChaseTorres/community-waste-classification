<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>垃圾分类指南 - 社区垃圾分类系统</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 20px;
        }
        .guide-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .page-title {
            color: #28a745;
            margin-bottom: 30px;
            text-align: center;
        }
        .category-card {
            margin-bottom: 30px;
            border: none;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .category-card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .recyclable {
            background-color: #007bff;
            color: white;
        }
        .hazardous {
            background-color: #dc3545;
            color: white;
        }
        .food {
            background-color: #28a745;
            color: white;
        }
        .other {
            background-color: #6c757d;
            color: white;
        }
        .card-body {
            padding: 20px;
        }
        .examples {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
        }
        .examples-title {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .category-images {
            display: flex;
            margin-top: 15px;
        }
        .category-image {
            width: 32%;
            margin-right: 2%;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .back-btn {
            margin-bottom: 20px;
        }
        .search-container {
            max-width: 600px;
            margin: 0 auto 30px;
        }
    </style>
</head>
<body>
    <div class="container guide-container">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary back-btn">
            <i class="fa fa-arrow-left"></i> 返回首页
        </a>
        
        <h1 class="page-title">垃圾分类指南</h1>
        
        <!-- 搜索框 -->
        <div class="search-container mb-4">
            <div class="input-group">
                <input type="text" class="form-control" id="searchInput" placeholder="输入垃圾名称、描述关键词搜索...">
                <div class="input-group-append">
                    <button class="btn btn-success" type="button" onclick="searchCategories()">
                        <i class="fa fa-search"></i> 搜索
                    </button>
                </div>
            </div>
        </div>
        
        <div class="row" id="categoryList">
            <!-- 垃圾分类列表将通过AJAX加载 -->
        </div>
    </div>
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.bootcss.com/font-awesome/5.15.1/js/all.min.js"></script>
    <script>
        $(function() {
            // 页面加载时获取垃圾分类数据
            loadCategories();
        });
        
        // 搜索垃圾分类
        function searchCategories() {
            var keyword = $("#searchInput").val();
            if (!keyword) {
                loadCategories(); // 如果关键词为空，加载所有分类
                return;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/waste/search",
                type: "GET",
                data: { keyword: keyword },
                success: function(res) {
                    if (res.code === 200) {
                        renderCategories(res.data);
                    } else {
                        alert(res.message || "搜索失败");
                    }
                },
                error: function() {
                    alert("系统错误，请稍后再试");
                }
            });
        }
        
        // 监听搜索框回车事件
        $("#searchInput").keypress(function(e) {
            if (e.which === 13) {
                searchCategories();
            }
        });
        
        // 重构加载分类函数，提取渲染逻辑
        function loadCategories() {
            $.ajax({
                url: "${pageContext.request.contextPath}/api/waste/list",
                type: "GET",
                success: function(res) {
                    if (res.code === 200) {
                        renderCategories(res.data);
                    } else {
                        alert(res.message || "获取垃圾分类数据失败");
                    }
                },
                error: function() {
                    alert("系统错误，请稍后再试");
                }
            });
        }
        
        // 渲染分类列表
        function renderCategories(categories) {
            var html = '';
            
            if (categories.length === 0) {
                html = '<div class="col-12"><div class="alert alert-info">未找到相关垃圾分类信息</div></div>';
            } else {
                $.each(categories, function(index, category) {
                    var cardClass = '';
                    switch(index % 4) {
                        case 0: cardClass = 'recyclable'; break;
                        case 1: cardClass = 'food'; break;
                        case 2: cardClass = 'hazardous'; break;
                        case 3: cardClass = 'other'; break;
                    }
                    
                    html += '<div class="col-md-6">';
                    html += '  <div class="card category-card">';
                    html += '    <div class="card-header ' + cardClass + '">' + category.name + '</div>';
                    html += '    <div class="card-body">';
                    html += '      <p>' + (category.description || '暂无描述') + '</p>';
                    
                    if (category.examples) {
                        html += '      <div class="examples">';
                        html += '        <div class="examples-title">常见示例：</div>';
                        html += '        <p>' + category.examples + '</p>';
                        html += '      </div>';
                    }
                    
                    html += '      <div class="category-images">';
                    if (category.image1) {
                        html += '        <img src="${pageContext.request.contextPath}/static/images/' + category.name + '-示例图片1.png" class="category-image" alt="' + category.name + '-示例图片1">';
                    }
                    if (category.image2) {
                        html += '        <img src="${pageContext.request.contextPath}/static/images/' + category.name + '-示例图片2.png" class="category-image" alt="' + category.name + '-示例图片2">';
                    }
                    if (category.image3) {
                        html += '        <img src="${pageContext.request.contextPath}/static/images/' + category.name + '-示例图片3.png" class="category-image" alt="' + category.name + '-示例图片3">';
                    }
                    html += '      </div>';
                    
                    html += '    </div>';
                    html += '  </div>';
                    html += '</div>';
                });
            }
            
            $("#categoryList").html(html);
        }
    </script>
</body>
</html> 