'use strict';

var homeModule = angular.module('homeModule', ['ngResource','statisApp']);


homeModule.controller('HomeController',
		['$scope', 'HomeService',
		function($scope, HomeService) {
			
			var currentProjectId = getCurrentProjectId();
			//当天-左上位置-进站人数
			HomeService.inNumToday({params:currentProjectId},function(inNum) {
	    		$scope.inNumToday = inNum[0].result;
			 });
			
			//工程总人数
			HomeService.allPersonNum({params:currentProjectId},function(allPersonNum) {
				$scope.allPersonNum = allPersonNum[0].result;
			});
			
			//----------------------------------------------------
			
			//当天-右上位置-已检测标签人数
			HomeService.tagNumYesToday({params:currentProjectId},function(tagNumYes) {
				$scope.tagNumYesToday = tagNumYes[0].result;
				
				//查询已绑定标签数
				HomeService.tagBindNumToday({params:currentProjectId},function(tagBindNum) {
					//未检测标签数=已绑定标签数量-已检测标签数量
						$scope.tagNoBindNumToday = tagBindNum[0].result-tagNumYes[0].result;
				});
			});
			//已绑定标签人数
			HomeService.tagPersonNumToday({params:currentProjectId},function(tagPersonNum) {
				$scope.tagPersonNumToday = tagPersonNum[0].result;
			});
			
			
			//---------------------------------------------------
			//当天-左下位置-移动应用活跃用户数
			HomeService.moblieNumToday({params:currentProjectId},function(moblieNum) {
				$scope.moblieNumToday = moblieNum[0].result;
			});
			
			//累计活跃用户数
			HomeService.moblieNum({params:currentProjectId},function(allMoblieNum) {
				$scope.allMoblieNum = allMoblieNum[0].result;
			});
			
			//---------------------------------------------------
			//当天-右下位置-违章数
			HomeService.violateNumToday({params:currentProjectId},function(violateNum) {
				$scope.violateNumToday = violateNum[0].result;
			});
			//违章人数
			HomeService.violatePersonNumToday({params:currentProjectId},function(violatePersonNum) {
				$scope.violatePersonNumToday = violatePersonNum[0].result;
			});
			//违章照片数量
			HomeService.violatePhotoNumToday({params:currentProjectId},function(violatePhotoNum) {
				$scope.violatePhotoNumToday = violatePhotoNum[0].result;
			});
			
			//累计违章数
			HomeService.violateNum({params:currentProjectId},function(allViolateNum) {
				$scope.allViolateNum = allViolateNum[0].result;
			});
			//累计违章人数
			HomeService.violatePersonNum({params:currentProjectId},function(allViolatePersonNum) {
				$scope.allViolatePersonNumToday = allViolatePersonNum[0].result;
			});
			//累计违章照片数量
			HomeService.violatePhotoNum({params:currentProjectId},function(allViolatePhotoNum) {
				$scope.allViolatePhotoNumToday = allViolatePhotoNum[0].result;
			});
			
			//***************************************************************************
			//本周数据
			var weekData = function(){
				
			//本周-左上位置-进站人数
			HomeService.inNumWeek({params:currentProjectId},function(inNum) {
				$scope.inNumWeek = inNum[0].result;
			});
			
			//----------------------------------------------------
			
			//本周-右上位置-已检测标签人数
			HomeService.tagNumYesWeek({params:currentProjectId},function(tagNumYes) {
				$scope.tagNumYesWeek = tagNumYes[0].result;
				
				//查询已绑定标签数
				HomeService.tagBindNumWeek({params:currentProjectId},function(tagBindNum) {
					//未检测标签数=已绑定标签数量-已检测标签数量
					$scope.tagNoBindNumWeek = tagBindNum[0].result-tagNumYes[0].result;
				});
			});
			//已绑定标签人数
			HomeService.tagPersonNumWeek({params:currentProjectId},function(tagPersonNum) {
				$scope.tagPersonNumWeek = tagPersonNum[0].result;
			});
			
			
			//---------------------------------------------------
			//本周-左下位置-移动应用活跃用户数
			HomeService.moblieNumWeek({params:currentProjectId},function(moblieNum) {
				$scope.moblieNumWeek = moblieNum[0].result;
			});
			
			//---------------------------------------------------
			//本周-右下位置-违章数
			HomeService.violateNumWeek({params:currentProjectId},function(violateNum) {
				$scope.violateNumWeek = violateNum[0].result;
			});
			//违章人数
			HomeService.violatePersonNumWeek({params:currentProjectId},function(violatePersonNum) {
				$scope.violatePersonNumWeek = violatePersonNum[0].result;
			});
			//违章照片数量
			HomeService.violatePhotoNumWeek({params:currentProjectId},function(violatePhotoNum) {
				$scope.violatePhotoNumWeek = violatePhotoNum[0].result;
			});
			
			};
			
			//***************************************************************************
			//本月数据
			var monthData = function(){
				
			//本月-左上位置-进站人数
			HomeService.inNumMonth({params:currentProjectId},function(inNum) {
				$scope.inNumMonth = inNum[0].result;
			});
			
			//----------------------------------------------------
			
			//本月-右上位置-已检测标签人数
			HomeService.tagNumYesMonth({params:currentProjectId},function(tagNumYes) {
				$scope.tagNumYesMonth = tagNumYes[0].result;
				
				//查询已绑定标签数
				HomeService.tagBindNumMonth({params:currentProjectId},function(tagBindNum) {
					//未检测标签数=已绑定标签数量-已检测标签数量
					$scope.tagNoBindNumMonth = tagBindNum[0].result-tagNumYes[0].result;
				});
			});
			//已绑定标签人数
			HomeService.tagPersonNumMonth({params:currentProjectId},function(tagPersonNum) {
				$scope.tagPersonNumMonth = tagPersonNum[0].result;
			});
			
			
			//---------------------------------------------------
			//本月-左下位置-移动应用活跃用户数
			HomeService.moblieNumMonth({params:currentProjectId},function(moblieNum) {
				$scope.moblieNumMonth = moblieNum[0].result;
			});
			
			//---------------------------------------------------
			//本月-右下位置-违章数
			HomeService.violateNumMonth({params:currentProjectId},function(violateNum) {
				$scope.violateNumMonth = violateNum[0].result;
			});
			//违章人数
			HomeService.violatePersonNumMonth({params:currentProjectId},function(violatePersonNum) {
				$scope.violatePersonNumMonth = violatePersonNum[0].result;
			});
			//违章照片数量
			HomeService.violatePhotoNumMonth({params:currentProjectId},function(violatePhotoNum) {
				$scope.violatePhotoNumMonth = violatePhotoNum[0].result;
			});
			
			};
			
			//延时读取周数据和月数据
			setTimeout(function(){
				weekData();
				} , 500);
			setTimeout(function(){
				monthData();
			} , 1000);
			
		} 
		 
]);

