<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta content="width=device-width,initial-scale=1" name="viewport">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="${pageContext.request.contextPath}/common.jsp" />
		<title>组织机构</title>
		<script type="text/javascript">
			var projectObj = parent._$comboboxObj;
			var nodeId = "" ; 
			var nodeText = "" ; 
			var allowAddUser = false;
			var _menu_id = getQueryString('menu_id');
			var _pageSize=10;
		    var page={pageNumber:1,totalPage:0,totalRow:0,type:'ALL' };
		    var pagePerm = {'create' : null , 'update' : null , 'delete' : null};
		    var selectNode=null;
			$(function(){
				initPageDate();
				initOrgTree();
			});
			
			function initPageDate(){
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
							$('#a_add').css('color' , '#aaa').attr('onclick' , null);
						}
						if(pagePerm['update'] != 'update'){
							$('#a_edit').css('color' , '#aaa').attr('onclick' , null);
						}
						if(pagePerm['delete'] != 'delete'){
							$('#a_delete').css('color' , '#aaa').attr('onclick' , null);
						}
					}
				});
			}
			function initOrgTree(){
				//获取数据
				$.ajax({
					url:'/org/getOrgByProjectId',
					type:'post',
					dataType : 'json',
					data:{projectId:projectObj.id},
					success:function(data){
						initTree(data);
					}
				});
			}
			//初始化组织机构树
			function initTree(data){
				$('#org_tree').tree({    
				    data :data,
				    onLoadSuccess:function(node, data){
						var node=$('#org_tree').tree('getRoot');
						$('#org_tree').tree('collapseAll',node.target);
						$('#org_tree').tree('expand',node.target);
						 $('#org_tree').tree('select',node.target);
					},
				    onSelect: function(node){
						//加载右侧数据
						 selectNode=node;	
						 page.pageNumber=1;
						ajaxData();
					}
				});
			}
			function ajaxData(){
				loadingStart('加载中...');
		    	$.ajax({
		            url: "/user/zzjguser",
		            data:{
		            	pageNumber:page.pageNumber,
		            	pageSize:_pageSize ,
		            	projectId : projectObj.id,
		            	organizationId : selectNode.pid==null?'':selectNode.id ,
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
		                	 var updateHTML = "<a id='"+row.ID+"' href='#' onclick='editzzjgUser(\""+row.MOBILE_PHONE+"\");'>修改</a>" ;
		                	 var deleteHTML = "<a href='#' onclick='userDelete(\""+row.ID+"\");'>删除</a>";
		                	 var disableHTML = "<a id='"+row.ID+"' href='#' onclick='userDisable(\""+row.ID+"\");'>"+(row.STATE==0?"禁用":"启用")+"</a>" ;
		                	 var wzRecord="<a href='#' onclick=\"userViolateDetail('"+row.REAL_NAME+"');\">"+(row.VIOLATE)+"</a>";
							 if(row.VIOLATE==0){
									wzRecord=0;
								}
		                	 var tr="";
		                	 var index=(page.pageNumber-1)*10+(i+1);
		                	   tr="<tr><td>"+index+"</td><td><a href='#' onclick='userDetail(\""+row.ID+"\");'>"+(row.REAL_NAME==null?"":row.REAL_NAME)+"</a>"+(row.STATE==0?"":"<img class='img_span' src='../source/image/disable.png' />")+"</td>"
		                	   +"<td>"+(row.FIRST_IN==null?"":row.FIRST_IN)+"</td><td>"+(row.LAST_IN==null?"":row.LAST_IN)+"</td><td>"+(row.IN_OUT_DAY==null?0:row.IN_OUT_DAY)+"</td><td>"+(row.IN_SUM==null?0:row.IN_SUM)+"</td><td>"+(row.IN_AVG==null?0:row.IN_AVG)+"</td><td>"+(wzRecord)+"</td>"
		                	   +"<td>"+disableHTML+"&nbsp;"+updateHTML+"&nbsp;"+deleteHTML+"</td></tr>";
		                	   table.append(tr);
		                 });
		                 if(list.length==0){
		                  	   tr="<tr><td colspan='9'>没有相关数据</td></tr>";
		                	 table.append(tr);
		                 }
		               tabPager();
		               loadingEnd();
		            }
		        });
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
			//违章
			function userViolateDetail(userName){
				parent.initIframePage('/wzPage/index.jsp?wzPerson='+userName);
			}
			
			function userDetail(userId){
				var projectId = parent._$comboboxObj.id;
				parent.initIframePage('/user/userInfo/userId='+userId+"&projectId="+projectId);
			}
			
			function userDelete(userId){
				layer.confirm('确认删除吗？', {
				    btn: ['确定','取消'] 
				}, function(index){
					$.ajax({
			            url: "/user/delete2",
			            data:{
			            	id:userId,
			            	projectId : projectObj.id,
			            	organizationId : selectNode.pid==null?'':selectNode.id 
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

			
			function edit(){
				var node = $('#org_tree').tree('getSelected');
				var id = node.id ; 
				var text = node.text;
				var org_code = node.attributes.org_code;
				var description = node.attributes.description;
				append(id , text , org_code , description);
			}
			
			function deletezzjg(){
				//判断能否删除
		        var trs=$(".gridtable").find("tr");
		        if(trs.length > 1){
		        	var tr = trs[1];
		        	var tds = $(tr).find("td");
		        	if(tds.length != 1){
		        		layer.alert('组织机构人员不为空，不能删除！');
			        	return;
		        	}
		        }
		        layer.confirm('确认删除？', {
		            btn: ['确定','取消'] //按钮
		        }, function(){
		        	var node = $('#org_tree').tree('getSelected');
					var id = node.id ; 
					$.ajax({
						url:'/user/deletejg',
						type:'post',
						dataType:'JSON',
						data:{
							id : id,
						},
						success:function(data){
							if (data.success){    
								layer.alert(data.message);
					        	window.location.reload();
					        }else{
					        	layer.alert(data.message);
					        } 
						}
					});
		        });
				
			}
			
			function newzzjgUser(){
					openLayerFrame("新增用户",'/zzjgPage/getNewUser.jsp?menu_id='+_menu_id+"&projectId="+projectObj.id+"&orgId="+selectNode.id,null,null);					
 			}
			function editzzjgUser(mobilePhone){
				openLayerFrame("编辑用户",'/zzjgPage/getNewUser.jsp?menu_id='+_menu_id+"&projectId="+projectObj.id+"&orgId="+selectNode.id+"&mobilePhone="+mobilePhone,null,null);					
			}
			function addZzjg(){
				if(selectNode==null){
					layer.alert('请先选中要添加的组织机构.');
				}else{
				   openLayerFrame("新增组织机构",'/zzjgPage/gcNew.jsp?menu_id='+_menu_id+"&projectId="+projectObj.id+"&parentId="+selectNode.id,null,null);					
				}
			}
			function editZzjg(){
				if(selectNode==null){
					layer.alert('请先选中要添加的组织机构.');
				}else if(selectNode.pid==null){
					layer.alert('根节点不能编辑.');
				}else{
				   openLayerFrame("新增组织机构",'/zzjgPage/gcEdit.jsp?menu_id='+_menu_id+"&projectId="+projectObj.id+"&parentId="+selectNode.pid+"&id="+selectNode.id,null,null);					
				}
			}
			function deleteZzjg(){
				if(selectNode==null){
					layer.alert('请先选中要删除的组织机构.');
				}else if(selectNode.pid==null){
					layer.alert('根节点不能删除.');
				}else{
					layer.confirm('确认删除吗？', {
					    btn: ['确定','取消'] 
					}, function(index){
						 $.ajax({
					            url: "/org/deleteByOrgIdAndProjectId",
					            data:{
					            	orgCode:selectNode.id,
					            	projectId:projectObj.id
					            },
					            dataType: "json",
					            type: "POST",
					            success: function(data) {
					            	if(data.success){
					            		layer.close(index);
					            		initOrgTree();
					            	}else{
					            		layer.alert('删除失败！');
					            	}
					            }
							});
					}, function(){
					   return;
					});
				   
				}
			}
		</script>
	</head>
	<body style="overflow: hidden;">
	<div class="wrapper wrapper-content  gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>组织机构</h5>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-sm-9 m-b-xs">
								<button type="button" id="add" class="btn btn-sm btn-primary "
									onclick="newzzjgUser();">新增人员</button>
							</div>
							<div class="col-sm-3">
								<div class="input-group">
									<input type="text"   id="search"  placeholder="输入搜索条件" class="input-sm form-control"  onkeyup="$('.clear').show();" ><a class="fa fa-times-circle clear"   href="javascript:void(0)"  onclick="$('#search').focus();$('#search').val('');$(this).hide();"></a> 
									 <span
										class="input-group-btn">
										<button type="button" class="btn btn-sm btn-primary"
											onclick="ajaxData();">搜索</button>
									</span>
								</div>
							</div>
						</div>
						<div class="table-responsive" id="table_content" >
							<div class="col-sm-3 m-b-xs"  height="100%">
							    <div style="overflow: auto;height: 100%;" >
								     <div style="height:25px;line-height:25px;padding-left:0px;">
									  <a href="javascript:void(0)"  id="a_add"  onclick="addZzjg();"><i class="fa fa-plus-square-o"></i>添加</a>
									  <a href="javascript:void(0)"   id="a_edit"  onclick="editZzjg();"> <i class="fa fa-edit"></i>编辑</a>
									   <a href="javascript:void(0)"  id="a_delete"  onclick="deleteZzjg();"><i class="fa fa-trash-o"></i>删除</a>
								    </div>
								     <ul id="org_tree" ></ul>
							    </div>
							</div>
							<div class="col-sm-9 m-b-xs"  >
								 <table class="gridtable  table table-striped" >
													<thead>
														 <tr>
															<th width="2%">序号</th><th width="4%">姓名</th><th width="6%">首次进站时间</th><th width="8%">最后一次进站时间</th><th width="5%">进站天数</th><th width="5%">总进站时长</th><th width="6%">平均进站时长</th><th width="4%">违章记录</th><th width="8%">操作</th>
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
	</div>
	<script type="text/javascript">
		$('#table_content').height($(window).height() - 100);
	</script>
</body>
</html>