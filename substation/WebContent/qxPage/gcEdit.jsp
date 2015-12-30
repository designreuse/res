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
   String qxId=request.getParameter("qxId");
%>
<style type="text/css">
   .comb{
      position: absolute;;
      width: 368px;
      height:100px;
      border: 1px solid #aaa;
      z-index: 999;
      background-color: white;
      overflow-y: auto;
      overflow-x:hidden;
      display: none;
   }
   .comb div{
      height:30px;
      line-height:30px;
      vertical-align:middle;
      width: 368px;
      cursor: pointer;
      overflow:hidden;   
      padding: 10px 0px 0px  10px;
   }
    .comb div:HOVER {
	  background-color: #0081C2;
   }
</style>
<title>首页</title>
<script type="text/javascript">
   var _menu_id=getQueryString('menu_id');
   var id=getQueryString('qxId');
   var count=0;
   $(function(){
	   initIcoComb();
		getData();
	});
	
	function getData(){
		$.ajax({
          url: "/limits/getDataById",
          dataType: "json",
          type: "POST",
          data:{
        	  perId:id
          },
          success: function(data) {
       	   console.info(data);
               var inputs= $('form input');
               $.each(inputs,function(i,item){
              	if(!! $(item).attr('name')){
                  	 var name=$(item).attr('name').toUpperCase();
                  	 if(!!name){
                  		 $(item).val(data[name]);     
                  	 }                        		
              	}
               });
               $("#type").val(data["type".toUpperCase()]);
               $("#description").val(data["description".toUpperCase()]);
          }
      });
	}
	function initIcoComb(){
		   $.ajax({
				url : "/qxPage/ico.json",
				dataType : "json",
				type : "POST",
				success : function(data) {
					var icos=data.icos;
					var html="";
					$.each(icos,function(i,item){
						html+='<div onclick="selectIco(\''+item.ico+'\');"><i class="'+item.ico+'"></i></div>';
					});
					$(".comb").append($(html));
				}
			});
	   }
	   
	   function showComb(event,obj){
		   if(count==0){
			   $(obj).next().show();
			   count=1;
		   }else{
			   $(obj).next().hide();
			   count=0;
		   }
		   event.stopPropagation();
	   }
	   
	   function selectIco(value){
		   $("input[name='ico']").val(value);
	   }
</script>
</head>
<body style="overflow: hidden;">
	<div style="padding:0px;">
		<div class="panel"   style="border: 0px;border-radius:0px;">
			<div class="panel-body"   style="height:395px;"  onclick="$('.comb').hide();count=0;">
			         	<div style="display: block;" class="portlet-body form">
						<!-- BEGIN FORM-->
						<form class="horizontal-form"  action="/limits/saveData"  method="post">
							<div class="form-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">权限编号(<font class='hongxin'>*</font>)</label> <input type="text"    name="code"  id="code"   valType="required" 
											    onblur="validateVal(this);"
												id="firstName" class="form-control" placeholder="请输入权限编号">
												<span class="help-block"  style="display:none">
														编号不能为空. </span>
										</div>
									</div>
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">权限名称(<font class='hongxin'>*</font>)</label> <input type="text"   valType="required" 
											   onblur="validateVal(this);"  name="name"      id="name"  
												class="form-control" placeholder="请输入权限名称">
											<span class="help-block"  style="display:none">
														名称不能为空. </span>
										</div>
									</div>
									<!--/span-->
								</div>
								<div class="row">
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">权限类型(<font class='hongxin'>*</font>)</label> <select  name="type"  id="type"    valType="required" 
												class="form-control">
													<option value="menu">菜单权限</option>
													<option value="browse">浏览权限</option>
													<option value="create">添加权限</option>
													<option value="delete">删除权限</option>
													<option value="update">更新权限</option>
											</select>
											<span class="help-block"  style="display:none">
														类型不能为空. </span>
										</div>
									</div>
									    <div class="col-sm-6">
										<div class="form-group " >
											<label class="control-label">权限路径</label> <input type="text"   
											    name="navigate_uri"      id="navigate_uri"  
												class="form-control"   placeholder="请输入权限路径">
										</div>

															    
									<!--/span-->
								</div>
								</div>
                                <div class="row">
									<!--/span-->
									<div class="col-sm-6">
										<div class="form-group ">
											<label class="control-label">顺序(<font class='hongxin'>*</font>)</label> 
											<input type="text"   
											    name="order_by"      id="order_by"   valType="number" 
												class="form-control"   placeholder="请输入序号">
												<span class="help-block"  style="display:none">
														顺序不能为空,且必须为数字. </span>
										</div>
									</div>
									 <div class="col-sm-6">
										<div class="form-group " >
											<label class="control-label">图标</label>
											  <input type="text"    name="ico"    id="ico"  class="form-control"   placeholder="点击选择图标"  onclick="showComb(event,this);">
											  <div class="comb">
											  </div>
										</div>
									</div>
								</div>
								<div  class="row">
								       <div class="col-sm-6">
										<div class="form-group "  style="display: none;">
											<label class="control-label"></label> 
											<input  type="text"    name="parent_id"  class="form-control"  />
											<input  type="text"    name="id"  class="form-control"  id="id"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12 ">
										<div class="form-group">
											<label>角色描述</label>
											<textarea type="text" class="form-control"  id="description"  name="description"  rows="3"></textarea>
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