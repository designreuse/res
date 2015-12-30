<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="width:100%;height:100%;">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<link rel="stylesheet" href="slider/jquery-ui.min.css" />
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main.css" />
<script src="slider/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ek37Ouoi8mI6NIMStFsisayR"></script>
<style type="text/css">
body,#allmap {
	width: 100%;
	height: 100%;
	margin: 0;
}

#red {
	float: left;
	clear: left;
	height: 160px;
	margin-left: 10px;
	width: 5px;
	background: #0C88E8;
	margin-top: 8px;
	cursor: pointer;
}

#red .ui-slider-range {
	background: #fff;
}

#red .ui-slider-handle {
	border-color: #F52E2E;
	width: 13px;
}
.anchorBL{ 
display:none; 
}
</style>
<script type="text/javascript">
	var map;
	var _project_id = parent.parent._$comboboxObj.id;
	var mapParams = {};
	var zoom;
	$(function() {
		initMapParam();
	});
	
	/**获取Map初始化所需要的参数*/
	function initMapParam() {
		loadingStart('加载中...');
		$.ajax({
			url : "/layoutdiagram/getInitMapData",
			dataType : "json",
			type : "POST",
			data : {
				project_id : _project_id
			},
			success : function(data) {
				mapParams = data;
// 				initMap();//初始化地图
				loadingEnd();
			},
			error : function() {
				loadingEnd();
			}
		});
	}
	function initMap() {
		// 西南角和东北角
		  var SW = new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_LT_LAT);
		  var NE = new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_RD_LAT);
		  var groundOverlayOptions = {
				    opacity: 1,
				    displayOnMinLevel: mapParams.LAY_ZOOMS_MIN, 
				    displayOnMaxLevel: mapParams.LAY_ZOOMS_MAX
				  }
		// 初始化GroundOverlay
		  var groundOverlay = new BMap.GroundOverlay(new BMap.Bounds(SW, NE), groundOverlayOptions);
		  // 设置GroundOverlay的图片地址
		  groundOverlay.setImageURL("/pictureSan/file.jsp?fileName="+ mapParams.LAY_IMAGE_PATH);
		// 初始化地图
		map = new BMap.Map("allmap",{minZoom:parseInt(mapParams.MAP_ZOOM_MIN),maxZoom:parseInt(mapParams.MAP_ZOOM_MAX)});    // 创建Map实例
		map.centerAndZoom(new BMap.Point(mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT), mapParams.MAP_ZOOM);  // 初始化地图,设置中心点坐标和地图级别
		map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
		map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
// 		map.setMapStyle({features:mapParams.MAP_FEATURES.split(",")});//设置地图的样式
        map.setMapStyle({
		    	   styleJson:[
		    	         {
		                    "featureType": "poi",
		                    "elementType": "all",
		                    "stylers": {
		                              "color": "#ffffff",
		                              "visibility": "off"
		                    }
				          },
				          {
				                    "featureType": "road",
				                    "elementType": "all",
				                    "stylers": {
				                              "color": "#ffffff",
				                              "visibility": "off"
				                    }
				          },
				          {
				                    "featureType": "background",
				                    "elementType": "all",
				                    "stylers": {
				                              "color": "#ffffff"
				                    }
				          },
				          {
				                    "featureType": "administrative",
				                    "elementType": "all",
				                    "stylers": {
				                              "color": "#ffffff",
				                              "visibility": "off"
				                    }
				          }
					]
				});
		map.addOverlay(groundOverlay);
		//添加比例尺
		var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT});// 左上角，添加比例尺
		var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
		var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_TOP_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮
		map.addControl(top_left_control);        
		map.addControl(top_left_navigation);     
		//添加中心点
		var centerIcon = new BMap.Icon("http://vdata.amap.com/icons/b18/1/2.png", new BMap.Size(32, 32), {    //小车图片
			imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
		 });
		var marker = new BMap.Marker(new BMap.Point(mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT),{icon:centerIcon});
		map.addOverlay(marker);
	}
	
	/**画用户轨迹*/
	function drow_user_point(_data) {
		initMap();
		if(_data.length>0){
			var jd = _data[0].GPS_LONGITUDE.split(",");
			var wd = _data[0].GPS_LATITUDE.split(",");
			var active = _data[0].ACT.split(",");
			var targetId = _data[0].TID.split(",");
			var userId = _data[0].USERID.split(",");
			var real_name = _data[0].REAL_NAME;
			var PointArray = [] ; 
			var WzArray=[];
			for ( var i = 0; i < jd.length; i++) {
				 var point = new BMap.Point(jd[i],wd[i]) ; 
				 PointArray.push(point);
				 if (active[i] != null && active[i] != ''&& active[i].indexOf('违章') != -1) {
					 addWzMarker(new BMap.Point(jd[i], wd[i]), targetId[i], userId[i],real_name);
					}
			 }
			var polyline = new BMap.Polyline( //添加折线
					 PointArray,{strokeColor:"#006600", strokeWeight:2, strokeOpacity:1}    
			       );    
			 map.addOverlay(polyline);
			//添加起始点标记
			 var firstIcon = new BMap.Icon("http://js.webapi.amap.com/theme/v1.3/markers/n/start.png", new BMap.Size(32, 32), {    //小车图片
					imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
				 });
			var firstMarker = new BMap.Marker(new BMap.Point(jd[0],wd[0]),{icon:firstIcon});
			map.addOverlay(firstMarker);
			
			 var endIcon = new BMap.Icon("http://js.webapi.amap.com/theme/v1.3/markers/n/end.png", new BMap.Size(32, 32), {    //小车图片
					imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
				 });
			var endMarker = new BMap.Marker(new BMap.Point(jd[jd.length-1],wd[wd.length-1]),{icon:endIcon});
			map.addOverlay(endMarker);
		}
	}
	
	function addWzMarker(pot, tid, userId, real_name){
		//添加违章点标记
		var wzIcon = new BMap.Icon("http://webapi.amap.com/images/marker_sprite.png", new BMap.Size(32, 32), {    //小车图片
			imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
		 });
		var wzMarker = new BMap.Marker(pot,{icon:wzIcon});
		wzMarker.addEventListener("click", function(event){
			// 百度地图API功能
			var sContent = '<iframe  src="/pmbztPage/showUserWzDateil.jsp?tid='
				+ tid
				+ '&userId='
				+ userId
				+ '&lng='
				+ pot.lng
				+ '&lat='
				+ pot.lat
				+ '"  frameborder="0" scrolling="no"  width="600" height="400"></iframe>'
			var infoWindow = new BMap.InfoWindow(sContent);  // 创建信息窗口对象
			this.openInfoWindow(infoWindow);
		});
		map.addOverlay(wzMarker);
	}
</script>
</head>
<body>
	<div id="allmap"></div>
</body>
</html>

