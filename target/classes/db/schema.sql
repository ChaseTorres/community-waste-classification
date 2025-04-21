CREATE DATABASE IF NOT EXISTS waste_classification DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE waste_classification;

-- 用户表
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(32) NOT NULL COMMENT '密码（MD5加密）',
    phone VARCHAR(11) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    role INT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员，2-超级管理员',
    register_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    last_login_time TIMESTAMP COMMENT '最后登录时间',
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_phone (phone)
) COMMENT '用户表';

-- 垃圾分类表
DROP TABLE IF EXISTS waste_category;
CREATE TABLE waste_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description TEXT COMMENT '分类描述',
    examples TEXT COMMENT '常见示例',
    image1 VARCHAR(255) COMMENT '图片1',
    image2 VARCHAR(255) COMMENT '图片2',
    image3 VARCHAR(255) COMMENT '图片3',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '垃圾分类表';

-- 常见问题表
DROP TABLE IF EXISTS faq;
CREATE TABLE faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(200) NOT NULL COMMENT '问题',
    answer TEXT NOT NULL COMMENT '回答',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '常见问题表';

-- 垃圾投放记录表
DROP TABLE IF EXISTS disposal_record;
CREATE TABLE disposal_record (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '用户ID',
    category_id INT NOT NULL COMMENT '垃圾分类ID',
    disposal_time TIMESTAMP NOT NULL COMMENT '投放时间',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (category_id) REFERENCES waste_category(id)
) COMMENT '垃圾投放记录表';

-- 社区公告表
DROP TABLE IF EXISTS announcement;
CREATE TABLE announcement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    publisher_id INT NOT NULL COMMENT '发布者ID',
    publish_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (publisher_id) REFERENCES user(id)
) COMMENT '社区公告表';

-- 活动信息表
DROP TABLE IF EXISTS activity;
CREATE TABLE activity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL COMMENT '活动标题',
    content TEXT NOT NULL COMMENT '活动内容',
    location VARCHAR(200) COMMENT '活动地点',
    start_time TIMESTAMP NOT NULL COMMENT '开始时间',
    end_time TIMESTAMP NOT NULL COMMENT '结束时间',
    registration_method VARCHAR(200) COMMENT '报名方式',
    publisher_id INT NOT NULL COMMENT '发布者ID',
    publish_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (publisher_id) REFERENCES user(id)
) COMMENT '活动信息表'; 