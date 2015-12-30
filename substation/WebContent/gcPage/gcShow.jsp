<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<style type="text/css">
    table tr td{
      font-size: 14px;
    }

</style>
<title>首页</title>
	    <script>
	        var projectObj = parent._$comboboxObj;
		    $(function(){
		    	if(projectObj.id!=null){
		    		$('.panel-title').text(projectObj.name);
		    		ajaxData();
		    	}
		    });
		    
		    
		    function ajaxData(){
		    	        loadingStart('加载中...');
				    	$.ajax({
				            url: "/project/getProjectInfnById",
				            data:{
				            	projectId:projectObj.id
				            },
				            dataType: "json",
				            type: "POST",
				            success: function(data) {
		                          $("tr td").each(function(i,item){
		                        	  $(item).text(data[$(item).attr("name")]);
		                          });
		                           loadingEnd();
				            }
				        });
				    }
				    
				   
		</script>
    </head>
 <body style="overflow: hidden;background-color: #fff">
   <div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>工程概览</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="table-responsive"   id="table_content"   style="overflow: hidden;font-size: 15px;">
                              <div class="row"  style="padding:10px 30px  30px 30px;">
                                  <div class="panel panel-success">
								   <div class="panel-heading">
								      <h3 class="panel-title"></h3>
								   </div>
								   <div class="panel-body">
								      <table class="table "  >
										<tr >
											<td width="10%"><strong>工程编号:</strong></td>
											<td width="20%" name="PROJECT_CODE"></td>
											<td width="10%"><strong>工程名称:</strong></td>
											<td width="20%" name="PROJECT_NAME"></td>
											<td width="10%"><strong>工程简称:</strong></td>
											<td width="20%"  name="SHORT_NAME"></td>
										</tr>
										<tr>
											<td width="10%"><strong>工程类型:</strong></td>
											<td width="20%" name="PROJECT_TYPE"></td>
											<td width="10%"><strong>创建时间:</strong></td>
											<td width="20%" name="CREATE_TIME"></td>
											<td width="10%"><strong>&nbsp;&nbsp;&nbsp;创建人:</strong></td>
											<td width="20%"  name="REAL_NAME"></td>
										</tr>
										<tr>
											<td width="10%"><strong>工程概述:</strong></td>
											<td width="80%" name="DESCRIPTION"  colspan="5"></td>
										</tr>
							        </table> 
								   </div>
								</div>
                                   
	                      </div>
                      </div>
                 </div>
            </div>
         </div>
    </div>
</div>
<script type="text/javascript">
    $('#table_content').height($(window).height()-100);
</script>
</body>
</html>