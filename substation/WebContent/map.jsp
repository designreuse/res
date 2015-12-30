<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
	     <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	     <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery.cookie.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/source/js/common.js"></script>
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=8mmXjXRXcrfk3LQqljbydSNO"></script>
        <script type="text/javascript" src="http://developer.baidu.com/map/custom/stylelist.js"></script>
        <title>变电站工程现场人员动态管控一体化平台</title>
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
            #map{
            	height: 100%;
            }
        </style>
        <script type="text/javascript">
        		$(function(){
        			var map = new BMap.Map("map",{minZoom:12,maxZoom:18});    
        			 var point = new BMap.Point(116.404, 39.915);    
        			 map.centerAndZoom(point, 15); 
        			 map.enableScrollWheelZoom();   //启用滚轮放大缩小，默认禁用
        			 map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
        			 
        			 var  mapStyle ={ 
        				        features: ["road", "building","water","land"],//隐藏地图上的poi
        				        style : "grayscale"  //设置地图风格为高端黑
        				    }
        				map.setMapStyle(mapStyle);
        			 
        			 var marker = new BMap.Marker(new BMap.Point(116.409, 39.918));        // 创建标注    
        			 map.addOverlay(marker);                     // 将标注添加到地图中
        			 
/*         			 marker.addEventListener("click", function(){    
         				 	var opts = {    
        						 width : 250,     // 信息窗口宽度    
        						 height: 100,     // 信息窗口高度    
        						 title : "Hello"  // 信息窗口标题   
      						}    
      						var infoWindow = new BMap.InfoWindow("World", opts);  // 创建信息窗口对象    
      						map.openInfoWindow(infoWindow, map.getCenter());      // 打开信息窗口	    
        			}); */
        				
        				var myIcon = new BMap.Icon("source/image/people.png", new BMap.Size(32, 70), {    //小车图片
        					imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
        				  });
        				
        				var PointArray = [] ; 
        				 for( var i = 116.380967 ; i < 116.424374 ; i=i+0.003){
        					 var point = new BMap.Point(i,39.913285) ; 
        					 PointArray.push(point);
        				 }
        				 
        				
        				var polyline = new BMap.Polyline( //添加折线
        						 PointArray,{strokeColor:"red", strokeWeight:6, strokeOpacity:0.5}    
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

        		});
        		
        </script>
    </head>
    <body>
    		<div id="map"></div>
    </body>
</html>