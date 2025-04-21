/**
 * 社区垃圾分类系统公共JavaScript
 */
$(function() {
    // 初始化提示工具
    initTooltips();
    
    // 初始化表单验证
    initFormValidation();
    
    // 初始化消息通知
    initToasts();
    
    // 替换默认警告框
    overrideAlerts();
    
    // 初始化动画效果
    initAnimations();
});

/**
 * 初始化提示工具
 */
function initTooltips() {
    $('[data-toggle="tooltip"]').tooltip();
}

/**
 * 初始化表单验证
 */
function initFormValidation() {
    // 添加自定义表单验证样式
    $('.form-control').on('focus', function() {
        $(this).parent().addClass('focused');
    }).on('blur', function() {
        $(this).parent().removeClass('focused');
        if ($(this).val() !== '') {
            $(this).parent().addClass('has-value');
        } else {
            $(this).parent().removeClass('has-value');
        }
    });
    
    // 已经有值的输入框添加样式
    $('.form-control').each(function() {
        if ($(this).val() !== '') {
            $(this).parent().addClass('has-value');
        }
    });
}

/**
 * 初始化消息通知
 */
function initToasts() {
    // Toast通知容器
    if ($('#toast-container').length === 0) {
        $('body').append('<div id="toast-container" class="toast-container position-fixed bottom-0 end-0 p-3"></div>');
    }
}

/**
 * 显示Toast通知
 * @param {string} message - 消息内容
 * @param {string} type - 消息类型：success, error, warning, info
 */
function showToast(message, type = 'success') {
    // 不同类型的图标和颜色
    const icons = {
        'success': 'fas fa-check-circle',
        'error': 'fas fa-times-circle',
        'warning': 'fas fa-exclamation-circle',
        'info': 'fas fa-info-circle'
    };
    const bgColors = {
        'success': '#39b54a',
        'error': '#dc3545',
        'warning': '#ffc107',
        'info': '#17a2b8'
    };
    
    // 创建Toast元素
    const toastId = 'toast-' + Date.now();
    const toast = `
        <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true" style="background-color: ${bgColors[type]}; color: white;">
            <div class="toast-body d-flex align-items-center">
                <i class="${icons[type]} mr-2" style="font-size: 1.2rem;"></i>
                <span>${message}</span>
                <button type="button" class="ml-auto mb-1 close" data-dismiss="toast" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </div>
    `;
    
    // 添加到容器并显示
    $('#toast-container').append(toast);
    $(`#${toastId}`).toast({
        delay: 3000,
        animation: true
    }).toast('show').on('hidden.bs.toast', function() {
        $(this).remove();
    });
}

/**
 * 替换默认警告框
 */
function overrideAlerts() {
    // 替换默认的alert函数
    window._originalAlert = window.alert;
    window.alert = function(message) {
        showToast(message, 'info');
    };
}

/**
 * 确认对话框
 * @param {string} message - 确认消息
 * @param {Function} confirmCallback - 确认回调
 * @param {Function} cancelCallback - 取消回调
 */
function confirmDialog(message, confirmCallback, cancelCallback) {
    // 创建确认框的Modal
    const modalId = 'confirm-modal-' + Date.now();
    const modal = `
        <div class="modal fade" id="${modalId}" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title" id="confirmModalLabel">确认操作</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary confirm-btn">确认</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // 添加到body
    $('body').append(modal);
    
    // 显示Modal
    const $modal = $(`#${modalId}`);
    $modal.modal('show');
    
    // 确认按钮点击事件
    $modal.find('.confirm-btn').on('click', function() {
        $modal.modal('hide');
        if (typeof confirmCallback === 'function') {
            confirmCallback();
        }
    });
    
    // 取消按钮点击事件（包括关闭按钮和点击背景）
    $modal.on('hidden.bs.modal', function() {
        if (!$modal.hasClass('confirmed') && typeof cancelCallback === 'function') {
            cancelCallback();
        }
        // 移除Modal
        $modal.remove();
    });
}

/**
 * 初始化动画效果
 */
function initAnimations() {
    // 为带有.animate-on-scroll类的元素添加滚动动画
    const animateElements = document.querySelectorAll('.animate-on-scroll');
    
    if (animateElements.length > 0) {
        // 检查元素是否在视口内
        const isInViewport = function(element) {
            const rect = element.getBoundingClientRect();
            return (
                rect.top >= 0 &&
                rect.left >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
                rect.right <= (window.innerWidth || document.documentElement.clientWidth)
            );
        };
        
        // 检查所有元素
        const checkElements = function() {
            animateElements.forEach(function(element) {
                if (isInViewport(element) && !element.classList.contains('animated')) {
                    element.classList.add('animated');
                }
            });
        };
        
        // 初始检查和滚动时检查
        checkElements();
        window.addEventListener('scroll', checkElements);
    }
}

/**
 * 显示加载动画
 * @param {string} message - 加载消息
 */
function showLoading(message = '加载中...') {
    // 创建loading覆盖层
    if ($('#loading-overlay').length === 0) {
        const loading = `
            <div id="loading-overlay" class="position-fixed w-100 h-100" style="top: 0; left: 0; background-color: rgba(255,255,255,0.8); z-index: 9999; display: flex; align-items: center; justify-content: center; flex-direction: column;">
                <div class="spinner mb-3"></div>
                <p id="loading-message" class="text-center">${message}</p>
            </div>
        `;
        $('body').append(loading);
    } else {
        $('#loading-message').text(message);
        $('#loading-overlay').show();
    }
}

/**
 * 隐藏加载动画
 */
function hideLoading() {
    $('#loading-overlay').hide();
}

/**
 * 数字动画效果
 * @param {string} selector - 元素选择器
 * @param {number} targetValue - 目标数值
 * @param {number} duration - 动画时长（毫秒）
 */
function animateNumber(selector, targetValue, duration = 1000) {
    const $element = $(selector);
    const startValue = parseInt($element.text().replace(/,/g, '')) || 0;
    const startTime = Date.now();
    
    function updateNumber() {
        const currentTime = Date.now();
        const elapsed = currentTime - startTime;
        
        if (elapsed < duration) {
            const progress = elapsed / duration;
            const currentValue = Math.floor(startValue + (targetValue - startValue) * progress);
            $element.text(currentValue.toLocaleString());
            requestAnimationFrame(updateNumber);
        } else {
            $element.text(targetValue.toLocaleString());
        }
    }
    
    updateNumber();
} 