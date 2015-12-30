<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<body class="fixed-navigation  fixed-nav   pace-done"  style="overflow: hidden;">
<div class="pace pace-inactive">
	<div class="pace-progress" data-progress-text="100%" data-progress="99" style="-webkit-transform: translate3d(100%, 0px, 0px); transform: translate3d(100%, 0px, 0px);">
		<div class="pace-progress-inner"></div>
	</div>
	<div class="pace-activity"></div>
</div>
<div id="wrapper">
	<nav class="navbar-default navbar-static-side"   id="menu"   role="navigation">
		<div class="sidebar-collapse">
			<ul class="nav metismenu" id="side-menu">
			<c:forEach items="${menuList}"   var="item"  >
				<c:if test="${fn:length(item.children) == 0 }">
					<li   class="${item.active}"> <a href="javascript:void(0)"  onclick="$('#centerPageIframe').attr('src','${item.url}');$(this).parent().parent().children('li').removeClass('active');$(this).parent().addClass('active');$('.nav-second-level').removeClass('in');$('.nav-second-level').addClass('collapse');"><i class="${item.ico}"></i> <span class="nav-label">${item.name}</span></a> </li>
				</c:if>
				<c:if test="${fn:length(item.children)!= 0 }">
					<li  class="${item.active}"> <a href="javascript:void(0)" ><i class="${item.ico}"></i> <span class="nav-label">${item.name}</span><span class="fa arrow"></span></a> 
					  <ul class="nav nav-second-level collapse" > 
					  <c:forEach items="${item.children}"   var="itemChild"  >
						 <li><a href="javascript:void(0)"  onclick="$('#centerPageIframe').attr('src','${itemChild.url}');$(this).parent().parent().parent().parent().children('li').removeClass('active');$(this).parent().parent().parent().addClass('active');">${itemChild.name}</a></li> 
					  </c:forEach>
					 </ul> 
					</li>
				</c:if>
			</c:forEach>
			</ul>
		</div>
	</nav>
	<div id="page-wrapper"  class="gray-bg">
		<div class="row border-bottom"  id="top">
			<nav class="navbar white-bg navbar-fixed-top"   role="navigation"   style="margin-bottom: 0">
				<div class="navbar-header">
					<div class="pull-left"><img alt="image" class="img-circle logo_img" src="source/image/logo.png"><span class="logo_title">工程现场管控平台</span>
						<div class="input-group select_item">
							<select data-placeholder="请选择工程..." class="chosen-select"   style="width:300px;"  tabindex="2"   id="gc_combobox">
								<option value="">请选择工程</option>
							</select>
						</div>
					</div>
				</div>
				<a class="navbar-minimalize minimalize-styl-2 btn btn-primary pull-right" href="#"><i class="fa fa-bars"></i></a>
				<ul class="nav navbar-top-links navbar-right">
					<li> <a href="javascript:void(0)" onclick="gotoUserInfo('${user.userId}')"><span class="m-r-sm text-muted welcome-message">${user.userName}</span></a> </li>
					<li> <a href="/index/logout"> <i class="fa fa-sign-out"></i>退出</a> </li>
				</ul>
			</nav>
		</div>
		<div class="wrapper wrapper-content"   id="content">
                     <iframe id="centerPageIframe"  src=""    frameborder="0" scrolling="no" width="100%" height="100%"  ></iframe>
		</div>
		<div class="footer fixed">
			<div class="pull-right"> <strong>版本号：</strong>${version} </div>
			<div> <strong>版权所有</strong> ${company} © 2015-2016 </div>
		</div>
	</div>
</div>


<script>
     var _$comboboxObj =null;
     var url='${menuList[0].url==""?menuList[0].children[0].url:menuList[0].url}';
        $(document).ready(function() {
        	$("#content").height($(window).height()-110);
			$('#centerPageIframe').load(function() { 
			     $('#centerPageIframe').contents().find("body").css('background-color','#fffff');
			}); 
             initProjectComb();
        });
        function initProjectComb(){
        	$("#gc_combobox").chosen().change(function(){
        		var _id=$("#gc_combobox option:selected").val();
        		var _name=$("#gc_combobox option:selected").text();
        		_$comboboxObj ={id:_id,name:_name};
        		//刷新当前页面
        		$('#centerPageIframe').attr('src',$('#centerPageIframe').attr('src'));
        	});
        	$.ajax({
				url : "permission/getProjectByUser",
				dataType : "json",
				type : "GET",
				success : function(data) {
					$("#gc_combobox").html(""); 
					$("#gc_combobox").chosen("destroy"); 
					var html="";
					$.each(data,function(i,item){
						html+="<option value='"+item.ID+"'>"+item.PROJECT_NAME+"</option>";
					});
					if(html!=""){
						$("#gc_combobox").append(html);
					}
					$("#gc_combobox").trigger("liszt:updated");
					$("#gc_combobox").chosen(); 
					var _id=$("#gc_combobox option:selected").val();
	        		var _name=$("#gc_combobox option:selected").text();
	        		_$comboboxObj ={id:_id,name:_name};
	        		$('#centerPageIframe').attr('src',url);
				}
			});
        }
        	function initIframePage(url){
				$('#centerPageIframe').attr('src' , url);
			}
			
			
			function gotoUserInfo(userId){
				var projectId =$("#gc_combobox option:selected").val();
				initIframePage('/user/userDetail/userId='+userId+'&projectId='+projectId);
			}
			
			function projectInfo(userId){
				var projectId = $("#gc_combobox option:selected").val();
				initIframePage('/user/projectInfo/userId='+userId+'&projectId='+projectId);
			}
			
			function fullScreenCenter(){
				var url=$("#centerPageIframe").attr('src');
				var h=$(window).height();
				var w=$(window).width();
				layer.open({
		            type: 2,
		            title: "",
		            shadeClose: false,
		            closeBtn: false,
		            shade: false,
		            maxmin: false, //开启最大化最小化按钮
		            area: [w+"px", h+"px"],
		            content: url+"?max=true"
		        });
			}
			
			function minScreenCenter(){
				$("#centerPageIframe").attr('src',$("#centerPageIframe").attr('src'));
				layer.closeAll();
			}
    </script> 
</body>
</html>