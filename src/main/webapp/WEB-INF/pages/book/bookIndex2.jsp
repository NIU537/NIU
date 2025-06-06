<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>图书查询</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/font-awesome-4.7.0/css/font-awesome.min.css" media="all">
    <style>
        html, body {
            height: 100%;
        }
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Helvetica, Arial, sans-serif;
            color: #212529;
            margin: 0;
        }
        .layuimini-main {
            box-sizing: border-box;
            height: 100%;
            padding: 20px;
        }
        .page-container {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
            height: 100%;
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
        }
        .search-area {
            margin-bottom: 20px;
            flex-shrink: 0;
        }
        .layui-form-item .layui-inline {
            margin-right: 15px;
            margin-bottom: 10px;
        }
        .layui-input, .layui-select {
            border-radius: 6px;
        }
        .layui-btn {
            border-radius: 6px;
        }
        .layui-table-view {
            border-radius: 8px;
            border: 1px solid #e2e2e2;
            flex-grow: 1;
        }
    </style>
</head>
<body>
<div class="layuimini-main">
    <div class="page-container">
        <div class="search-area">
            <form class="layui-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">图书编号</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="isbn" id="isbn" autocomplete="off" placeholder="请输入图书编号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">书名</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="name" id="name" autocomplete="off" placeholder="请输入书名">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">图书分类</label>
                        <div class="layui-input-inline">
                            <select id="typeId" name="typeId" lay-filter="typeId">
                                <option value="">所有分类</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn" lay-submit lay-filter="data-search-btn"><i class="layui-icon">&#xe615;</i> 搜索</button>
                    </div>
                </div>
            </form>
        </div>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;

        $.get("${pageContext.request.contextPath}/findAllList", {}, function (data) {
            var list = data;
            var select = $("#typeId");
            if (list != null || list.length > 0) {
                for (var i in list) {
                    select.append($("<option>", {value: list[i].id, text: list[i].name}));
                }
            }
            form.render('select');
        }, "json");

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/bookAll',
            defaultToolbar: ['filter', 'print'],
            cols: [[
                {type: "numbers", width: 50, title: '序号'},
                {field: 'isbn', width: 120, title: '图书编号', sort: true},
                {field: 'name', width: 150, title: '图书名称'},
                {templet: '<div>{{d.typeInfo.name}}</div>', width: 120, title: '图书类型'},
                {field: 'author', width: 120, title: '作者'},
                {field: 'price', width: 80, title: '价格'},
                {field: 'language', width: 100, title: '语言'},
                {title: '状态', width: 100, templet: function(d) {
                    return d.status === 0 ? '<span class="layui-badge layui-bg-green">在馆</span>' : '<span class="layui-badge layui-bg-red">已借出</span>';
                }}
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,
            page: true,
            skin: 'line',
            id: 'testReload'
        });

        form.on('submit(data-search-btn)', function (data) {
            var result = data.field;
            table.reload('testReload', {
                page: {curr: 1},
                where: {
                    name: result.name,
                    isbn: result.isbn,
                    typeId: result.typeId
                }
            }, 'data');
            return false;
        });

    });
</script>

</body>
</html> 