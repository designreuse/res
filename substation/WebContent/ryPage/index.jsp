<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta content="width=device-width,initial-scale=1" name="viewport">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
<title>首页</title>
	    <!--简化版的plupload-->
		<script type="text/javascript" src="${pageContext.request.contextPath}/source/plupload/plupload.full.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/uploadFile.js"></script>  
	    <script>
		    var _pageSize=10;
		    var page={pageNumber:1,totalPage:0,totalRow:0,type:'ALL' };
		    var pagePerm = {'create' : null , 'update' : null , 'delete' : null}; 
		    var _menu_id=getQueryString('menu_id');
		    $(function(){
		    	initPageDate();
		    	ajaxData();
		    	$init_file_upload();
		    });

		    function initPageDate(){
				var _menu_id = getQueryString('menu_id');
				$.ajax({
					type : 'POST',
					url : '/permission/getPagePermByMenu' , 
					async : false ,
					data : {
						menu_id : _menu_id
					},
					dataType : 'JSON',
					success : function(data){
						$.each(data,function(i , item){
							pagePerm[item.CODE] = item.CODE;
						});
						if(pagePerm['create'] != 'create'){
							$('#open-lyy').hide();
							$('#open-lyy2').show().attr('disabled' , 'disabled');
							$('#add').attr('disabled' , 'disabled').attr('onclick' , null);
						}
					}
				});
			}
		    
			function newUser(){
				openLayerFrame("新增人员",'/ryPage/getNew.jsp?menu_id='+_menu_id,null,null);
 			}
			//修改用户
			function userUpdate(userId,telephone){
				openLayerFrame("人员修改",'/ryPage/getEdit.jsp?menu_id='+_menu_id+"&userId="+userId+"&telephone="+telephone,null,null);
			}
			//导入成功刷新GRID
			function refreshGrid(){
				ajaxData();
			}
			
			function userDetail(userId){
				var projectId = parent._$comboboxObj.id;
				parent.initIframePage('/user/userInfo/userId='+userId+"&projectId="+projectId);
			}
			
			function userViolateDetail(userName){
				parent.initIframePage('/wzPage/index.jsp?wzPerson='+userName);
			}
			
			function userDisable(userId){
		    	$.ajax({
		            url: "/user/disable",
		            data:{
		            	id:userId
		            }, 
		            dataType: "json",
		            type: "POST",
		            success: function(data) {
		            	if (data.success){    
		            		var $dom = $('#'+userId);
		            		var type = $dom.html();
		    				if(type == '禁用'){
		    					$dom.html('启用');
			    				layer.alert("该用户已禁用",function(index){
			    					layer.close(index);
			    					ajaxData();
			    				});
		    				}else{
		    					$dom.html('禁用');
		    					layer.alert("该用户已启用",function(index){
		    						layer.close(index);
		    						ajaxData();
			    				});
		    				}
				        }else{
				        	layer.alert(data.message);
				        } 
		            }
		        });
			}
			function userDelete(userId){
				layer.confirm('确认删除吗？', {
				    btn: ['确定','取消'] 
				}, function(index){
					$.ajax({
			            url: "/user/delete",
			            data:{
			            	id:userId
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
			
			function ajaxData(){
				loadingStart('加载中...');
		    	$.ajax({
		            url: "/user/index",
		            data:{
		            	pageNumber:page.pageNumber,
		            	pageSize:_pageSize ,
		            	userName : $.trim($('#search').val())
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
	                        	    var disableHTML = "<a id='"+row.ID+"' href='#' onclick='userDisable(\""+row.ID+"\");'>"+(row.STATE==0?"禁用":"启用")+"</a>" ;
			                	    var deleteHTML = "<a href='#' onclick='userDelete(\""+row.ID+"\");'>删除</a>";
			                	    var updateHTML="<a href='#' onclick='userUpdate(\""+row.ID+"\",\""+row.MOBILE_PHONE+"\");'>修改</a>";
			                	    var wzRecord="<a href='#' onclick=\"userViolateDetail('"+row.REAL_NAME+"');\">"+(row.USER_VIOLATE)+"</a>";
			                	    var ico=row.STATE==0?"":"<img class='img_span' src='../source/image/disable.png' />";
			                	   if(pagePerm['update'] != 'update'){
			                		   updateHTML = "<span style='color:#aaa'>修改</span>" ;
									}
									if(pagePerm['delete'] != 'delete'){
										deleteHTML = "<span style='color:#aaa'>删除</span>";
									}
									if(row.USER_VIOLATE==0){
										wzRecord=0;
									}
	                        	 var tr="";
	                        	 var index=(page.pageNumber-1)*10+(i+1);
	                        	   tr="<tr><td>"+index+"</td><td><a href='#' onclick='userDetail(\""+row.ID+"\");'>"+(row.REAL_NAME==null?"":row.REAL_NAME)+ico+"</a></td><td>"+(row.USER_NAME==null?"":row.USER_NAME)+"</td><td>"+(row.ROLE)+"</td><td>"+(row.SEX==null?"":row.SEX=='man'?'男':'女')+"</td><td>"+(row.MOBILE_PHONE==null?"":row.MOBILE_PHONE)
	                        	   +"</td><td>"+(row.DUTY==null?"":row.DUTY)+"</td><td>"+(row.IN_OUT)+"</td><td>"+(row.USER_TRAIN)+"</td><td>"+wzRecord+"</td>"
	                        	   +"<td>"+disableHTML+"&nbsp;"+updateHTML+"&nbsp;"+deleteHTML+"</td></tr>";
	                        	   table.append(tr);
	                         });
	                         if(list.length==0){
	                          	   tr="<tr><td colspan='12'>没有相关数据</td></tr>";
	                        	 table.append(tr);
	                         }
                           tabPager();
                           loadingEnd();
		            },
		            error : function(requet , statu , e){
		            	loadingEnd();
		            	$.messager.alert('提示', '数据请求出错', 'error');
		            }
		        });
		    }
		</script>
    </head>
	<body>	
  		<div class="wrapper wrapper-content  gray-bg"   >
    <div class="row">
         <div class="col-lg-12">
            <div class="ibox float-e-margins">
                 <div class="ibox-title">
                     <h5>人员</h5>
                 </div>
                 <div class="ibox-content">
                      <div class="row">
                          <div class="col-sm-9 m-b-xs">
                             <button id="open-lyy"  type="button" class="btn btn-sm btn-primary"> 导入</button>
                             <button id="open-lyy2"  type="button" class="btn btn-sm btn-primary" style="display: none;"> 导入</button>
                             <button id="add"   type="button" class="btn btn-sm btn-primary"  onclick="newUser();"> 新增</button>
                             <a href="/user/downloadT"><button type="button" class="btn btn-sm btn-primary"> 下载导入模板</button></a>
                          </div>
                          <div class="col-sm-3">
                               <div class="input-group">
										<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control"  onkeyup="$('.clear').show();" ><a class="fa fa-times-circle clear"   href="javascript:void(0)"  onclick="$('#search').focus();$('#search').val('');$(this).hide();"></a> 
										<span class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"  onclick="ajaxData();"> 搜索</button>
										</span>
							</div>
                          </div>
                      </div>
                      <div class="table-responsive" id="table_content"  >
                               <table class="gridtable  table table-striped">
							<thead>
								<tr>
									<th width="5%">序号</th><th width="10%">姓名</th><th width="10%">登录名</th><th width="20%">角色</th><th width="5%">性别</th><th width="10%">电话</th><th width="8%">职务</th><th width="6%">进站记录</th><th width="6%">考试记录</th><th width="6%">违章记录</th><th width="15%">操作</th>
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