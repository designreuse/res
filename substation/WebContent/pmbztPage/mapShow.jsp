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
<script type="text/javascript"
	src="http://webapi.amap.com/maps?v=1.3&key=caecc77497fd32ef455860b9f147cb45"></script>
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
				initMap();//初始化地图
				loadingEnd();
			},
			error : function() {
				loadingEnd();
			}
		});
	}

	function initMap() {
		var imageLayer = new AMap.ImageLayer(
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
		new AMap.Marker({
			icon : 'http://vdata.amap.com/icons/b18/1/2.png',
			position : [ mapParams.MAP_CENTER_LNG, mapParams.MAP_CENTER_LAT ],
			map : map
		});
		AMap.event.addListener(map, "complete", draw_xxd_ploy);
		AMap.event.addListener(map, "zoomchange", zoom_change);
		initSlider(mapParams);
	}
    
	function zoom_change(tag){
		zoom =map.getZoom();
		$("#red").slider("value",zoom);
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

			prompt("绘制完成，请复制多边形坐标点以备用", "[" + str + "]");

			$('#draw_poly').text('绘制多边形');

		}
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
	var marker_lasts = [];
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
		if (marker_lasts.length > 0) {
			$.each(marker_lasts, function(i, item) {
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
			var targetId = item.TID.split(",");
			var userId = item.USERID.split(",");
			var real_name = item.REAL_NAME;
			lineArr = [];
			for ( var i = 0; i < jd.length; i++) {
				lineArr.push([ jd[i], wd[i] ]);
				if (active[i] != null && active[i] != ''&& active[i].indexOf('违章') != -1) {
					addMarker([ jd[i], wd[i] ], targetId[i], userId[i],real_name);
				}
			}
			addPolyline(lineArr, real_name);
		});
	}
	/**划线*/
	function addPolyline(lineArr, real_name) {
		var polyline = new AMap.Polyline({
			path : lineArr, //设置线覆盖物路径
// 			strokeColor : '#3366FF', //线颜色
			strokeOpacity : 1, //线透明度
			strokeWeight : 2, //线宽
			strokeStyle : "solid", //线样式
			strokeDasharray : [ 10, 5 ],
// 			isOutline:true
		//补充线样式
		});
		polyline.setMap(map);
		var marker_first = new AMap.Marker({
			icon : "http://js.webapi.amap.com/theme/v1.3/markers/n/start.png",
			position : lineArr[0]
		});
		marker_first.setMap(map);
		var marker_last = new AMap.Marker({
			icon : "http://js.webapi.amap.com/theme/v1.3/markers/n/end.png",
			position : lineArr[lineArr.length-1]
		});
		marker_last.setMap(map);
        AMap.event.addListener(marker_first,'mouseover',
						function(e) {
					    		marker_first.setLabel({
								content : real_name
							     });
		});
        AMap.event.addListener(marker_first,'mouseout',
				function(e) {
			    		marker_first.setLabel({
						content :''
					     });
      });
		polylines.push(polyline);
		marker_firsts.push(marker_first);
		marker_lasts.push(marker_last);
	}

	//添加点标记
	function addMarker(_pos, tid, userId, real_name) {
		var marker_phone = new AMap.Marker({
			icon : "http://webapi.amap.com/images/marker_sprite.png",
			position : _pos,
			clickable : true
		});
		marker_phone.setMap(map); // 在地图上添加点
		AMap.event
				.addListener(
						marker_phone,
						'click',
						function(e) {
							var lng = e.lnglat.lng;
							var lat = e.lnglat.lat;
							//构建信息窗体中显示的内容
							var info = [];
							infoWindow = new AMap.InfoWindow(
									{
										content : '<iframe  src="/pmbztPage/showUserWzDateil.jsp?tid='
												+ tid
												+ '&userId='
												+ userId
												+ '&lng='
												+ lng
												+ '&lat='
												+ lat
												+ '"  frameborder="0" scrolling="no"  width="600" height="400"></iframe>'
									});
							infoWindow.open(map, [ lng, lat ]);
						});
		marker_phones.push(marker_phone);
	}
</script>
</head>
<body>
	<div id="mapContainer"></div>
		<div class=" BMap_stdMpCtrl BMap_stdMpType0 BMap_noprint anchorBR"
			style="transition: bottom 0.3s ease-out 0.3s; width: 65px; height: 227px; bottom: 10px; right: 0px; top: auto; left: auto; position: absolute; z-index: 10; -moz-user-select: none;"
			unselectable="on">
			<div style="height: 227px; width: 65px;" class="BMap_stdMpZoom">
				<div class="BMap_button BMap_stdMpZoomIn"  title="放大一级"   onclick="maxMap();">
					<div class="BMap_smcbg"></div>
				</div>
				<div style="top: 204px;" class="BMap_button BMap_stdMpZoomOut"
					title="缩小一级"  onclick="minMap();">
					<div class="BMap_smcbg"></div>
				</div>
				<div style="height: 180px;" class="BMap_stdMpSlider"  >
					<div style="height: 180px;" class="BMap_stdMpSliderBgTop">
				           <div id="red"></div>
					</div>
			</div>
		</div>
		</div>
</body>
<script type="text/javascript">
    //最大化地图
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

