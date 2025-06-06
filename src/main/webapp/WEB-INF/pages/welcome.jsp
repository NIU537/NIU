<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/font-awesome-4.7.0/css/font-awesome.min.css" media="all">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Helvetica, Arial, sans-serif;
            color: #212529;
            padding: 40px;
        }
        .welcome-container {
            max-width: 960px;
            margin: 0 auto;
        }
        .welcome-header {
            text-align: center;
            margin-bottom: 60px;
        }
        .welcome-header h1 {
            font-size: 3.5rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #1d1d1f;
        }
        .welcome-header p {
            font-size: 1.25rem;
            color: #6c757d;
            margin-top: 15px;
        }
        .notice-card {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
        }
        .notice-card-header {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }
        .notice-card-header .fa {
            color: #1E9FFF;
            margin-right: 15px;
        }
        .notice-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
            cursor: pointer;
            transition: background-color 0.2s ease-in-out;
        }
        .notice-item:last-child {
            border-bottom: none;
        }
        .notice-item:hover {
            background-color: #f8f9fa;
        }
        .notice-title {
            font-size: 1rem;
            color: #343a40;
        }
        .notice-date {
            font-size: 0.9rem;
            color: #6c757d;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<div class="layuimini-main">
    <div class="welcome-container">
        <div class="welcome-header">
            <h1>欢迎回来, ${sessionScope.user.username}</h1>
            <p>"书籍是人类进步的阶梯。" — 高尔基</p>
        </div>

        <div class="notice-card">
            <div class="notice-card-header">
                <i class="fa fa-bullhorn"></i>系统公告
            </div>
            <div class="notice-list">
                <c:forEach var="notice" items="${noticeList}">
                    <div class="notice-item">
                        <div class="notice-title">${notice.topic}</div>
                        <div class="notice-date"><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd" /></div>
                        <div class="layui-hide notice-content">${notice.content}</div>
                        <div class="layui-hide notice-time"><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['layer'], function () {
        var $ = layui.jquery,
            layer = layui.layer;

        $('.notice-item').on('click', function () {
            var title = $(this).find('.notice-title').text(),
                content = $(this).find('.notice-content').html(),
                noticeTime = $(this).find('.notice-time').text();

            parent.layer.open({
                type: 1,
                title: title,
                area: ['500px', '400px'],
                shade: 0.8,
                id: 'notice-popup',
                btn: ['关闭'],
                moveType: 1,
                content: '<div style="padding: 20px; line-height: 1.8;">' + content + '<div style="text-align: right; color: #999; margin-top: 20px;">发布于: ' + noticeTime + '</div></div>'
            });
        });
    });
</script>
</body>
</html>

