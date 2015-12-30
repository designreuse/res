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
<script type="text/javascript" src="/source/js/jquery.nicescroll.min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ek37Ouoi8mI6NIMStFsisayR"></script>
<script src="slider/jquery-ui.min.js"></script>
<style type="text/css">
body {
	width: 100%;
	height: 100%;
	margin: 0;
	text-align: left;
}
#img_bg {
		margin: 0px;
		z-index: -1px;
	}
	
	.location {
		cursor:pointer;
		width: 15px;
		height:24px; 
		position: relative;
		z-index: 100;  
	}
	
	.location img{
		border: 0;
		width: 100%;
		height:100%; 
	}
 #blue {
    position:fixed;
    left:3px;
    top:3px;
    z-index:999px;
    width: 10px;
    height:250px;
    margin: 15px;
  }
  #blue .ui-slider-range { background: #729fcf; }
  #blue .ui-slider-handle { border-color: #729fcf; }
</style>
<script type="text/javascript">
	var map;
	var _project_id = parent.parent._$comboboxObj.id;
	var paramsObj = {
			'map_center_lng' : '',
			'map_center_lat' : '',
			'map_zoom' : '',
			'map_zoom_min' : '',
			'map_zoom_max' : '',
			'map_features' : '',
			'lay_image_path' : '',
			'lay_bounds_lt_lng' : '',
			'lay_bounds_lt_lat' : '',
			'lay_bounds_rd_lng' : '',
			'lay_bounds_rd_lat' : '',
			'lay_zooms_min' : '',
			'lay_zooms_max' : '',
			'lay_outline' : '',
			'project_id' : _project_id,
			'id' : ''
		};
	// x轴距离，像素	
	var x_distance, y_distance;
	var x_pixels, y_pixels;
	$(function() {
		initMapParam();
		init();
		$( "#blue" ).slider({
		      orientation: "vertical",
		      range: "min",
		      max: 200,
		      value: 100,
		      change: refreshSwatch
		    });
	});
	
	function refreshSwatch() {
	   var   _value = $( "#blue" ).slider( "value" );
	      changesize(_value);
	  }
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
				initMap();
				loadingEnd();
			},
			error : function() {
				loadingEnd();
			}
		});
	}
	/**获取底图*/
	function init() {
		loadingStart('加载中...');
		$.ajax({
			url : "/layoutdiagram/getProjectPicInfo",
			dataType : "json",
			type : "POST",
			data : {
				projectId : _project_id
			},  
			success : function(data) {
				var imageName=data.name;
				var wid=data.width ;
				var hei=data.height;
// 				var nice = $("body").niceScroll({touchbehavior:true,cursorcolor:"#aaa",cursoropacitymax:0.6,cursorwidth:8});
				var obj = $("#img_bg");
				obj.width(wid);
				obj.height(hei);
				// 底图
				$('<img id="bgImg" src="/pictureSan/file.jsp?fileName='+imageName+'" width="100%" height="100%"/>').appendTo(obj);
				loadingEnd();
			},
			error : function() {
				loadingEnd();
			}
		});
	}
    var SW;//左下角
    var NE;//右上角
    var SE;//左上角
    var NW;//右下角
	function initMap() {
		// 初始化地图
		   SW = new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_LT_LAT);
		   NE = new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_RD_LAT);
		   SE=  new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_RD_LAT);
		   NW=new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_LT_LAT);
		map = new BMap.Map("allmap",{});    // 创建Map实例
		map.centerAndZoom(new BMap.Point(mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT), mapParams.MAP_ZOOM);  // 初始化地图,设置中心点坐标和地图级别
		map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
		map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
		// 计算高度、宽度
		x_distance = map.getDistance(NE,SE).toFixed(2);
		y_distance = map.getDistance(NE,NW).toFixed(2);
		x_pixels   =$(window).width();
		y_pixels   =$(window).height();
	}
	
	var wzArr=[];
	/**画用户轨迹*/
	function drow_user_point(_data) {
		if(_data.length>0){
			var jd = _data[0].GPS_LONGITUDE.split(",");
			var wd = _data[0].GPS_LATITUDE.split(",");
			var active = _data[0].ACT.split(",");
			var targetId = _data[0].TID.split(",");
			var userId = _data[0].USERID.split(",");
			var real_name = _data[0].REAL_NAME;
			var PointArray = [] ; 
			for ( var i = 0; i < jd.length; i++) {
				 var point = new BMap.Point(jd[i],wd[i]) ; 
				 PointArray.push(point);
				 if (active[i] != null && active[i] != ''&& active[i].indexOf('违章') != -1) {
					 wzArr.push({'x':getX(jd[i],wd[i]),'y':getY(jd[i],wd[i]),'targetId':targetId[i],' userId':userId[i],'real_name':real_name});
					}
			 }
			$('#img_bg').remove('.location');
			$.each(wzArr, function(i,o) {
				var str = '<div class="location" ox="' + o.x 
				        + '" oy="' + o.y
				        + '"><img src="/source/image/location3.png"/></div>';
				var left=parseFloat(o.x);
				var top=parseFloat(o.y);
				$(str).css({left:left,top:top}).appendTo($('#img_bg'));
			})
		}
	}
	
	function getX(lng,lat){
		 var p1 = new BMap.Point(lng, lat); 	
		 var pw = parseFloat(map.getDistance(p1,NE).toFixed(2),10);
		 var px = (pw/x_distance * x_pixels).toFixed(0);
		return px;
	}
	
	function getY(lng,lat){
		var p2 = new BMap.Point(lng,lat); 	
		var ph = parseFloat(map.getDistance(p2,NE).toFixed(2),10);
		var py = (ph/y_distance * y_pixels).toFixed(0);
		return py;
	}
	
	function changesize(b) {
		b=b/100;
		var obj = $("#img_bg");
		var w = (x_pixels * b).toFixed(0);
		var h = (y_pixels * b).toFixed(0);
		obj.animate({ 
		    width: w,
		    height: h
		}, 100 );
		
		$(".location").each(function (i,o) {
			var o = $(o);
			var w = (o.attr("ox") * b).toFixed(0);
			var h = (o.attr("oy") * b).toFixed(0);
			o.animate({ 
			    left: w,
			    top: h
			}, 100 );
		});
	}
</script>
</head>
<body style="background-color:#ffffff;overflow: auto;"   >
    <div id="blue"></div>
	<div id="img_bg" ></div>
	<div id="allmap" style="display: none;"></div>
</body>
</html>

