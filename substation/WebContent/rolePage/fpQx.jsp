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
<style>
</style>
<script>
	var roleId=getQueryString('roleId');
	var checkItems="";
	var removeItems="";
	$(function() {
		getInitQXTreeData();
	});
	
	function getInitQXTreeData(){
		loadingStart('加载中...');
		$.ajax({
			url : "/role/getQxTreeData",
			data:{
				roleId:roleId
			},
			dataType : "json",
			type : "POST",
			success : function(data) {
				initQxTree(data);
				loadingEnd();
			}
		});
		
	}
	
	function initQxTree(data) {
		$('#tree').tree({
// 			lines : true,
            checkbox:true,
			data : data,
			cascadeCheck :true,
			onLoadSuccess:function(node, data){
				var node=$('#tree').tree('getRoot');
				$('#tree').tree('collapseAll',node.target);
				$('#tree').tree('expand',node.target);
			},
			onSelect: function(node){
			}
		});

	}
	
    //保存权限信息
    var qxIds;
    var ids="";
	function saveQx(){
        qxIds=[];//选中的权限id数组 
		var nodes =$('#tree').tree('getChecked');
        $.each(nodes,function(i,node){
        	qxIds.push(node.id);
        });
         ids=qxIds.join(",");
        //遍历每个节点找其父节点然后把父节点也放入进去
        $.each(nodes,function(i,node){
        	while(node.pid!=null&&node.pid!='f4b2eead61ba11e5b26c0050568173ac'){
        		node=setParentNode(node);
        	}
        });
        loadingStart('加载中...');
        $.ajax({
			url : "/role/saveQxData",
			data:{
				roleId:roleId,
				qxIds:qxIds.join()
			},
			dataType : "json",
			type : "POST",
			success : function(data) {
				  loadingEnd();
				  layer.alert(data.message);
			}
		});
    }
    
    function setParentNode(node){
    	var p=$('#tree').tree('getParent',node.target);
	   	 if(ids.indexOf(p.id)==-1){
	   		 qxIds.push(p.id);
	   	 }
	   	 return p;
    }
</script>
</head>
<body style="overflow: hidden;">
	<div class="wrapper wrapper-content  gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
						<div class="table-responsive" id="table_content">
								<ul id="tree"></ul>
						</div>
						<div class="row">
						   <div class="col-sm-5">
							</div>
							<div class="col-sm-2 m-b-xs">
							       <button type="button" id="add" class="btn btn-sm btn-primary "
									onclick="saveQx();">分配权限</button>
							</div>
							<div class="col-sm-5">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript">
		$('#table_content').height(350);
	    </script>
</body>
</html>