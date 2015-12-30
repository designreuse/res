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
 *角色管理控制器
 */
public class RoleController extends BaseController
{  
	private final String tableName = "t_role";
	private final String perTableName = "t_role_permission";
	private final String primaryKey = "id";
    @Override
	public void index(){
    	 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		 String roleName = getPara("roleName");
		 String parentId = getPara("parentId");
		 roleName = ParamUtil.isEmpty(roleName) ? "%%" : "%"+roleName+"%" ; 
		 String sqlText=getSqlText("getRoleByParentId");
		 Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,parentId,roleName);
		 renderJson(rePage);
    }
   //获取所有的角色列表不包括职务
   public void getAllRole(){
	   String type=getPara("type");
	   List<Record> res=new ArrayList<Record>();
	   if("system".equals(type)){
		   res=query("getAllRoleSystem");
	   }else{
		    res=query("getAllRoleExDuty");		    
	   }
	   renderJson(res);
   }
    public void deleteById(){
    	String id=getPara("id");
    	Record  rec= queryOne("getRoleById", new Object[]{id});
    	boolean flag=delete(tableName, primaryKey, rec);
    	//删除关联表数据
    	List<Record> res=query("getPermissionByRoleId", id);
		for(Record r:res){
			delete(perTableName, primaryKey, r);    			
		}
    	Status st=new Status();
    	st.setSuccess(flag);
    	renderJson(st);
    }
    public void getDataById(){
    	String idStr=getPara("roleId");
    	Record resRecord=find(tableName, primaryKey, idStr).get(0);
    	renderJson(resRecord);
    }
    
    public void saveData(){
    	UserVO userVo=getSessionAttr("user");
    	Map<String, Object> data=new HashMap<String, Object>();
    	Map<String,String[]> map=getParaMap();
    	for(String key:map.keySet()){
    		data.put(key, map.get(key)[0]);
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
		 List<Record> res=query("getAllRole");
		 for(Record r:res){
			 JsonTreeData vo=new JsonTreeData();
			 vo.setId(r.getStr("id"));
			 vo.setText(r.getStr("role_name"));
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
    
    /**
     * 获取所有的职务duty
     */
    public  void getAllDuty(){
    	List<Record> dutys=query("getAllDuty");
    	renderJson(dutys);
    }
}
