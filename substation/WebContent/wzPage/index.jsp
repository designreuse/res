<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<link rel="stylesheet" href="/pictureSan/lightBox/css/lightbox.css" media="screen"/>
<script src="/pictureSan/lightBox/js/lightbox-2.6.min.js"></script>
<title>首页</title>
<script>
	var _pageSize = 10;  
	var params={};
	var _menu_id = getQueryString('menu_id');
	var selectParam={
			startDate:"",
    		endDate:"",
    		orgId:"", 
    		wzContent:"",
    		wzPerson:'${param.wzPerson}'==null?"":'${param.wzPerson}'
	       };
	var _project_id=parent._$comboboxObj.id;
	var page={pageNumber:1,totalPage:0,totalRow:0,type:'ALL' };
	var pagePerm = {
			'create':null,
			'delete' : null, 
			'submit':null,
			'export':null
		};//页面默认进来增删改权限都为null
	$(function() {
		  initParams();
          initTools();
          ajaxPagePerm();
	});
	 function initParams(){
	    	params={
	    			projectId:_project_id,
		    		startDate:selectParam.startDate,
		    		endDate:selectParam.endDate,
		    		orgId:selectParam.orgId,
		    		wzContent:$.trim(selectParam.wzContent),
		    		wzPerson:$.trim(selectParam.wzPerson),
		    		pageNumber : page.pageNumber,
		    		totalPage : page.totalPage,
		    		totalRow : page.totalRow,
		    		isShowAll:pagePerm['submit'],
		    		type : 'table'
         	};
	    }
	 /**初始化工具条*/
	    function initTools(){
	    	$.ajax({
	    		url:'/org/getOrgListByProId', 
				type:'post',
				dataType : 'json',
				data:{projectId:_project_id},
	            success: function(data) {
	            	if(data.length>0){
	            		var html="<option value='' selected='selected' >全部</option>";
	            		$.each(data,function(i,item){
	            			html+="<option value='"+item.ORG_CODE+"'>"+item.ORG_NAME+"</option>";
	            		});
	            		$("#org").append(html);
	            	}
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
					console.info(data);
					$.each(data, function(i, item) {
						pagePerm[item.CODE] = item.CODE;
					});
					if(pagePerm['submit']=='submit'){
						$('#subMit').show();
					}else{
						$('#subMit').hide();
					}
					ajaxData();
				}
			});
		}
	  
	function ajaxData() {
    	initParams();			
		loadingStart('加载中...');
		$.ajax({
					url : "/illegal/getAllByPage",
					data:params,
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
						$.each(
										list,
										function(i, row) {
											tr = "";
											var del = "<span style='color:#aaa'>删除</span>";
											var exportWord="<span style='color:#aaa'>导出</span>";
											var index = (params.pageNumber - 1)* 10 + (i + 1);
											if (pagePerm['delete'] == 'delete') {
												del = "<a href='javascript:void(0)'   onclick='deleteRow(\""
														+ row.ID
														+ "\")'>删除</a>";
											}
											if (pagePerm['export'] == 'export') {
												exportWord ="<a href='javascript:void(0)' onclick='exportWord(\""+ row.ID+ "\")'>导出word</a>";
											}
											if(pagePerm['create'] == 'create'){
												index="<input type='checkbox' value='"+row.ID+"'/>";
											}
											tr = "<tr><td>"+index+"</td>"
													+ "<td>"
													+ (row.VIOLATE_CODE==null?"":row.VIOLATE_CODE)
													+ "</td><td>"
													+ (row.VIOLATE_CONTENT==null?"":row.VIOLATE_CONTENT)
													+ "</td><td>"
													+ (row.VIOLATE_FINE==null?"":row.VIOLATE_FINE)
													+ "</td><td>"
													+ (row.ORG_NAME==null?"":row.ORG_NAME)
													+ "</td><td>"
													+ (row.USERNAME==null?"":row.USERNAME)
													+ "</td><td>"
													+ (row.CREATE_TIME==null?"":row.CREATE_TIME)
													+ "</td><td>"
													+ (row.REAL_NAME==null?"":row.REAL_NAME)
													+ "</td>";
													if( row.CNT==0){
													  tr+="<td>"+ row.CNT+ "</td>";														
													}else{
													  tr+="<td><a href='javascript:void(0)'  onclick='getPhoneInfo(\""+ row.ID + "\")'>"+ row.CNT+ "</a></td>";														
													}
													if(row.VIOLATE_STATUS=='1'){
														tr+="<td><i class='fa fa-check' style='color:#18a689'></td>"	;													
													}else{
														tr+="<td><i class='fa fa-times' style='color:red'></td>"	;
													}
													tr+="<td>"+del+"&nbsp;&nbsp;"+exportWord+"</td>";
													tr+="</tr>";
											table.append(tr);
										});
						if (list.length == 0) {
							tr = "<tr><tdcolspan='11'>没有相关数据</td></tr>";
							table.append(tr);
						}
						tabPager();
						loadingEnd();
					}
				});
	}
	
	function deleteRow(id){
		layer.confirm('确认删除吗？', {
		    btn: ['确定','取消'] 
		}, function(index){
			$.ajax({
	            url: "/illegal/delete",
	            data:{
	            	id:id
	            },
	            dataType: "json",
	            type: "POST",
	            success: function(data) {
	            	if(data.success){
	            		layer.close(index);
		            	ajaxData();
	            	}else{
	            		layer.alert('删除失败！');
	            	}
	            }
	        });
		}, function(){
		   return;
		});
	}
	
	function tabPager(){
    	refashPage(page.pageNumber,page.totalPage,page.totalRow);
    }
	function getPhoneInfo(id) {
		showImg(id);
	}

	function initPhone() {
		$(".imgtext").hide();
		$(".imgbox").hover(function() {
			$(".imgtext", this).slideToggle(500);
		});
	}
	function showImg(wzId) {
		$.ajax({
            url: "/illegal/getIllPhoneByillId",
            dataType: "json",
            data:{wzId:wzId},
            type: "post",
            success: function(data) {
            	if(data.length>0){
            		$("#container").empty();
            		var html="";
            		$.each(data,function(i,item){
            			html+='<a  href="/pictureSan/file.jsp?fileName='+item.FILE_PATH+'" data-lightbox="set"   title=""><img src="/pictureSan/file.jsp?fileName='+item.FILE_PATH+'"></a>';
            		});
         	       $("#container").append(html);
        	       //触发click事件
        	       $('#container a').eq(0).trigger("click");
            	}
            }
    	}); 
	}
     
	//查询
	function onSeach() {
		selectParam.startDate = $("#startDate").val();
		selectParam.endDate = $("#endDate").val();
		selectParam.orgId = $("#org option:selected").val();
		selectParam.wzContent = $("#wzContent").val();
		selectParam.wzPerson = $("#wzPerson").val();
		page.pageNumber =1;
		ajaxData();
	}
	
	function saveWzInfo(){
		var checkedIds="";
		$("input[type=checkbox]:checked").each(function(i,ck){
			checkedIds+=$(ck).val()+",";
		});
		if(checkedIds=="") return;
		$.ajax({
            url: "/illegal/submitIllRecord",
            dataType: "json",
            data:{ids:checkedIds},
            type: "post",
            success: function(data) {
            	if(data.success){
            		ajaxData();
            	}
            }
    	}); 
	}
	
	function exportWord(illId){
// 		    layer.alert("正在实现中……");
		    var form = $("<form>");
	        form.attr('style', 'display:none');
	        form.attr('target', '');
	        form.attr('method', 'post');
	        form.attr('action', '/illegal/createWordByIllId');
	        var input1 = $('<input>');
	        input1.attr('type', 'hidden');
	        input1.attr('name', 'illId');
	        input1.attr('value', illId);
	        $('body').append(form);
	        form.append(input1);
	        form.submit();
	        form.remove();
	}
