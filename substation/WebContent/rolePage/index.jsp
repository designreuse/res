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
	var _menu_id = getQueryString('menu_id');
	var parent_id='-1';
	var project_id="";
	var project_name="";
	var pagePerm = {
		'create' : null,
		'update' : null,
		'delete' : null
	};//页面默认进来增删改权限都为null
	var page = {
		pageNumber : 1,
		totalPage : 0,
		totalRow : 0,
		type : 'ALL'
	};
	$(function() {
		loadingStart('加载中...');
		ajaxPagePerm();
	});
    
	function getInitTreeData(){
		$.ajax({
			url : "/role/getTreeData",
			data : {
				parentId :parent_id
			},
			dataType : "json",
			type : "POST",
			success : function(data) {
				initRoleTree(data);
			}
		});
		
	}
	
	function initRoleTree(data) {
		$('#tree').tree({
			data : data,
			onLoadSuccess:function(node, data){
				var node=$('#tree').tree('getRoot');
				$('#tree').tree('collapseAll',node.target);
				$('#tree').tree('expand',node.target);
				 $('#tree').tree('select',node.target);
			},
			onSelect: function(node){
				 parent_id=node.id;
				 ajaxData();
			}
		});

	}

	//获取页面权限
	function ajaxPagePerm() {
		$.ajax({
			url : "/permission/getPagePermByMenu",
			data : {
				menu_id : _menu_id
			},
			dataType : "json",
			type : "POST",
			success : function(data) {
				$.each(data, function(i, item) {
					pagePerm[item.CODE] = item.CODE;
				});
				//通过pagePerm来设置添加样式的控制
				if (pagePerm['create'] != 'create') {
					$('#add').attr('disabled', 'disabled');
					$('#add').attr('onclick', null);
				}
				getInitTreeData();
			}
		});
	}

	function ajaxData() {
		$
				.ajax({
					url : "/role/index",
					data : {
						pageNumber : page.pageNumber,
						pageSize : _pageSize,
						roleName : $('#search').val(),
						parentId:parent_id
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
											var update = "<span style='color:#aaa'>编辑</span>";
											var del = "<span style='color:#aaa'>删除</span>";
											var fpUser= "<a href='javascript:void(0)'   onclick='fpRole(\""
												+ row.ID
												+ "\")'>"+(row.CNT == null ? "0"
														: row.CNT)+"</a>";
											var qx= "<a href='javascript:void(0)'   onclick='fpQx(\""
												+ row.ID
												+ "\")'>分配权限</a>";
											if(row.DESCRIPTION=='工种'){
												fpUser="---";
												qx="---";
											}
											if (pagePerm['update'] == 'update') {
												update = "<a href='javascript:void(0)'   onclick='editRole(\""
														+ row.ID
														+ "\")'>编辑</a>";
											}
											if (pagePerm['delete'] == 'delete') {
												del = "<a href='javascript:void(0)'   onclick='deleteRole(\""
														+ row.ID
														+ "\")'>删除</a>";
											}
											
											tr = "<tr><td>"
													+ index
													+ "</td><td >"
													+ (row.ROLE_CODE == null ? ""
															: row.ROLE_CODE)
													+ "</td><td>"
													+ (row.ROLE_NAME == null ? ""
															: row.ROLE_NAME)
													+ "</td><td>"
													+ (row.DESCRIPTION == null ? ""
															: row.DESCRIPTION)
													+ "</td><td>"
													+ fpUser
													+ "</td><td>" + update
													+ "&nbsp;&nbsp;" + del
													+ "&nbsp;&nbsp;" + qx
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
	//新增角色
	function newRole() {
		openLayerFrame("新增角色",'/rolePage/gcNew.jsp?menu_id=' + _menu_id+"&roleId="+parent_id,null,null);
	}
    
	//编辑角色
	function editRole(roleId) {
		openLayerFrame("编辑角色",'/rolePage/gcEdit.jsp?menu_id=' + _menu_id+"&roleId="+roleId,null,null);
	}
	//分配用户
    function fpRole(roleId){
    	layer.open({
            type: 2,
            title: '已授权用户数量',
            shadeClose: true,
            shade: false,
            maxmin: false, //开启最大化最小化按钮
            area: ['800px', '450px'],
            content: '/rolePage/fpRole.jsp?roleId=' + roleId
        });
    }
	//分配权限
	function fpQx(roleId){
		layer.open({
            type: 2,
            title: '菜单权限分配',
            shadeClose: true,
            shade: false,
            maxmin: false, //开启最大化最小化按钮
            area: ['800px', '450px'],
            content: '/rolePage/fpQx.jsp?roleId=' + roleId
        });
	}
	
	function deleteRole(roleId) {
		layer.confirm('确认删除吗？', {
			btn : [ '确定', '取消' ]
		}, function(index) {
			$.ajax({
				url : "/role/deleteById",
				data : {
					id : roleId
				},
				dataType : "json",
				type : "POST",
				success : function(data) {
					if (data.success) {
						layer.close(index);
						ajaxData();
					} else {
						layer.alert('删除失败！');
					}
				}
			});
		}, function() {
			return;
		});

	}
</script>
</head>
<body style="overflow: hidden;">
	<div class="wrapper wrapper-content  gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>角色管理</h5>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-sm-9 m-b-xs">
								<button type="button" id="add" class="btn btn-sm btn-primary "
									onclick="newRole();">新增</button>
							</div>
							<div class="col-sm-3">
								<div class="input-group">
									<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control"  onkeyup="$('.clear').show();" ><a class="fa fa-times-circle clear"   href="javascript:void(0)"  onclick="$('#search').focus();$('#search').val('');$(this).hide();"></a> 
									 <span
										class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"
											onclick="ajaxData();">搜索</button>
									</span>
								</div>
							</div>
						</div>
						<div class="table-responsive" id="table_content">
							<div class="col-sm-2 m-b-xs">
								<ul id="tree"></ul>
							</div>
							<div class="col-sm-10 m-b-xs">
								<table class="gridtable  table table-striped">
									<thead>
										<tr>
											<th width="5%">序号</th>
											<th width="15%">角色编码</th>
											<th width="15%">角色名称</th>
											<th width="15%">角色说明</th>
											<th width="15%">已授权用户数量</th>
											<th width="36%">操作</th>
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
	</div>
	<script type="text/javascript">
		$('#table_content').height($(window).height() - 100);
	</script>
</body>
</html>