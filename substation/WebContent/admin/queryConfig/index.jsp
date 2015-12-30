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
.wrapper-content {
    padding: 0px;
}
.wrapper {
    padding: 0px;
}
.ibox-content {
    background-color: #FFF;
    color: inherit;
    padding: 10px 0px 5px 10px;
    border-color: #E7EAEC;
    border-image: none;
    border-style: solid solid none;
    border-width: 1px 0px;
}
.input-group {
    position: relative;
    display: table;
    border-collapse: separate;
    margin-right: 10px;
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
	    var _pageSize=10;
	    var page={pageNumber:1,totalPage:0,totalRow:0,type:'ALL' };
		    $(function(){
		    	ajaxData();
		    });
		    	 function ajaxData(){
		    		    loadingStart('加载中...');
				    	$.ajax({
				            url: "/admin/getData",
				            data:{
				            	pageNumber:page.pageNumber,
				            	pageSize:_pageSize,
				            	queryName:$('#search').val()
				            },
				            dataType: "json",
				            type: "POST",
				            success: function(data) {
		                            var list=data.list;
		                        	var table=$(".gridtable");
		                        	var trs=table.find("tr");
		                        	for(var i=1;i<trs.length;i++){
		                        		trs[i].remove();
		                        	}
		                        	page.pageNumber=data.pageNumber;
		                        	page.totalPage=data.totalPage;
		                        	page.totalRow=data.totalRow;
		                         $.each(list,function(i,row){
		                        	 var tr="";
		                        	 var index=(page.pageNumber-1)*10+(i+1);
		                        	   tr="<tr><td>"+index+"</td><td style='text-align: left;'>"+(row.QUERY_NAME==null?"":row.QUERY_NAME)+"</td><td  style='text-align: left;'>"+(row.QUERY_DESCRIBE==null?"":row.QUERY_DESCRIBE)+"</td><td  style='text-align: left;'>"+(row.QUERY_COMMENT==null?"":row.QUERY_COMMENT)+"</td><td  style='text-align: left;'>"+(row.QUERY_TEXT==null?"":row.QUERY_TEXT)+"</td><td style='text-align: left;'>"+(row.QUERY_PARAM==null?"":row.QUERY_PARAM)+"</td><td><a href='javascript:void(0)'  onclick='editQc(\""+row.ID+"\")'>编辑</a>&nbsp;&nbsp;<a href='javascript:void(0)'  onclick='deleteQc(\""+row.ID+"\")'>删除</a></td></tr>";
		                        	   table.append(tr);
		                         });
		                         if(list.length==0){
		                          	   tr="<tr><tdcolspan='5'>没有相关数据</td></tr>";
		                        	 table.append(tr);
		                         }
		                           tabPager();
		                           loadingEnd();
				            }
				        });
				    }
				    
				    function tabPager(){
		            	refashPage(page.pageNumber,page.totalPage,page.totalRow);
				    }
		    function newQc(){
		    	layer.open({
		            type: 2,
		            title: '查询新增',
		            shadeClose: true,
		            shade: false,
		            maxmin: false, //开启最大化最小化按钮
		            area: ['1000px', '500px'],
		            content: 'qcNew.jsp?totalRecord='+page.totalRow,
		            cancel:function(index){
		            	ajaxData();
		            }
		        });
		    }
			
			function editQc(id){
				layer.open({
		            type: 2,
		            title: '查询新增',
		            shadeClose: true,
		            shade: false,
		            maxmin: false, //开启最大化最小化按钮
		            area: ['1000px', '500px'],
		            content: 'qcEdit.jsp?id='+id,
		            cancel:function(index){
		            	ajaxData();
		            }
		        });
			}
			
			function deleteQc(gcId){
				layer.confirm('确定要删除数据吗？', {
				    btn: ['确定','取消'] 
				}, function(index){
					 $.ajax({
				            url: "/admin/deleteById",
				            data:{
				            	id:gcId
				            },
				            dataType: "json",
				            type: "POST",
				            success: function(data) {
				            	if(data.success){
				            		layer.close(index);
				            		ajaxData();
				            	}else{
				            		layer.alert('删除失败！');
				            	}
				            }
						});
				}, function(){
				   return;
				});
				
			}
		</script>
    </head>
<body style="overflow: hidden;">
<div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>查询配置</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-9 m-b-xs">
                              <button type="button" class="btn btn-sm btn-primary"   onclick="newQc();"> 新增</button>
                          </div>
                          <div class="col-sm-3">
                               <div class="input-group">
										<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control">
										<span class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"  onclick="ajaxData();"> 搜索</button>
										</span>
							</div>
                          </div>
                      </div>
                      <div class="table-responsive"  id="table_content">
                               <table class="gridtable  table table-striped">
							<thead>
								<tr>
									<th width="5%">序号</th><th width="10%">查询名称</th><th width="11%">查询描述</th><th width="11%">创建人</th><th width="40%">SQ文本</th><th width="12%">查询参数</th><th width="12%">操作</th>
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
<script type="text/javascript">
    $('#table_content').height($(window).height()-100);
</script>
</body>
</html>