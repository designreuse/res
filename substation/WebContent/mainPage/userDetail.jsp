<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<style type="text/css">
		     html , body{
		     	margin: 0px 0px 0px 0px;
		     	overflow-y: auto;
		     	background: #FFF;
		     }
		   
		    .header{
		    	width: 100%;
		    	height: 150px;
		    	background: #F4F4F4;
		    }
		    .img_span{
		    	width: 50px;
		    	height: 50px;
		    	padding: 0px;
		    	margin: 0px;
		    	vertical-align: middle;
		    }
		    .img_span_60{
		    	width: 60px;
		    	height: 60px;
		    	padding: 0px;
		    	margin: 0px;
		    	vertical-align: middle;
		    }
		    .span_margin_right{
	    	    margin-right: 60px;
    			font-size: 14px;
    			margin-left: 10px;
		    }
		    .span_margin_right a{
		    	margin-left: 5px;
		    }
		    .nav_header{
	    	    clear: both;
		    	margin: 10px 0px;
		    	padding-left:10px;
			  	height: 40px;
			  	line-height: 40px;
			  	width: 100%;
			  	font-weight: bold;
			  	background: #aaa;
			  	color: #000;
		    }
			.bqxx_container{
				height: 80px;
				float: left;
				overflow: hidden;
				margin: 20px;
			}
		</style>
		<script type="text/javascript">
		    //传递的用户ID
		    var userId = '${param.userId}';
		</script>
	</head>
	<body>
   <div class="wrapper wrapper-content  gray-bg"   >
		<div class="header">
			<div style="width: 150px;height: 100%;border: 0px;float: left;margin-right: 20px">
				<img src="/pictureSan/file.jsp?fileName=${userRecord.PHOTO}"   onerror="this.src='/source/phone/defuatlUserPhoto.png'"  style="width:130px;height:130px;padding:0px;margin:10px;vertical-align:middle;">	
			</div>
			<div style="height: 100%;border: 0px;float: left;">
				<div style="height: 50%;line-height: 80px;font-size: 20px">
					<span>${userRecord.REAL_NAME =='' ? userRecord.USER_NAME : userRecord.REAL_NAME }</span>
				</div>
				<div>
					<span class="span_margin_right"><i class="fa fa-exchange"></i>&nbsp;进站记录<a href="#">${inoutCount }</a></span>
<%-- 					<img class="img_span" src="/source/phone/${userRecord.PHOTO}"   onerror="this.src='/source/phone/defuatlUserPhoto.png'"/>	<span class="span_margin_right">培训记录<a href="#">${trainCount }</a></span> --%>
						<span class="span_margin_right" style="margin-right: 0px;"><i class="fa fa-camera"></i>&nbsp;违章记录<a href="#">${violateCount }</a></span>
				</div>
			</div>
		</div>
		<!-- 个人信息 --> 
		<div>
			<div class="nav_header">个人信息</div>
			<div style="width: 95%;">
				<table class="table ">
					<tr>
						<td width="10%"><strong>账号：</strong></td><td width="40%">${userRecord.USER_NAME}</td><td width="10%"><strong>单位：</strong></td><td width="40%">${userRecord.CORPORATION }</td>
					</tr>
					<tr> 
						<td><strong>性别：</strong></td><td>${userRecord.SEX}</td><td><strong>部门：</strong></td><td>${userRecord.DEPARTMENT }</td>
					</tr>
					<tr>
						<td><strong>身份证：</strong></td><td>${userRecord.IDENTITY_CARD }</td><td><strong>职务：</strong></td><td>${userRecord.DUTY }</td>
					</tr>
					<tr>
						<td><strong>电话：</strong></td><td>${userRecord.MOBILE_PHONE }</td><td><strong>邮箱：</strong></td><td>${userRecord.EMAIL }</td>
					</tr>
					<tr>
						<td><strong>专业：</strong></td><td>${userRecord.SPECIALTY}</td><td><strong>分管：</strong></td><td>${userRecord.PART_MANAGE}</td>
					</tr>
					<tr>
						<td><strong>备注：</strong></td><td>${userRecord.DESCRIPTION }</td><td><strong></strong></td><td></td>
					</tr>
		  		</table> 
			</div>
		</div>
		<!-- 标签信息 --> 
