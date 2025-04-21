<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 页脚 -->
<footer class="bg-white py-4 mt-5 border-top shadow-sm">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <h5 class="text-success">社区垃圾分类系统</h5>
                <p class="text-muted">致力于提高社区居民垃圾分类意识，打造绿色环保的社区环境。</p>
                <div class="d-flex">
                    <a href="#" class="text-secondary mr-3"><i class="fab fa-weixin fa-lg"></i></a>
                    <a href="#" class="text-secondary mr-3"><i class="fab fa-weibo fa-lg"></i></a>
                    <a href="#" class="text-secondary"><i class="fas fa-envelope fa-lg"></i></a>
                </div>
            </div>
            <div class="col-md-4 mb-4 mb-md-0">
                <h5 class="text-success">快速链接</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/guide" class="text-secondary"><i class="fas fa-angle-right mr-2"></i>垃圾分类指南</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq" class="text-secondary"><i class="fas fa-angle-right mr-2"></i>常见问题</a></li>
                    <li><a href="${pageContext.request.contextPath}/activity" class="text-secondary"><i class="fas fa-angle-right mr-2"></i>社区活动</a></li>
                    <li><a href="${pageContext.request.contextPath}/statistics" class="text-secondary"><i class="fas fa-angle-right mr-2"></i>数据统计</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="text-success">联系我们</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><i class="fas fa-map-marker-alt mr-2 text-secondary"></i> 上海市浦东新区XXX路XX号</li>
                    <li class="mb-2"><i class="fas fa-phone mr-2 text-secondary"></i> 021-XXXXXXXX</li>
                    <li class="mb-2"><i class="fas fa-envelope mr-2 text-secondary"></i> contact@waste-community.com</li>
                </ul>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-12 text-center">
                <p class="mb-0 text-muted">© 2023 社区垃圾分类系统 版权所有</p>
            </div>
        </div>
    </div>
</footer>

<!-- 回到顶部按钮 -->
<button id="backToTop" class="btn btn-success btn-sm rounded-circle position-fixed" style="bottom: 20px; right: 20px; display: none; width: 40px; height: 40px; z-index: 1000;">
    <i class="fas fa-arrow-up"></i>
</button>

<script>
    // 回到顶部按钮
    $(window).scroll(function() {
        if ($(this).scrollTop() > 300) {
            $('#backToTop').fadeIn();
        } else {
            $('#backToTop').fadeOut();
        }
    });
    
    $('#backToTop').click(function() {
        $('html, body').animate({scrollTop: 0}, 800);
        return false;
    });
</script> 