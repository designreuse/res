<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<title>首页</title>
		<script type="text/javascript">
		    var max=getQueryString("max");
		    $(function() {
				if(max){
		    		$("#full").text("还原");
		    		$("#back").hide();
		    		
		    	}else{
		    		$("#full").text("全屏");
		    	}
			});
		    
			function back(){
				window.location.href="index.jsp";
			}
			
			function saveOrUpdate(){
				lay_map.window.saveData();
			}
		</script>
	</head>
	<body>  
 <body style="overflow: hidden;">
   <div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                      <div class="row">
                           <div class="col-sm-11 m-b-xs">
		                     <h5>平面布置图:设置</h5>
                           </div>
                           <div class="col-sm-1 m-b-xs "  style="text-align: right;">
                               <a href="javascript:void(0);"  id="full"  onclick="fullScreen(this);">全屏</a>
                           </div>
                   </div>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-9 m-b-xs">
                             <button type="button" class="btn btn-sm btn-primary"  id="back"  onclick="back()"> 返回</button>
			                 <button type="button" class="btn btn-sm btn-primary" onclick="saveOrUpdate()"> 保存</button>
                          </div>
                      </div>
                      <div class="table-responsive"   id="table_content"  >
			            <iframe id="lay_map"  name="lay_map"    src="/pmbztPage/mapSetting_baiduMap.jsp"   style="width: 100%; height: 100%; border: 0px;padding-right: 10px;"></iframe>
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