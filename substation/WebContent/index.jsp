<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
	     <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	     <meta content="width=device-width,initial-scale=1" name="viewport">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery.cookie.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/common.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery.qrcode.min.js"></script>
        <title>工程现场管控平台</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/source/image/logo.png" />
        <style type="text/css">
            html,body{
                margin: 0px;
                padding: 0px;
                width: 100%;
                height: 100%;
                overflow: hidden;
                border: 0px;
            }
            body{
                font-family:"微软雅黑";
/*                 background: url(/source/image/index_background.jpg) no-repeat top left; */
                background-color:#F3F3F5;
                background-size: cover;
                -ms-behavior:url(/source/htc/backgroundsize.min.htc);
                behavior: url(/source/htc/backgroundsize.min.htc);
            }
            .login_container{
            	display:none;
                width: 300px;
                height:550px;
                padding: 0px 120px;
                position: fixed;
/*                 margin-left: -260px; */
                 background-color: #F3F3F5; 
                filter: progid:DXImageTransform.Microsoft.gradient(startcolorstr=#4BFFFFFF,endcolorstr=#4BFFFFFF);
            }
            .login_title{
                height: 130px; 
                line-height:200px;
                width:100%;
                font-weight: bold;
                vertical-align:center;
                text-align: center; 
                background: url(/source/image/app_title2.png) no-repeat center top; 
            }
            .login_title_span{
                font-size: 20px;
/*                 position: absolute;  */
/*                  top: 110px;  */
/*                 left: 195px;  */
                
            }
            .text_input{
                width: 251px;
                height: 40px;
                line-height: 40px;
                border: 0px ;
                outline:none;
                padding-left:5px;
                font-size: 16px;
                vertical-align:middle;
            }
            .text_input_outline{
            	background-color: #fff;
            	outline: 2px solid #0A9074;
            }
            .error_text_input{
				outline: 2px solid #d9534f;
            }
            
            .form_input{
            	background-color: #fff;
                text-align: center;
                margin-top: 10px;
            }
            .border{
               border: 1px solid  #aaa;
            }
            .form_button{
                text-align: center;
                margin-top: 20px;
            }
            
            .form_input img{
           	    vertical-align: middle;
   				 background-color: #FFF;
   				 height: 24px;
				 width: 24px;
				 padding-right: 5px;
   				 
            }
            .button_blue {
            	font-family:"微软雅黑";
                display: inline-block;
                height: 40px;
                border-radius: 5px;
                background: #1AB393;
                border: none;
                cursor: pointer;
                color: #fff;
                font-size: 24px;
            }
            .button_blue:hover
            {
                background:#0A9074;
                *border-bottom:none;
            }
            .left{float: left; font-size: 14px;}
            .right{float: right; font-size: 14px;}
            .right a{color: #000}
            input:-webkit-autofill {
			     -webkit-box-shadow: 0 0 0px 1000px white inset;
			}
			.footer_div{
				position: absolute;
			    bottom: 0;
			    height: 40px;
			    line-height: 40px;
			    text-align: center;
			    background-color: #222222;
			    color: #838383;
			    font-size: 16px;
			    width: 100%;
			}
			.error_tip{    
				margin-top: 5px;
			    display: inherit;
			    margin-bottom: 5px;
			    color: #DE2323;
			    position: absolute;
			    display: none;
		    }
		    
		    #div_qrcode {
		    	width:300px; 
		    	height:100px;
		    	text-align: center;
		    	margin-top:20px;"
		    }
		    
		    #div_qrcode a {
		    	float:left;
		    	display: block;
		    	margin-left:25px;
		    	margin-right:25px;
		    	vertical-align: bottom;
		    	width:100px; 
		    	height:125px;
		    	outline:none;
		    	color:#000;
		    	font-size:12px;
		    	text-decoration:none;
		    	text-align: center;
		    }
		   
			#div_qrcode a:hover {
				color:#000;
			}
			
			#div_qrcode a:visited{
				color:#000;
			}

        </style>
        <script type="text/javascript">
        var type = '${param.type}';
        var message = '${param.message}';
        	function keydownEvent(){
        		var e = window.event || arguments.callee.caller.arguments[0];
        		if (e && e.keyCode == 13 ) {
        			document.getElementById("submit_btn").click();
                }
        	}
        	$(function(){
	        	if (top != self) {
					top.location = self.location;
				}
        		initMessage();
        		initInputValue();
        		initInputTextChange();
        		initSubmitBtn();
        		//设置login_container垂直位置
        		var wh=$(window).height();
        		var ww=$(window).width();
        		var lh=$('.login_container').height();
        		var fh=$('.footer_div').height();
        		if(wh-lh-fh>0){
        		  var pos_top=(wh-lh-fh)/2;
        		  $(".login_container").css('margin-top',pos_top+"px");
        		}
        		var pos_left=(ww/2)-270;
        		$(".login_container").css('margin-left',pos_left+"px");
        		$(".login_container").fadeIn("slow");
        		
        	});
        	
            	
        	function initMessage(){
        		if(type == 'error'){
        			$('.error_tip').text(message).show();
        		}
        	}
        	function initInputValue(){
        		if($.cookie('saveUser')){
        			$('#username').val($.cookie('username'));
        			$('#password').val($.cookie('password'));
        		}
        	}
        	function initInputTextChange(){
        		$(".text_input").on('change',function(e){  
        			$(this).parent().removeClass('error_text_input');
        		});
        		
        		$(".text_input").on('focus',function(e){  
        			$(".text_input").parent().removeClass('text_input_outline');
        			$(this).parent().addClass('text_input_outline');
        		});
        	}
        	function initSubmitBtn(){
        		$('#submit_btn').click(function(){
        			var $username = $('#username') ; 
        			var $password = $('#password') ; 
        			if($username.val() === ""){
        				$username.parent().addClass('error_text_input');
        				$username.focus();
        				return ;
        			}
        			if($password.val() === ""){
        				$password.parent().addClass('error_text_input');
        				$password.focus();
        				return ;
        			}
        			if($('#checkbox_remenber')[0].checked){
        				$.cookie('saveUser', true);
        				$.cookie('username', $username.val());
        				$.cookie('password', $password.val());
        			}
        			$('#login_form').submit();
        		});
        	}
        </script>
    </head>
    <body onkeydown="keydownEvent()">
        <div class="login_container">
            <div class="login_title">
                             <span class="login_title_span">工程现场管控平台</span>
           </div>
            <form id="login_form" action="/index" method="post">
                <div class="form_input border">
                    <img alt="" src="source/image/user.png" /><input id="username" type="text" class="text_input" name="username" placeholder="请输入账号"/>
                </div>
                <div class="form_input border">
                    <img alt="" src="source/image/password.png" /><input id="password" type="password" class="text_input" name="password" placeholder="请输入密码"/>
                </div>
                <span class="error_tip">用户名或密码错误</span>
                <br/>
	            <div class="form_input" >
		        		<span class="left"><input id="checkbox_remenber" type="checkbox"/><label for="checkbox_remenber">记住登录信息</label></span><span class="right"><a href="/index/getPassword">忘记密码</a></span>
		         </div>
		         <br>
                <div class="form_button" >
                    <input id="submit_btn" type="button" value="登 录" style="width:300px;" class="button_blue">
                </div>
            </form>
            
            <!-- 二维码 -->
	        <div id="div_qrcode">
	        	<img src="source/image/appLogin.png">
              	<a id="upkApkUrl" href="downapp?t=apk" target="_blank"><img src="source/image/qrcode_apk.png"/><span>Android版</span></a>
              	<a id="upkIpaUrl" href="downapp?t=ipa" target="_blank"><img src="source/image/qrcode_ipa.png"/><span>IOS版</span></a>
	        </div>  
        </div>
        <div class="footer_div">
        	<span>版权所有：${company}</span>
        </div>
    </body>
</html>