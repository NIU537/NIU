<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>修改密码</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Helvetica, Arial, sans-serif;
            color: #212529;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .page-container {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
            width: 100%;
            max-width: 450px;
        }
        .form-header {
            text-align: center;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
        }
        .layui-form-label {
            font-weight: 500;
        }
        .layui-input {
            border-radius: 6px;
        }
        .layui-btn {
            border-radius: 6px;
            width: 100%;
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="form-header">修改密码</div>
    <div class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">当前密码</label>
            <div class="layui-input-block">
                <input type="password" name="oldPwd" id="oldPwd" placeholder="请输入当前密码" class="layui-input" lay-verify="required" lay-reqtext="当前密码不能为空">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">新密码</label>
            <div class="layui-input-block">
                <input type="password" name="newPwd" id="newPwd" placeholder="请输入新密码" class="layui-input" lay-verify="required|newPwd" lay-reqtext="新密码不能为空">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">确认密码</label>
            <div class="layui-input-block">
                <input type="password" name="againPwd" id="againPwd" placeholder="请再次输入新密码" class="layui-input" lay-verify="required|confirmPwd" lay-reqtext="确认密码不能为空">
            </div>
        </div>
        <div class="layui-form-item" style="margin-top: 25px;">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveBtn">确认修改</button>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'layer'], function () {
        var form = layui.form,
            layer = layui.layer,
            $ = layui.$;

        form.verify({
            newPwd: [
                /^[\S]{6,12}$/,
                '密码必须6到12位，且不能出现空格'
            ],
            confirmPwd: function(value) {
                if (value !== $('#newPwd').val()) {
                    return '两次输入的新密码不一致';
                }
            }
        });

        form.on('submit(saveBtn)', function (data) {
            var datas = data.field;
            
            $.ajax({
                url: "updatePwdSubmit2",
                type: "POST",
                data: {
                    oldPwd: datas.oldPwd,
                    newPwd: datas.newPwd
                },
                success: function(result) {
                    if (result.code == 0) {
                        layer.msg('修改成功', {
                            icon: 1,
                            time: 1500
                        }, function() {
                            // 清空表单
                            $('input').val('');
                        });
                    } else {
                        layer.msg(result.msg, { icon: 2 });
                    }
                },
                error: function() {
                    layer.msg('请求失败，请稍后重试', { icon: 2 });
                }
            });
            
            return false;
        });
    });
</script>
</body>
</html>