<!-- 		<div> -->
<!-- 			<div class="nav_header">标签信息</div> -->
<!-- 			<div style="width: 95%;height:100px; text-align: center;"> -->
<%-- 			    <c:forEach items="${tagRecord }" var="item" varStatus="status"> --%>
<!-- 					<div class="bqxx_container"> -->
<!-- 						<div style="float: left;width: 80px"> -->
<%-- 							<img class="img_span_60"  src="/source/phone/${userRecord.PHOTO}"   onerror="this.src='/source/phone/defuatlUserPhoto.png'" /> --%>
<!-- 						</div> -->
<!-- 						<div style="float: left;width: 150px"> -->
<%-- 							<div>安全帽标签：${item.part }</div> --%>
<%-- 							<div>名称：${item.tag_name }</div> --%>
<%-- 							<div>标签ID：${item.tag_mac }</div> --%>
<!-- 						</div> -->
<!-- 					</div>			    	 -->
<%-- 			    </c:forEach> --%>
<!-- 			</div> -->
<!-- 		</div> -->
		
		<!-- 违章信息 --> 
		<div>
			<div class="nav_header">违章记录</div>
			 <div class="table-responsive"   id="table_content"  >
                   <table class="gridtable  table table-striped" >
					<tr>
						<th width="10%">序号</th><th width="70%">违章内容</th><th width="20%">违章时间</th>
					</tr>
					<c:if test="${!empty violateRecord}">
					<c:forEach items="${violateRecord}"   var="item"    varStatus="status">
					    <tr>
							<td>${status.count}</td><td>${item.violate_content}</td><td>${item.upload_time}</td>
						</tr>
					</c:forEach>
					 </c:if>
					 <c:if test="${empty violateRecord}">
				        <tr>
							<td colspan="3"  style="text-align: center;color: red;">没有记录.</td>
						</tr>
				   </c:if>
		  		</table> 
			</div>
		</div>
		
		<!-- 培训信息 --> 
<!-- 		<div> -->
<!-- 			<div class="nav_header">培训记录</div> -->
<!-- 			<div style="width: 95%;height:100px; text-align: center;"> -->
<!-- 				<table class="gridtable"> -->
<!-- 					<tr> -->
<!-- 						<th width="5%">序号</th><th width="35%">课程名称</th><th width="10%">课程讲师</th><th width="35%">时间</th><th width="15%">参加时长</th> -->
<!-- 					</tr> -->
<%-- 					<c:forEach items="${trainRecord }" var="item" varStatus="status"> --%>
<!-- 						<tr> -->
<%-- 							<td>${status.count}</td><td>${item.course_name }</td><td>待定</td><td>${item.create_time }</td><td>${item.hours }</td> --%>
<!-- 						</tr> -->
<%-- 					</c:forEach> --%>
<!-- 		  		</table>  -->
<!-- 			</div> -->
<!-- 		</div> -->
		
		<!-- 进出站信息 --> 
		<div>
			<div class="nav_header">进出站记录</div>
			<div class="table-responsive"   id="table_content"  >
                   <table class="gridtable  table table-striped" >
					<tr>
						<th width="10%">序号</th><th width="30%">日期</th><th width="30%">进站时间</th><th width="30%">出站时间</th>
					</tr>
				  <c:if test="${!empty inoutRecord}">
					<c:forEach items="${inoutRecord }" var="item" varStatus="status">
						<tr>
							<td>${status.count }</td><td>${item.date }</td><td>${item.in_time }</td><td>${item.out_time }</td>
						</tr>
					</c:forEach>
				   </c:if>	
				    <c:if test="${empty inoutRecord}">
				        <tr>
							<td colspan="4"  style="text-align: center;color: red;">没有记录.</td>
						</tr>
				   </c:if>
		  		</table> 
			</div>
		</div>
        </div>
	</body> 
</html>