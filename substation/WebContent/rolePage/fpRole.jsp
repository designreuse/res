<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<title>首页</title>
<style>
</style>
<script>
	var _pageSize = 10;
	var roleId=getQueryString('roleId');
	var _project_id=getQueryString('project_id');
	var _project_name=getQueryString('project_name');
	var checkItems="";
	var removeItems="";
	var page = {
		pageNumber : 1,
		totalPage : 0,
		totalRow : 0,
		type : 'ALL'
	};
	$(function() {
		getUserByRoleId();
		ajaxData();
	});
	//通过roleId获取用户
	function getUserByRoleId(){
		
	}
	function ajaxData() {
				loadingStart('加载中...');
		    	$.ajax({
		            url: "/role/getUserInfo",
		            data:{
		            	pageNumber:page.pageNumber,
		            	pageSize:_pageSize ,
		            	userName : $('#search').val(),
		            	roleId:roleId
		            },
					dataType : "json",
					type : "POST",
					success : function(data) {
						var list = data.list;
						var table = $(".gridtable");
						var trs = table.find("tr");
						for ( var i = 1; i < trs.length; i++) {
							trs[i].remove();
						}
						page.pageNumber = data.pageNumber;
						page.totalPage = data.totalPage;
						page.totalRow = data.totalRow;
						$
								.each(
										list,
										function(i, row) {
											var tr = "";
											var index = (page.pageNumber - 1)
													* 10 + (i + 1);
											tr = "<tr><td>"
													+ index
													+ "</td><td >"
													+ (row.REAL_NAME == null ? ""
															: row.REAL_NAME)
													+ "</td><td >"
													+ (row.PROJECT_NAME == null ? ""
															: row.PROJECT_NAME)
													+ "</td><td>"
													+ (row.MOBILE_PHONE == null ? ""
															: row.MOBILE_PHONE)
													+ "</td><td>"
													+ (row.EMAIL == null ? ""
															: row.EMAIL)
													+ "</td></tr>";
											table.append(tr);
										});
						if (list.length == 0) {
							
						}
						tabPager();
						loadingEnd();
					}
				});
	}
	//判定那些用户被选中那些用户从选中状态又取消掉
	function chageChecked(obj){
		var userId=$(obj).attr('userid');
		var user_role_id=$(obj).attr('id');
		 if($(obj).is(':checked')&&user_role_id==''){
			 if(checkItems.indexOf(userId)==-1){
				 checkItems+=userId+",";
			 }
		 }else if($(obj).is(':checked')&&user_role_id!=''){
			 if(checkItems.indexOf(userId)==-1){
				 removeItems+=user_role_id+",";
			 }
		 }
	}
	
	function tabPager() {
		refashPage(page.pageNumber, page.totalPage, page.totalRow);
	}
	function refashPage(pno, total, totalRecords) {
		//初始化函数  
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
				totalRecordsBeforeText : '共',
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
</script>
</head>
<body style="overflow: hidden;">
	<div class="wrapper wrapper-content  gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
						<div class="row">
							<div class="col-sm-9 m-b-xs">
							</div>
							<div class="col-sm-3">
								<div class="input-group">
									<input type="text" id="search" placeholder="输入搜索条件"
										class="input-sm form-control"> <span
										class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"
											onclick="ajaxData();">搜索</button>
									</span>
								</div>
							</div>
						</div>
						<div class="table-responsive" id="table_content">
								<table class="gridtable  table table-striped">
									<thead>
										<tr>
											<th width="10%">序号</th>
											<th width="15%">用户名</th>
											<th width="40%">所在工程</th>
											<th width="15%">电话</th>
											<th width="20%">邮箱</th>
										</tr>
									</thead>
								</table>
								<div id="kkpager" style="width: 100%; margin: 0px auto;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$('#table_content').height(350);
	</script>
</body>
</html>