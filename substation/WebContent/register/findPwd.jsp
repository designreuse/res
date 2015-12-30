<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- 	   <jsp:include page="${pageContext.request.contextPath}/common.jsp" /> --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>找回密码</title>
<link href="${pageContext.request.contextPath}/register/css/flow.css" type="text/css" rel="stylesheet" />
<script src="${pageContext.request.contextPath}/source/js/inspinia/jquery-2.1.1.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/source/js/layer/layer.js"></script>
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
				padding: 0px 30px;
			}
			.center_container_p{
				height: 30px;
				line-height: 30px;
				font-size: 18px;
			}
			.bread_nav{
				height: 30px;
				line-height: 30px;
				font-size: 24px;
			}
			.bread_nav_sep{
				margin: 0px 20px;
			}
			.bread_nav_disable{
				color: #B5B5B5;
			}
			
			.div_container{
				margin-top: 70px;
				display: none;
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
                border: 1px solid #aaa;
            }
            .text_input_validate_code{
            	/* height: 40px; */
            	padding: 2px 0px 10px 0px;
            	width:80px;
            	background-image: url('/source/image/code_bg.png');
            	border: 0px;
/*             	margin-left: -87px; */
/*             	text-align: center; */
            	font-size: 24px;
            }
            .error_text_input{
	            border-width: 2px;
					border-color: #d9534f;
					border-style: solid;
            }
            .button_blue {
                display: inline-block;
                width: 330px;
                height: 41px;
                line-height:41px;
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
            .left{text-align: left;margin-left: 250px}
            .top-20{margin-top: 20px;}
</style>
<script type="text/javascript">
		   var $validate_code = "" ; 
		   var $user_phone = "" ; 
		   var $user_email = "" ; 
			$(function(){
				initDiplayAndShow('getPassword');
				changeCode();
				initInputTextChange();
				initBtn();
			});
			
			function changeTitle(msg){
				if(msg){
					$('#center_container_title').html(msg);
				}
			}
			
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
			
			function initBtn(){
				initSubmitBtn();
				initMethodType();
				initInputCodeBtn();
				initRepasswordBtn();
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
							$.ajax({
								type:'POST' , 
								url:'/index/getPhoneAndEmail',
								data:{
									username:$('#username').val()
								},
								success:function(data){
									if(data.success){
										data = data.result[0];
										$user_phone = data.PHONE ; 
										$user_email = data.EMAIL ; 
										var index = $user_email.indexOf('@');;
										$('#phone_show').html($user_phone.substr(0 , 3) + "****" + $user_phone.substr(7));
										$('#email_show').html($user_email.substr(0 , $user_email.substr(0,index).length/2) + "****"+$user_email.substr(index));
										$('#email_show_ts').html($user_email.substr(0 , $user_email.substr(0,index).length/2) + "****"+$user_email.substr(index));
										$('.first-current').removeClass().next().addClass('first-current');
										initDiplayAndShow('method_type' , '您正在找回'+$('#username').val()+'的密码');
									}else{
										$userName.addClass('error_text_input');
										layer.tips(data.message,"#username");
									}
								}
							});
						}
					}else{
						$validate_code_user.val('');
						$validate_code_user.addClass('error_text_input');
						layer.tips("验证码错误.","#text_input_validate_code_user");
					}
				});
			}
			
			function initMethodType(){
				$('#method_type_btn').click(function(){
					sendPhoneAndEmail();
				});
			}
			function sendPhoneAndEmail(){
				var type = $("input[name='validate_method']:checked").val();
				$.ajax({
					type:'POST' , 
					url:'/index/sendPhoneAndEmail',
					data:{
						type : type ,
						value : (type === 'phone') ? $user_phone : $user_email
					},
					success:function(data){
						if(data.success){
// 							layer.alert(data.message);
							initDiplayAndShow('input_code');
						}else{
							layer.alert(data.message);
						}
					}
				});
			}
			
			function initInputCodeBtn(){
				$('#input_code_btn').click(function(){
					var $validateCode = $('#input_code_text');
					if($validateCode.val() === ''){
						$validateCode.addClass('error_text_input');
					}else{
						$.ajax({
							type:'POST' , 
							url:'/index/validateInputCode',
							data:{
								code : $validateCode.val()
							},
							success:function(data){
								if(data.success){
									$('.first-current').removeClass().next().addClass('first-current');
									initDiplayAndShow('repassword');
								}else{
									layer.tips(data.message,"#input_code_text");
									$validateCode.val('');
									$validateCode.addClass('error_text_input');
								}
							}
						});
					}
				});
			}
			
			function initRepasswordBtn(){
				
				$('#repassword_btn').click(function(){
					var pasword1 = $('#password1').val();
					var pasword2 = $('#password2').val();
					if(pasword1 !== pasword2){
						$('#password2').addClass('error_text_input');
						layer.tips("两次密码不相同.","#password2");
					}else if(pasword1==''||pasword1==null){
						layer.tips("密码不能为空.","#password1");
					}else{
						$.ajax({
							type:'POST' , 
							url:'/index/repassword',
							data:{
								password : pasword1
							},
							success:function(data){
								if(data.success){
									layer.alert(data.message, function(index){
									    layer.close(index);
									   window.location.href = "/index";
									});
								}else{
									layer.alert(data.message);
								}
							}
						});
					}
				});
			}
			
			function initDiplayAndShow(id,title){
				$('.div_container').hide();
				$('#'+id).show();
				changeTitle(title);
			}
		</script>
