<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<link  href="${pageContext.request.contextPath}/source/js/inspinia/bootstrap.min.css"  rel="stylesheet">
<link  href="${pageContext.request.contextPath}/source/font-awesome/css/font-awesome.css"  rel="stylesheet">
<!-- chosen -->
<link href="${pageContext.request.contextPath}/source/js/inspinia/plugins/chosen/chosen.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/source/js/inspinia/animate.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/source/js/inspinia/style.css" rel="stylesheet">

<!-- css -->
<link href="${pageContext.request.contextPath}/source/css/css.css" rel="stylesheet">
<title>首页</title>
<style>
table.gridtable {
   width: 100%;
}
body {
    font-family: "open sans","Helvetica Neue",Helvetica,Arial,sans-serif;
    background-color: #F3F3F4;
    font-size: 13px;
    color: #676A6C;
    overflow-x: hidden;
}
</style>
	    <script>
		    $(function(){
		    });
		    
		    function classDetail(classId){
		    	parent.initIframePage('pxPage/classDetail.jsp?classId='+classId);
		    }
		</script>
    </head>
	<body>
	<div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>培训</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-9 m-b-xs"></div>
                          <div class="col-sm-3">
                               <div class="input-group">
										<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control">
										<span class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"  onclick="ajaxData();"> 搜索</button>
										</span>
							</div>
                          </div>
                      </div>
                      <div class="table-responsive">
                               <table class="gridtable  table table-striped">
							<thead>
								<tr>
			                	<th width="5%">序号</th><th width="25%">课程名称</th><th width="10%">讲课老师</th><th width="25%">培训时间</th><th width="10%">授课时长</th><th width="10%">发布人</th><th width="10%">参加人数</th>
								</tr>
								<tr>
									<td>1</td><td><a href="#" onclick="classDetail('classId')">课程名称</a></td><td>李雷</td><td>2015-06-22  14:00 ~ 15:00</td><td>1小时</td><td>李雷</td><td>20人</td>
								</tr>
								<tr>
									<td>1</td><td><a href="#" onclick="classDetail('classId')">课程名称</a></td><td>李雷</td><td>2015-06-22  14:00 ~ 15:00</td><td>1小时</td><td>李雷</td><td>20人</td>
								</tr>
								<tr>
									<td>1</td><td><a href="#" onclick="classDetail('classId')">课程名称</a></td><td>李雷</td><td>2015-06-22  14:00 ~ 15:00</td><td>1小时</td><td>李雷</td><td>20人</td>
								</tr>
								<tr>
									<td>1</td><td><a href="#" onclick="classDetail('classId')">课程名称</a></td><td>李雷</td><td>2015-06-22  14:00 ~ 15:00</td><td>1小时</td><td>李雷</td><td>20人</td>
								</tr>
								<tr>
									<td>1</td><td><a href="#" onclick="classDetail('classId')">课程名称</a></td><td>李雷</td><td>2015-06-22  14:00 ~ 15:00</td><td>1小时</td><td>李雷</td><td>20人</td>
								</tr>
							</thead>
						</table>
	                      <div id="kkpager" style="width: 100%; margin: 0px auto;"></div>
                      </div>
                 </div>
            </div>
         </div>
    </div>
</div>
</body>
</html>