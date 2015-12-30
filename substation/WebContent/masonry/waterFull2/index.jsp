<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<link rel='stylesheet' href='style.css' media='screen' />

<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery.lazyload.min.js"></script>
<script type="text/javascript" src="js/blocksit.js"></script>

<link rel="stylesheet" href="/pictureSan/lightBox/css/lightbox.css" media="screen"/>
<script src="/pictureSan/lightBox/js/lightbox-2.6.min.js"></script>
 <link rel="stylesheet" href="http://cache.amap.com/lbs/static/main.css" />
 <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ek37Ouoi8mI6NIMStFsisayR"></script>
<style>
.lazy {
	width: 320px;
}

img{
   cursor: pointer;
}

.address{
  font-size: 12px;
  font-weight: bold;
}
</style>
</head>
<body >


	<div id="wrapper">
		<div id="container" >
		</div>

	</div>


	<div id="test" style="display: none;">
		<div class="grid">
			<div class="imgholder">
				<img    src="images/10.jpg"    onerror="this.src='/source/image/default.jpg'"/>
			</div>
			<strong>DATE</strong>
			<p>CONTENT</p>
		</div>
	</div>
    <div id="max_container"   style="display: none;"></div>
	<script type="text/javascript">
		$(function() {
			$(window).scroll(
					function() {
						// 当滚动到最底部以上50像素时， 加载新内容
						if ($(document).height() - $(this).scrollTop()- $(this).height() < 50) {
							if(parseInt(window.parent.page.pageNumber)<parseInt(window.parent.page.totalPage)){
								window.parent.page.pageNumber=parseInt(window.parent.page.pageNumber)+1;
								window.parent.ajaxData();
							}
						}
					});

			var currentWidth = 1100;
			$(window).resize(function() {
				var winWidth = $(window).width();
				var conWidth;
				if (winWidth < 660) {
					conWidth = 440;
					col = 1
				} else if (winWidth < 880) {
					conWidth = 660;
					col = 2
				} else if (winWidth < 1100) {
					conWidth = 880;
					col = 2;
				}else{
					conWidth = 1100;
					col = 3;
				}

				if (conWidth != currentWidth) {
					currentWidth = conWidth;
					$('#container').width(conWidth);
					$('#container').BlocksIt({
						numOfCol : col,
						offsetX : 8,
						offsetY : 8
					});
				}
			});
		});
		
		function loadImg(flag,list){
			if(flag){
				$('#container').empty();
			}
			for(var j=0;j<list.length;j++){
				var html="";
				var item=list[j];
				var  lnglatXY = [116.396574, 39.992706];
				var address=geocoder(lnglatXY);
				html='<div >'+
				'		<div class="grid">'+
				'			<div class="imgholder">'+
				'				<img   onclick="maxPic(\''+item.FILE_PATH+'\');" src="${pageContext.request.contextPath}/pictureSan/file.jsp?fileName='+item.FILE_PATH+'" onerror="this.src=\'/source/image/default.jpg\'"  />'+
				'			</div>'+
				'			<strong>'+item.CREATE_TIME+'</strong>'+
				'			<p class="address"  lng="'+item.GPS_LONGITUDE+'"  lat="'+item.GPS_LATITUDE+'">拍摄位置:</p>'+
				'			<p>'+item.VIOLATE_CONTENT+'</p>'+
				'		</div>'+
				'	</div> ';
			  $('#container').append($(html).html());
			  $(".address").each(function(i,obj){
				      geocoder(obj);
			  });
		     };	 
		     $('img').load(function(){
		    	  // 加载完成   
			     $('#container').BlocksIt({
						numOfCol : 3,
						offsetX : 8,
						offsetY : 8
					});
		    	});
		}
		function geocoder(obj) {
			if($(obj).attr('lng')==null||$(obj).attr('lng')==""||$(obj).attr('lat')==null||$(obj).attr('lat')=="")
				return;
			var point = new BMap.Point($(obj).attr('lng'),$(obj).attr('lat'));
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
	        	 $(obj).text("拍摄位置:"+address);
	        });
	    }
		
		function maxPic(filePath){
        		$("#max_container").empty();
        		var html='<a  href="/pictureSan/file.jsp?fileName='+filePath+'" data-lightbox="set"   title=""><img src="/pictureSan/file.jsp?fileName='+filePath+'"></a>';
     	       $("#max_container").append(html);
    	       //触发click事件
    	       $('#max_container a').eq(0).trigger("click");
		}
	</script>
</body>
</html>