homeModule.factory('HomeService',
		['$resource',
		function($resource) {
			
			var path = restPathRoot+'/api/v1.0/query/exec/:method';
			 var resource = $resource(
					 path, 
					 {},
					 {
						 inNumToday: {
							 method: 'GET',
							 params: {
								 method : 'in_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 inNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'in_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 inNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'in_num_month',
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
						 tagNumYesToday: {
							 method: 'GET',
							 params: {
								 method : 'tag_num_yes_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagNumYesWeek: {
							 method: 'GET',
							 params: {
								 method : 'tag_num_yes_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagNumYesMonth: {
							 method: 'GET',
							 params: {
								 method : 'tag_num_yes_month',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagPersonNumToday: {
							 method: 'GET',
							 params: {
								 method : 'tag_person_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagPersonNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'tag_person_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagPersonNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'tag_person_num_month',
								 params: '@params'
							 }, 
							 isArray:true
						 },						 
						 tagBindNumToday: {
							 method: 'GET',
							 params: {
								 method : 'tag_bind_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagBindNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'tag_bind_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 tagBindNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'tag_bind_num_month',
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
						 moblieNumToday: {
							 method: 'GET',
							 params: {
								 method : 'moblie_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 moblieNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'moblie_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 moblieNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'moblie_num_month',
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
						 violateNumToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'violate_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violateNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'violate_num_month',
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
						 violatePersonNumToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_person_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePersonNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'violate_person_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePersonNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'violate_person_num_month',
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
						 violatePhotoNumToday: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_num_today',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePhotoNumWeek: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_num_week',
								 params: '@params'
							 }, 
							 isArray:true
						 },
						 violatePhotoNumMonth: {
							 method: 'GET',
							 params: {
								 method : 'violate_photo_num_month',
								 params: '@params'
							 }, 
							 isArray:true
						 }
					 }
			 );
			 return resource;
		
		}

]);

