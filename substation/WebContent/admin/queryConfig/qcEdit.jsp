<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<link  href="${pageContext.request.contextPath}/source/js/inspinia/bootstrap.min.css"  rel="stylesheet">
<link  href="${pageContext.request.contextPath}/source/font-awesome/css/font-awesome.css"  rel="stylesheet">
<!-- chosen -->
<link href="${pageContext.request.contextPath}/source/js/inspinia/plugins/chosen/chosen.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/source/js/inspinia/animate.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/source/js/inspinia/style.css" rel="stylesheet">

<!-- css -->
<link href="${pageContext.request.contextPath}/source/css/css.css" rel="stylesheet">
	<style>
	body {
	    font-family: "open sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	    background-color: #FFF;
	    font-size: 13px;
	    color: #676A6C;
	    overflow-x: hidden;
	}
	</style>
		<script type="text/javascript">
		    var  id=getQueryString('id'); 
			$(function(){
				getData();
			});
			
			function getData(){
				$.ajax({
		            url: "/admin/getQueryById",
		            dataType: "json",
		            type: "POST",
		            data:{
		            	id:id
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
                         $("#QUERY_TEXT").val(data["QUERY_TEXT".toUpperCase()]);
		            }
		        });
			}
			
			function saveOrUpdate(){
				$('form').form('submit', {    
				    success: function(data){
				    	data = eval('('+data+')');
				    	layer.alert(data.message);
				    }    
				});
			}
		</script>
	</head>
	<body>  
    <div class="myworkingbox"  style="margin-left: 10px;">
	<form id="gcForm"  action="/admin/saveQueryData"  method="post">
			<div class="TabTable">
			        <div class="FUNCIONBARNEW"  style="padding: 10px;">
							 <button type="button" class="btn btn-sm btn-primary"   onclick="saveOrUpdate()"> 保存</button>
					</div>
				  	<div class="Formtable">
						<div class="Formtabletitle">
							<span>查询信息</span>
						</div>			
					<table class="FormtableCon"  id="__table">
		                <tr class="color">
		                    <td>查询名称:</td>
		                    <td>
		                    <input   type="text" name="QUERY_NAME"  id="QUERY_NAME"  valType="required" msg="查询名称不能为空"    size="25px"></input>
		                    <input  type="hidden"  name="ID"    id="ID">
		                     <input  type="hidden"  name="SORT"  id="SORT" >
		                    </td>
		                    <td>描述:</td>
		                    <td><input  type="text" name="QUERY_DESCRIBE"  size="25px"    id="QUERY_DESCRIBE"   ></input></td>
		                </tr>
		                <tr >
		                    <td>创建人:</td>
		                    <td><input  type="text" name="QUERY_COMMENT"   size="25px"  id="QUERY_COMMENT"    valType="required"   msg="创建人不能为空" ></input></td>
		                    <td>查询参数:</td>
		                    <td><input  type="text" name="QUERY_PARAM"  size="25px" ></input></td>
		                </tr>
		                <tr>
		                   <td>SQL文本:</td>
		                    <td colspan="8"><textarea id="QUERY_TEXT"  name="QUERY_TEXT"  rows="5"  cols="140"  valType="required" msg="SQL不能为空" ></textarea></td>
		                </tr>
		            </table>
		         </div>	
			</div>
				</form>
		</div>
				<script type="text/javascript">
         $('#_table').height($(window).height()-140);
</script>
	</body> 
</html>