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
   String roleId=request.getParameter("roleId");
%>
<title>首页</title>
<script type="text/javascript">
   var _menu_id=getQueryString('menu_id');
   var roleId=getQueryString('roleId');
   $(function(){
		getData();
	});
	
	function getData(){
		$.ajax({
           url: "/role/getDataById",
           dataType: "json",
           type: "POST",
           data:{
        	   roleId:roleId
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
                $("#role_type").val(data["role_type".toUpperCase()]);
                $("#description").val(data["description".toUpperCase()]);
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
						<form class="horizontal-form"  action="/role/saveData"  method="post">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">角色编号(<font class='hongxin'>*</font>)</label> <input type="text"    name="role_code"  id="role_code"   valType="required" 
											    onblur="validateVal(this);"
												id="firstName" class="form-control" placeholder="请输入角色编号">
												<span class="help-block"  style="display:none">
														角色编号不能为空. </span>
										</div>
									</div>
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">角色名称(<font class='hongxin'>*</font>)</label> <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="role_name"      id="role_name"  
												class="form-control" placeholder="请输入角色名称">
											<span class="help-block"  style="display:none">
														角色名称不能为空. </span>
										</div>
									</div>
									<!--/span-->
								</div>
								<div class="row">
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">角色类型</label> <select  name="role_type"  id="role_type" 
												class="form-control">
												<option value="WORKTYPE">WORKTYPE</option>
												<option value="PROJECT">PROJECT</option>
												<option value="SYSTEM">SYSTEM</option>
											</select>
										</div>
									</div>
										<div class="col-sm-6">
										<div class="form-group "   style="display: none;">
											<label class="control-label"  ></label> 
											<input  type="text"    name="parent_id"  class="form-control" />
											<input  type="text"    name="id"  id="id" class="form-control" />
										</div>
									</div>
															    
									<!--/span-->
								</div>

								<div class="row">
									<div class="col-sm-12 ">
										<div class="form-group">
											<label>角色描述</label>
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