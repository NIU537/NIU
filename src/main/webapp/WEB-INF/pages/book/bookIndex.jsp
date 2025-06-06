<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>图书管理</title>
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

        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe654;</i> 添加</button>
                <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="delete"><i class="layui-icon">&#xe640;</i> 删除</button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="update">修改</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
        </script>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;
        var layer = parent.layer;

        $.get("${pageContext.request.contextPath}/type/findAllList", {}, function (data) {
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
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print'],
            cols: [[
                {type: "checkbox", width: 50},
                {field: 'isbn', width: 120, title: '图书编号', sort: true},
                {field: 'name', width: 150, title: '图书名称'},
                {templet: '<div>{{d.typeInfo.name}}</div>', width: 120, title: '图书类型'},
                {field: 'author', width: 120, title: '作者'},
                {field: 'price', width: 80, title: '价格'},
                {field: 'language', width: 100, title: '语言'},
                {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
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

        table.on('tool(currentTableFilter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'update') {
                var index = layer.open({
                    title: '修改图书信息',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['70%', '85%'],
                    content: '${pageContext.request.contextPath}/queryBookInfoById?id=' + data.id,
                    end: function() {
                        table.reload('testReload');
                    }
                });
            } else if (obj.event === 'delete') {
                layer.confirm('确定要删除这本书吗？', function (index) {
                    deleteInfoByIds(data.id, index);
                    layer.close(index);
                });
            }
        });

        table.on('toolbar(currentTableFilter)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            if (obj.event === 'add') {
                var index = layer.open({
                    title: '添加图书',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['70%', '85%'],
                    content: '${pageContext.request.contextPath}/bookAdd',
                    end: function() {
                        table.reload('testReload');
                    }
                });
            } else if (obj.event === 'delete') {
                var data = checkStatus.data;
                if (data.length === 0) {
                    layer.msg("请至少选择一本书进行删除");
                } else {
                    var ids = data.map(function(item){ return item.id; }).join(",");
                    layer.confirm('确定要删除选中的 ' + data.length + ' 本书吗？', function (index) {
                        deleteInfoByIds(ids, index);
                        layer.close(index);
                    });
                }
            }
        });

        function deleteInfoByIds(ids, index) {
            $.post("deleteBook", {ids: ids}, function (result) {
                if (result.code == 0) {
                    layer.msg('删除成功', {icon: 6, time: 500}, function () {
                        table.reload('testReload');
                        layer.close(index);
                    });
                } else {
                    layer.msg(result.msg || "删除失败");
                }
            });
        }
    });
</script>

</body>
</html>