</script>
</head>
<body  style="overflow: hidden;">
	<div class="wrapper wrapper-content  gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>违章</h5>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-sm-12 m-b-xs">
								<table style="height: 70px; border: 0px; padding-left: 10px;"
									class="FormtableCon">
									<tr style="height: 35px;">
									   <td><label> 违章时间:&nbsp;</label>&nbsp;</td>
										<td><input type="text" name="create_time" class="Wdate"
											size="19" id="startDate"
											onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />&nbsp;至&nbsp;
											<input type="text" name="create_time" class="Wdate" size="19"
											id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
										</td>
										<td><label>&nbsp;&nbsp;&nbsp;组织机构:&nbsp;</label></td>
										<td><select id="org" style="width: 250px">
										</select></td>
									</tr>
									<tr style="height: 35px;">
									    <td><label> 违章内容:&nbsp;</label>&nbsp;</td>
										<td><input
											id="wzContent" type="text" size="47" /></td>
										<td><label>&nbsp;&nbsp;&nbsp;违章人:&nbsp;</label></td>
										<td><input type="text" size="37" id="wzPerson" />
											<button type="button" class="btn btn-sm btn-primary"
												onclick="onSeach()">搜索</button>
												<button type="button"  id="subMit" class="btn btn-sm btn-primary"
												onclick="saveWzInfo()">提交</button></td>
									</tr>
								</table>
							</div>
							<div class="row">
							     <div class="col-sm-10 m-b-xs"></div>
							    <div class="col-sm-2 m-b-xs"  style="text-align: center;"><a  href="/illegal/getPicJsp">切换到照片墙</a></div>
							</div>
						</div>
						<div class="table-responsive"  id="table_content" >
							<table class="gridtable  table table-striped">
								<thead>
									<tr>
									    <th width="4%">序号</th>
										<th width="5%">违章编码</th>
										<th width="20%">违章内容</th>
										<th width="7%">违章罚金</th>
										<th width="15%">组织机构</th>
										<th width="8%">违章人</th>
										<th width="10%">违章时间</th>
										<th width="7%">拍摄人</th>
										<th width="7%">违章照片</th>
										<th width="5%">状态</th>
										<th width="10%">操作</th>
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
<div id="container" style="display: none;"></div>
	<script type="text/javascript">
	 $('#table_content').height($(window).height()-180);
</script>
</body>
</html>