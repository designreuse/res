<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
   String userId=request.getParameter("userId");
%>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<title>首页</title>
<script type="text/javascript">
      //验证两次密码是否正确
      function confirmPwd(obj){
    	  var pwd1=$("input[name='newPassword']").val();
    	  var pwd2=$(obj).val();
    	  if(pwd1!=pwd2){
    		  $(obj).parent().addClass('has-error');
    		  $(obj).next().text("两次密码不一致").show();
  			  $(obj).focus();	
    	  }
      }
    //表单保存或者更新
  	function saveOrUpdate() {
  		$('form').form('submit', {
  			success : function(data) {
  				data = eval('(' + data + ')');
                  if(data.success){
                     parent.layer.closeAll();
                  }else{
                  	layer.alert(data.message);
                  }
  			}
  		});
  	}
</script>
</head>
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
			<div class="panel-body"   style="height:450px;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/user/cpassword"  method="post"  name="normal">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">初始密码(<font class='hongxin'>*</font>)</label> <input type="password"    name="oldPassword"    valType="required" 
											    onblur="validateVal(this);"
											    class="form-control"   placeholder="请输入初始密码">
												<span class="help-block"  style="display:none">
														初始密码不能为空. </span>
												<input  type="hidden"  name="userId"   value="<%=userId%>">		
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">新密码(<font class='hongxin'>*</font>)</label> <input type="password"    name="newPassword"    valType="required" 
											    onblur="validateVal(this);"
											    class="form-control"   placeholder="请输入新密码">
												<span class="help-block"  style="display:none">
														新密码不能为空. </span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">再次确认(<font class='hongxin'>*</font>)</label> <input type="password"       valType="required" 
											    onblur="validateVal(this);confirmPwd(this);"
											    class="form-control"   placeholder="请再次确认密码">
												<span class="help-block"  style="display:none">
														再次确认密码不能为空. </span>
										</div>
									</div>
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
					</div>
			</div>
		</div>
	</div>
</body>
</html>