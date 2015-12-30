<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<style type="text/css">
		    .container{
		    	margin: 30px 0px 0px 5%;
		    }
			.user_message{
				margin: 30px 0px;
			}
			.user_message span{
				margin: 0px 10px;
			}
			table.gridtable {
				font-family: verdana,arial,sans-serif;
				font-size:12px;
				color:#333333;
				border-collapse: collapse;
				width: 95%;
			}
			table.gridtable th {
				border-width: 1px;
				height : 40px;
				border-style: groove;
				background: #EDEDED;
			}
			table.gridtable td {
				border-width: 1px;
				height : 40px;
				border-style: groove;
				background: #ffffff;
				text-align: center;
			}
			table.gridtable tr:HOVER {
	            background: #D8F0F9;
            }
            table.gridtable tr:HOVER td{
	            background: none;
            }
		</style>
		<script type="text/javascript">
		    var userId = '${param.id}';
			$(function(){
				console.log(userId);
			});
		</script>
	</head>
	<body>  
		<div class="container">
			<span style="font-size: 16px">首页>查看进站记录</span>
			<hr align="left" style="width: 95%" />
			<div class="user_message">
				<img src="${pageContext.request.contextPath}/source/image/mainPage/u30.png" style="width:50px;height:50px;padding:0px;margin:0px;vertical-align:middle;">
				<span style="font-size: 16px">李晓</span>
				<span>XX职位</span>
				<span>XX部门</span>
			</div>
			<div>
				<table class="gridtable">
					<tr>
						<th width="10%">序号</th><th width="30%">时间</th><th width="60%">地点</th>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td>
					</tr>
		  		</table> 			
			</div>
		</div>  
	</body> 
</html>