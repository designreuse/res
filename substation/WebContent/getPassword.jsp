<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
	   <jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<style type="text/css">
			.header_container{
			   width: 800px;
				height: 60px;
				line-height: 60px;
				margin: 0px auto;
				overflow: hidden;
			}
			.header_left{
				font-size: 24px;font-weight: bold;float: left;
			}
			.header_right{
			 	font-size:14px;float: right;
			}
			.center_container{
				width: 800px;
				height: 500px;
				background-color: #fff;
				margin: 50px auto;
				padding: 10px 30px;
			}
			.center_container_p{
				height: 30px;
				line-height: 30px;
				font-size: 18px;
			}
			#login_form{
				margin-top: 40px;
			}
			.form_input{
                height: 70px;
                line-height: 70px;
                text-align: center;
            }
            .text_input{
                width: 250px;
                height: 40px;
                line-height: 40px;
                border-radius: 2px;
                border: 1px solid #DDD0D0;
            }
            .text_input_validate_code{
            	/* height: 40px; */
            	padding: 2px 0px 10px 0px;
            	width:80px;
            	background-image: url('/source/image/code_bg.png');
            	border: 0px;
            	margin-left: -87px;
            	text-align: center;
            	font-size: 24px;
            }
            .error_text_input{
	            border-width: 2px;
					border-color: #d9534f;
					border-style: solid;
            }
            .button_blue {
                display: inline-block;
                width: 250px;
                height: 41px;
                line-height: 41px;
                border-radius: 5px;
                background: #2795dc;
                border: none;
                cursor: pointer;
                color: #fff;
                font-size: 16px;
            }
            .button_blue:hover
            {
                background:#0081c1;
                *border-bottom:none;
            }
		</style>
		<script type="text/javascript">
		   var $validate_code = "" ; 
			$(function(){
				changeCode();
				initInputTextChange();
				initSubmitBtn();
			});
			
			function initInputTextChange(){
        		$(":input").on('input',function(e){  
        			$(this).removeClass('error_text_input');
        		});
        	}
			
			function changeCode(){
				var $text_input_validate_code = $('#text_input_validate_code');
				$validate_code = "" ; 
				var selectChar = new Array('a','b','c','d','e','f','g','h','j','k','l','m','n','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','S','T','U','V','W','X','Y','Z');      
				for(var i=0;i<4;i++) {      
				   var charIndex = Math.ceil(Math.random()*45);      
				   $validate_code += selectChar[charIndex];      
				}  
				$text_input_validate_code[0].value = $validate_code;
			}
			
			function initSubmitBtn(){
				$('#submit_btn').click(function(){
					$validate_code = $validate_code.toUpperCase();
					var $validate_code_user = $('#text_input_validate_code_user');
					var $validate_code_user_value = $validate_code_user.val().toUpperCase();
					var $userName = $('#username');
					var $userName_value = $userName.val();
					if($validate_code === $validate_code_user_value){
						if($userName_value === ""){
							$userName.addClass('error_text_input');
						}else{
							
						}
					}else{
						$validate_code_user.val('');
						$validate_code_user.addClass('error_text_input');
					}
				});
			}
		</script>
	</head>
	<body class="easyui-layout">   
	    <div data-options="region:'north'" style="height:60px;overflow: hidden;">
	      <div class="header_container">
	      	<span class="header_left">变电站工程现场人员动态管控一体化平台  | 找回密码</span>
	      	<span class="header_right">已有账号，<a href="/index">马上登录</a></span>
	      </div>
	    </div>   
	    <div data-options="region:'center'" style="padding:5px;background:#eee;">
	    	<div class="center_container">
	    		<p class="center_container_p">请输入您要找回密码的账号</p>
	    		<hr/>
	    		<form id="login_form" action="/index" method="post">
	                <div class="form_input">
	                    <input id="username" type="text" class="text_input" name="username" placeholder="请输入用户名"/>
	                </div>
	                <div class="form_input">
	                    <input id="text_input_validate_code_user" type="text" class="text_input" name="password" placeholder="请输入验证码"/>
	                    <input id="text_input_validate_code" type="button" class="text_input_validate_code" value="CXSD" readonly="readonly" onclick="changeCode();" />
	                </div>
	                <div class="form_input">
	                    <input id="submit_btn" type="button" value="登 录" class="button_blue">
	                </div>
	            </form>
	    	</div>
	    </div>   
	</body> 
</html>