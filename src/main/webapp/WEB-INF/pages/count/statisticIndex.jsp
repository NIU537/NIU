<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.yx.po.TypeInfo" %>
<%
    List<TypeInfo> typeList = (List<TypeInfo>) request.getAttribute("list");
    String json = JSON.toJSONString(typeList);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>图书分类统计</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Helvetica, Arial, sans-serif;
            color: #212529;
            padding: 20px;
        }
        .chart-container {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
        }
        .chart-header {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 25px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="layuimini-main">
    <div class="chart-container">
        <div class="chart-header">图书分类统计</div>
        <div id="main" style="width: 100%; height:600px;"></div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['echarts'], function () {
        var echarts = layui.echarts;
        var myChart = echarts.init(document.getElementById('main'));
        var chartData = JSON.parse('<%=json%>');

        var legendData = chartData.map(function(item) {
            return item.name;
        });

        var seriesData = chartData.map(function(item) {
            return {name: item.name, value: item.counts};
        });

        var option = {
            title: {
                text: '各类图书占比',
                subtext: '扇形图',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b} : {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: legendData
            },
            series: [
                {
                    name: '图书分类',
                    type: 'pie',
                    radius: '55%',
                    center: ['50%', '60%'],
                    data: seriesData,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };
        myChart.setOption(option);
    });
</script>
</body>
</html>
