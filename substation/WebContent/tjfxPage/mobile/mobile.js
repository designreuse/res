'use strict';

var mobileModule = angular.module('mobileModule', [
                                                    'ngResource',
                                                    'statisApp'
                                                    ]);



mobileModule.controller('MobileController',
		['$scope', 'MobileService','CommonService',
		function($scope, MobileService,CommonService) {
			
			var heightRatio = $(window).height()/666;
			var currentProjectId = getCurrentProjectId();
			
			//当天日期
			var currentDate;
			//当前年月
			var currentMonth;
			CommonService.currentDate({},function(current) {
				currentDate = current[0].result;
				currentMonth = getMonthByDate(currentDate);
				$scope.selectedDate = currentDate;
				$scope.fromDate = currentMonth+"-01";
				$scope.untilDate = currentDate;
				
			});
			
			//查询当天量
			var mobileToday = function(divId){
				MobileService.mobileTodayNum({params:currentProjectId},function(personNum) {
					var chartDate = buildLineData(personNum,"in_time","in_date_num","");
					var todayNum =  chartDate.todayNum;
					
					//当天移动用户活跃人数
					$scope.todayNum = todayNum;
					//按时间段折线图，查当天
					$("#"+divId).height(150*heightRatio);
					var chart = drawLineChart(divId,chartDate,'移动应用活跃用户数','人');
					
				});
			};
			
			//默认加载当天-进站人数
			mobileToday("dateLine");
			
			//累计活跃用户数
			var where = currentProjectId+separator+"1"+separator+"1";
			MobileService.moblieNum({params:currentProjectId},function(allMoblieNum) {
				$scope.allMoblieNum = allMoblieNum[0].result;
			});
			
			//日期选择查询
			$scope.queryDate = function(){
				//判断查询当天量
				if($scope.selectedDate == currentDate){
					mobileToday("dateLine");
				}
				else
				{
					var whereDate = currentProjectId+separator+$scope.selectedDate+separator+$scope.selectedDate;
					MobileService.mobileBetweenNum({params:whereDate},function(personNum) {
						var chartDate = lineEmptyDate;
						var obj = "";
						if(personNum.length>0){
							obj = eval('('+personNum[0].in_time_num+')');
						}
							
						chartDate = fillEmptyLineData(obj);
						
						var chart1 = drawLineChart("dateLine",chartDate,'移动应用活跃用户数','人');
					});
				}
				
			};
			
			//日期区间选择查询
			$scope.queryDateRange = function(){
				
				if($scope.fromDate==null || $scope.untilDate==null){
					return ;
				}
				
				//判断查询当天量
				if($scope.fromDate == currentDate && $scope.untilDate == currentDate){
					mobileToday("rangeLine");
				}
				else
				{
					var whereDate = currentProjectId+separator+$scope.fromDate+separator+$scope.untilDate;
					MobileService.mobileBetweenNum({params:whereDate},function(personNum) {
						var chartDate = buildLineData(personNum,"in_date","in_date_num",$scope.fromDate+","+$scope.untilDate);
						drawLineChart("rangeLine",chartDate,'移动应用活跃用户数','人');
					});
				}
			};
			
			//延时调用当天数据汇总存储过程
			window.setTimeout(function(){
				
				MobileService.callProcMobile({},function(data) {
				});
				
	        }, 100);
			
				//按天页签点击事件
				$scope.dateTabSelect = function(){
					$("#rangeLine").height(150*heightRatio);
					$("#rangeLine").width("100%");
					
					$scope.queryDateRange();
				};
				
							
		} 
		 
]);

mobileModule.factory('MobileService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 callProcMobile: {
							 method: 'GET',
							 params: {
								 method : 'call_proc_moblie'
							 }, 
							 isArray:true
						 },
						 mobileTodayNum: {
							 method: 'GET',
							 params: {
								 method : 'mobile_today_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 moblieNum: {
							 method: 'GET',
							 params: {
								 method : 'moblie_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 mobileBetweenNum: {
							 method: 'GET',
							 params: {
								 method : 'mobile_between_num',
								 params: '@params'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

