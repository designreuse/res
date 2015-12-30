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
<link rel="stylesheet" href="index_map.css" />
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main.css" />
<script src="slider/jquery-ui.min.js"></script>
<script type="text/javascript"  src="http://webapi.amap.com/maps?v=1.3&key=caecc77497fd32ef455860b9f147cb45"></script>
<style type="text/css">
body,#mapContainer {
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
	function initMap() {
		imageLayer = new AMap.ImageLayer(
				{
					url : "/pictureSan/file.jsp?fileName="
							+ mapParams.LAY_IMAGE_PATH,
					bounds : new AMap.Bounds([ mapParams.LAY_BOUNDS_LT_LNG,
							mapParams.LAY_BOUNDS_LT_LAT ], [
							mapParams.LAY_BOUNDS_RD_LNG,
							mapParams.LAY_BOUNDS_RD_LAT ]),
					zooms : [ mapParams.LAY_ZOOMS_MIN, mapParams.LAY_ZOOMS_MAX ]
				});
		map = new AMap.Map('mapContainer', {
			resizeEnable : true,
			scrollWheel : true,
			doubleClickZoom : true,
			dark : 'fresh',
			center : [ mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT ],
			zoom : parseInt(mapParams.MAP_ZOOM),
			zooms : [ parseInt(mapParams.MAP_ZOOM_MIN),
					parseInt(mapParams.MAP_ZOOM_MAX) ],
			features : mapParams.MAP_FEATURES.split(","),
			layers : [ new AMap.TileLayer(), imageLayer ]
		});
		map.setDefaultCursor("default");
		AMap.event.addListener(map, "complete", draw_xxd_ploy);
		//AMap.event.addListener(map, "zoomchange", show_hide_xxd);

		$("input[name='m_feature']").click(function() {
			var f = [];
			$("input:checked[name='m_feature']").each(function(o) {
				f.push($(this).val());
			});
			map.setFeatures(f);
		});

		$("input[name='r_img']").click(
				function() {
					imageLayer.setImageUrl('http://sweb.hhwy.org/source/image/'
							+ $(this).val());
				});

		//初始化地图中心标记点
		markerObj['center'] = new AMap.Marker({
			id : 'center',
			icon : 'http://vdata.amap.com/icons/b18/1/2.png',
			position : [ mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT ],
			draggable : true,
			map : map
		});
		AMap.event.addListener(markerObj['center'], 'dragend', _dragend);
		//初始化图层左上标记点
		markerObj['leftTop'] = new AMap.Marker({
			id : 'leftTop',
			position : [ mapParams.LAY_BOUNDS_LT_LNG,
					mapParams.LAY_BOUNDS_LT_LAT ],
			draggable : true,
			map : map
		});
		AMap.event.addListener(markerObj['leftTop'], 'dragend', _dragend);
		//初始化图层右下标记点
		markerObj['rigthBottom'] = new AMap.Marker({
			id : 'rigthBottom',
			position : [ mapParams.LAY_BOUNDS_RD_LNG,
					mapParams.LAY_BOUNDS_RD_LAT ],
			draggable : true,
			map : map
		});
		AMap.event.addListener(markerObj['rigthBottom'], 'dragend', _dragend);
		AMap.event.addListener(map, "zoomchange", zoom_change);
		initSlider(mapParams);
	}
	
	function zoom_change(tag){
		zoom =map.getZoom();
		$("#red").slider("value",zoom);
	}
	
	function drawPoly() {
		var obj = $('#draw_poly');
		if (obj.text() == '绘制多边形') {
			obj.text('鼠标在地图上点击绘制多边形，点击右键或双击左键结束绘制');

			//设置多边形的属性
			var polygonOption = {
				strokeColor : "#19A4EB",
				strokeOpacity : 0.34,
				strokeWeight : 2,
				fillColor : "blue",
				fillOpacity : 0.1
			};

			//在地图中添加MouseTool插件
			map.plugin([ "AMap.MouseTool" ], function() {
				var mouseTool = new AMap.MouseTool(map);
				mouseTool.polygon(polygonOption); //使用鼠标工具绘制多边形
				AMap.event.addListener(mouseTool, "draw", drawComplete);
			});
		}
	}

	function drawComplete(tag) {
		if (tag.type == 'draw') {
			var str = '';

			$.each(tag.obj.Rd.path, function(i, o) {
				str += '{"lng": "' + o.lng + '", "lat": "' + o.lat + '"},'
			});

			if (str.length > 0) {
				str = str.substring(0, str.length - 1);
			}

			// 			prompt("绘制完成，请复制多边形坐标点以备用","[" + str + "]");
			alert("绘制完成");
			paramsObj['lay_outline'] = "[" + str + "]";
			$('#draw_poly').text('绘制多边形');

		}
		//alert(tag.obj.rd.path);
	}

	// 当zoom>=16时，显示图层
	function show_hide_xxd(e) {
		var zoom = map.getZoom();
		if (zoom >= 16) {
			zoom.setLayers([ new AMap.TileLayer(), imageLayer ]);
		}
	}

	function draw_xxd_ploy() {
		// 描绘多边形
		var lnglatJson = '[{"lng": "109.052085", "lat": "34.365668"},{"lng": "109.054842", "lat": "34.365668"},{"lng": "109.054896", "lat": "34.365757"},{"lng": "109.054885", "lat": "34.367333"},{"lng": "109.059638", "lat": "34.367333"},{"lng": "109.059584", "lat": "34.365252"},{"lng": "109.05967", "lat": "34.36519"},{"lng": "109.060657", "lat": "34.36519"},{"lng": "109.060647", "lat": "34.362648"},{"lng": "109.059681", "lat": "34.362657"},{"lng": "109.059542", "lat": "34.362569"},{"lng": "109.059542", "lat": "34.36225"},{"lng": "109.054832", "lat": "34.36225"},{"lng": "109.054832", "lat": "34.364021"},{"lng": "109.054692", "lat": "34.364092"},{"lng": "109.052096", "lat": "34.364056"}]';
		//		var lnglatJson = '[{"lng": "116.411295", "lat": "39.94591"},{"lng": "116.411508", "lat": "39.945927"}]';
		var data = {
			type : "Polygon",
			name : "",
			desc : "",
			strokeWeight : 2,
			strokeColor : "#19A4EB",
			strokeOpacity : 0.34,
			fillColor : "blue",
			fillOpacity : 0.1
		};
		var o = $.parseJSON(lnglatJson);
		var path = [];
		$.each(o, function(i, d) {
			path.push(new AMap.LngLat(d.lng, d.lat));
		});
		//		map.setCenter([116.411295,39.94591]);
		new AMap.Polygon({
			map : map,
			path : path,
			extData : data,
			zIndex : 100,
			strokeWeight : data.strokeWeight,
			strokeColor : data.strokeColor,
			strokeOpacity : data.strokeOpacity,
			fillColor : data.fillColor,
			fillOpacity : data.fillOpacity
		});

	}
	var polylines = [];
	var marker_firsts = [];
	var marker_phones = [];
	/**画用户轨迹*/
	function drow_user_point(_data) {
		if (polylines.length > 0) {
			$.each(polylines, function(i, item) {
				item.setMap(null);
			});
		}
		if (marker_firsts.length > 0) {
			$.each(marker_firsts, function(i, item) {
				item.setMap(null);
			});
		}
		if (marker_phones.length > 0) {
			$.each(marker_phones, function(i, item) {
				item.setMap(null);
			});
		}
		$.each(_data, function(i, item) {
			var jd = item.GPS_LONGITUDE.split(",");
			var wd = item.GPS_LATITUDE.split(",");
			var active = item.ACT.split(",");
			var real_name = item.REAL_NAME;
			lineArr = [];
			for (var i = 0; i < jd.length; i++) {
				lineArr.push([ jd[i], wd[i] ]);
				if (active[i] != null & active[i] != '') {
					addMarker([ jd[i], wd[i] ]);
				}
			}
			addPolyline(lineArr, real_name);
		});
	}
	function addPolyline(lineArr, real_name) {
		var polyline = new AMap.Polyline({
			path : lineArr, //设置线覆盖物路径
			strokeColor : "#3366FF", //线颜色
			strokeOpacity : 1, //线透明度
			strokeWeight : 4, //线宽
			strokeStyle : "solid", //线样式
			strokeDasharray : [ 10, 5 ]
		//补充线样式
		});
		polyline.setMap(map);
		var marker_first = new AMap.Marker({
			position : lineArr[0]
		});
		marker_first.setMap(map);
		marker_first.setLabel({
			content : real_name
		});
		polylines.push(polyline);
		marker_firsts.push(marker_first);
	}

	//添加点标记
	function addMarker(_pos) {
		var marker_phone = new AMap.Marker({
			icon : "http://webapi.amap.com/images/marker_sprite.png",
			position : _pos,
			clickable : true
		});

		marker_phone.setMap(map); // 在地图上添加点
		AMap.event.addListener(marker_phone, 'click', function() {
			marker_phone.setLabel({
				content : "拍摄违章点信息."
			});
		});
		marker_phones.push(marker_phone);
	}

	//点击事件
	var clickCount = false;
	var plText;
	function clickEvent(obj, name) {
		$name = name;
		map.setDefaultCursor("crosshair");
		$obj = $(obj);
		clickCount = false;
		plText = $obj.text();
		$obj.text("请点击地图");
		map.on('click', function(e) {
			map.setDefaultCursor("default");
			if (clickCount) {
				return;
			}
			$obj.next().val(e.lnglat.getLng() + "," + e.lnglat.getLat());
			$obj.text(plText);
			clickCount = true;
			if (markerObj[$name] == null) {
				if ($name == 'center') {
					markerObj[$name] = new AMap.Marker({
						id : $name,
						icon : 'http://vdata.amap.com/icons/b18/1/2.png',
						position : [ e.lnglat.getLng(), e.lnglat.getLat() ],
						draggable : true,
						map : map
					});
					AMap.event.addListener(markerObj[$name], 'dragend',
							_dragend);
				} else {
					markerObj[$name] = new AMap.Marker({
						id : $name,
						position : [ e.lnglat.getLng(), e.lnglat.getLat() ],
						draggable : true,
						map : map
					});
					AMap.event.addListener(markerObj[$name], 'dragend',
							_dragend);
				}

			} else {
				markerObj[$name].setPosition([ e.lnglat.getLng(),
						e.lnglat.getLat() ]);
			}
		});
	}

	function _dragend(e) {
		var id = e.target.Vd.id||e.target.Rd.id;
		if (id == "center") {
			$('#map_center').val(e.lnglat.getLng() + "," + e.lnglat.getLat());
		} else if (id == "leftTop") {
			$('#lay_bounds_lt').val(e.lnglat.getLng() + "," + e.lnglat.getLat());
			imageLayer.setBounds(new AMap.Bounds([ e.lnglat.getLng(),
					e.lnglat.getLat() ], [
					imageLayer.getBounds().northeast.lng,
					imageLayer.getBounds().northeast.lat ]));
		} else if (id == "rigthBottom") {
			$('#lay_bounds_rt')
					.val(e.lnglat.getLng() + "," + e.lnglat.getLat());
			imageLayer.setBounds(new AMap.Bounds([
					imageLayer.getBounds().southwest.lng,
					imageLayer.getBounds().southwest.lat ], [
					e.lnglat.getLng(), e.lnglat.getLat() ]));
		}
	}

	function cancelclickEvent() {
		map.off('click');
	}
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
					location.href = 'mapSetting.jsp';
				}
			});
		} else {//上传附件
			$('#form1').form('submit', {
				success : function(data) {
					data = eval('(' + data + ')');
					if (data.success) {
						paramsObj['lay_image_path'] = $('#file').val();
						$.ajax({
							url : "/layoutdiagram/saveOrUpdate",
							dataType : "json",
							data : paramsObj,
							type : "POST",
							success : function(data) {
								location.href = 'mapSetting.jsp';
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
</script>
<body>
	<div id="tool_bar">
		<ul id="toolbar-panel">
			<li>【地图设置】<br /> &nbsp; <a href="javascript:void(0)"
				onclick="clickEvent(this,'center');" id="draw_center">中心点确定</a> <input
				type="text" id="map_center" name="map_center" value="" size='20' />
				&nbsp; <span>地图元素：</span> <label for='c1'>背景</label><input id='bg'
				type='checkbox' value='bg' name='m_feature' /> <label for='c2'>道路</label><input
				id='road' type='checkbox' value='road' name='m_feature' /> <label
				for='c3'>建筑物</label><input id='building' type='checkbox'
				value='building' name='m_feature' /> <label for='c4'>兴趣点</label><input
				id='point' type='checkbox' value='point' name='m_feature' /> &nbsp;
				<label>初始缩放级别: </label><input type="text" id="map_zoom"
				name="map_zoom" size='3' onchange="isT(this);" /> &nbsp; <label>缩放级别最小值:
			</label><input type="text" id="map_zoom_min" name="map_zoom_min" size='4'
				onchange="isMin(this);" /> &nbsp; <label>缩放级别最大值: </label> <input
				type="text" id="map_zoom_max" name="map_zoom_max" size='4'
				onchange="isMax(this);" /> &nbsp;
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
				onchange="isMin(this);" /> &nbsp; <label>缩放级别最大值: </label> <input
				type="text" id="lay_zooms_max" name="lay_zooms_max" size='4'
				onchange="isMax(this);" /> &nbsp; <a href="javascript:drawPoly()"
				id="draw_poly">绘制多边形</a>
			</li>
		</ul>
	</div>

	<div id="mapContainer"></div>
	<div class=" BMap_stdMpCtrl BMap_stdMpType0 BMap_noprint anchorBR"
		style="transition: bottom 0.3s ease-out 0.3s; width: 65px; height: 227px; bottom: 10px; right: 0px; top: auto; left: auto; position: absolute; z-index: 10; -moz-user-select: none;"
		unselectable="on">
		<div style="height: 227px; width: 65px;" class="BMap_stdMpZoom">
			<div class="BMap_button BMap_stdMpZoomIn" title="放大一级"
				onclick="maxMap();">
				<div class="BMap_smcbg"></div>
			</div>
			<div style="top: 204px;" class="BMap_button BMap_stdMpZoomOut"
				title="缩小一级" onclick="minMap();">
				<div class="BMap_smcbg"></div>
			</div>
			<div style="height: 180px;" class="BMap_stdMpSlider">
				<div style="height: 180px;" class="BMap_stdMpSliderBgTop">
					<div id="red"></div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function maxMap() {
		zoom = zoom + 1;
		$("#red").slider("value", zoom);
		map.setZoom(zoom);
	}

	function minMap() {
		zoom = zoom - 1;
		$("#red").slider("value", zoom);
		map.setZoom(zoom);
	}
	function initSlider() {
		zoom = parseInt(mapParams.MAP_ZOOM);
		$("#red").slider({
			orientation : "vertical",
			range : "max",
			min : parseInt(mapParams.MAP_ZOOM_MIN),
			max : parseInt(mapParams.MAP_ZOOM_MAX),
			value : parseInt(mapParams.MAP_ZOOM),
			change : refreshSwatch
		});
	}
	function refreshSwatch() {
		zoom = $("#red").slider("value");
		map.setZoom(zoom);
	}
</script>

</html>