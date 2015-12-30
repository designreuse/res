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
<link rel="stylesheet" href="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.css" />
<script src="slider/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ek37Ouoi8mI6NIMStFsisayR"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.js"></script>
<style type="text/css">
body,#allmap {
	width: 100%;
	height: 100%;
	margin: 0;
}

input {
	color: #000;
}

a {
	color: blue;
	text-decoration: underline;
	cursor: default;
}

#tool_bar {
	background-color: #ddd;
	height: 35px;
	padding-top: 3px;
	padding-bottom: 2px;
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	z-index: 1000;
	background-color: rgba(30, 30, 30, 0.8);
	color: #fff;
}

ul#toolbar-panel {
	width: 100%;
	margin: 0 auto;
	padding: 0;
	list-style-type: none;
	overflow: auto;
}

ul#toolbar-panel li {
	margin-top: 3px;
}

#tool_bar a {
	color: #fff;
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
	var paramsObj = {
		'map_center_lng' : '',
		'map_center_lat' : '',
		'map_zoom' : '',
		'map_zoom_min' : '3',
		'map_zoom_max' : '18',
		'map_features' : '',
		'lay_image_path' : '',
		'lay_bounds_lt_lng' : '',
		'lay_bounds_lt_lat' : '',
		'lay_bounds_rd_lng' : '',
		'lay_bounds_rd_lat' : '',
		'lay_zooms_min' : '3',
		'lay_zooms_max' : '18',
		'lay_outline' : '',
		'project_id' : _project_id,
		'id' : ''
	};
	var $name = "";
	var markerObj = {
		center : null,
		leftTop : null,
		rigthBottom : null
	};
	var imageLayer = null;
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
				initTools();//初始化工具条
				initMap();//初始化地图
				loadingEnd();
			},
			error : function() {
				loadingEnd();
			}
		});
	}
	/**初始化工具条*/
	function initTools() {
		$('#map_center').val(
				mapParams.MAP_CENTER_LNG + "," + mapParams.MAP_CENTER_LAT);
		$('#map_zoom').val(parseInt(mapParams.MAP_ZOOM));
		$('#lay_bounds_lt')
				.val(
						mapParams.LAY_BOUNDS_LT_LNG + ","
								+ mapParams.LAY_BOUNDS_LT_LAT);
		$('#lay_bounds_rt')
				.val(
						mapParams.LAY_BOUNDS_RD_LNG + ","
								+ mapParams.LAY_BOUNDS_RD_LAT);
		if (mapParams.LAY_IMAGE_PATH != null && mapParams.LAY_IMAGE_PATH != "") {

			$('#fileName').html(
					mapParams.LAY_IMAGE_PATH + "&nbsp;&nbsp;&nbsp;&nbsp;");
		}
	}
	var marker;
	var leftBottomMarker;
	var rightUpMarker; 
    var plText;
    var id;
    var $obj;       
    var flag=false;
    var SW;//左下角
    var NE;//右上角
    var SE;//左上角
    var NW;//右下角
	function initMap() {
		// 西南角和东北角
		   SW = new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_LT_LAT);
		   NE = new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_RD_LAT);
		   SE=  new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_RD_LAT);
		   NW=new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_LT_LAT);
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
		map = new BMap.Map("allmap",{});    // 创建Map实例
		map.centerAndZoom(new BMap.Point(mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT), mapParams.MAP_ZOOM);  // 初始化地图,设置中心点坐标和地图级别
		map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
		map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
		map.addOverlay(groundOverlay);  
		map.disableDoubleClickZoom();
		//添加中心点
		var centerIcon = new BMap.Icon("http://vdata.amap.com/icons/b18/1/2.png", new BMap.Size(32, 32), {    //小车图片
			imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
		 });
		marker = new BMap.Marker(new BMap.Point(mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT),{icon:centerIcon});
		marker.enableDragging();
		marker.addEventListener("dragend", function(event){
			$('#map_center').val(event.point.lng + "," + event.point.lat);
		});
		map.addOverlay(marker);
		leftBottomMarker = new BMap.Marker(new BMap.Point(mapParams.LAY_BOUNDS_LT_LNG,mapParams.LAY_BOUNDS_LT_LAT));
		leftBottomMarker.enableDragging();
		leftBottomMarker.addEventListener("dragend", function(event){
			$('#lay_bounds_lt').val(event.point.lng + "," + event.point.lat);
			SW = new BMap.Point(event.point.lng,event.point.lat);
			groundOverlay.setBounds(new BMap.Bounds(SW, NE));
		});
		map.addOverlay(leftBottomMarker);
		//添加图层右上角固定点
		rightUpMarker = new BMap.Marker(new BMap.Point(mapParams.LAY_BOUNDS_RD_LNG,mapParams.LAY_BOUNDS_RD_LAT ));
		rightUpMarker.enableDragging();
		rightUpMarker.addEventListener("dragend", function(event){
			$('#lay_bounds_rt').val(event.point.lng + "," + event.point.lat);
			NE = new BMap.Point(event.point.lng,event.point.lat);
			groundOverlay.setBounds(new BMap.Bounds(SW, NE));
		});
		map.addOverlay(rightUpMarker);
		
		//zoomend 添加zoom改变事件
		map.addEventListener("zoomend", function(event){
			$('#map_zoom').val(map.getZoom());
		});
		map.addEventListener('click', function(e){
			if(flag) {
				map.setDefaultCursor("default");
				$obj.next().val(e.point.lng + "," + e.point.lat);
				$obj.text(plText);
				flag=false;
				if(id=='center'){
				     marker.setPosition(new BMap.Point(e.point.lng,e.point.lat));				
				}else if(id=='leftTop'){
					leftBottomMarker.setPosition(new BMap.Point(e.point.lng,e.point.lat));	
					$('#lay_bounds_lt').val(e.point.lng, + "," + e.point.lat);
					SW = new BMap.Point(e.point.lng,e.point.lat);
					groundOverlay.setBounds(new BMap.Bounds(SW, NE));
				}else{
					rightUpMarker.setPosition(new BMap.Point(e.point.lng,e.point.lat));			
					$('#lay_bounds_rt').val(e.point.lng + "," + e.point.lat);
					NE = new BMap.Point(e.point.lng,e.point.lat);
					groundOverlay.setBounds(new BMap.Bounds(SW, NE));
				}
			}
		});
		// 绘制矩形
		//bds的四个脚点坐标
		var pts = [];
	    pts.push(SE);
	    pts.push(NE);
	    pts.push(NW);
	    pts.push(SW);
	    var rect = new BMap.Polygon(pts);
	    map.addOverlay(rect);//添加测试矩形  
	}
	//保存数据
	function saveData() {
		if ($("#map_center").val() == "" || $("#map_center").val() == null) {
			alert("请选择中心点");
			return;
		}
		paramsObj['map_center_lng'] = $("#map_center").val().split(',')[0];
		paramsObj['map_center_lat'] = $("#map_center").val().split(',')[1];
		paramsObj['map_zoom'] = $("#map_zoom").val();
		if ($("#lay_bounds_lt").val() != ""
				&& $("#lay_bounds_lt").val() != null) {
			paramsObj['lay_bounds_lt_lng'] = $("#lay_bounds_lt").val().split(
					',')[0];
			paramsObj['lay_bounds_lt_lat'] = $("#lay_bounds_lt").val().split(
					',')[1];
		}
		if ($("#lay_bounds_rt").val() != ""
				&& $("#lay_bounds_rt").val() != null) {
			paramsObj['lay_bounds_rd_lng'] = $("#lay_bounds_rt").val().split(
					',')[0];
			paramsObj['lay_bounds_rd_lat'] = $("#lay_bounds_rt").val().split(
					',')[1];
		}
		if (mapParams.PROJECT_ID == 'DEFAULT') {
			paramsObj['id'] = '';
		} else {
			paramsObj['id'] = mapParams.ID
		}
		if ($('#file').val() == '' || $('#file').val() == null) {
			paramsObj['lay_image_path'] = mapParams.LAY_IMAGE_PATH;
			$.ajax({
				url : "/layoutdiagram/saveOrUpdate",
				dataType : "json",
				data : paramsObj,
				type : "POST",
				success : function(data) {
					location.href = 'mapSetting_baiduMap.jsp';
				}
			});
		} else {//上传附件
			$('#form1').form('submit', {
				success : function(data) {
					data = eval('(' + data + ')');
					if (data.success) {
						paramsObj['lay_image_path'] =data.message;
						$.ajax({
							url : "/layoutdiagram/saveOrUpdate",
							dataType : "json",
							data : paramsObj,
							type : "POST",
							success : function(data) {
								location.href = 'mapSetting_baiduMap.jsp';
							}
						});
					}
				}
			});
		}
	}

	function setFileName(obj) {
		$('#fileName').html($(obj).val());
	}

    function clickEvent(obj,_id){
    	map.setDefaultCursor("crosshair");
    	$obj = $(obj);
    	id=_id;
		plText = $obj.text();
		$obj.text("请点击地图");
        flag=true;
    }
