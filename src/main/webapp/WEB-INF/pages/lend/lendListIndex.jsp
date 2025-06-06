<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>借阅管理</title>
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
                        <label class="layui-form-label">借书卡</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="readerNumber" id="readerNumber" autocomplete="off" placeholder="请输入借书卡号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">图书名称</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="name" id="name" autocomplete="off" placeholder="请输入图书名称">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">归还类型</label>
                        <div class="layui-input-inline">
                            <select name="type" id="type">
                                <option value="">全部</option>
                                <option value="0">正常还书</option>
                                <option value="1">延迟还书</option>
                                <option value="2">破损还书</option>
                                <option value="3">丢失</option>
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
                <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe654;</i> 借书</button>
                <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="back"><i class="fa fa-undo"></i> 还书</button>
                <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="delete"><i class="layui-icon">&#xe640;</i> 删除</button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            {{# if(d.backDate==null){ }}
            <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="edit">异常还书</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
            {{# }else{ }}
            <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
            {{# } }}
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
            url: '${pageContext.request.contextPath}/lendListAll',//查询借阅图书记录
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {type: "checkbox", width: 50},
                {templet: '<div><a href="javascript:void(0)" style="color:#1E9FFF" lay-event="bookInfoEvent">{{d.bookInfo.name}}</a></div>',
                    width: 100, title: '图书名称'},
                {templet: '<div>{{d.readerInfo.readerNumber}}</div>', width: 120, title: '借书卡'},
                {templet: '<div><a href="javascript:void(0)" style="color:#1E9FFF" lay-event="readerInfoEvent">{{d.readerInfo.realName}}</a></div>',
                    width: 100, title: '借阅人'},
                {templet:"<div>{{layui.util.toDateString(d.lendDate,'yyyy-MM-dd HH:mm:ss')}}</div>", width: 160, title: '借阅时间'},
                {templet:"<div>{{d.backDate? layui.util.toDateString(d.backDate,'yyyy-MM-dd HH:mm:ss') : ''}}</div>", width: 160, title: '还书时间'},
                {title:"还书类型",minWidth: 120,templet:function(res){
                      if(res.backType=='0'){
                          return '<span class="layui-badge layui-bg-green">正常还书</span>'
                      }else if(res.backType=='1'){
                          return '<span class="layui-badge layui-bg-orange">延迟还书</span>'
                      }else if(res.backType=='2') {
                          return '<span class="layui-badge layui-bg-yellow">破损还书</span>'
                      }else if(res.backType=='3'){
                          return '<span class="layui-badge layui-bg-red">丢失图书</span>'
                      }else{
                          return '<span class="layui-badge layui-bg-blue">在借中</span>'
                      }
                    }},
                {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,
            page: true,
            skin: 'line',
            id:'testReload'
        });

        form.on('submit(data-search-btn)', function (data) {
            var result = data.field;
            table.reload('testReload', {
                page: {
                    curr: 1
                }
                , where: {
                    name: result.name,
                    readerNumber: result.readerNumber,
                    type: result.type
                }
            }, 'data');
            return false;
        });

        table.on('toolbar(currentTableFilter)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    var index = layer.open({
                        title: '添加借阅记录',
                        type: 2,
                        shade: 0.2,
                        maxmin: true,
                        shadeClose: true,
                        area: ['70%', '85%'],
                        content: '${pageContext.request.contextPath}/addLendList',
                         end:function(){
                            //执行重载
                            table.reload('testReload');
                         }
                    });
                    break;
                case 'back':
                     var data = checkStatus.data;
                     if(data.length==0){
                        layer.msg("请选择要还的记录");
                        return;
                     }
                     var ids= getCheackId(data);
                     var bookIds= getCheackBookId(data);
                     layer.confirm('确定标记为已还状态吗?', function (index) {
                         //调用方法
                         backBook(ids,bookIds);
                         layer.close(index);
                     });
                     break;
                case 'delete':
                    var data = checkStatus.data;
                    if(data.length==0){
                        layer.msg("请选择要删除的记录");
                        return;
                    }
                    var ids= getCheackId(data);
                    var bookIds= getCheackBookId(data);
                    layer.confirm('确定删除吗?', function (index) {
                        //调用方法
                        deleteInfoByIds(ids,bookIds,index);
                        layer.close(index);
                    });
                    break;
            }
        });

        table.on('tool(currentTableFilter)', function (obj) {
            var data=obj.data;
            if (obj.event === 'edit') { 
                var index = layer.open({
                    title: '异常还书',
                    type: 2,
                    shade: 0.2,
                    maxmin:true,
                    shadeClose: true,
                    area: ['70%', '85%'],
                    content: '${pageContext.request.contextPath}/excBackBook?id='+data.id+"&bookId="+data.bookId,
                    end:function(){
                        table.reload('testReload');
                    }
                });
            } else if (obj.event === 'delete') { 
                layer.confirm('确定是否删除', function (index) {
                    deleteInfoByIds(data.id,data.bookId,index);
                    layer.close(index);
                });
            } else if( obj.event === 'bookInfoEvent') {
                  var bid=data.bookId;
                  queryLookBookList("book",bid);
            } else {
                var rid=data.readerId;
                queryLookBookList("user",rid);
            }
        });

        function queryLookBookList(flag,id){
            var index = layer.open({
                title: '借阅时间线',
                type: 2,
                shade: 0.2,
                maxmin:true,
                shadeClose: true,
                area: ['70%', '85%'],
                content: '${pageContext.request.contextPath}/queryLookBookList?id='+id+"&flag="+flag,
            });
        }
        
        function getCheackId(data){
            var arr=new Array();
            for(var i=0;i<data.length;i++){
                arr.push(data[i].id);
            }
            return arr.join(",");
        };

        function getCheackBookId(data){
            var arr=new Array();
            for(var i=0;i<data.length;i++){
                arr.push(data[i].bookId);
            }
            return arr.join(",");
        };

        function deleteInfoByIds(ids ,bookIds,index){
            $.ajax({
                url: "deleteLendListByIds",
                type: "POST",
                data: {ids: ids,bookIds:bookIds},
                success: function (result) {
                    if (result.code == 0) {
                        layer.msg('删除成功', {
                            icon: 6,
                            time: 500
                        }, function () {
                            table.reload('testReload');
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(result.msg);
                    }
                }
            })
        }
        
        function backBook(ids ,bookIds){
            $.ajax({
                url: "backBook",
                type: "POST",
                data: {ids: ids,bookIds:bookIds},
                success: function (result) {
                    if (result.code == 0) {
                        layer.msg('还书成功', {
                            icon: 6,
                            time: 500
                        }, function () {
                            table.reload('testReload');
                        });
                    } else {
                        layer.msg(result.msg);
                    }
                }
            })
        }
    });
</script>
</body>
</html>
