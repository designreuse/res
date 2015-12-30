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
<body class="fixed-navigation  fixed-nav pace-done"  style="overflow: hidden;">
<div class="pace pace-inactive">
	<div class="pace-progress" data-progress-text="100%" data-progress="99" style="-webkit-transform: translate3d(100%, 0px, 0px); transform: translate3d(100%, 0px, 0px);">
		<div class="pace-progress-inner"></div>
	</div>
	<div class="pace-activity"></div>
</div>
<div id="wrapper">
	<nav class="navbar-default navbar-static-side" role="navigation">
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
		<div class="row border-bottom">
			<nav class="navbar white-bg navbar-fixed-top" role="navigation" style="margin-bottom: 0">
				<div class="navbar-header">
					<div class="pull-left"><img alt="image" class="img-circle logo_img" src="source/image/logo.png"><span class="logo_title">变电站工程现场人员动态管控一体化平台</span>
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
					<li class="dropdown"> <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#"> <i class="fa fa-envelope"></i> <span class="label label-warning">16</span> </a>
						<ul class="dropdown-menu dropdown-messages">
							<li>消息内容</li>
						</ul>
					</li>
					<li class="dropdown"> <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#"> <i class="fa fa-bell"></i> <span class="label label-primary">8</span> </a>
						<ul class="dropdown-menu dropdown-alerts">
							<li> <a href="#">
								<div> <i class="fa fa-envelope fa-fw"></i> 消息内容 <span class="pull-right text-muted small">4 分钟前</span> </div>
								</a> </li>
							<li class="divider"></li>
							<li> <a href="#">
								<div> <i class="fa fa-twitter fa-fw"></i> 消息内容消息内容 <span class="pull-right text-muted small">12 分钟前</span> </div>
								</a> </li>
							<li class="divider"></li>
							<li> <a href="#">
								<div> <i class="fa fa-upload fa-fw"></i> 消息内容消息内容 <span class="pull-right text-muted small">4 前</span> </div>
								</a> </li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block"> <a href="#"> <strong>所有信息</strong> <i class="fa fa-angle-right"></i> </a> </div>
							</li>
						</ul>
					</li>
					<li> <a href="/index/logout"> <i class="fa fa-sign-out"></i>退出</a> </li>
				</ul>
			</nav>
		</div>
		<div class="wrapper wrapper-content"   id="content">
                     <iframe id="centerPageIframe"  src="${menuList[0].url}"    frameborder="0" scrolling="no" width="100%" height="100%"  ></iframe>
		</div>
		<div class="footer fixed">
			<div class="pull-right"> <strong>版本号：</strong>V1.0 </div>
			<div> <strong>版权所有</strong> 唐山新质点科技有限公司 © 2015-2016 </div>
		</div>
	</div>
</div>

<script>
     var _$comboboxObj =null;
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
    </script> 
<!-- 页面设置 -->
<div class="theme-config" style="display:none;">
	<div class="theme-config-box">
		<div class="spin-icon"> <i class="fa fa-cogs fa-spin"></i> </div>
		<div class="skin-setttings">
			<div class="title">Configuration</div>
			<div class="setings-item"> <span> Collapse menu </span>
				<div class="switch">
					<div class="onoffswitch">
						<input type="checkbox" name="collapsemenu" class="onoffswitch-checkbox" id="collapsemenu">
						<label class="onoffswitch-label" for="collapsemenu"> <span class="onoffswitch-inner"></span> <span class="onoffswitch-switch"></span> </label>
					</div>
				</div>
			</div>
			<div class="setings-item"> <span> Fixed sidebar </span>
				<div class="switch">
					<div class="onoffswitch">
						<input type="checkbox" name="fixedsidebar" class="onoffswitch-checkbox" id="fixedsidebar">
						<label class="onoffswitch-label" for="fixedsidebar"> <span class="onoffswitch-inner"></span> <span class="onoffswitch-switch"></span> </label>
					</div>
				</div>
			</div>
			<div class="setings-item"> <span> Top navbar </span>
				<div class="switch">
					<div class="onoffswitch">
						<input type="checkbox" name="fixednavbar" class="onoffswitch-checkbox" id="fixednavbar">
						<label class="onoffswitch-label" for="fixednavbar"> <span class="onoffswitch-inner"></span> <span class="onoffswitch-switch"></span> </label>
					</div>
				</div>
			</div>
			<div class="setings-item"> <span> Boxed layout </span>
				<div class="switch">
					<div class="onoffswitch">
						<input type="checkbox" name="boxedlayout" class="onoffswitch-checkbox" id="boxedlayout">
						<label class="onoffswitch-label" for="boxedlayout"> <span class="onoffswitch-inner"></span> <span class="onoffswitch-switch"></span> </label>
					</div>
				</div>
			</div>
			<div class="setings-item"> <span> Fixed footer </span>
				<div class="switch">
					<div class="onoffswitch">
						<input type="checkbox" name="fixedfooter" class="onoffswitch-checkbox" id="fixedfooter">
						<label class="onoffswitch-label" for="fixedfooter"> <span class="onoffswitch-inner"></span> <span class="onoffswitch-switch"></span> </label>
					</div>
				</div>
			</div>
			<div class="title">Skins</div>
			<div class="setings-item default-skin"> <span class="skin-name "> <a href="#" class="s-skin-0"> Default </a> </span> </div>
			<div class="setings-item blue-skin"> <span class="skin-name "> <a href="#" class="s-skin-1"> Blue light </a> </span> </div>
			<div class="setings-item yellow-skin"> <span class="skin-name "> <a href="#" class="s-skin-3"> Yellow/Purple </a> </span> </div>
		</div>
	</div>
