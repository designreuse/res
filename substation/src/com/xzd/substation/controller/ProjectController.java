package com.xzd.substation.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.UserVO;

/**
 * 工程项目控制器
 */
public class ProjectController extends BaseController
{  
	private final String tableName = "t_project";
	private final String org_tableName = "t_organization";
	private final String primaryKey = "id";
	
    @Override
	public void index(){
    	 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		 String projectName = getPara("projectName");
		 projectName = ParamUtil.isEmpty(projectName) ? "%%" : "%"+projectName+"%" ; 
		 String sqlText=getSqlText("getProjectRecord");
		 Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,projectName);
		 renderJson(rePage);
    }
    
    public void deleteById(){
    	String id=getPara("id");
    	Record  rec= queryOne("getProById", new Object[]{id});
    	boolean flag=delete(tableName, primaryKey, rec);
    	//删除组织机构表里边的数据
  		List<Record> resOrg=find(org_tableName, "project_id",id);
  		for(Record  r:resOrg){
  			delete(org_tableName, "id", r);
  		}
    	Status st=new Status();
    	st.setSuccess(flag);
    	renderJson(st);
    }
    public void getDataById(){
    	String idStr=getPara("gcId");
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
	      		//查询组织结构为default的数据然后设置priject_id重新插入数据
	      		List<Record> resOrg=find(org_tableName, "project_id", "-1");
	      		for(Record  r:resOrg){
	      			r.set("project_id", primaryValue);
	      			r.set("id", null);
	      			r.set("create_user", userVo.getLoginName());
	      			r.set("create_time", DateUtils.getCurrDateTimeStr());
	      			r.set("update_user", userVo.getLoginName());
	      			r.set("update_time", DateUtils.getCurrDateTimeStr());
	      			save(org_tableName, "id", r);
	      		}
      	}else{
      		data.put("update_user", userVo.getUserName());
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
    
    public void getProjectInfo() {
		Map<String, String> mapParam = ParamUtil.convertStringParamToMapParam(getPara());
		String projectId = mapParam.get("projectId");
		Record record = Db.findFirst("SELECT * FROM T_PROJECT T WHERE T.ID = ?", projectId);
		record.set("PROJECT_TYPE", getRealType(record.getStr("PROJECT_TYPE")));
		setAttr("project", record);
		renderJsp("/mainPage/gcgk.jsp");
	}
    
    /**
     * [{
			"bd":"变电工程",
			"sd":"送电工程",
			"hlz":"换流站工程",}]
     * @param type
     * @return
     */
    public String getRealType(String type){
    	Map<String, String> typeMap = new HashMap<String, String>();
    	String projectType=getParamValueByName("project_type");
    	projectType=projectType.replace("[{","");
    	projectType=projectType.replace("}]","");
    	String[] types=projectType.split(",");
    	if(types.length>0){
    		for(String tp:types)
    			if(!StringUtil.isBlankOrNull(tp)&&tp.contains(":")){
    				typeMap.put(tp.split(":")[0].trim(), tp.split(":")[1]);				
    			}
    		}
    	String tp=(typeMap.get("\""+type+"\"") == null) ? "" : typeMap.get("\""+type+"\"");
    	tp=tp.replaceAll("\"", "");
    	return  tp;
    }
    
    /**
     *  查询工程编号是否存在,如果存在则不保存。
     */
    public void isHaveCode(){
    	String projectCode=getPara("p_code");
    	List<Record> records=find(tableName, "project_code", projectCode);
    	if(records!=null&&records.size()>0){
    		renderJson(new Status(Boolean.FALSE, "工程编号已经存在."));
    	}else{
    		renderJson(new Status(Boolean.TRUE, "工程编号不存在."));
    	}
    }
    
    public void getProjectInfnById(){
    	String projectId = getPara("projectId");
    	List<Record> res=query("getProjectById", projectId);
    	if(res!=null&&res.size()>0){
    		Record record = res.get(0);
    		record.set("PROJECT_TYPE", getRealType(record.getStr("PROJECT_TYPE")));
    		renderJson(record);
    	}
    }
}
