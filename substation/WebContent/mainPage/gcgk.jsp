<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<link  href="${pageContext.request.contextPath}/source/js/inspinia/bootstrap.min.css"  rel="stylesheet">
		<link  href="${pageContext.request.contextPath}/source/font-awesome/css/font-awesome.css"  rel="stylesheet">
		<!-- chosen -->
		<link href="${pageContext.request.contextPath}/source/js/inspinia/plugins/chosen/chosen.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/source/js/inspinia/animate.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/source/js/inspinia/style.css" rel="stylesheet">
		<!-- css -->
		<link href="${pageContext.request.contextPath}/source/css/css.css" rel="stylesheet">
		<title>工程概况</title>
		<style type="text/css">
			body {
			    font-family: "open sans","Helvetica Neue",Helvetica,Arial,sans-serif;
			    background-color: #FFF;
			    font-size: 13px;
			    color: #676A6C;
			    overflow-x: auto;
			}
			.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td{
				border-top: 0px;
			}
			.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th{
				border-top: 0px;
			}
			.ibox-title{
				border-width: 0px;
				border-bottom: 1px solid #e7eaec;
			}
			.content_div{margin: 8px 10px 8px 15px;}
			.title_span{
			    width: 90px;
			    display: inline-table;
			    font-weight: bold;
			}
			.content_span{
		        max-width: 600px;
			    display: inline-table;
			    line-height: 26px;
			}
		</style>
		<script type="text/javascript">
		</script>
	</head>
	<body>	
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>当前工程概况</h5>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">工程编号：</span>
                 	<span class="content_span">${project.project_code }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">工程名称：</span>
                 	<span class="content_span">${project.project_name }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">工程简称：</span>
                 	<span class="content_span">${project.short_name }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">工程类型：</span>
                 	<span class="content_span">${project.project_type }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">工程概述：</span>
                 	<span class="content_span">${project.description }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">创建人：</span>
                 	<span class="content_span">${project.create_user }</span>
                 </div>
                 <div class="content_div">
                 	<span class="title_span">创建时间：</span>
                 	<span class="content_span">${project.create_time }</span>
                 </div>
            </div>
         </div>
	</body>
</html>