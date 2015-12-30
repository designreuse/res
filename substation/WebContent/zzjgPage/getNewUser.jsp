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
<script type="text/javascript">
   var _menu_id=getQueryString('menu_id');
   var projectId=getQueryString('projectId');
   var organizationId=getQueryString('orgId');
   var mobilePhone=getQueryString('mobilePhone');
   $(function(){
	   $("input[name='project_id']").val(projectId);
	   $("input[name='organization_id']").val(organizationId);
	   //获取角色列表
	   loadingStart('加载中...');
		$.ajax({
           url: "/role/getAllRole",
           dataType: "json",
           type: "POST",
           success: function(data) {
        	         var options="";
        	        $.each(data,function(i,item){
        	        	options+='<option value="'+item.ID+'">'+item.ROLE_NAME+'</option>';
        	        });
        	        $('#role_id').append($(options));
        	        getDutyList();//获取职务列表
           }
		});

   });
   
 //获取职务列表
   function getDutyList(){
		$.ajax({
	           url: "/role/getAllDuty",
	           dataType: "json",
	           type: "POST",
	           success: function(data) {
	        	         var options="";
	        	        $.each(data,function(i,item){
	        	        	options+='<option value="'+item.ROLE_CODE+'">'+item.ROLE_NAME+'</option>';
	        	        });
	        	        $('#duty').append($(options));
	        	        loadingEnd();
	           	        if(mobilePhone!=null&&mobilePhone!=''){
	           	        	$("#orgCode").show();
	           	        	getOrgList();
	           	        }
	           }
			});
   }
    //获取组织机构列表
    function getOrgList(){
    	$.ajax({
	           url: "/org/getOrgByProjectIdExpPidNULL",
	           dataType: "json",
	           type: "POST",
	           data:{
	        	   projectId:projectId
	           },
	           success: function(data) {
	        	         var options="";
	        	        $.each(data,function(i,item){
	        	        	options+='<option value="'+item.ORG_CODE+'">'+item.ORG_NAME+'</option>';
	        	        });
	        	        $('#org_code').append($(options));
	           	        if(mobilePhone!=null&&mobilePhone!=''){
	           	        	ajaxUserInfo(mobilePhone);
	           	        }
	           }
			});
    }
	function saveOrUpdate() {
		if($('#file').val()==''||$('#file').val()==null){//没用上传头像直接提交数据区数据
				$("form[name='normal']").form('submit', {
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
			
		}else{
			//先保存图片然后再保存数据
			 $('#form1').form('submit', {    
			       success: function(data){
			    	   data = eval('('+data+')');
			    	   if(data.success){
			    		   $("form[name='normal']").form('submit', {
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
			        }    
	             });
		}	
	}
	
	function getUserInfoByIdCard(obj){
		if($(obj).val()!=''){
			var moilePhone=$.trim($(obj).val());	
			ajaxUserInfo(moilePhone);
		}
	}
	function ajaxUserInfo(mobilePhone){
		 loadingStart('加载中...');
		$.ajax({
            url: "/user/findUserByIdCard",
            data:{
            	telephone:$.trim(mobilePhone),
            	projectId:projectId
            },
            dataType: "json",
            type: "POST",
            success: function(data) {
            	if(data.MOBILE_PHONE!=""&&data.MOBILE_PHONE!=null){
	            	$("input[name='password']").attr('type','password');
	            	var inputs= $("form input[name!='sex']");
	                $.each(inputs,function(i,item){
	               	if(!! $(item).attr('name')){
	                   	 var name=$(item).attr('name').toUpperCase();
	                   	  if(!!name&&!!data[name]){
	                   		  //组织机构做一个特殊处理
	                   		  if(name=="organization_id".toUpperCase()){
	                   			  if(data[name]!=null&&data[name]!=""){
	                   				    $(item).val(data[name]);     
	                   				    $("#org_code").val(data[name]);
	                   			  }  
	                   		  }else{
		                   		 $(item).val(data[name]);     	                   			  
	                   		  }
	                   	 }                        		
	               	}
	                });
	                $("#role_id").val(data["role_id".toUpperCase()]);
	                $("#duty").val(data["duty".toUpperCase()]);
	                $("#description").val(data["description".toUpperCase()]);
	                $("#"+data["sex".toUpperCase()]).attr("checked", "checked");
	                if(projectId!=data["PROJECT_ID"]){
	              		 //判断当前项目和库里边的项目id是否一个，不一样则修改项目id
	              		 $("input[name='project_id']").val(projectId);
	              		 $("input[name='ru_id']").val("");
// 	              		$("input[name='password']").val("123456");
	              	 }	
            	}else{
            		//没找到用户则新增加密密码
            		$("input[name='isSetPassword']").val('1');//重置密码标志
            	}
					loadingEnd();
            	
            }
		});
	}
	//重置密码
	function reSetPassWord(obj){
		$("input[name='password']").attr('type','text');
		$("input[name='password']").val("123456");
		validateVal($("input[name='password']"));
		$("input[name='isSetPassword']").val('1');//重置密码标志
	}
	//修改密码的时候把密码框改为文本框
	function setInput4Text(obj){
// 		$("input[name='password']").attr('type','text');
	}
	
	 function setFileName(obj){
		    $("input[name='photo']").val($(obj).val());
	 }
	 
	 //如果修改了组织机构重新设置orgId
	 function changeOrg(obj) {
		 var orgCode=$("#org_code  option:selected").val();
		 $("input[name='organization_id']").val(orgCode);
	 }
</script>
</head>
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
			<div class="panel-body"   style="height:395px;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/user/add"  method="post"  name="normal">
							<div class="form-body">
							<!-- 隐藏区域 -->
							<div class="row">
									<div class="col-sm-6"   style="display: none;">
										<div class="form-group">
											<input  name="id"  id="primId" />
											<input  name="state"   value="0"/>
											<input  name="project_id" />
											<input  name="organization_id" />
											<input  name="ru_id" />
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">手机号(<font class='hongxin'>*输入手机号码匹配用户</font>)</label> <input type="text"  name="mobile_phone"   valType="required" 
												onblur="validateVal(this);getUserInfoByIdCard(this);"  class="form-control"  placeholder="请输入手机号码">
											<span class="help-block"  style="display:none">
														手机号码不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group ">
										<label class="control-label">登录名(<font class='hongxin'>*</font>)</label> <input type="text"    name="user_name"    valType="required" 
											    onblur="validateVal(this);"
											    class="form-control"   placeholder="请输入登录名">
												<span class="help-block"  style="display:none">
														登录不能为空. </span>
										
										</div>
									</div>
								</div>
								<div class="row">
								   <div class="col-sm-6">
										<div class="form-group">
										   <label class="control-label">姓名(<font class='hongxin'>*</font>)</label> <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="real_name"     
												class="form-control" placeholder="请输入用户名"  >
											<span class="help-block"  style="display:none">
														姓名不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">密码(<font class='hongxin'>*</font>)&nbsp;<a href="javascript:void(0)"  onclick="reSetPassWord(this);">重置密码(密码:123456)</a></label> <input type="password"  name="password"  onfocus="setInput4Text(this)" valType="required" 
												onblur="validateVal(this);"   class="form-control"  placeholder="请输入密码"  value="123456">
											<span class="help-block"  style="display:none">
														密码不能为空. </span>
												<input name="isSetPassword"  type="hidden"   value="0">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">性别</label> </br>
											   &nbsp;&nbsp;&nbsp;&nbsp;<input id="man"  type="radio"   name="sex"   checked="checked"    value="man"  > 男
											   &nbsp;&nbsp;&nbsp;&nbsp;<input id="weman"  type="radio"   name="sex"    value="weman"  > 女
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group ">
										   <label class="control-label">身份证</label> <input type="text"  name="identity_card"   
												  class="form-control"  placeholder="请输入身份证号">

											
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">邮箱(<font class='hongxin'>*</font>)</label> <input type="text"  name="email"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入邮箱地址">
											<span class="help-block"  style="display:none">
														邮箱地址不能为空. </span>
										</div>
									</div>
										<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">单位(<font class='hongxin'>*</font>)</label> <input type="text"  name="corporation"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入单位">
											<span class="help-block"  style="display:none">
														单位不能为空. </span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">部门(<font class='hongxin'>*</font>)</label> <input type="text"  name="department"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入部门">
											<span class="help-block"  style="display:none">
														部门不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">职务</label>
											  <select  name="duty"   id="duty"  class="form-control">
											</select>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">角色</label>
											<select  name="role_id"   id="role_id"
												class="form-control">
											</select>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">上传头像</label> 
											<input type="text"  name="photo"   onclick="$('#file').click();"
												  class="form-control"  placeholder="请点击输入框选择头像文件上传">
										</div>
									</div>
								</div>
								<div class="row"  id="orgCode"  style="display: none;">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">组织机构</label>
											<select    id="org_code"   onchange="changeOrg(this);"
												class="form-control">
											</select>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">专业</label>
											<input type="text"  name="specialty"   
												  class="form-control"  placeholder="请输入专业">
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">分管</label>
											<input type="text"  name="part_manage"   
												  class="form-control"   placeholder="请输入分管">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12 ">
										<div class="form-group">
											<label>描述</label>
											<textarea type="text" class="form-control"  id="description"  name="description"  rows="3"></textarea>
										</div>
									</div>
								</div>

								<!--/row-->
							</div>
							<br/>
						</form>
						 <form id="form1"  action="/user/savePhoto"   method="post" enctype="multipart/form-data"  style="display: none;">
					        <input type="file"   id="file"  name="file"   accept="image/gif, image/jpeg, image/png "  onchange="setFileName(this);"></input>
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