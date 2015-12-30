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
	height: 100px;
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
		$('#map_zoom_min').val(parseInt(mapParams.MAP_ZOOM_MIN));
		$('#map_zoom_max').val(parseInt(mapParams.MAP_ZOOM_MAX));
		$.each(mapParams.MAP_FEATURES.split(","), function(i, item) {
			$('#' + item).attr("checked", 'true');
		});
		$('#lay_bounds_lt')
				.val(
						mapParams.LAY_BOUNDS_LT_LNG + ","
								+ mapParams.LAY_BOUNDS_LT_LAT);
		$('#lay_bounds_rt')
				.val(
						mapParams.LAY_BOUNDS_RD_LNG + ","
								+ mapParams.LAY_BOUNDS_RD_LAT);
		$('#lay_zooms_min').val(mapParams.LAY_ZOOMS_MIN);
		$('#lay_zooms_max').val(mapParams.LAY_ZOOMS_MAX);
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
		map.setMapStyle({features:mapParams.MAP_FEATURES.split(",")});//设置地图的样式
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
		//设置feature
		$("input[name='m_feature']").click(function() {
			var f = [];
			$("input:checked[name='m_feature']").each(function(o) {
				f.push($(this).val());
			});
			map.setMapStyle({features:f});
		});
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
		//绘制多边形
        if(mapParams.LAY_OUTLINE==null||mapParams.LAY_OUTLINE=="")  return;
		var layoutLine=eval('(' + mapParams.LAY_OUTLINE + ')');
		var Points=[];
		for(var i=0;i<layoutLine.length;i++){
			Points.push(new BMap.Point(layoutLine[i].lng,layoutLine[i].lat));
		}
		var polygon=new BMap.Polygon(Points,{
				   strokeColor:"red",    //边线颜色。
			       fillColor:"#aaa",      //填充颜色。当参数为空时，圆形将没有填充效果。
		          strokeWeight: 2,       //边线的宽度，以像素为单位。
		          strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
		          fillOpacity: 0.6      //填充的透明度，取值范围0 - 1。
		});
		map.addOverlay(polygon);
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
		paramsObj['map_zoom_min'] = $("#map_zoom_min").val();
		paramsObj['map_zoom_max'] = $("#map_zoom_max").val();
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
		paramsObj['lay_zooms_min'] = $("#lay_zooms_min").val();
		paramsObj['lay_zooms_max'] = $("#lay_zooms_max").val();

		var arr = [];
		$("input:checked[name='m_feature']").each(function(o) {
			arr.push($(this).val());
		});
		paramsObj['map_features'] = arr.join(",");
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
	
	function drawPoly(){
		clearAll();
		map.setDefaultCursor("crosshair");
		var styleOptions = {
		        strokeColor:"red",    //边线颜色。
		       fillColor:"#aaa",      //填充颜色。当参数为空时，圆形将没有填充效果。
		        strokeWeight: 2,       //边线的宽度，以像素为单位。
		        strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
		        fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
		        strokeStyle: 'solid' //边线的样式，solid或dashed。
		    }
		    //实例化鼠标绘制工具
		    var drawingManager = new BMapLib.DrawingManager(map, {
		        isOpen: true, //是否开启绘制模式
		        enableDrawingTool: false, //是否显示工具栏
		        drawingToolOptions: {
		            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
		            offset: new BMap.Size(5, 5)
		        },
		        circleOptions: styleOptions, //圆的样式
		        polylineOptions: styleOptions, //线的样式
		        polygonOptions: styleOptions, //多边形的样式
		        rectangleOptions: styleOptions //矩形的样式
		    });  
		    drawingManager.setDrawingMode(BMAP_DRAWING_POLYGON);
			 //添加鼠标绘制工具监听事件，用于获取绘制结果
		    drawingManager.addEventListener('overlaycomplete', overlaycomplete);
	}
	
	var overlays = [];
	var overlaycomplete = function(e){
        overlays.push(e.overlay);
        map.setDefaultCursor("default");
        var str = '';
        if(overlays.length>0){
			$.each(overlays[0].oo, function(i, o) {
				str += '{"lng": "' + o.lng + '", "lat": "' + o.lat + '"},'
			});
	
			if (str.length > 0) {
				str = str.substring(0, str.length - 1);
			}
        }
		paramsObj['lay_outline'] = "[" + str + "]";
    };
    
    function clearAll() {
		for(var i = 0; i < overlays.length; i++){
            map.removeOverlay(overlays[i]);
        }
        overlays.length = 0   
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
			<li>【地图设置】<br /> &nbsp;  <a href="javascript:void(0)"
				onclick="clickEvent(this,'center');" id="draw_center">中心点确定</a>  <input
				type="text" id="map_center" name="map_center" value="" size='20' />
				&nbsp; <span>地图元素：</span> <label for='c1'>河流</label><input id='water'
				type='checkbox' value='water'  name='m_feature' /> <label for='c2'>陆地</label><input id='land'
				type='checkbox' value='land'  name='m_feature' /><label for='c3'>道路</label><input
				id='road' type='checkbox' value='road' name='m_feature' /> <label
				for='c4'>建筑物</label><input id='building' type='checkbox'
				value='building' name='m_feature' /> <label for='c5'>兴趣点</label><input
				id='point' type='checkbox' value='point' name='m_feature' /> &nbsp;
				<label>初始缩放级别: </label><input type="text"   id="map_zoom"
				name="map_zoom" size='3' /> &nbsp; <label>缩放级别最小值:
			</label><input type="text" id="map_zoom_min" name="map_zoom_min" size='4' /> &nbsp; <label>缩放级别最大值: </label> <input
				type="text" id="map_zoom_max" name="map_zoom_max" size='4' /> &nbsp;
			</li>
			<li>【图层设置】<br />
				<form id="form1" action="/layoutdiagram/saveImage" method="post"
					enctype="multipart/form-data" style="float: left;">
					&nbsp; <input type="button" value="浏览..." onclick="file.click()" />
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
				size='20' /> &nbsp; <label>缩放级别最小值: </label><input type="text"
				id="lay_zooms_min" name="lay_zooms_min" size='4'
				/> &nbsp; <label>缩放级别最大值: </label> <input
				type="text" id="lay_zooms_max" name="lay_zooms_max" size='4'
				/> &nbsp;
				 <a href="javascript:drawPoly()"  id="draw_poly">绘制多边形</a>
			</li>
		</ul>
	</div>

<div id="allmap"></div>
</body>
</html>