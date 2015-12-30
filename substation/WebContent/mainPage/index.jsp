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
        <title>首页</title>
        <style>
		  #tabs {
		    overflow: hidden;
		    width: 100%;
		    margin: 20px 0px 0px 50px;
		    padding: 0;
		    list-style: none;
		  }
		  #tabs a {
		    float: left;
		    position: relative;
		    padding: 0 40px;
		    height: 0;
		    line-height: 40px;
		    text-transform: uppercase;
		    text-decoration: none;
		    color: #fff;      
		    border-right: 40px solid transparent;
		    border-bottom: 40px solid #3D3D3D;
		    border-bottom-color: #777\9;
		    opacity: .3;
		    filter: alpha(opacity=30);      
		  }
		  #tabs a:hover, #tabs a:focus {
		    border-bottom-color: #2ac7e1;
		    opacity: 1;
		    filter: alpha(opacity=100);
		  }
		  #tabs a:focus {
		    outline: 0;
		  }
		  #tabs #current {
		    z-index: 3;
		    border-bottom-color: #3d3d3d;
		    opacity: 1;
		    filter: alpha(opacity=100);      
		  }
		  #content {
		  	  background-color : #F7F7F7;
		      margin: 20px 50px; 
		      height: 700px;
		  } 
		  .content_tab{
		  	width: 100%;height: 100%;overflow: auto;
		  }
		  .md{
               height: 30px;
  			  		line-height: 20px;
  			  		background-position: center 15px;
  			 		 font-size: 16px;
          }
          #tab3 img{
          		vertical-align: middle;
          		width: 20px;
          		height: 20px; 
          		margin-bottom: 5px;
     		}
     	  .combo{margin-bottom: 8px;}
	    </style>  
	    <script>
	        var _mapFlag = false ;
		    $(function(){
		    	initTabs();
		    	initCalendar();
		    	initjzjlClick();
		    });
		    
		    function initTabs(){
	        	$("#content > div").hide();
		        $("#tabs li:first a").attr("id","current");
		        $("#content > div:first").fadeIn();
		        
		        $("#tabs a").on("click",function(e) {
		            e.preventDefault();
		            if ($(this).attr("id") == "current"){
		             return       
		            }
		            else{             
			            resetTabs();
			            $(this).attr("id","current");
			            $($(this).attr('name')).fadeIn();
		            	if($(this).attr('name') == '#tab3' & !_mapFlag){
		            		initMap();
		            		_mapFlag = true;
		            	}
		            }
		        });
	        }
		    function resetTabs(){
		        $("#content > div").hide(); //Hide all content
		        $("#tabs a").attr("id",""); //Reset id's      
		    }
		    
		    function initCalendar(){
		    	var now = new Date();
		    	$('#calendar').calendar({ 
		    		border:true,
		    	    formatter:function(data){
		    	    	if(now.getDate() === data.getDate()){
		    	    		return '<div class="icon-ok md">' + data.getDate() + '</div>';
		    	    	}else{
		    	    		return '<div class="icon-no md">' + data.getDate() + '</div>';
		    	    	}
		    	    }
		    	});
		    }
		    function initjzjlClick(){
		    	$('.gridtable a').click(function(e){
		    		e.preventDefault();
		    		parent.initIframePage('mainPage/jzjl_sy.jsp?id='+$(this).attr('href'));
		    	});
		    }
		    
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
   				/* var myIcon = new BMap.Icon("../source/image/people.png", new BMap.Size(32, 70), {    //小车图片
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
   				},1500); */
		    }
		</script>
    </head>
	<body>
		<ul id="tabs">
	     	<li><a href="javascript:(0)" name="#tab1">我的进站</a></li>
	      	<li><a href="javascript:(0)" name="#tab2">员工进站</a></li>
	      	<li><a href="javascript:(0)" name="#tab3">轨迹热点图</a></li>
		</ul>
		<div id="content">
		      <div id="tab1" class="content_tab">
		          <div style="margin: 5px 0px">
		          	  <span style="margin: 0px 10px 0px 60px">进站记录：30</span>
		          	  <span style="margin: 0px 10px 0px 60px">首次进站日期：2015-04-22 </span>
		          	  <span style="margin: 0px 10px 0px 60px">最近一次进站日期：2015-07-12</span>
		          </div>
		          <div style="text-align: center;">
		          	<h3>进站时间分布</h3>
		          </div>
		          <div id="calendar" style="width: 80%;height: 70%;margin: 0px auto;"></div>    
		      </div>
		      <div id="tab2" class="content_tab">
		          	<table class="gridtable">
						<tr>
							<th width="10%">序号</th><th width="10%">姓名</th><th width="15%">部门</th><th width="15%">职位</th><th width="20%">首次进站时间</th><th width="20%">最后一次进站时间</th><th width="10%">进站记录</th>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="1">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="2">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="3">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="4">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="1">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="2">Text 1C</a></td>
						</tr>
						<tr>
							<td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td>Text 1A</td><td>Text 1B</td><td>Text 1C</td><td><a href="3">Text 1C</a></td>
						</tr>
			  		</table> 
		      </div>
		      <div id="tab3" class="content_tab">
		      	  <div style="height: 50px;line-height: 50px;">
		          	  <span style="margin: 0px 10px 0px 20px;font-size: 18px;font-weight: bold;">员工轨迹热点图</span>
		          	  <span style="margin: 0px 10px 0px 60px"><img src="${pageContext.request.contextPath}/source/image/u400.png" />角色1</span>
		          	  <span style="margin: 0px 10px 0px 60px"><img src="${pageContext.request.contextPath}/source/image/u418.png" />角色2</span>
		          	  <span style="margin: 0px 60px 0px 60px"><img src="${pageContext.request.contextPath}/source/image/u408.png" />角色3</span>
		          	  <select id="timeSelect" class="easyui-combobox" name="time" style="width:150px;height: 30px;">   
						    <option value="hour">1小时</option>   
						    <option value="day">1天内</option>   
						    <option value="tday">3天内</option>   
						    <option value="week">1周内</option>   
						    <option value="all">全部</option>   
					  </select> 
		          </div>
		          <div id="map" style=" width:100% ;height: 650px;"></div>
		      </div>
    	</div>
	</body>
</html>