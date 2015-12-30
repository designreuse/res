'use strict';

var peccancyModule = angular.module('peccancyModule', ['ngResource','statisApp']);


peccancyModule.controller('PeccancyController',
		['$scope', 'PeccancyService','CommonService',
		function($scope, PeccancyService,CommonService) {
			
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
			
			//默认加载当天-进站人数
			var peccancyToday = function(divId){
				PeccancyService.peccancyTodayNum({params:currentProjectId},function(personNum) {
					var chartDate = buildLineData(personNum,"in_time","in_date_num","");
					var todayNum = chartDate.todayNum;
					//当天违章量
					$scope.todayNum = todayNum;
					//按时间段折线图，查当天
					$("#"+divId).height(150*heightRatio);
					drawLineChart(divId,chartDate,'违章条数','条');
					
				});
			};
			
			//默认加载当天-违章数，折线图
			peccancyToday("dateLine");
			
			//var whereToday = currentProjectId+separator+"to_days(create_time)"+separator+"to_days(now())";
			//违章人数
			PeccancyService.violatePersonNum({params:currentProjectId},function(violatePersonNum) {
				$scope.violatePersonNumToday = violatePersonNum[0].result;
			});
			//违章照片数量
			PeccancyService.violatePhotoNum({params:currentProjectId},function(violatePhotoNum) {
				$scope.violatePhotoNumToday = violatePhotoNum[0].result;
			});
			var where = currentProjectId+separator+"1"+separator+"1";
			//累计违章数
			PeccancyService.violateNum({params:currentProjectId},function(allViolateNum) {
				$scope.allViolateNum = allViolateNum[0].result;
			});
			//累计违章人数
			PeccancyService.violatePersonNum({params:currentProjectId},function(allViolatePersonNum) {
				$scope.allViolatePersonNumToday = allViolatePersonNum[0].result;
			});
			//累计违章照片数量
			PeccancyService.violatePhotoNum({params:currentProjectId},function(allViolatePhotoNum) {
				$scope.allViolatePhotoNumToday = allViolatePhotoNum[0].result;
			});
			
			//************************************************************************************
			
			//违章量柱状图-当天
			PeccancyService.violateRoleToday({params:currentProjectId},function(peccancyNum) {
				var chartDate = barEmptyDate;
				var todayNum = 0;
				if(peccancyNum.length >0 ){
					todayNum = peccancyNum[0].in_date_num;
					chartDate = buildBarData(peccancyNum,"role_id","in_date_num");
				}
				//当天移动用户活跃人数
				$scope.todayNum = todayNum;
				//按时间段折线图，查当天
				$("#peccancyBar").height(170*heightRatio);
				drawBarChart("peccancyBar",chartDate,'违章量','macarons');
				
			});
			//违章拍摄量柱状图-当天
			PeccancyService.violatePhotoToday({params:currentProjectId},function(peccancyNum) {
				var chartDate = barEmptyDate;
				if(peccancyNum.length >0 ){
					chartDate = buildBarData(peccancyNum,"create_user","in_date_num");
				}
				//按时间段折线图，查当天
				$("#photoBar").height(170*heightRatio);
				drawBarChart("photoBar",chartDate,'违章拍摄量','macarons2');
				
			});
			//各单位违章量环形图-当天
			PeccancyService.violateOrgToday({params:currentProjectId},function(peccancyNum) {
				var chartDate = barEmptyDate;
				if(peccancyNum.length >0 ){
					chartDate = buildBarData(peccancyNum,"org_id","in_date_num");
				}
				
				$("#orgPie").height(200*heightRatio);
				drawPieChart("orgPie",chartDate,"各单位违章比例",'macarons');
				
			});
			//各工种违章量环形图-当天
			PeccancyService.violateOrgToday({params:currentProjectId},function(peccancyNum) {
				var chartDate = barEmptyDate;
				if(peccancyNum.length >0 ){
					chartDate = buildBarData(peccancyNum,"work_type","in_date_num");
				}
				
				$("#workPie").height(200*heightRatio);
				drawPieChart("workPie",chartDate,"各工种违章比例",'macarons2');
				
			});
			
			//违章量-时间折线图按日期区间或单独日期查询
			var peccancyNumLine = function(where,divId,isRange){
				PeccancyService.peccancyBetweenNum({params:where},function(personNum) {
					var chartDate = lineEmptyDate;
						if(isRange){
							chartDate = buildLineData(personNum,"in_date","in_date_num",$scope.fromDate+","+$scope.untilDate);
						}
						else
						{
							var obj = "";
							if(personNum.length>0){
								obj = eval('('+personNum[0].in_time_num+')');
							}
								
							chartDate = fillEmptyLineData(obj);
						}
					drawLineChart(divId,chartDate,'违章条数','条');
				});
			};
			//违章量-角色柱状图按日期区间或单独日期查询
			var peccancyRoleBar = function(where,divId){
				PeccancyService.violateRoleBetween({params:where},function(peccancyNum) {
					var chartDate = barEmptyDate;
					if(peccancyNum.length >0 ){
						chartDate = buildBarData(peccancyNum,"role_id","in_date_num");
					}
					drawBarChart(divId,chartDate,'违章量','macarons');
				});
			};
			//违章拍摄量-拍摄人柱状图按日期区间或单独日期查询
			var peccancyPhotoBar = function(where,divId){
				PeccancyService.violatePhotoBetween({params:where},function(peccancyNum) {
					var chartDate = barEmptyDate;
					if(peccancyNum.length >0 ){
						chartDate = buildBarData(peccancyNum,"create_user","in_date_num");
					}
					//按时间段折线图，查当天
					drawBarChart(divId,chartDate,'违章拍摄量','macarons2');
				});
			};
			//各单位违章量按日期区间或单独日期查询
			var peccancyOrgPie = function(where,divId){
				PeccancyService.violateOrgBetween({params:where},function(peccancyNum) {
					var chartDate = barEmptyDate;
					if(peccancyNum.length >0 ){
						chartDate = buildBarData(peccancyNum,"org_id","in_date_num");
					}
					drawPieChart(divId,chartDate,"各单位违章比例",'macarons');
				});
			};
			//各工种违章量按日期区间或单独日期查询
			var peccancyWorkPie = function(where,divId){
				PeccancyService.violateWorkBetween({params:where},function(peccancyNum) {
					var chartDate = barEmptyDate;
					if(peccancyNum.length >0 ){
						chartDate = buildBarData(peccancyNum,"work_type","in_date_num");
					}
					
					drawPieChart(divId,chartDate,"各工种违章比例",'macarons2');
				});
			};
			
			
			
			//日期选择查询
			$scope.queryDate = function(){
				
				var whereDate = currentProjectId+separator+$scope.selectedDate+separator+$scope.selectedDate;
				
				//判断查询当天量-折线图图
				if($scope.selectedDate == currentDate){
					peccancyToday("dateLine");
				}
				else
				{
					peccancyNumLine(whereDate,"dateLine",false);
				}
				
				//违章量柱状图
				peccancyRoleBar(whereDate,"peccancyBar");
				
				//违章拍摄量柱状图
				peccancyPhotoBar(whereDate,"photoBar");
				
				//各单位违章量环形图
				peccancyOrgPie(whereDate,"orgPie");
				
				//各工种违章量环形图
				peccancyWorkPie(whereDate,"workPie");
				
			};
			
			//日期区间选择查询
			$scope.queryDateRange = function(){
				
				if($scope.fromDate==null || $scope.untilDate==null){
					return ;
				}
				
				var whereDate = currentProjectId+separator+$scope.fromDate+separator+$scope.untilDate;
				
				//判断查询当天量-折线图
				if($scope.fromDate == currentDate && $scope.untilDate == currentDate){
					peccancyToday("rangeLine");
				}
				else
				{
					peccancyNumLine(whereDate,"rangeLine",true);
					
				}
				
				//违章量柱状图
				peccancyRoleBar(whereDate,"peccancyBar");
				
				//违章拍摄量柱状图
				peccancyPhotoBar(whereDate,"photoBar");
				
				//各单位违章量环形图
				peccancyOrgPie(whereDate,"orgPie");
				
				//各工种违章量环形图
				peccancyWorkPie(whereDate,"workPie");
				
				
			};
				
			//延时调用当天数据汇总存储过程
			window.setTimeout(function(){
				
				PeccancyService.callProcViolate({},function(data) {
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

peccancyModule.factory('PeccancyService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 callProcViolate: {
							 method: 'GET',
							 params: {
								 method : 'call_proc_violate'
							 }, 
							 isArray:true
						 },
						 peccancyTodayNum: {
							 method: 'GET',
							 params: {
								 method : 'peccancy_today_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateNum: {
							 method: 'GET',
							 params: {
								 method : 'violate_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePersonNum: {
							 method: 'GET',
							 params: {
								 method : 'violate_person_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePhotoNum: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 peccancyBetweenNum: {
							 method: 'GET',
							 params: {
								 method : 'peccancy_between_num',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateRoleToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_role_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateRoleBetween: {
							 method: 'GET',
							 params: {
								 method : 'violate_role_between',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePhotoToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePhotoBetween: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_between',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateOrgToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_org_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateOrgBetween: {
							 method: 'GET',
							 params: {
								 method : 'violate_org_between',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateWorkToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_work_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateWorkBetween: {
							 method: 'GET',
							 params: {
								 method : 'violate_work_between',
								 params: '@params'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

