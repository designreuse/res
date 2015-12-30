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
   var userId=getQueryString('userId');
   var idCard=getQueryString('idCard');
   $(function(){
	   $("input[name='id']").val(userId);
	   if(!!idCard){
		   ajaxUserInfo(idCard);		   
	   }
   });
   
   function ajaxUserInfo(idCard){
		loadingStart('加载中...');
		$.ajax({
           url: "/user/findUserByIdCard",
           data:{
           	idCard:idCard
           },
           dataType: "json",
           type: "POST",
           success: function(data) {
           	$("input[name='password']").attr('type','password');
           	var inputs= $('form input');
               $.each(inputs,function(i,item){
              	if(!! $(item).attr('name')){
                  	 var name=$(item).attr('name').toUpperCase();
                  	 if(!!name&&!!data[name]){
                  		 $(item).val(data[name]);     
                  	 }                        		
              	}
               });
               $("#sex").val(data["sex".toUpperCase()]);
               $("#description").val(data["description".toUpperCase()]);
					loadingEnd();
           	
           }
		});
	}
   function setFileName(obj){
	    $("input[name='photo']").val($(obj).val());
	 }
   function saveOrUpdate() {
		if($('#file').val()==''||$('#file').val()==null){//没用上传头像直接提交数据区数据
				$("form[name='normal']").form('submit', {
					success : function(data) {
						data = eval('(' + data + ')');
						if(data.success){
			                   window.parent.location.href =  window.parent.location.href;
			                   parent.layer.closeAll();
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
						                   window.parent.location.href = window.parent.location.href;
						                   parent.layer.closeAll();
						                }
								}
							});
			    	   }
			        }    
	             });
		}	
	}
</script>
</head>
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
			<div class="panel-body"   style="height:450px;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/user/add"  method="post"  name="normal">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">登录名(<font class='hongxin'>*</font>)</label> <input type="text"    name="user_name"    valType="required" 
											    onblur="validateVal(this);"
											    class="form-control"   placeholder="请输入登录名">
												<span class="help-block"  style="display:none">
														登录不能为空. </span>
												<input type="hidden"  class="form-control"  name="id"/>		
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">用户名(<font class='hongxin'>*</font>)</label> <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="real_name"     
												class="form-control" placeholder="请输入用户名"  >
											<span class="help-block"  style="display:none">
														用户名不能为空. </span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">身份证(<font class='hongxin'>*</font>)</label> <input type="text"  name="identity_card"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入身份证号">
											<span class="help-block"  style="display:none">
														身份证号不能为空. </span>
										</div>
									</div>
									 <div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">性别</label> 
											<select  name="sex"  
												class="form-control">
												<option value="man">男</option>
												<option value="weman">女</option>
											</select>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">电话(<font class='hongxin'>*</font>)</label> <input type="text"  name="mobile_phone"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入电话号码">
											<span class="help-block"  style="display:none">
														电话号码不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">邮箱(<font class='hongxin'>*</font>)</label> <input type="text"  name="email"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入邮箱地址">
											<span class="help-block"  style="display:none">
														邮箱地址不能为空. </span>
										</div>
									</div>
								</div>
								<div class="row">
										<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">单位(<font class='hongxin'>*</font>)</label> <input type="text"  name="corporation"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入单位">
											<span class="help-block"  style="display:none">
														单位不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">部门(<font class='hongxin'>*</font>)</label> <input type="text"  name="department"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入部门">
											<span class="help-block"  style="display:none">
														部门不能为空. </span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">职务(<font class='hongxin'>*</font>)</label> <input type="text"  name="duty"   valType="required" 
												onblur="validateVal(this);"  class="form-control"  placeholder="请输入职务">
											<span class="help-block"  style="display:none">
														职务不能为空. </span>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">上传头像</label> 
											<input type="text"  name="photo"   onclick="$('#file').click();"
												  class="form-control"  placeholder="请上传头像">
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
							<div class="form-actions right">
								<button type="button" class="btn btn-sm btn-primary"  onclick="back();">
									<i class="fa  fa-times "></i> 返回
								</button>
								<button type="button"  class="btn btn-sm btn-primary" onclick="saveOrUpdate()">
									<i class="fa fa-check"></i> 保存
								</button>
							</div>
						</form>
						<!-- END FORM-->
						 <form id="form1"  action="/user/savePhoto"   method="post" enctype="multipart/form-data"  style="display: none;">
					        <input type="file"   id="file"  name="file"   accept="image/gif, image/jpeg, image/png "  onchange="setFileName(this);"></input>
					      </form> 
					</div>
			</div>
		</div>
	</div>
</body>
</html>