</div>
<script>
    var config = {
                '.chosen-select'           : {},
                '.chosen-select-deselect'  : {allow_single_deselect:true},
                '.chosen-select-no-single' : {disable_search_threshold:10},
                '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                '.chosen-select-width'     : {width:"95%"}
                }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

    // Enable/disable fixed top navbar
    $('#fixednavbar').click(function () {
        if ($('#fixednavbar').is(':checked')) {
            $(".navbar-static-top").removeClass('navbar-static-top').addClass('navbar-fixed-top');
            $("body").removeClass('boxed-layout');
            $("body").addClass('fixed-nav');
            $('#boxedlayout').prop('checked', false);

            if (localStorageSupport) {
                localStorage.setItem("boxedlayout",'off');
            }

            if (localStorageSupport) {
                localStorage.setItem("fixednavbar",'on');
            }
        } else {
            $(".navbar-fixed-top").removeClass('navbar-fixed-top').addClass('navbar-static-top');
            $("body").removeClass('fixed-nav');

            if (localStorageSupport) {
                localStorage.setItem("fixednavbar",'off');
            }
        }
    });

    // Enable/disable fixed sidebar
    $('#fixedsidebar').click(function () {
        if ($('#fixedsidebar').is(':checked')) {
            $("body").addClass('fixed-sidebar');
            $('.sidebar-collapse').slimScroll({
                height: '100%',
                railOpacity: 0.9
            });

            if (localStorageSupport) {
                localStorage.setItem("fixedsidebar",'on');
            }
        } else {
            $('.sidebar-collapse').slimscroll({destroy: true});
            $('.sidebar-collapse').attr('style', '');
            $("body").removeClass('fixed-sidebar');

            if (localStorageSupport) {
                localStorage.setItem("fixedsidebar",'off');
            }
        }
    });

    // Enable/disable collapse menu
    $('#collapsemenu').click(function () {
        if ($('#collapsemenu').is(':checked')) {
            $("body").addClass('mini-navbar');
            SmoothlyMenu();

            if (localStorageSupport) {
                localStorage.setItem("collapse_menu",'on');
            }

        } else {
            $("body").removeClass('mini-navbar');
            SmoothlyMenu();

            if (localStorageSupport) {
                localStorage.setItem("collapse_menu",'off');
            }
        }
    });

    // Enable/disable boxed layout
    $('#boxedlayout').click(function () {
        if ($('#boxedlayout').is(':checked')) {
            $("body").addClass('boxed-layout');
            $('#fixednavbar').prop('checked', false);
            $(".navbar-fixed-top").removeClass('navbar-fixed-top').addClass('navbar-static-top');
            $("body").removeClass('fixed-nav');
            $(".footer").removeClass('fixed');
            $('#fixedfooter').prop('checked', false);

            if (localStorageSupport) {
                localStorage.setItem("fixednavbar",'off');
            }

            if (localStorageSupport) {
                localStorage.setItem("fixedfooter",'off');
            }


            if (localStorageSupport) {
                localStorage.setItem("boxedlayout",'on');
            }
        } else {
            $("body").removeClass('boxed-layout');

            if (localStorageSupport) {
                localStorage.setItem("boxedlayout",'off');
            }
        }
    });

    // Enable/disable fixed footer
    $('#fixedfooter').click(function () {
        if ($('#fixedfooter').is(':checked')) {
            $('#boxedlayout').prop('checked', false);
            $("body").removeClass('boxed-layout');
            $(".footer").addClass('fixed');

            if (localStorageSupport) {
                localStorage.setItem("boxedlayout",'off');
            }

            if (localStorageSupport) {
                localStorage.setItem("fixedfooter",'on');
            }
        } else {
            $(".footer").removeClass('fixed');

            if (localStorageSupport) {
                localStorage.setItem("fixedfooter",'off');
            }
        }
    });

    // SKIN Select
    $('.spin-icon').click(function () {
        $(".theme-config-box").toggleClass("show");
    });

    // Default skin
    $('.s-skin-0').click(function () {
        $("body").removeClass("skin-1");
        $("body").removeClass("skin-2");
        $("body").removeClass("skin-3");
    });

    // Blue skin
    $('.s-skin-1').click(function () {
        $("body").removeClass("skin-2");
        $("body").removeClass("skin-3");
        $("body").addClass("skin-1");
    });

    // Inspinia ultra skin
    $('.s-skin-2').click(function () {
        $("body").removeClass("skin-1");
        $("body").removeClass("skin-3");
        $("body").addClass("skin-2");
    });

    // Yellow skin
    $('.s-skin-3').click(function () {
        $("body").removeClass("skin-1");
        $("body").removeClass("skin-2");
        $("body").addClass("skin-3");
    });

    if (localStorageSupport) {
        var collapse = localStorage.getItem("collapse_menu");
        var fixedsidebar = localStorage.getItem("fixedsidebar");
        var fixednavbar = localStorage.getItem("fixednavbar");
        var boxedlayout = localStorage.getItem("boxedlayout");
        var fixedfooter = localStorage.getItem("fixedfooter");

        if (collapse == 'on') {
            $('#collapsemenu').prop('checked','checked')
        }
        if (fixedsidebar == 'on') {
            $('#fixedsidebar').prop('checked','checked')
        }
        if (fixednavbar == 'on') {
            $('#fixednavbar').prop('checked','checked')
        }
        if (boxedlayout == 'on') {
            $('#boxedlayout').prop('checked','checked')
        }
        if (fixedfooter == 'on') {
            $('#fixedfooter').prop('checked','checked')
        }
    }
	 
</script>
</body>
</html>