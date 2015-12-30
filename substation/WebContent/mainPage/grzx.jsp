<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<style type="text/css">
		     html , body{
		     	overflow : hidden;
		     	background: #FFF;
		     }
		     .main_container{
		     	width: 100%;
		     	overflow-y: auto;
		     	overflow-x: hidden;
		     }
		     table.gridtable{
		     	width: 90%;
	     	    margin: 0px auto;
		     }
		     table.gridtable td{
		     	border-width : 0px;
		     	text-align: left
		     }
		     table.gridtable tr:HOVER {
	            background: #FFF;
            }
            table.gridtable tr td:HOVER{
	            background: #D8F0F9;
            }
            .button-ext{
	  		  	height: 30px;
	            line-height: 30px;
	            text-align: center;
	            width: 70px;
	            background: #1AB394;
	            border: none;
	            color: #fff;
	            border-radius:4px;
	            outline: none;
	  		  }
  		  .right{
  		      float: right;
  		      margin-right: 10px;
 		      margin-top: 10px;
  		  }
  		  .button-ext:hover{
		      background: #348A78;
		  }
		  
		  .header_div{
		  	width: 100%;
		    height: 60px;
		    line-height: 60px;
		    background: #FFF;
		    font-size: 22px;
		  }
		  .header_div span{
		  	margin-left: 20px;
		  }
		  .center_div{
		  	margin-top: 30px;
		  }
		  .center_div_top{
		  	width: 90%;
		  	background: #FFF;
		  	margin: 0px auto;
		  	border-bottom: 1px solid #DDD;
		  	height: 50px;
		  	line-height: 50px;
		  }
		  .footer_div{
		  	position: absolute;
		    bottom: 0px;
		    width: 100%;
		    background: #FFF;
		    height: 40px;
		    line-height: 40px;
		  }
		  .td_img{
		  	width: 150px;
		    height: 150px;
		    border-radius: 150px;
		  }
		</style>
		<script type="text/javascript">
			function changePassword(){
				openLayerFrame("修改密码","/mainPage/setPassWord.jsp?userId="+$('#userId_span').val(),"500px","350px");
			}
			function editUser(){
				openLayerFrame("编辑用户","/mainPage/editUser.jsp?userId="+$('#userId_span').val()+"&idCard=${userRecord.IDENTITY_CARD }",null,null);
			}
		</script>
	</head>
	<body>  
		<div class="main_container">
			<div class="header_div">
				<span>个人中心</span>
			</div>
			<div class="center_div">
	    		<div class="center_div_top">
					<input type="button" value="修改密码" class="button-ext right" onclick="changePassword();" />
					<input type="button" value="编辑" class="button-ext right" onclick="editUser();"/>
			    </div>
				<table class="gridtable">
					<tr style="display:none">
						<td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td>
					</tr>
					<tr>
						<td rowspan="5" style="text-align: center;">
						<img class="td_img"  src="/source/phone/${userRecord.PHOTO}"   onerror="this.src='/source/phone/defuatlUserPhoto.png'"/>						
						</td><td colspan="3">你好，${userRecord.REAL_NAME =='' ? userRecord.USER_NAME : userRecord.REAL_NAME }</td>
					</tr>
					<tr>
						<td id="sex_td">性别：${userRecord.SEX=='man'?'男':'女' }</td><td>组织机构：${userRecord.ORGANIZATION }</td><td>角色：${role == null ? '' : role}</td>
					</tr>
					<tr>
						<td>身份证：${userRecord.IDENTITY_CARD }</td><td>单位：${userRecord.CORPORATION }</td><td>账户：${userRecord.USER_NAME}</td>
					</tr>
					<tr>
						<td>邮箱：${userRecord.EMAIL }</td><td>部门：${userRecord.DEPARTMENT }</td><td></td>
					</tr>
					<tr>
						<td>电话：${userRecord.MOBILE_PHONE }</td><td>职务：${userRecord.DUTY }</td><td></td>
					</tr>
		  		</table> 
			</div>
		</div>
		<input id="userId_span" value="${userRecord.ID }" style="display:none"></input>
		<input id="org_td" value="${userRecord.ORGANIZATION_ID }" style="display:none"></input>
		<input id="role_td" value="${roleId == null ? '' : roleId}" style="display:none"></input>
		<input id="project_td" value="${projectId}" style="display:none"></input>
	</body> 
</html>