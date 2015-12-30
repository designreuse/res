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
			table.gridtable{
			  	width: 90%; 
			  	margin: 20px 0px;
		    }
		    .container{
		    	margin: 30px 0px 0px 5%;
		    }
			.user_message{
				margin: 30px 0px;
			}
			.user_message span{
				margin: 0px 10px;
			}
			table.gridtable-ext {
				font-family: verdana,arial,sans-serif;
				font-size:12px;
				color:#333333;
				border-collapse: collapse;
				width: 90%; 
			  	margin: 20px 0px;
			}
			table.gridtable-ext td {
				border-width: 0px;
				height : 40px;
				background: #ffffff;
				text-align: center;
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
			<span>首页>查看培训详情</span>
			<hr align="left" style="width: 90%" />
			<table class="gridtable-ext">
				<tr>
					<td width="100px">课程名称</td><td style="text-align: left;">XXX培训课程</td>
				</tr>
				<tr>
					<td>课程讲师</td><td style="text-align: left;">李雷</td>
				</tr>
				<tr>
					<td>课程内容</td><td style="text-align: left;">课程内容课程内容课程内容课程内容课程内容课程内容课程内容</td>
				</tr>
				<tr>
					<td>培训时间</td><td style="text-align: left;">2015-06-22 14:00 ~ 15:00</td>
				</tr>
				<tr>
					<td>授课时长</td><td style="text-align: left;">1小时</td>
				</tr>
				<tr>
					<td>发布人</td><td style="text-align: left;">李晓 </td>
				</tr>
				<tr>
					<td>参加人员</td><td style="text-align: left;">22人</td>
				</tr>
	  		</table> 
	  		
	  		<table class="gridtable">
				<tr>
					<th width="8%">序号</th><th width="12%">姓名</th><th width="15%">部门</th><th width="15%">职务</th><th width="16%">进场时间</th><th width="16%">听课时长</th><th width="18%">缺勤时长</th>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>-</td>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>15分钟</td>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>-</td>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>15分钟</td>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>-</td>
				</tr>
				<tr>
					<td>1</td><td>张三</td><td>XXX部门</td><td>XXX职务</td><td>14：00</td><td>1小时</td><td>15分钟</td>
				</tr>
	  		</table> 
		</div>  
	</body> 
</html>