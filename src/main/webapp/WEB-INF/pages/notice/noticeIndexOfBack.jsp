<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>公告管理</title>
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
                        <label class="layui-form-label">公告主题</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="topic" id="topic" autocomplete="off" placeholder="请输入公告主题">
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
                <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe654;</i> 发布公告</button>
                <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="delete"><i class="layui-icon">&#xe640;</i> 删除</button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="query">查看详情</a>
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

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/noticeAll',
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print'],
            cols: [[
                {type: "checkbox", width: 50},
                {field: 'topic', width: 200, title: '公告主题'},
                {field: 'content', title: '公告内容', width: 300},
                {field: 'author', width: 120, title: '发布者'},
                {templet:"<div>{{layui.util.toDateString(d.createDate,'yyyy-MM-dd HH:mm:ss')}}</div>", title: '发布时间'},
                {title: '操作', minWidth: 180, toolbar: '#currentTableBar', align: "center"}
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
                    topic: result.topic
                }
            }, 'data');
            return false;
        });

        table.on('tool(currentTableFilter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'query') {
                layer.open({
                    type: 1,
                    title: '公告详情',
                    area: ['700px', 'auto'],
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    content: '<div style="padding: 20px; line-height: 1.8; font-size: 14px; word-wrap: break-word;">' +
                             '<h3 style="text-align: center; margin-bottom: 15px;">' + data.topic + '</h3>' +
                             '<p style="text-align: center; color: #999; font-size: 12px; margin-bottom: 20px;">' +
                             '<span>发布者: ' + data.author + '</span>' +
                             '<span style="margin-left: 20px;">发布时间: ' + layui.util.toDateString(data.createDate, 'yyyy-MM-dd HH:mm:ss') + '</span>' +
                             '</p>' +
                             '<hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;">' +
                             '<div style="text-indent: 2em;">' + data.content + '</div>' +
                             '</div>'
                });
            } else if (obj.event === 'delete') {
                layer.confirm('确定要删除此公告吗？', function (index) {
                    deleteInfoByIds(data.id, index);
                    layer.close(index);
                });
            }
        });

        table.on('toolbar(currentTableFilter)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            if (obj.event === 'add') {
                layer.open({
                    title: '发布公告',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['70%', '85%'],
                    content: '${pageContext.request.contextPath}/noticeAdd',
                    end: function() {
                        table.reload('testReload');
                    }
                });
            } else if (obj.event === 'delete') {
                var data = checkStatus.data;
                if (data.length === 0) {
                    layer.msg("请至少选择一条公告进行删除");
                } else {
                    var ids = data.map(function(item){ return item.id; }).join(",");
                    layer.confirm('确定要删除选中的 ' + data.length + ' 条公告吗？', function (index) {
                        deleteInfoByIds(ids, index);
                        layer.close(index);
                    });
                }
            }
        });

        function deleteInfoByIds(ids, index) {
            $.post("deleteNoticeByIds", {ids: ids}, function (result) {
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
