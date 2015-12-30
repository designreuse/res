<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	   <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=8mmXjXRXcrfk3LQqljbydSNO"></script>
		<style type="text/css">
		    .container{
		    	margin: 30px 0px 0px 5%;
		    }
			table.gridtable {
				font-family: verdana,arial,sans-serif;
				font-size:12px;
				color:#333333;
				border-collapse: collapse;
				width: 95%;
				margin: 10px 0px 0px 0px;
			}
			.img_span {
			    width: 40px;
			    height: 40px;
			    padding: 0px;
			    margin: 0px;
			    vertical-align: middle;
			}
		</style>
		<script type="text/javascript">
			$(function(){
				initMap();
			});
			function initMap(){
		    	var map = new BMap.Map("map",{minZoom:13,maxZoom:18});    
	   			 var point = new BMap.Point(116.404, 39.915);    
	   			 map.centerAndZoom(point, 15); 
	   			 map.enableScrollWheelZoom();   //启用滚轮放大缩小，默认禁用
	   			 map.enableContinuousZoom();    //启用连续缩放效果，默认禁用。
	   			 //map.disableDragging();
	   			 var  mapStyle ={ 
	   				        features: ["road", "building","water","land"],//隐藏地图上的poi
	   				        style : "grayscale"  //设置地图风格为高端黑
	   				    }
	   				map.setMapStyle(mapStyle);
	   			 
	   			 var greenIcon = new BMap.Icon("../source/image/u400.png", new BMap.Size(30,30));
	   			 var redIcon = new BMap.Icon("../source/image/u408.png", new BMap.Size(30,30));
	   			 var yellowIcon = new BMap.Icon("../source/image/u418.png", new BMap.Size(30,30));
	   			 var iconArray = [greenIcon , redIcon , yellowIcon];
	   			
	   			var data_info = [[116.417854,39.921988,"地址：北京市东城区王府井大街88号乐天银泰百货八层"],
	   							 [116.406605,39.921585,"地址：北京市东城区东华门大街"],
	   							 [116.412222,39.912345,"地址：北京市东城区正义路甲5号"]
	   							];
	   			var opts = {
	   						width : 250,     // 信息窗口宽度
	   						height: 80,     // 信息窗口高度
	   						title : "用户信息" // 信息窗口标题
	   					   };
	   			for(var i=0;i<data_info.length;i++){
	   				var marker = new BMap.Marker(new BMap.Point(data_info[i][0],data_info[i][1]), {icon : iconArray[i]});  // 创建标注
	   				var content = data_info[i][2];
	   				map.addOverlay(marker);               // 将标注添加到地图中
	   				addClickHandler(content,marker);
	   			}
	   			function addClickHandler(content,marker){
	   				marker.addEventListener("click",function(e){
	   					openInfo('<h6>'+content+'</h6>',e)}
	   				);
	   				marker.addEventListener("mouseout" , function(){
		   				map.closeInfoWindow(); //关闭信息窗
		   			});
	   				marker.addEventListener("dblclick", function(){    
	   					parent.initIframePage("mainPage/grgj.jsp");
					});
	   			}
	   			function openInfo(content,e){
	   				var p = e.target;
	   				var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
	   				var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象 
	   				map.openInfoWindow(infoWindow,point); //开启信息窗口
	   			}	   			 
   				//为轨迹服务
   			    var myIcon = new BMap.Icon("../source/image/people.png", new BMap.Size(32, 70), {    //小车图片
   					imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
   				  });
   				
   				var PointArray = [] ; 
   				 for( var i = 116.380967 ; i < 116.424374 ; i=i+0.003){
   					 var point = new BMap.Point(i,39.913285) ; 
   					 PointArray.push(point);
   				 }
   				 
   				
   				var polyline = new BMap.Polyline( //添加折线
   						 PointArray,{strokeColor:"red", strokeWeight:3, strokeOpacity:0.5}    
      			       );    
      			 map.addOverlay(polyline);
      			 
      			window.run = function(){
      				var carMk = new BMap.Marker(PointArray[0],{icon:myIcon});
   				   map.addOverlay(carMk);
   				   var index = 0 ; 
   				   function resetMkPoint(index){
   					   carMk.setPosition(PointArray[index]);
   					   if(index < PointArray.length){
      						setTimeout(function(){
      							index++;
      							resetMkPoint(index);
      						},1000);
      					}
   				   }
   				   setTimeout(function(){
      					resetMkPoint(1);
      				},100)
      			}
   				
   				setTimeout(function(){
   					run();
   				},1500);
		    }
		</script>
	</head>
	<body>  
		<div class="container">
			<span style="font-size: 16px;font-weight: bold;">轨迹图</span>
			<hr align="left" style="width: 95%" />
			<div>
				<div>
					<input id="startDate" name="startDate" type= "text" class= "easyui-datebox" style="width: 180px;" data-options="height:30"></input> 至
			        <input id="startDate" name="endDate" type= "text" class= "easyui-datebox" style="width: 180px;" data-options="height:30"></input> 
			        <a href="#"><img style="vertical-align: middle;" src="${pageContext.request.contextPath}/source/image/search.png" /></a>
				</div>
		        <div style="margin-top: 20px;">
		        	<img class="img_span" src="/source/image/mainPage/u30.png" />
		        	<span>张三</span>
		        	<span>XXX部门</span>
		        	<span>XXX职务</span>
		        </div>
			</div>
			
 			<div id="map" style=" width:95% ;height: 450px;"></div>
			
			<div>
				<table class="gridtable">
					<tr>
						<th width="10%">序号</th><th width="40%">时间</th><th width="50%">地点</th>
					</tr>
					<tr>
						<td>1</td><td>2015-06-07 18:55:26<img src="/source/image/card20-13.png"></td><td>XXX地点</td>
					</tr>
					<tr>
						<td>2</td><td>2015-06-07 18:55:26<img src="/source/image/card14-22.png"></td><td>XXX地点</td>
					</tr>
					<tr>
						<td>1</td><td>2015-06-07 18:55:26<img src="/source/image/card20-13.png"></td><td>XXX地点</td>
					</tr>
		  		</table> 			
			</div>
		</div>  
	</body> 
</html>