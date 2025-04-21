USE waste_classification;

-- 插入初始用户数据(密码均为123456的MD5加密)
INSERT INTO user (username, password, phone, email, role, register_time) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '13800000000', 'admin@example.com', 2, CURRENT_TIMESTAMP),
('manager', 'e10adc3949ba59abbe56e057f20f883e', '13900000000', 'manager@example.com', 1, CURRENT_TIMESTAMP),
('user1', 'e10adc3949ba59abbe56e057f20f883e', '13700000001', 'user1@example.com', 0, CURRENT_TIMESTAMP),
('user2', 'e10adc3949ba59abbe56e057f20f883e', '13700000002', 'user2@example.com', 0, CURRENT_TIMESTAMP);

-- 插入垃圾分类数据
INSERT INTO waste_category (name, description, examples, image1, image2, image3, create_time, update_time) VALUES
('可回收物', '可回收物是指适宜回收和资源利用的废弃物。', '废纸张、废塑料、废玻璃、废金属、废织物等', '/images/recyclable1.jpg', '/images/recyclable2.jpg', '/images/recyclable3.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('厨余垃圾', '厨余垃圾是指居民日常生活及食品加工、饮食服务、单位供餐等活动中产生的垃圾。', '剩菜剩饭、瓜皮果核、花卉绿植、中药药渣等', '/images/food1.jpg', '/images/food2.jpg', '/images/food3.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('有害垃圾', '有害垃圾是指对人体健康或者自然环境造成直接或者潜在危害的废弃物。', '废电池、废荧光灯管、废药品、废油漆桶等', '/images/hazardous1.jpg', '/images/hazardous2.jpg', '/images/hazardous3.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('其他垃圾', '其他垃圾是指除可回收物、厨余垃圾、有害垃圾之外的其他生活废弃物。', '卫生纸巾、烟头、陶瓷碗碟、一次性餐具、破旧衣物等', '/images/other1.jpg', '/images/other2.jpg', '/images/other3.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 插入常见问题数据
INSERT INTO faq (question, answer, create_time, update_time) VALUES
('什么是垃圾分类？', '垃圾分类是指按照垃圾的不同种类、成分和性质，将垃圾分别投放到相应的收集容器中，以便于资源回收利用和后续处理的一种环保行为。', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('为什么要进行垃圾分类？', '垃圾分类可以减少垃圾处理量和处理设备的负荷，降低处理成本；减少土地资源的消耗；减少环境污染；有利于资源的回收利用。', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('废旧电池属于什么垃圾？', '废旧电池属于有害垃圾，应投放到有害垃圾收集容器中。', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('过期药品应该如何处理？', '过期药品属于有害垃圾，应投放到有害垃圾收集容器中。', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('塑料瓶盖是什么垃圾？', '塑料瓶盖属于可回收物，应投放到可回收物收集容器中。', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 插入社区公告数据
INSERT INTO announcement (title, content, publisher_id, publish_time, update_time) VALUES
('社区垃圾分类实施通知', '亲爱的居民：\n为响应国家垃圾分类政策，我社区将于下月1日起正式实施垃圾分类制度。请各位居民积极配合，将垃圾分类投放到指定的收集容器中。\n社区将组织垃圾分类知识讲座，欢迎居民参加。', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('垃圾分类知识宣传', '垃圾分类知识宣传活动将于本周六上午9点在社区活动中心举行，欢迎居民参加学习垃圾分类知识。', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 插入活动信息数据
INSERT INTO activity (title, content, location, start_time, end_time, registration_method, publisher_id, publish_time, update_time) VALUES
('垃圾分类知识讲座', '本次讲座将邀请环保专家为大家讲解垃圾分类的重要性和具体分类方法，欢迎居民踊跃参加。', '社区活动中心', DATEADD(DAY, 7, CURRENT_TIMESTAMP), DATEADD(DAY, 7, DATEADD(HOUR, 2, CURRENT_TIMESTAMP)), '请致电社区办公室（电话：12345678）或扫描海报上的二维码进行报名', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('垃圾分类实践活动', '本次活动将组织居民实践垃圾分类，通过游戏和互动形式，提高居民垃圾分类意识和能力。', '社区广场', DATEADD(DAY, 14, CURRENT_TIMESTAMP), DATEADD(DAY, 14, DATEADD(HOUR, 2, CURRENT_TIMESTAMP)), '活动现场报名参加', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); 