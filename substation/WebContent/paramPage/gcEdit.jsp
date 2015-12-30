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
var id=getQueryString('paramId');
	$(function() {
 		getData();
	});
   
	function getData() {
		loadingStart('加载中...');
		$.ajax({
			url : "/param/getDataById",
			dataType : "json",
			type : "POST",
			data : {
				paramId : id
			},
			success : function(data) {
				var inputs = $('form input');
				$.each(inputs, function(i, item) {
					if (!!$(item).attr('name')) {
						var name = $(item).attr('name').toUpperCase();
						if (!!name) {
							$(item).val(data[name]);
						}
					}
				});
				$("#is_inner").val(data["is_inner".toUpperCase()]);
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
					<form class="horizontal-form" action="/param/saveData"
						method="post">
						<div class="form-body">
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group ">
										<label class="control-label">参数名称(<font
											class='hongxin'>*</font>)
										</label> <input type="text" name="param_name" id="param_name"
											valType="required" onblur="validateVal(this);"
											class="form-control" placeholder="请输入参数名称"> <span
											class="help-block" style="display: none"> 参数名称不能为空. </span>
									</div>
								</div>
								<!--/span-->
								<div class="col-sm-6">
									<div class="form-group ">
										<label class="control-label">参数值</label> <input type="text"
											name="param_value" id="param_value" class="form-control"
											placeholder="请输入参数值">
									</div>
								</div>
								<!--/span-->
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="control-label">参数中文名称(<font
											class='hongxin'>*</font>)
										</label> <input type="text" name="cn_name" valType="required"
											onblur="validateVal(this);" id="cn_name" class="form-control">
										<span class="help-block" style="display: none">
											中文名称不能为空. </span>
									</div>
								</div>
								<!--/span-->
								<div class="col-sm-6">
									<div class="form-group ">
										<label class="control-label">是否内置参数</label> <select
											name="is_inner" id="is_inner" class="form-control">
											<option value="1">是</option>
											<option value="0">否</option>
										</select>
									</div>
								</div>
								<!--/span-->
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="control-label">默认参数值</label> <input type="text"
											name="default_value" id="default_value" class="form-control">
									</div>
								</div>
							      <div class="col-sm-6">
										<div class="form-group "  style="display: none;">
											 <input type="text"   name="id"    id="id"    class="form-control" >
										</div>
									</div>
							</div>

							<div class="row">
								<div class="col-sm-12 ">
									<div class="form-group">
										<label>备注</label>
										<textarea type="text" class="form-control" id="description"
											name="description" rows="3"></textarea>
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