<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>工程现场管控平台</title>

<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/source/image/logo.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/source/easyui/themes/bootstrap/easyui.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/source/css/common.css" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/source/easyui/themes/icon.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/source/css/kkpager_orange.css" />

<link
	href="${pageContext.request.contextPath}/source/js/inspinia/bootstrap.min.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/source/font-awesome/css/font-awesome.css"
	rel="stylesheet">
<!-- chosen -->
<link
	href="${pageContext.request.contextPath}/source/js/inspinia/plugins/chosen/chosen.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/source/js/inspinia/animate.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/source/js/inspinia/style.css"
	rel="stylesheet">
<!-- css -->
<link href="${pageContext.request.contextPath}/source/css/css.css"
	rel="stylesheet">

<script
	src="${pageContext.request.contextPath}/source/js/inspinia/jquery-2.1.1.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/common.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/kkpager.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/layer/layer.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/validate/validate-1.0.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/jquery.form.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/My97DatePicker/WdatePicker.js"></script>

<!-- Mainly scripts -->
<script
	src="${pageContext.request.contextPath}/source/js/inspinia/bootstrap.min.js"></script>
<script
	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/metisMenu/jquery.metisMenu.js"></script>
	
<script  src="${pageContext.request.contextPath}/source/js/inspinia/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Flot -->
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.tooltip.min.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.spline.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.resize.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.pie.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/jquery.flot.symbol.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/flot/curvedLines.js"></script> --%>

<!-- Peity -->
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/peity/jquery.peity.min.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/demo/peity-demo.js"></script> --%>

<!-- Custom and plugin javascript -->
<script
	src="${pageContext.request.contextPath}/source/js/inspinia/inspinia.js"></script>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/pace/pace.min.js"></script> --%>

<!-- jQuery UI -->
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/jquery-ui/jquery-ui.min.js"></script> --%>

<!-- Jvectormap -->
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script> --%>
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script> --%>

<!-- Sparkline -->
<!-- <script -->
<%-- 	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/sparkline/jquery.sparkline.min.js"></script> --%>

<!-- Chosen -->
<script
	src="${pageContext.request.contextPath}/source/js/inspinia/plugins/chosen/chosen.jquery.js"></script>
<style type="text/css">
body {
	font-family: "open sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 13px;
	color: #676A6C;
	overflow-x: hidden;
}

table.gridtable {
	width: 100%;
}

.wrapper-content {
	padding: 0px;
}

.wrapper {
	padding: 0px;
	background-color: #ffffff
}

.ibox-content {
	background-color: #FFF;
	color: inherit;
	padding: 10px 0px 5px 10px;
	border-color: #DBDBDB;
	border-image: none;
	border-style: solid solid none;
	border-width: 1px 0px;
}
.panel-footer {
    padding: 0px;
    background-color: #F5F5F5;
    border-top: 1px solid #DDD;
    border-bottom-right-radius: 3px;
    border-bottom-left-radius: 3px;
}
.input-group {
	position: relative;
	display: table;
	border-collapse: separate;
	margin-right: 10px;
}

.tree-node {
	height: 28px;
}

.tree-expanded, .tree-collapsed, .tree-folder, .tree-file,
	.tree-checkbox, .tree-indent {
	height: 18px;
	margin-top: 5px;
}

.tree-title {
	height: 28px;
	line-height: 28px;
	font-size: 13px;
}

.hongxin{
  color:red;
  font-weight: bold;
}
 /**input 清除按钮*/
 .clear { display:none;position: absolute; width: 16px; height: 16px; margin: 8px 0 0 -20px;right:50px;z-index:999;}   
</style>
<script type="text/javascript">

    //刷新分页工具条
	function tabPager() {
		refashPage(page.pageNumber, page.totalPage, page.totalRow);
	}
    
	//分页工具条
	function refashPage(pno, total, totalRecords) {
		//初始化函数  
		$('#kkpager').children().detach();
		kkpager.generPageHtml({
			pno : pno, //当前页数  
			total : total,//总页数  
			totalRecords : totalRecords, //总数据条数  
			mode : 'click', //这里设置为click模式  
			isShowTotalRecords : true,
			isShowTotalPage : false,
			isGoPage : false,
			lang : {
				firstPageText : '第一页',
				lastPageText : '最后一页',
				prePageText : '上一页',
				nextPageText : '下一页',
				totalPageBeforeText : '共',
				totalPageAfterText : '页',
				totalRecordsAfterText : '条数据',
				gopageBeforeText : '转到',
				gopageButtonOkText : '确定',
				gopageAfterText : '页',
				buttonTipBeforeText : '第',
				buttonTipAfterText : '页'
			},
			//点击页码的函数，这里发送ajax请求后台  
			click : function(n) {
				if (page.pageNumber != n) {
					page.pageNumber = n;
					ajaxData();
				}
				this.selectPage(n); //手动条用selectPage进行页码选中切换  
			},
			//设置href链接地址,默认#  
			getHref : function(n) {
				return "javascript:;;";
			}
		}, true);
	}

	//获取url参数
	function getQueryString(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
		var r = window.location.search.substr(1).match(reg);
		if (r != null)
			return unescape(r[2]);
		return null;
	}
	
	//弹出一个iframe层
	function openLayerFrame(title,url,wid,hei){
		layer.open({
            type: 2,
            title: title,
            shadeClose: true,
            shade: false,
            maxmin: false, //开启最大化最小化按钮
            area: [wid==null?'800px':wid, hei==null?'480px':hei],
            content: url
        });
	}
	//表单保存或者更新
	function saveOrUpdate() {
		$('form').form('submit', {
			success : function(data) {
				data = eval('(' + data + ')');
                if(data.success){
                   window.parent.ajaxData();
                   parent.layer.closeAll();
                }else{
                	layer.alert(data.message);
                }
			}
		});
	}
	//表单的返回或者取消
	function back() {
		parent.layer.closeAll();
	}
	
	//表单验证
	function validateVal(obj){
		if($(obj).val()==''){
			$(obj).parent().addClass('has-error');
			$(obj).next().show();
			$(obj).focus();			
		}else{
			$(obj).parent().removeClass('has-error');
			$(obj).next().hide();
		}
	}
	
	//表单验证长度为500
	function valLength(obj){
		var len=$(obj).val().length;
		if(len>500){
			$(obj).parent().addClass('has-error');
			$(obj).next().show();
			$(obj).focus();			
		}else{
			$(obj).parent().removeClass('has-error');
			$(obj).next().hide();
		}
	}
	
	function fullScreen(obj){
		if($(obj).text()=="全屏"){
			    parent.fullScreenCenter();				
		}else{
			parent.minScreenCenter();	
		}
	}
</script>
</head>
</html>