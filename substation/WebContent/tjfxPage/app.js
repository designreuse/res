'use strict';

/* App Module */

var statisApp = angular.module('statisApp', [
	'ngRoute',
	'mgcrea.ngStrap.datepicker'
]);

statisApp.config(['$routeProvider', function($routeProvider) {
	$routeProvider.when('/home', {
		templateUrl : 'home/centent.html',
		controller : 'HomeController'	
	}).when('/mobile', {
		templateUrl : 'mobile/centent.html',
		controller : 'MobileController'
	}).when('/peccancy', {
		templateUrl : 'peccancy/centent.html',
		controller : 'PeccancyController'
	}).when('/personnel', {
		templateUrl : 'personnel/centent.html',
		controller : 'PersonnelController'
	}).when('/tag', {
		templateUrl : 'tag/centent.html',
		controller : 'TagController'
	}).otherwise({
		templateUrl : 'home/centent.html',
		controller : 'HomeController'	
	});
	
	
} ]);

statisApp.config(function($datepickerProvider) {
  angular.extend($datepickerProvider.defaults, {
    dateFormat: 'yyyy-MM-dd',
    startWeek: 1
  });
});

statisApp.factory('CommonService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 currentDate: {
							 method: 'GET',
							 params: {
								 method : 'current_date'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

//获取当前工程id
var getCurrentProjectId = function(){
	return parent._$comboboxObj.id;
//	return "k3ezdrxlzm9jl1icnq76wlkph2dtm72e";
};
//var restPathRoot = "http://substation.hhwy.org";
var restPathRoot = "../..";
//var restPathRoot = "http://localhost:8080/rest-webapp";
//传参数分隔符
var separator = "`";
//折线图空数据json
var lineEmptyDate = {"items":{"dateTime":['无数据'],"value":[0]}};
//柱状图空数据json
var barEmptyDate = {"legend":['空数据'],"value":[{value:0, name:'空数据'}]};
//ecahrts绘制折线图
var drawLineChart = function(divId,data,title,unit){
	
	var myChart = echarts.init(document.getElementById(divId));
		
		var option = {
			    tooltip : {							        
			        trigger: 'axis',
				    formatter: "{c}("+unit+")"
			    },
			    calculable : false,
			    xAxis : [
			        {
			            type : 'category',
			            boundaryGap : false,
			            data : data.items.dateTime
			        }
			    ],
			    yAxis : [
			        {
			            type : 'value'
			        }
			    ],
			    grid:{
			    	x:35,
			    	y:5,
			    	x2:35,
			    	y2:30
			    },
			    series : [
			        {
			            name:title,
			            type:'line',
			            data:data.items.value
			        }
			    ]
			};
        myChart.setOption(option);
        
        //自适应分辨率
        addResizeEvent(function(){
    		$("#"+divId).width("100%");
        	myChart.resize();
    	});
        
        return myChart;
        
};

//构建柱状图数据
var buildLineData = function(arrayNum,xName,yName,dayRange){
	var chartDate = {"todayNum":0,"items":{"dateTime":['无数据'],"value":[0]}};
	var dateTime = [];
	var value = [];
	var todayNum = 0;
	//默认横轴显示内容为24小时
	var xRangeArray = ['00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00','08:00','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00'];
	//按日期区间构建日期数组，并作为横轴显示内容
	if(dayRange.indexOf(",") != -1){
		var start = dayRange.split(",")[0];
		var end = dayRange.split(",")[1];
		xRangeArray = [start];
		while(start != end){
			start = addDate(start,1);
			xRangeArray.push(start);
		}
	}
	
	xRangeArray.forEach(function(x){  
		//是否有数据标志
		var f = false;
		//x轴名称
		dateTime.push(x);
		for(var i=0;i<arrayNum.length;i++){
			if(x == eval("arrayNum["+i+"]."+xName)){
				value.push(eval("arrayNum["+i+"]."+yName));
				todayNum += eval("arrayNum["+i+"]."+yName);
				f = true;
				break;
			}
		}
		
		if(!f){
			value.push(0);
		}
		
	});
	
	chartDate.items.dateTime = dateTime;
	chartDate.items.value = value;
	chartDate.todayNum = todayNum;
	return chartDate;
};

//补充空数据到按小时查询的折线图中
var fillEmptyLineData=function(obj){
	var chartDate = {"items":{"dateTime":['无数据'],"value":[0]}};
	var value = [];
	//默认横轴显示内容为24小时
	var xRangeArray = ['00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00','08:00','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00'];
	if(obj != ""){
		var xValue = obj.items.dateTime;
		var yValue = obj.items.value;
		xRangeArray.forEach(function(x){  
			//是否有数据标志
			var f = false;
			for(var i=0;i<xValue.length;i++){
				if(x == xValue[i]){
					value.push(yValue[i]);
					f = true;
					break;
				}
			}
			
			if(!f){
				value.push(0);
			}
			
		});
		
		chartDate.items.value = value;
		
	}
	else
	{
		chartDate.items.value = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	}
	
	chartDate.items.dateTime = xRangeArray;
	
	return chartDate;
};

//日期加天数
function addDate(date,days){ 
    var d=new Date(date); 
    d.setDate(d.getDate()+days); 
    var month = d.getMonth() + 1;
    if (parseInt(month) < 10)
        month = "0" + month;
    var day = d.getDate();
    if (parseInt(day) < 10)
        day = "0" + day;
    var date = (d.getFullYear()) + "-" + month + "-" + day;
    
    return date; 
}

//echarts绘制柱状图
var drawBarChart = function(divId,data,title,theme){
	
	var myChart1 = echarts.init(document.getElementById(divId));
	
	var option = { 
			 tooltip : {
				 trigger: 'axis'
			 },
			 calculable : false,
			 xAxis : [
			          {
			        	  type : 'category',
			        	  data : data.legend
			          }
			          ],
			          yAxis : [
			                   {
			                	   type : 'value'
			                   }
			                   ],
			                   grid:{
			                	   x:25,
			                	   y:10,
			                	   x2:35,
			                	   y2:30
			                   },
			                   series : [
			                             {
			                            	 name:title,
			                            	 type:'bar',
			                            	 itemStyle : { normal: {label : {show: true, position: 'top'}}},
			                            	 data:data.value         
			                            	 
			                             }
			                             
			                             ]
	 };
		                    
	
	myChart1.setOption(option);
	myChart1.setTheme(theme);
	
	//自适应分辨率
	addResizeEvent(function(){
		$("#"+divId).width("100%");
    	myChart1.resize();
	});
	
	return myChart1;
	
};

//构建柱状图数据
var buildBarData = function(arrayNum,legendName,valueName){
	var chartDate = barEmptyDate;
	var legend = [];
	var value = [];
	arrayNum.forEach(function(e){  
		legend.push(eval("e."+legendName));
		var elem = {value:"",name:""};
		elem.value=eval("e."+valueName);
		elem.name=eval("e."+legendName);
		value.push(elem);
	});
	
	chartDate.legend = legend;
	chartDate.value = value;
	return chartDate;
};

//echarts绘制饼图
var drawPieChart = function(divId,data,title,theme){
	
	var myChart2 = echarts.init(document.getElementById(divId));
		
	var option = {
		    tooltip : {
		        trigger: 'item',
		        formatter: "{d}%"
		    },
		    calculable : false,
		    legend: {
		        orient : 'horizontal',
		        y : 'bottom',
		        data:data.legend
		    }, 
		    series : [
		        {
		            name:title,
		            type:'pie',
		            radius : ['30%', '70%'],
		            center: ['50%', '50%'],
		          itemStyle : {
		                normal : {
		                    label : {
		                        position : 'inner',
		                        formatter : "{d}%"
		                    },
		                    labelLine : {
		                        show : false,
		                        length : 1
		                    }
		                }
		            },
		            data:data.value
		        }
		    ]
		};
	
        myChart2.setOption(option);
        myChart2.setTheme(theme);
        
      //自适应分辨率
        addResizeEvent(function(){
    		$("#"+divId).width("100%");
        	myChart2.resize();
    	});
        
        return myChart2;
        
};

//追加window.onresize事件
function addResizeEvent(func) {
	  var old = window.onresize;
	  if (typeof window.onresize != 'function') {
	    window.onresize = func;
	  } else {  
	    window.onresize = function() {
	      old();
	      func();
	    }
	  }
}

//从日期中截取月份，日期格式为yyyy-mm-dd
function getMonthByDate(date){
	var arrayDate = date.split("-");
	return arrayDate[0] + "-" + arrayDate[1];
}