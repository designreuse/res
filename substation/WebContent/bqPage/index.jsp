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
					url : "/tag/index",
					data : {
						pageNumber : page.pageNumber,
						pageSize : _pageSize,
						tagName : $.trim($('#search').val())
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
													+ (row.TAG_MAC == null ? ""
															: row.TAG_MAC)
													+ "</td><td>"
													+ (row.TAG_NAME == null ? ""
															: row.TAG_NAME)
													+ "</td><td>"
													+ (row.TAG_TYPE == null ? ""
															: row.TAG_TYPE)
													+ "</td><td>"
													+ (row.MANUFACTURER == null ? ""
															: row.MANUFACTURER)
													+ "</td><td><a href='javascript:getUserInfo(\""
													+ row.USER_ID
													+ "\")'>"
													+ (row.REAL_NAME == null ? ""
															: row.REAL_NAME)
													+ "</a></td><td>"
													+ (row.SHORT_NAME == null ? ""
															: row.SHORT_NAME)
													+ "</td><td>"
													+ (row.DESCRIPTION == null ? ""
															: row.DESCRIPTION)
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

	function getUserInfo(userId) {
		var projectId = parent._$comboboxObj.id;
		parent.initIframePage('/user/userInfo/userId='+userId+"&projectId="+projectId);
	}
</script>
</head>
<body style="overflow: hidden;">
   <div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>标签库</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-9 m-b-xs">
                          </div>
                          <div class="col-sm-3">
                               <div class="input-group">
										<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control"  onkeyup="$('.clear').show();" ><a class="fa fa-times-circle clear"   href="javascript:void(0)"  onclick="$('#search').focus();$('#search').val('');$(this).hide();"></a> 
										<span class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"  onclick="ajaxData();"> 搜索</button>
										</span>
							</div>
                          </div>
                      </div>
                      <div class="table-responsive"   id="table_content"  >
                               <table class="gridtable  table table-striped">
							<thead>
								<tr>
									<th width="5%">序号</th>
									<th width="15%">标签MAC</th>
									<th width="10%">标签名称</th>
									<th width="10%">标签类型</th>
									<th width="10%">生产厂家</th>
									<th width="15%">使用人员</th>
									<th width="30%">所在项目</th>
									<th width="5%">说明</th>
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