</script>
<body>
	<div id="tool_bar">
		<ul id="toolbar-panel">
			<li> &nbsp;  <a href="javascript:void(0)"
				onclick="clickEvent(this,'center');" id="draw_center">中心点确定</a>  &nbsp;	
				<input
				type="text" id="map_center" name="map_center" value="" size='20' />
				<input type="text"   id="map_zoom"
				name="map_zoom" size='3' /> 
				<form id="form1" action="/layoutdiagram/saveImage" method="post"
					enctype="multipart/form-data" style="float: left;">
					&nbsp; <input type="button" value="选择工程图..." onclick="file.click()" />
					<span id="fileName">未选择文件&nbsp;&nbsp;&nbsp;&nbsp; </span> <span
						style="display: none;"> <input type="file" id="file"
						name="file" accept="image/gif, image/jpeg, image/png "
						onchange="setFileName(this);"></input></span>
				</form> &nbsp; <a href="javascript:void(0)"
				onclick="clickEvent(this,'leftTop');" id="draw_phone_left">左下角确定</a>
				<input type="text" id="lay_bounds_lt" name="lay_bounds_lt" value=""
				size='20' /> &nbsp; <a href="javascript:void(0)"
				onclick="clickEvent(this,'rigthBottom');" id="draw_phone_rigth">右上角确定</a>
				<input type="text" id="lay_bounds_rt" name="lay_bounds_rt" value=""
				size='20' /> 
			</li>
		</ul>
	</div>

<div id="allmap"></div>
</body>
</html>