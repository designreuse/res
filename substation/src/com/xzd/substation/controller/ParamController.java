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
import com.xzd.substation.vo.UserVO;

/**
 * 工程项目控制器
 */
public class ParamController extends BaseController
{  
	private final String tableName = "t_parameter";
	private final String org_tableName = "t_organization";
	private final String primaryKey = "id";
    @Override
	public void index(){
    	 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		 String paramName = getPara("paramName");
		 paramName = ParamUtil.isEmpty(paramName) ? "%%" : "%"+paramName+"%" ; 
		 String sqlText=getSqlText("getParamsRecord");
		 Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,paramName);
		 renderJson(rePage);
    }
    
    public void deleteById(){
    	String id=getPara("id");
    	try {
    		Record  rec=find(tableName, primaryKey,id).get(0);
    		boolean flag=delete(tableName, primaryKey, rec);
    		Status st=new Status();
    		st.setSuccess(flag);
    		st.setMessage("删除成功!");
    		renderJson(st);			
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(false, "删除失败!"));		
		}
    }
    public void getDataById(){
    	String idStr=getPara("paramId");
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
    
    public void getProjectInfo() {
		Map<String, String> mapParam = ParamUtil.convertStringParamToMapParam(getPara());
		String projectId = mapParam.get("projectId");
		Record record = Db.findFirst("SELECT * FROM T_PROJECT T WHERE T.ID = ?", projectId);
		record.set("PROJECT_TYPE", getRealType(record.getStr("PROJECT_TYPE")));
		setAttr("project", record);
		renderJsp("/mainPage/gcgk.jsp");
	}
    
    public String getRealType(String type){
    	Map<String, String> typeMap = new HashMap<String, String>();
    	List<Record> res=find(tableName, "param_name", "project_type");
    	if(res!=null&&res.size()==1){
    		Record r=res.get(0);
    		String values=r.getStr("PARAM_VALUE");
    		values=values.replace("[{","");
    		values=values.replace("}]","");
    		System.out.println(values);
    	}
    	typeMap.put("xl", "线路");
    	typeMap.put("bdz", "变电站");
    	typeMap.put("hlz", "换流站");
    	return (typeMap.get(type) == null) ? "" : typeMap.get(type); 
    }
    
    /**
     * 获取项目类型
     * @return
     */
    public void getProjetType(){
    	List<Record> res=find(tableName, "param_name", "project_type");
    	renderJson(res);
    }
    
}
