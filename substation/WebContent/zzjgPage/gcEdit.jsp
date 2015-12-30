<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<%
   String orgCode=request.getParameter("id");
   String projectId=request.getParameter("projectId");
%>
<title>首页</title>
<script type="text/javascript">
   var _menu_id=getQueryString('menu_id');
   var orgCode='<%=orgCode%>';
   var projectId='<%=projectId%>';
	$(function(){
		initOrgType();
	});
	
	function initOrgType(){
		loadingStart('加载中...');
		$.ajax({
	           url: "/org/getOrgType",
	           dataType: "json",
	           type: "POST",
	           success: function(data) {
	        	         var options="";
	        	         for(var key in data){
	        	        	 var val=key.replace(new RegExp(/\"/g),'');
	        	        	 var val=val.replace(new RegExp(/\'/g),'');
	        	        	 var text=data[key].replace(new RegExp(/\"/g),'');
	        	        	options+='<option value="'+val+'">'+text+'</option>';
	        	         }
	        	        $('#org_type').append(options);
	        			getData();
	           }
			});
	}
	
	function getData(){
		$.ajax({
           url: "/org/getOrgDataByprojectIdAndorgCode",
           dataType: "json",
           type: "POST",
           data:{
        	   orgCode:orgCode,
               projectId:projectId
           },
           success: function(data) {
                var inputs= $('form input');
                $.each(inputs,function(i,item){
               	if(!! $(item).attr('name')){
                   	 var name=$(item).attr('name').toUpperCase();
                   	 if(!!name){
                   		 $(item).val(data[name]);     
                   	 }                        		
               	}
                });
                $("#org_type").val(data["org_type".toUpperCase()]);
                $("#description").val(data["description".toUpperCase()]);
    	        loadingEnd();
           }
       });
	}

</script>
</head>
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
			<div class="panel-body"   style="height:395px;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/org/saveOrgData"  method="post">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">机构编码(<font class='hongxin'>*</font>)</label> <input type="text"    name="org_code"  id="role_code"   valType="required" 
											    onblur="validateVal(this);"  value="<%=orgCode%>"
												 class="form-control" placeholder="请输入机构编号">
												<span class="help-block"  style="display:none">
														机构编号不能为空. </span>
										</div>
									</div>
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">机构名称(<font class='hongxin'>*</font>)</label>
											 <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="org_name"      
												class="form-control" placeholder="请输入机构名称">
											<span class="help-block"  style="display:none">
														机构名称不能为空. </span>
										</div>
									</div>
									<!--/span-->
								</div>
                                <div class="row"  >
									<div class="col-sm-6 ">
									    <div class="form-group ">
											 <label class="control-label">施工单位</label>
											<select  name="org_type"   id="org_type"  class="form-control">
										</div>
									</div>
									<div class="col-sm-6 " >
										<div class="form-group">
										     <input type="hidden"     name="id"    class="form-control" >
											 <input type="hidden"     name="parent_id"    class="form-control"  >
											 <input type="hidden"     name="project_id"    class="form-control"   value="<%=projectId%>">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12 ">
										<div class="form-group">
											<label>机构描述</label>
											<textarea type="text" class="form-control"  id="description"  name="description"  rows="6"></textarea>
										</div>
									</div>
								</div>
                                
								<!--/row-->
							</div>
						</form>
						<!-- END FORM-->
					</div>
			</div>
			<div class="panel-footer"  style="min-height: 42px;padding-top: 5px;">
						<div  style="text-align: center;">
								<button type="button" class="btn btn-sm btn-primary"  onclick="back();">
									<i class="fa  fa-times "></i> 返回
								</button>
								<button type="button"  class="btn btn-sm btn-primary" onclick="saveOrUpdate()">
									<i class="fa fa-check"></i> 保存
								</button>
					  </div>
			</div>
		</div>
	</div>
</body>
</html>