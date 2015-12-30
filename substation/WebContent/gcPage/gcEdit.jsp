<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
  <%
   String gcId=request.getParameter("gcId");
%>
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
		var gcId='<%=gcId%>';
		$(function(){
			getProjectType();
		});
	 	//初始化工程类型
	    function getProjectType(){
			       loadingStart('加载中...');
					$.ajax({
			           url: "/param/getProjetType",
			           dataType: "json",
			           type: "POST",
			           success: function(data) {
			           	 if(data.length==1){
			           		 var typeArr=eval('(' + data[0].PARAM_VALUE + ')');
			           		 if(typeArr.length==1){
			           			 var typeObj=typeArr[0];
			           			 var html="";
			           			 for(var key in typeObj){
			           				 html+='&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+key+'"  type="radio"   name="project_type"    value="'+key+'"  >'+typeObj[key];
			           			 }
			           			 $('#projectType').append(html);
			           		 }
			           	 }
			 			getData();
			           }
			   	});
	    }
		function getData(){
			$.ajax({
	            url: "/project/getDataById",
	            dataType: "json",
	            type: "POST",
	            data:{
	            	gcId:gcId
	            },
	            success: function(data) {
                     var inputs= $("form input[type='text']");
                     $.each(inputs,function(i,item){
                    	if(!! $(item).attr('name')){
                        	 var name=$(item).attr('name').toUpperCase();
                        	 if(!!name){
                        		 $(item).val(data[name]);     
                        	 }                        		
                    	}
                     });
                     $("#"+data["project_type".toUpperCase()]).attr("checked", "checked");
                     $("#description").val(data["description".toUpperCase()]);
                     $("#id").val(data["ID"]);
    	           	 loadingEnd();
	            }
	        });
		}
			
			//验证工程编号是否存在
			function isHave(obj){
				if($(obj).val()!=''){
					 loadingStart('加载中...');
				    	$.ajax({
				            url: "/project/isHaveCode",
				            data:{
				            	p_code:$.trim($(obj).val())
				            },
				            dataType: "json",
				            type: "POST",
				            success: function(data) {
				            	 if(!data.success){
				            		 $(obj).parent().addClass('has-error');
				         			$(obj).next().text("项目编号已存在").show();
				         			$(obj).focus();			
				            	 }
				            	 loadingEnd();
				            }
				    	});	
				}
			}
			
			//表单保存或者更新
			function saveOrUpdate() {
				$('form').form('submit', {
					success : function(data) {
						data = eval('(' + data + ')');
		                if(data.success){
		                	window.parent.ajaxData();
		                   parent.parent.initProjectComb();
		                   parent.layer.closeAll();
		                }else{
		                	layer.alert(data.message);
		                }
					}
				});
			}
		</script>
	</head>
	<body>  
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
<!-- 			<div class="panel-heading"> -->
<!-- 				<h3 class="panel-title"><i class="fa  fa-folder-o"></i>&nbsp;新增</h3> -->
<!-- 			</div> -->
			<div class="panel-body"   style="height:395px;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/project/saveData"  method="post">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">工程编号(<font class='hongxin'>*</font>)</label> <input type="text"    name="project_code"  id="project_code"   valType="required" 
											    onblur="validateVal(this);"
												id="firstName" class="form-control" placeholder="请输入工程编号">
												<span class="help-block"  style="display:none">
														工程编号不能为空. </span>
						                         <input  type="hidden"  name="id"  id="id"/>
										</div>
									</div>
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">工程名称(<font class='hongxin'>*</font>)</label> <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="project_name"      id="project_name"  
												class="form-control" placeholder="请输入工程名称">
											<span class="help-block"  style="display:none">
														工程名称不能为空. </span>
										</div>
									</div>
									<!--/span-->
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="control-label">工程简称(<font class='hongxin'>*</font>)</label> <input type="text"  name="short_name"   valType="required" 
												id="short_name" class="form-control">
											<span class="help-block"  style="display:none">
														工程简称不能为空. </span>
										</div>
									</div>
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group "  id="projectType">
											<label class="control-label">工程类型</label> </br>
										</div>
									</div>
									<!--/span-->
								</div>
								<div class="row">
									<div class="col-sm-12 ">
										<div class="form-group">
											<label>工程简介</label>
											<textarea type="text" class="form-control"  id="description"  name="description"  rows="6"  onblur="valLength(this);"></textarea>
											<span class="help-block"  style="display:none">
														工程简介输入太长最多保存500个字符. </span>
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