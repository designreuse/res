<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<script>
		var _pageSize = 10;
		var params={};
		var selectParam={
				startDate:"",
				endDate:"",
				orgId:"",
				wzContent:"",
				wzPerson:'${param.wzPerson}'==null?"":'${param.wzPerson}'
		       };
		var _project_id=parent._$comboboxObj.id;
		var page={pageNumber:1,totalPage:0,totalRow:0,type:'ALL' };
		$(function() {
			  initParams();
		      initTools();
		      $('#picIframe').load(function(){
			      ajaxData();
		      });
		});
	 function initParams(){
	    	params={
	    			projectId:_project_id,
	    			startDate:selectParam.startDate,
		    		endDate:selectParam.endDate,
		    		orgId:selectParam.orgId,
		    		wzContent:selectParam.wzContent,
		    		wzPerson:selectParam.wzPerson,
		    		pageNumber : page.pageNumber,
		    		totalPage : page.totalPage,
		    		totalRow : page.totalRow,
		    		type : 'pic'
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
	            	console.info(data);
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
	function ajaxData(flag) {
		 initParams();		
		loadingStart('加载中...');
		$
				.ajax({
					url : "/illegal/getAllByPage",
					data:params,
					dataType : "json",
					type : "POST",
					success : function(data) {
						var list = data.list;
						page.pageNumber = data.pageNumber;
						page.totalPage = data.totalPage;
						page.totalRow = data.totalRow;
						picIframe.window.loadImg(flag,list);
						loadingEnd();
					}
				});
	}
	
	
	function getPhoneInfo(id) {
		showImg(id);
	}

     
	//查询
	function onSeach() {
		selectParam.startDate = $("#startDate").val();
		selectParam.endDate = $("#endDate").val();
		selectParam.orgId = $("#org option:selected").val();
		selectParam.wzContent = $("#wzContent").val();
		selectParam.wzPerson = $("#wzPerson").val();
		page.pageNumber =1;
		      ajaxData(true);
	}
</script>
</head>
<body style="overflow: hidden;">
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
										<td><input type="text" size="35" id="wzPerson" />
											<button type="button" class="btn btn-sm btn-primary"
												onclick="onSeach()">搜索</button></td>
									</tr>
								</table>
							</div>
						</div>
						<div class="row">
							     <div class="col-sm-10 m-b-xs"></div>
							    <div class="col-sm-2 m-b-xs"  style="text-align: center;"><a  href="/illegal/geTableJsp">切换到列表</a></div>
							</div>
						<div class="table-responsive"  id="table_content"  style="overflow: hidden;">
							<iframe id="picIframe"   name="picIframe"   src="../masonry/waterFull2/index.jsp"    frameborder="0"  width="100%" height="100%"  ></iframe>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript">
		$('#table_content').height($(window).height()-170);
</script>
</body>
</html>