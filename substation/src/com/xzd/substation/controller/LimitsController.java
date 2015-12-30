package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.TreeNodeUtil;
import com.xzd.substation.vo.JsonTreeData;
import com.xzd.substation.vo.TreeVO;
import com.xzd.substation.vo.UserVO;

/**
 * 权限管理控制器
 */
public class LimitsController extends BaseController
{  
	private final String tableName = "t_permission";
	private final String perTableName = "t_role_permission";
	private final String primaryKey = "id";
	
    @Override
	public void index(){
    	 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		 String limitName = getPara("limitName");
		 String parentId = getPara("parentId");
		 limitName = ParamUtil.isEmpty(limitName) ? "%%" : "%"+limitName+"%" ; 
		 String sqlText=getSqlText("getLimitByParentId");
		 Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,parentId,limitName);
		 if(pageNumber>1&&(rePage==null||rePage.getList().size()==0)){//删除的时候当前页面刚好只有一条数据删除完后加载上一页
			 pageNumber=pageNumber-1;
			 rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,parentId,limitName);
		 }
		 renderJson(rePage);
    }
    
    public void deleteById(){
    	String id=getPara("id");
    	Record  rec= find(tableName, primaryKey,id).get(0);
    	boolean flag=delete(tableName, primaryKey, rec);
    	//删除关联表数据
    	List<Record> res=query("getPermissionByPermId", id);
		for(Record r:res){
			delete(perTableName, primaryKey, r);    			
		}
    	Status st=new Status();
    	st.setSuccess(flag);
    	renderJson(st);
    }
    public void getDataById(){
    	String idStr=getPara("perId");
    	Record resRecord=find(tableName, primaryKey, idStr).get(0);
    	//处理权限类型
    	if("*::/training".equals(resRecord.get("rest_apis"))){
    		resRecord.set("type", "menu");
    	}else if("POST::/training".equals(resRecord.get("rest_apis"))){
    		resRecord.set("type", "create");
    	}else if("PUT::/training".equals(resRecord.get("rest_apis"))){
    		resRecord.set("type", "update");
    	}else if("DELETE::/training".equals(resRecord.get("rest_apis"))){
    		resRecord.set("type", "delete");
    	}else if("GET::/training".equals(resRecord.get("rest_apis"))){
    		resRecord.set("type", "browse");
    	}
    	renderJson(resRecord);
    }
    
    public void saveData(){
    	UserVO userVo=getSessionAttr("user");
    	Map<String, Object> data=new HashMap<String, Object>();
    	Map<String,String[]> map=getParaMap();
    	for(String key:map.keySet()){
    		data.put(key, map.get(key)[0]);
    	}
    	//处理权限类型
    	if("menu".equalsIgnoreCase((String) data.get("type"))){//菜单
    		data.put("rest_apis", "*::/training");
    		data.put("type", "");
    	}else if("create".equalsIgnoreCase((String) data.get("type"))){//添加
    		data.put("rest_apis", "POST::/training");
    		data.put("type", "");
    	}else if("update".equalsIgnoreCase((String) data.get("type"))){//添加
    		data.put("rest_apis", "PUT::/training");//更新权限
    		data.put("type", "");
    	}else if("delete".equalsIgnoreCase((String) data.get("type"))){//添加
    		data.put("rest_apis", "DELETE::/training");//删除权限
    		data.put("type", "");
    	}else if("browse".equalsIgnoreCase((String) data.get("type"))){//添加
    		data.put("rest_apis", "GET::/training");//删除权限
    		data.put("type", "");
    	}
      try {
    	  if("".equals(data.get(primaryKey))||data.get(primaryKey)==null){
    		    data.put("create_user", userVo.getLoginName());
    		    data.put("create_time", DateUtils.getCurrDateTimeStr());
    		    data.put("update_user", userVo.getLoginName());
    		    data.put("update_time", DateUtils.getCurrDateTimeStr());
	      		String primaryValue=saveOrUpdate(tableName, primaryKey , data); 
      	}else{
      		data.put("update_user", userVo.getLoginName());
		    data.put("update_time", DateUtils.getCurrDateTimeStr());
      		Record record = new Record();
      		for (final Map.Entry<String, Object> entry : data.entrySet())
      		{
      			record.set(entry.getKey(), entry.getValue());
      		}
      		update(tableName, primaryKey , record);
      	}
    	  renderJson(new Status(Boolean.TRUE, "操作成功"));
	} catch (Exception e) {
		e.printStackTrace();
		renderJson(new Status(Boolean.FALSE, "操作失败："));
	}
    }
    
    //获取角色组织机树
    public void getTreeData() {
    	  List<JsonTreeData>  trees=new ArrayList<JsonTreeData>();
		 List<Record> res=query("getAllLimits");
		 for(Record r:res){
			 JsonTreeData vo=new JsonTreeData();
			 vo.setId(r.getStr("id"));
			 vo.setText(r.getStr("name"));
			 vo.setPid(r.getStr("parent_id"));
			 trees.add(vo);
		 }
		 trees=TreeNodeUtil.getfatherNode(trees);
		 renderJson(trees );
	}
    
  //获取权限树
    public void getQxTreeData() {
    	  List<JsonTreeData>  trees=new ArrayList<JsonTreeData>();
    	 String roleId=getPara("roleId");
		 List<Record> res=query("getAllPermission");
		 for(Record r:res){
			 JsonTreeData vo=new JsonTreeData();
			 vo.setId(r.getStr("id"));
			 vo.setText(r.getStr("name"));
			 vo.setPid(r.getStr("parent_id"));
			 List<Record>  record=query("isHaveRolePermission", roleId,vo.getId());
			 if(record==null||record.isEmpty()){
				 vo.setChecked(false);
			 }else{
				 //判断是否是叶子节点是叶子节点选中否则不选中
				 List<Record>  re=query("isLeaf",vo.getId());
				 if(re==null||re.isEmpty()){
					 vo.setChecked(true);					 
				 }else{
					 vo.setChecked(false);
				 }
			 }
			 trees.add(vo);
		 }
		 trees=TreeNodeUtil.getfatherNode(trees);
		 renderJson(trees );
	}
    
    //保存角色权限信息
    public void saveQxData(){
    	String roleId=getPara("roleId");
    	String qxIds=getPara("qxIds");
    	UserVO userVo=getSessionAttr("user");
    	Status status;
    	//先通过roleId查询权限然后删除
    	try {
    		List<Record> res=query("getPermissionByRoleId", roleId);
    		for(Record r:res){
    			delete(perTableName, primaryKey, r);    			
    		}
    		//遍历qxIds来保存权限
    		String[]  qxList=qxIds.split(",");
    		for(String qxId:qxList){
    			Record record=new Record();
    			record.set("role_id", roleId);
    			record.set("permission_id", qxId);
    			record.set("create_user", userVo.getLoginName());
    			record.set("create_time", DateUtils.getCurrDateTimeStr());
    			record.set("update_user", userVo.getLoginName());
    			record.set("update_time", DateUtils.getCurrDateTimeStr());
    			save(perTableName, primaryKey, record);
    		}
    		status=new Status(true, "保存成功.");
		} catch (Exception e) {
			e.printStackTrace();
			status=new Status(false, "保存失败.");;
		}
    	renderJson(status);
    }
    /**
     * 获取用户信息
     */
    public void getUserInfo(){
    	 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
    	String userName=getPara("userName");
    	userName = ParamUtil.isEmpty(userName) ? "%%" : "%"+userName+"%" ; 
    	String roleId=getPara("roleId");
    	String sqlText=getSqlText("getUserInfoByRoleId");
		 Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,roleId,userName);
		 renderJson(rePage);
    }
}
