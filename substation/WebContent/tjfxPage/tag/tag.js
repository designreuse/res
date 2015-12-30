'use strict';

var tagModule = angular.module('tagModule', ['ngResource','statisApp']);


tagModule.controller('TagController',
		['$scope', 'tagService','CommonService',
		function($scope, tagService,CommonService) {
			
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
			var tagToday = function(divId){
				tagService.tagTodayNum({params:currentProjectId},function(personNum) {
					var chartDate = buildLineData(personNum,"in_time","in_date_num","");
					var todayNum = chartDate.todayNum;
					//当天移动用户活跃人数
					$scope.todayNum = todayNum;
					//按时间段折线图，查当天
					$("#"+divId).height(150*heightRatio);
					drawLineChart(divId,chartDate,'标签活跃人数','人');
					
				});
			};
			
			//默认加载当天-标签活跃人数
			tagToday("dateLine");
			
			var whereToday = currentProjectId+separator+"to_days(create_time)"+separator+"to_days(now())";
			//已绑定标签人数
			tagService.tagPersonNum({params:currentProjectId},function(tagPersonNum) {
				$scope.tagPersonNumToday = tagPersonNum[0].result;
				
				//查询已绑定标签数
				tagService.tagBindNum({params:currentProjectId},function(tagBindNum) {
					//未检测标签数=已绑定标签数量-已检测标签数量
					$scope.tagNoBindNumToday = tagBindNum[0].result-tagPersonNum[0].result;
				});
				
			});
			
			
			//日期选择查询
			$scope.queryDate = function(){
				
				//判断查询当天量
				if($scope.selectedDate == currentDate){
					tagToday("dateLine");
				}
				else
				{
					var whereDate = currentProjectId+separator+$scope.selectedDate+separator+$scope.selectedDate;
					tagService.tagBetweenNum({params:whereDate},function(personNum) {
						var chartDate = lineEmptyDate;
						var obj = "";
						if(personNum.length>0){
							obj = eval('('+personNum[0].in_time_num+')');
						}
							
						chartDate = fillEmptyLineData(obj);
						
						drawLineChart("dateLine",chartDate,'标签活跃人数','人');
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
					tagToday("rangeLine");
				}
				else
				{
					var whereDate = currentProjectId+separator+$scope.fromDate+separator+$scope.untilDate;
					tagService.tagBetweenNum({params:whereDate},function(personNum) {
						var chartDate = lineEmptyDate;
						if(personNum.length >0 ){
							chartDate = buildLineData(personNum,"in_date","in_date_num",$scope.fromDate+","+$scope.untilDate);
						}
						drawLineChart("rangeLine",chartDate,'标签活跃人数','人');
					});
				}
			};
				
			//延时调用当天数据汇总存储过程
			window.setTimeout(function(){
				
				tagService.callProcTag({},function(data) {
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

tagModule.factory('tagService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 callProcTag: {
							 method: 'GET',
							 params: {
								 method : 'call_proc_tag'
							 }, 
							 isArray:true
						 },
						 tagTodayNum: {
							 method: 'GET',
							 params: {
								 method : 'tag_today_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagPersonNum: {
							 method: 'GET',
							 params: {
								 method : 'tag_person_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagBindNum: {
							 method: 'GET',
							 params: {
								 method : 'tag_bind_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagBetweenNum: {
							 method: 'GET',
							 params: {
								 method : 'tag_between_num',
								 params: '@params'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

