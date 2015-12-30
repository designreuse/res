'use strict';

var personnelModule = angular.module('personnelModule', ['ngResource','statisApp']);


personnelModule.controller('PersonnelController',
		['$scope', 'personnelService','CommonService',
		function($scope, personnelService,CommonService) {
			
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
				
				$scope.orgId = "";
				$scope.workCode = "";
				$scope.currentTab="day";
				//拼接查询条件（按单位名称或工种名称）
				var buildWhere = function(){
					var where = "";
					var org = '%';
					var work = '%';
					var flag = false;
					if($scope.orgId != ""){
						org = $scope.orgId;
						flag = true;
					}
					if($scope.workCode != ""){
						work = $scope.workCode;
						flag = true;
					}
					
					if(flag){
						where =currentProjectId + separator + currentProjectId + separator + org + separator + work;
					}
					return where;
				}
				
				//当天查询结果渲染
				var todayRender = function(personNum,divId){
					var chartDate = buildLineData(personNum,"in_time","in_date_num","");
					var todayNum = chartDate.todayNum;
					//当天人数
					$scope.todayNum = todayNum;
					//按时间段折线图，查当天
					$("#"+divId).height(150*heightRatio);
					drawLineChart(divId,chartDate,'进站人数','人');
				};
				//按天查询结果渲染
				var queryDateRender = function(personNum){
					var chartDate = lineEmptyDate;
					var obj = "";
					if(personNum.length>0){
						obj = eval('('+personNum[0].in_time_num+')');
					}
					
					chartDate = fillEmptyLineData(obj);
					
					drawLineChart("dateLine",chartDate,'进站人数','人');
				};
				
				//默认加载当天-进站人数
				var inToday = function(divId){
					var condition = buildWhere();
					if(condition != ""){
						personnelService.inTodayNumWhere({params:condition},function(personNum) {
							todayRender(personNum,divId);						
						});
					}
					else
					{
						personnelService.inTodayNum({params:currentProjectId},function(personNum) {
							
							todayRender(personNum,divId);
							
						});
					}
				};
				
				//默认加载当天-进站人数
				inToday("dateLine");
				
				//工程总人数
				personnelService.allPersonNum({params:currentProjectId},function(allPersonNum) {
					$scope.allPersonNum = allPersonNum[0].result;
				});
				
				//日期选择查询
				$scope.queryDate = function(){
					//判断查询当天量
					if($scope.selectedDate == currentDate){
						inToday("dateLine");
					}
					else
					{
						var condition = buildWhere();
						if(condition != ""){
							var whereDate = condition+separator+$scope.selectedDate+separator+$scope.selectedDate;
							personnelService.inBetweenNumWhere({params:whereDate},function(personNum) {
								queryDateRender(personNum);
							});

						}
						else
						{
							var whereDate = currentProjectId+separator+$scope.selectedDate+separator+$scope.selectedDate;
							personnelService.inBetweenNum({params:whereDate},function(personNum) {
								queryDateRender(personNum);
							});
							
						}
					}
				};
				
				//日期区间选择查询
				$scope.queryDateRange = function(){
					
					if($scope.fromDate==null || $scope.untilDate==null){
						return ;
					}
					
					//判断查询当天量
					if($scope.fromDate == currentDate && $scope.untilDate == currentDate){
						inToday("rangeLine");
					}
					else
					{
						var condition = buildWhere();
						if(condition != ""){
							var whereDate = condition+separator+$scope.fromDate+separator+$scope.untilDate;
							personnelService.inBetweenNumWhere({params:whereDate},function(personNum) {
								var chartDate = buildLineData(personNum,"in_date","in_date_num",$scope.fromDate+","+$scope.untilDate);
								drawLineChart("rangeLine",chartDate,'进站人数','人');
							});
						}
						else
						{
							var whereDate = currentProjectId+separator+$scope.fromDate+separator+$scope.untilDate;
							personnelService.inBetweenNum({params:whereDate},function(personNum) {
								var chartDate = buildLineData(personNum,"in_date","in_date_num",$scope.fromDate+","+$scope.untilDate);
								drawLineChart("rangeLine",chartDate,'进站人数','人');
							});
						}
						
					}
					
				};
				
				//延时调用当天数据汇总存储过程
				window.setTimeout(function(){
					
					personnelService.callProcPerson({},function(data) {
					});
					
		        }, 100);
				
				//按天页签点击事件
				$scope.dateTabSelect = function(){
					$scope.currentTab="range";
					$("#rangeLine").height(150*heightRatio);
					$("#rangeLine").width("100%");
					
					$scope.queryDateRange();
				};
				
				//************************************************************************
				
				//组织机构作业列表
				personnelService.org({params:currentProjectId},function(data){
					$scope.orgs = data;
				});
				
				//工种作业列表
				personnelService.work({params:currentProjectId},function(data){
					$scope.works = data;
				});
				
				$scope.execQuery = function(){
					if($scope.currentTab=="day"){
						$scope.queryDate();
					}
					else
					{
						$scope.queryDateRange();
					}
					
				};
				
				$scope.selectOrg = function(orgId){
					
					$("#org_"+orgId).toggleClass("td-active");
					
					if($scope.orgId == ""){
						$scope.orgId = orgId;
					}
					else
					{
						$scope.orgId = "";
					}
					
					$scope.execQuery();
				};
				$scope.selectWork = function(workCode){
					
					$("#work_"+workCode).toggleClass("td-active");
					
					if($scope.workCode == ""){
						$scope.workCode = workCode;
					}
					else
					{
						$scope.workCode = "";
					}
					
					$scope.execQuery();
				};
				
		} 
		 
]);

personnelModule.factory('personnelService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 callProcPerson: {
							 method: 'GET',
							 params: {
								 method : 'call_proc_person'
							 }, 
							 isArray:true
						 },
						 inTodayNum: {
							 method: 'GET',
							 params: {
								 method : 'in_today_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 inTodayNumWhere: {
							 method: 'GET',
							 params: {
								 method : 'in_today_num_where',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 allPersonNum: {
							 method: 'GET',
							 params: {
								 method : 'all_person_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 inBetweenNum: {
							 method: 'GET',
							 params: {
								 method : 'in_between_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 inBetweenNumWhere: {
							 method: 'GET',
							 params: {
								 method : 'in_between_num_where',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 org: {
							 method: 'GET',
							 params: {
								 method : 'inout_org',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 work: {
							 method: 'GET',
							 params: {
								 method : 'inout_work',
							     params: '@params'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

