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
			table.gridtable {
				font-family: verdana,arial,sans-serif;
				font-size:12px;
				color:#333333;
				border-collapse: collapse;
				width: 95%;
				margin: 30px 0px 0px 0px;
			}
		</style>
		<script type="text/javascript">
			$(function(){
			});
		</script>
	</head>
	<body>  
		<div class="container">
			<span style="font-size: 16px">消息</span>
			<hr align="left" style="width: 95%" />
			<div>
				<table class="gridtable">
					<tr>
						<th width="10%">序号</th><th width="60%">消息内容</th><th width="15%">发布时间</th><th width="15%">操作</th>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="#">设为已读</a></td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="#">设为已读</a></td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1D</td>
					</tr>
					<tr>
						<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1D</td>
					</tr>
		  		</table> 			
			</div>
		</div>  
	</body> 
</html>