# 社区垃圾分类系统

## 项目介绍
社区垃圾分类系统是一个基于Java Web技术开发的垃圾分类管理平台，旨在提高社区居民的垃圾分类意识，促进垃圾分类工作的有效开展。

## 技术栈
- 前端：JSP、Bootstrap、jQuery、CSS
- 后端：Spring Boot、MyBatis
- 数据库：MySQL
- 日志管理：Logback
- 连接池：HikariCP

## 功能模块
1. **用户注册与登录**：支持用户注册和账号/手机号登录
2. **垃圾分类指南**：提供垃圾分类知识和查询功能
3. **垃圾投放记录**：记录居民的垃圾投放情况
4. **垃圾处理记录**：跟踪垃圾处理的全过程
5. **社区公告**：发布社区垃圾分类相关的通知和活动
6. **活动管理**：组织和发布社区垃圾分类活动
7. **问答中心**：常见问题解答和知识库
8. **数据统计与可视化**：统计垃圾分类参与情况和效果，提供图表展示
9. **报表导出**：支持将统计数据导出为Excel格式
10. **文件上传**：支持图片和文档上传功能
11. **管理员功能**：用户管理、公告和活动管理等

## 环境要求
- JDK 1.8+
- Maven 3.6+
- MySQL 5.7+
- 至少2G内存的服务器环境

## 安装步骤
1. 克隆或下载项目代码
2. 创建MySQL数据库并导入初始数据
   ```sql
   source /path/to/schema.sql
   source /path/to/data.sql
   ```
3. 修改`application.properties`中的数据库连接配置
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/waste_classification?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
   spring.datasource.username=root
   spring.datasource.password=P@ssw0rd
   ```
4. 在项目根目录执行Maven命令打包
   ```bash
   mvn clean package
   ```
5. 运行生成的JAR文件
   ```bash
   java -jar target/waste-classification-0.0.1-SNAPSHOT.jar
   ```
   或使用提供的启动脚本
   ```bash
   ./start.sh
   ```
6. 访问系统：http://localhost:8080/waste

## 默认账号
- 超级管理员：admin / 123456
- 管理员：manager / 123456
- 普通用户：user1 / 123456，user2 / 123456

## 系统配置
系统的主要配置位于`application.properties`文件中，包括：
- 服务器端口和上下文路径配置
- 数据库连接参数
- 连接池优化参数
- 日志级别和格式配置
- 文件上传大小限制（最大10MB）
- 静态资源路径配置

## 停止服务
使用提供的停止脚本即可安全关闭服务：
```bash
./stop.sh
```

## 开发者
- 社区垃圾分类管理团队 

## 页面美化指南

项目已经添加了美化样式和交互效果，以下是使用指南：

### 1. 引入公共样式和脚本

在每个JSP页面的头部添加以下代码：

```html
<link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/5.15.1/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
```

在每个JSP页面的底部脚本区域添加：

```html
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
```

### 2. 使用公共组件

引入导航栏和页脚：

```html
<!-- 引入页眉 -->
<jsp:include page="common/header.jsp" />

<!-- 页面内容 -->
<div class="container">
    <!-- 你的内容 -->
</div>

<!-- 引入页脚 -->
<jsp:include page="common/footer.jsp" />
```

### 3. 使用增强的交互组件

- 使用Toast通知替代alert：`showToast("操作成功", "success")`
- 使用确认对话框：`confirmDialog("确定删除？", function() { /* 确认后的代码 */ })`
- 使用加载动画：`showLoading("加载中...")` 和 `hideLoading()`
- 使用数字动画：`animateNumber("#counter", 100, 1000)`
- 使用滚动动画：为元素添加`animate-on-scroll`类

### 4. 应用统一的样式变量

CSS变量已在common.css中定义，可直接使用：

- 主色调：`var(--primary-color)`
- 次要色调：`var(--secondary-color)`
- 文本颜色：`var(--text-dark)`, `var(--text-light)`
- 阴影效果：`var(--shadow-sm)`, `var(--shadow-md)`, `var(--shadow-lg)`
- 过渡效果：`var(--transition-speed)`
- 圆角：`var(--border-radius)`

### 5. 页面元素样式

已美化的元素包括：
- 卡片容器：`.card`
- 按钮：`.btn`, `.btn-success`, `.btn-outline-success`
- 表单元素：`.form-control`
- 表格：`.table`
- 提示框：`.alert`

### 6. 响应式设计

所有页面都已适配移动设备，使用Bootstrap的网格系统和媒体查询实现。 