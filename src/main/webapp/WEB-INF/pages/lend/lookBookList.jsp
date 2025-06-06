<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>我的借阅</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <style>
        body {
            background-color: #f2f2f2;
            font-family: 'SF Pro Text', 'Myriad Set Pro', 'SF Pro Icons', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
        }

        .page-container {
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #e8e8e8;
            margin-bottom: 20px;
        }

        .header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }
        
        .book-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .book-card {
            background-color: #fff;
            border: 1px solid #e8e8e8;
            border-radius: 8px;
            padding: 15px;
            transition: box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .book-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .book-card .book-title {
            font-size: 18px;
            font-weight: 600;
            color: #007aff; /* Apple's blue accent color */
            margin-bottom: 10px;
        }
        
        .book-card .book-details p {
            font-size: 14px;
            color: #555;
            margin: 5px 0;
        }

        .book-card .book-details .status {
            font-weight: 600;
        }

        .status-returned {
            color: #34c759; /* Apple's green */
        }

        .status-borrowed {
            color: #ff3b30; /* Apple's red */
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #888;
        }
        
        .empty-state .icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

    </style>
</head>
<body>
<div class="layuimini-main">
    <div class="page-container">
        <div class="header">
            <h2>我的借阅记录</h2>
        </div>

        <c:if test="${empty info}">
            <div class="empty-state">
                <i class="layui-icon layui-icon-file-b icon"></i>
                <p>您还没有借阅任何书籍。</p>
            </div>
        </c:if>

        <div class="book-list">
            <c:forEach var="lend" items="${info}">
                <div class="book-card">
                    <div>
                        <div class="book-title"><<${lend.bookInfo.name}>></div>
                        <div class="book-details">
                            <p><strong>借阅人:</strong> ${lend.readerInfo.realName}</p>
                            <p><strong>借阅日期:</strong> <fmt:formatDate value="${lend.lendDate}" pattern="yyyy-MM-dd HH:mm"/></p>
                        </div>
                    </div>
                    <div class="book-details">
                        <c:if test="${lend.backDate == null}">
                            <p class="status status-borrowed">状态: 未归还</p>
                        </c:if>
                        <c:if test="${lend.backDate != null}">
                            <p class="status status-returned">状态: 已归还</p>
                            <p><strong>归还日期:</strong> <fmt:formatDate value="${lend.backDate}" pattern="yyyy-MM-dd HH:mm"/></p>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
</body>
</html>
