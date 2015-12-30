<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/DateUtils.js"></script>
<title>首页</title>
<style>

.nav_div_tools ul {
	list-style: none;
	margin: 0;
	padding: 0;
}

.nav_div_tools ul li {
	display: inline;
	float: left;
	width: 70px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	border: 1px solid #aaa;
	border-right: 0px;
	cursor: pointer;
}

.nav_div_tools ul li.last {
	display: inline;
	float: left;
	width: 70px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	border: 1px solid #aaa;
}

.nav_div_tools ul li a {
	display: inline;
	width: 70px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	color: black;
}

.nav_div_tools ul li.selected {
	background: #1AB394;
}

.nav_div_tools ul li.selected a {
	color: white;
}

.nav_div_tools ul li.selected:HOVER {
	background: #348A78;
}
</style>
<script>
    var _project_id=parent._$comboboxObj.id;
    var _type="day";
    var sDate="";
    var eDate="";
    var _userId="";
	$(function() {
		$("#gc_users").chosen(); 
		initTools();
	});

	//初始化工具条点击事件
	function initTools() {
		$(".nav_div_tools li").click(function() {
			if ($(this).attr('class') == 'selected') {
				return;
			} else {
				$(".nav_div_tools li").removeClass('selected');
				$(this).addClass('selected');
				_type=$(this).find('a').attr("type");
				ajaxData();
			}
		});
		$("#gc_users").chosen().change(function(){
			ajaxData();
    	});
		$.ajax({
			url : "/layoutdiagram/getUserByProjectId",
			dataType : "json",
			type : "POST",
			data:{
				project_id:_project_id
			},
			success : function(data) {
				$("#gc_users").html(""); 
				$("#gc_users").chosen("destroy"); 
				var html="";
				$.each(data,function(i,item){
					html+="<option value='"+item.USER_ID+"'>"+item.REAL_NAME+"</option>";
				});
				if(html!=""){
					$("#gc_users").append(html);
				}
				$("#gc_users").trigger("liszt:updated");
				$("#gc_users").chosen(); 
				$("#lay_map").on("load",function(){
				    //加载完成，需要执行的代码
					ajaxData();
			    });
			}
		});
	}
	/**获取数据*/
	function  ajaxData(){
		setDate();//设置起始日期时间戳
		$.ajax({
            url: "/layoutdiagram/getPointByProjectId",
            dataType: "json",
            data:{
            	project_id:_project_id,
            	sDate:sDate,
            	eDate:eDate,
            	userId:$("#gc_users option:selected").val()
            },
            type: "POST",
            success: function(data) {
            	lay_map.window.drow_user_point(data);
            }
    	}); 
	}
	
	//设置
	function setting(){
		parent.initIframePage('pmbztPage/gcSetting.jsp');	
	}
	
	//设置起止时间戳日期
	function setDate(){
		var date=new Date();
		var year=date.getFullYear();
		var month=date.getMonth();
		var day=date.getDate();
		var nowDay = date.getDay(); //星期 
		if(_type=='day'){
		  sDate=new Date(year, month, day, 0, 0, 0).getTime();
		  eDate=getIntervalTime(year,month,day,1);
		}else if(_type=='week'){
			sDate=getIntervalTime(year,month,day,-(nowDay-1));
			eDate=getIntervalTime(year,month,day,-(nowDay-1)+7);
		}else if(_type='month'){
			sDate=getIntervalTime(year,month,1,0);
			eDate=getIntervalTime(year,month,getLastDay(month+1),1);
			
		}
	}
	
	//获取相隔几个天后的时间戳
	function getIntervalTime(year,month,day,interval){
	    var newDate = new Date(year,month,day,0,0,0);
	    newDate.setDate(newDate.getDate()+interval);
	    return newDate.getTime();
  }
	
	function getLastDay(month){
		if(month=='1'||month=='3'||month=='5'||month=='7'||month=='8'||month=='10'||month=='12')
			return 31;
		else 
			return 30;
	}
</script>
</head>
<body style="overflow: hidden;">
   <div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                      <div class="row">
                           <div class="col-sm-11 m-b-xs">
		                     <h5>平面布置图</h5>
                           </div>
                           <div class="col-sm-1 m-b-xs "  style="text-align: right;">
                           </div>
                   </div>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-4 m-b-xs">
                               <div class="nav_div_tools">
									<ul>
										<li class='selected'><a type="day">今天</a></li>
										<li><a type="week">本周</a></li>
										<li class="last"><a type="month">本月</a></li>
									</ul>
								</div>
                          </div>
                          <div class="col-sm-7 m-b-xs"  style="height: 30px;line-height:30px;">
                                 <select data-placeholder="请选择用户..."   class="chosen-select"   style="width:300px;"     id="gc_users">
								     <option value="">请选择用户</option>
							     </select>
                          </div>
                          <div class="col-sm-1">
                               <div class="input-group">
										<button type="button" class="btn btn-sm btn-primary"  onclick="setting();"> 设置</button>
							</div>
                          </div>
                      </div>
                      <div class="table-responsive"   id="table_content"  >
                            <iframe id="lay_map"  name="lay_map"    src="mapShow_baiduMap.jsp"   style="width: 100%; height: 100%; border: 0px;padding-right: 10px;"></iframe>
                      </div>
                 </div>
            </div>
         </div>
    </div>
</div>
<script type="text/javascript">
    $('#table_content').height($(window).height()-100);
</script>
</body>
</html>