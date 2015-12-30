<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ek37Ouoi8mI6NIMStFsisayR"></script>
<title>首页</title>
<style>
  .imgContainer{
    width: 100%;
    height: 100%;
    float: left;
  }
 .left{
   width: 5%;
   height:380px;
   line-height:380px;
   text-align:center;
   float: left;
 }
 .prev{
    cursor: pointer;
	display: block;
	width: 22px;
	height: 34px;
	margin: 170px auto;
	background: transparent url("imgs/star.png") no-repeat scroll 0% 0%; 
 }
 .prev:HOVER{
    cursor: pointer;
	display: block;
	width: 22px;
	height: 34px;
	margin: 170px auto;
	background: transparent url("imgs/star.png") no-repeat scroll 0% 0%; 
	background-position:0px -42px;
 }
 .center{
   width: 90%;
   height:400px;
   float: left;
/*    border: 1px solid #aaa; */
 }
 .rigth{
   width: 5%;
   height:380px;
   line-height:380px;
   text-align:center;
   float: left;
 }
 .next{
    cursor: pointer;
	display: block;
	width: 22px;
	height: 34px;
	margin: 170px auto;
	background: transparent url("imgs/star.png") no-repeat scroll 0% 0%; 
	background-position:-25px 0px;
 }
 .next:HOVER{
    cursor: pointer;
	display: block;
	width: 22px;
	height: 34px;
	margin: 170px auto;
	background: transparent url("imgs/star.png") no-repeat scroll 0% 0%; 
	background-position:-25px -42px;
 }
 .imgs{
   display: block;
   width: 100%;
   height: 300px;
   line-height:300px;
   text-align: center;
   vertical-align:middle;
/*    background-color: red; */
 }
 .imgs img{
   width: auto;
   height: auto;
   max-height: 100%;
   vertical-align:middle;
 }
.imgDes{
   width: 100%;
   height: 100px;
   color: #000;
   padding-top: 10px;
/*    background-color:blue; */
}
 .address{
 padding-top:10px;
  font-size: 12px;
  font-weight: bold;
}
</style>
<script>
    var _project_id=parent.parent.parent._$comboboxObj.id;
    var tid=getQueryString("tid");
    var userId=getQueryString("userId");
    var lng=getQueryString("lng");
    var lat=getQueryString("lat");
    var imgObj={};
    var imgsLen=0;
    var cnt=0;//第1张图片
	$(function() {
		  ajaxData();
		  geocoder();
	});
    
	function ajaxData(){
		loadingStart('加载中...');
		$.ajax({
			url:"/layoutdiagram/getViolateInfo",
            data:{
            	tid:tid
            },
            dataType: "json",
            type: "POST",
            success: function(data) {
            	if(!!data&&data.length>0){
            		imgsLen=data.length;
	            	$.each(data,function(i,item){
	            		imgObj[i]=item;
	            	});
	            	$("#img").attr('src','${pageContext.request.contextPath}/pictureSan/file.jsp?fileName='+imgObj[cnt].FILE_PATH);
	            	$("#img").load(function(){
	          		  setCenter("#img");			
	          		});
	            	$("#date").text(imgObj[cnt].CREATE_TIME);
	            	$("#content").text(imgObj[cnt].VIOLATE_CONTENT);
            	}
            	loadingEnd();
            }
    	});
	}
	
	function geocoder() {
		var point = new BMap.Point(lng,lat);
		var address="";
        //加载地理编码插件
        var geoc = new BMap.Geocoder(); 
        geoc.getLocation(point, function(rs){
        	var addComp = rs.addressComponents;
        	if(!!addComp.province){
        		address+=addComp.province;
        	}
        	if(!!addComp.city){
        		address+=addComp.city;
        	}
        	if(!!addComp.district){
        		address+=addComp.district;
        	}
        	if(!!addComp.street){
        		address+=addComp.street;
        	}
        	if(!!addComp.streetNumber){
        		address+=addComp.streetNumber;
        	}
//         	alert(addComp.province + ", " + addComp.city + ", " + addComp.district + ", " + addComp.street + ", " + addComp.streetNumber);
        	 $("#address").text("拍摄位置:"+address);
        });
    }
	
	//上一张
	function  prev(){
		if(cnt==0) return;
		cnt--;
		$("#img").attr('src','${pageContext.request.contextPath}/pictureSan/file.jsp?fileName='+imgObj[cnt].FILE_PATH);
		$("#img").load(function(){
			  setCenter("#img");			
			});
    	$("#date").text(imgObj[cnt].CREATE_TIME);
    	$("#content").text(imgObj[cnt].VIOLATE_CONTENT);
	}
	//下一张
	function  next(){
		if(cnt==imgsLen) return;
		cnt++;
		$("#img").attr('src','${pageContext.request.contextPath}/pictureSan/file.jsp?fileName='+imgObj[cnt].FILE_PATH);
		$("#img").load(function(){
		  setCenter("#img");			
		});
    	$("#date").text(imgObj[cnt].CREATE_TIME);
    	$("#content").text(imgObj[cnt].VIOLATE_CONTENT);
	}
	
	//设置图片垂直居中显示
	function setCenter(Xelement)
	{
	    var pd=300-$(Xelement).height();
	    $(Xelement).css('padding-top',(pd/2)+"px");
	}
</script>
</head>
<body style="overflow: hidden;background-color: #fff;">
       <div  class="imgContainer">
                <div class="left"><a class="prev"  onclick="prev();"><a></div>
                <div class="center">
                   <div class="imgs">
                          <img id="img"   src="/source/image/default.jpg"     onerror="this.src='/source/image/default.jpg'" >
                   </div>
                   <div class="imgDes">
                          <strong id="date"></strong>
	                      <p id="address"  class="address" ></p>
	                      <p id="content"></p>
                   </div>
                </div>
                <div class="rigth"><a class="next"  onclick="next();"><a></div>
       </div>
</body>
</html>