</head>
<body>
 <div class="header_container">
	      	<span class="header_left">工程现场管控平台  | 找回密码</span>
	      	<span class="header_right">已有账号，<a href="/index">马上登录</a></span>
 </div>
<div class="flow">
  <ol class="main-flow">
    <li class="first-current"><a href="#s1-1">第1步:确认账号</a></li>
    <li><a href="#s1-2">第2步:安全验证</a></li>
    <li><a href="#s1-3">第3步:重置密码</a></li>
  </ol>
</div>
<div class="center_container">
	    		<div id="getPassword" class="div_container"  style="display: block;">
	                <div class="form_input">
	                    <input id="username" type="text" class="text_input" name="username" placeholder="请输入用户名"  style="width: 330px;"/>
	                </div>
	                <div class="form_input">
	                    <input id="text_input_validate_code_user" type="text" class="text_input" name="password" placeholder="请输入验证码"  />
	                    <input id="text_input_validate_code" type="button" class="text_input_validate_code"  value="CXSD" readonly="readonly" onclick="changeCode();" />
	                </div>
	                <div class="form_input top-20">
	                    <input id="submit_btn" type="button" value="下一步" class="button_blue">
	                </div>
	            </div>
	            
	            <div id= "method_type" class="div_container" >
<!-- 	            	<div class="form_input left top-20" > -->
<!-- 	                    <input type="radio" name="validate_method" value="phone"  ><span class="center_container_p">发送验证码到手机</span>&nbsp;<span id="phone_show" class="center_container_p bread_nav_disable">180****9103</span> -->
<!-- 	                </div> -->
	                <div class="form_input left">
	                    <input type="radio" name="validate_method" value="email" checked="checked"><span class="center_container_p">发送验证码到邮箱</span>&nbsp;<span id="email_show" class="center_container_p bread_nav_disable">yuan****@163.com</span>
	                </div>
	            	
	            	<div class="form_input top-20">
	                    <input id="method_type_btn" type="button" value="下一步" class="button_blue">
	                </div>
	            </div>
	            
	            <div id= "input_code" class="div_container">
	            	<div class="form_input">
	                    <span class="center_container_p">验证码已发送至邮箱：<span id="email_show_ts" class="center_container_p">185******15</span>，请注意接收</span>
	                </div>
	                <div class="form_input">
	                    <input id="input_code_text" type="text" class="text_input" placeholder="请输入验证码"/>
	                </div>
	                <div class="form_input">
	                    <input id="input_code_btn" type="button" value="下一步" class="button_blue">
	                </div>
	                <div class="form_input" style="line-height: 24px">
	                   	 请注意接受验证码<br/>
	                   	 没有收到？<a href="#" onclick="sendPhoneAndEmail();">重新发送</a>或者<a href="#" onclick="initDiplayAndShow('method_type')">使用其他方式</a>
	                </div>
	            </div>
	            
	            <div id= "repassword"       class="div_container">
	            	<div class="form_input">
	                    <input type="password" class="text_input" id="password1" placeholder="请输入新密码"/>
	                </div>
	                <div class="form_input">
	                    <input type="password" class="text_input" id="password2" placeholder="请再次输入新密码"/>
	                </div>
	                <div class="form_input">
	                    <input id="repassword_btn" type="button" value="确定" class="button_blue">
	                </div>
	            </div>
	            
	    	</div>
</body>
</html>
