<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />

<script>
	var _pageSize = 10;
	var projectObj = parent._$comboboxObj;
	var params={
			projectId:projectObj.id,
			inOutName:null,
			roleName:null,
			inStartDate:null,
			inEndDate:null,
			outStartDate:null,
			outEndDate:null
	};
	
	var page = {
		pageNumber : 1,
		totalPage : 0,
		totalRow : 0,
		type : 'ALL'
	};
	$(function() {
		ajaxData();
	});
	function ajaxData() {
		loadingStart('加载中...');
		$
				.ajax({
					url : "/inout/index",
					data : {
						pageNumber : page.pageNumber,
						pageSize : _pageSize,
						projectId:params.projectId,
						inOutName:params.inOutName,
						roleName:params.roleName,
						inStartDate:params.inStartDate,
						inEndDate:params.inEndDate,
						outStartDate:params.outStartDate,
						outEndDate:params.outEndDate
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
													+ "</td><td>"
													+ (row.REAL_NAME == null ? ""
															: row.REAL_NAME)
													+ "</td><td>"
													+ (row.ROLE_NAME == null ? ""
															: row.ROLE_NAME)
													+ "</td><td>"
													+ (row.IN_TIME == null ? ""
															: row.IN_TIME)
													+ "</td><td>"
													+ (row.OUT_TIME == null ? ""
															: row.OUT_TIME)
													+ "</td></tr>";
											table.append(tr);
										});
						if (list.length == 0) {
							tr = "<tr><tdcolspan='5'>没有相关数据</td></tr>";
							table.append(tr);
						}
						tabPager();
						loadingEnd();
					}
				});
	}
	//查询
	function onSeach() {
		params.inOutName = $.trim($("#real_name").val());
		params.roleName = $.trim($("#role_name").val());
		params.inStartDate = $("#in_startDate").val();
		params.inEndDate = $("#in_endDate").val();
		params.outStartDate= $("#out_startDate").val();
		params.outEndDate = $("#out_endDate").val();
		page.pageNumber =1;
		ajaxData();
	}
</script>
</head>
<body style="overflow: hidden;">
   <div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>进出站</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                         <div class="col-sm-12 m-b-xs">
								<table style="height: 70px; border: 0px; padding-left: 10px;"
									class="FormtableCon">
									<tr style="height: 35px;">
									   <td><label> 进站时间:&nbsp;</label>&nbsp;</td>
										<td><input type="text"  class="Wdate"
											size="19" id="in_startDate"
											onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />&nbsp;至&nbsp;
											<input type="text"   class="Wdate" size="19"
											id="in_endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
										</td>
										<td><label> 出站时间:&nbsp;</label>&nbsp;</td>
										<td><input type="text"    class="Wdate"
											size="19" id="out_startDate"
											onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />&nbsp;至&nbsp;
											<input type="text"    class="Wdate" size="19"
											id="out_endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
										</td>
									</tr>
									<tr style="height: 35px;">
									    <td><label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;人员:&nbsp;</label>&nbsp;</td>
										<td><input
											id="real_name" type="text" size="47" /></td>
										<td><label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;角色:&nbsp;</label></td>
										<td><input type="text" size="35" id="role_name" />
											<button type="button" class="btn btn-sm btn-primary"
												onclick="onSeach()">搜索</button></td>
									</tr>
								</table>
							</div>
                      </div>
                      <div class="table-responsive"   id="table_content"  >
                               <table class="gridtable  table table-striped">
							<thead>
								<tr>
									<th width="10%">序号</th>
									<th width="15%">人员名称</th>
									<th width="20%">角色</th>
									<th width="20%">进站时间</th>
									<th width="20%">出站时间</th>
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
    $('#table_content').height($(window).height()-100);
</script>
</body>
</html>