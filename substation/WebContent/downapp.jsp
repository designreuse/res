<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title>工程现场管控平台</title>

	<link rel="shortcut icon" href="${pageContext.request.contextPath}/source/image/logo.png" />
	<script	src="${pageContext.request.contextPath}/source/js/inspinia/jquery-2.1.1.js"></script>
	<style type="text/css">
		body{
			background-color: #fff;
		}
		
		#qrcode_parse,#download,#err {
			margin: 200px auto;
			
			width: 300px;
			height: 200px;
			text-align: center;
			vertical-align: middle;
		}
		
		#download,#err {
			display: none;
		}
	</style>
	<script type="text/javascript">
		var appId 			= '<%=request.getAttribute("appId")%>';
		var appType 		= '<%=request.getAttribute("appType")%>';
		var appVer	 		= '<%=request.getAttribute("appVer")%>';
		var appDownloadURL 	= '<%=request.getAttribute("appDownloadURL")%>';
		var status		 	= '<%=request.getAttribute("status")%>';
		
		$(function(){
			window.setTimeout("goto_url()",2000);
       	});
       	
       	function goto_url() {
       		if (status == "ok") {
       			$("#down_url").attr("href", appDownloadURL);
       			$("#qrcode_parse").hide();
       			$("#download").fadeIn("fast",function(){
       				document.location = appDownloadURL;
				 });
       		} else {
       			$("#qrcode_parse").hide();
       			$("#download").fadeIn("err",function(){
				 });
       		}
       		
       	}
	</script>
	</head>
	<body>
		
		<div id="qrcode_parse">
			<img src="${pageContext.request.contextPath}/source/image/loading-2.gif" />
			正在加载
		</div>
		
		<div id="download">
			<a href="" id="down_url">正在自动开始下载App<%=request.getAttribute("appVer") %>，如果没有正常下载请点击这里。</a>
		</div>
		
		<div id="err">
			下载失败：<%=request.getAttribute("errMsg")%></a>
		</div>
		
		
		
	</body> 
</html>