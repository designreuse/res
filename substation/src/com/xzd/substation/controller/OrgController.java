package com.xzd.substation.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.util.TreeNodeUtil;
import com.xzd.substation.vo.JsonTreeData;
import com.xzd.substation.vo.UserVO;

/**
 * 组织机构控制器
 */
public class OrgController extends BaseController {
	private final String tableName = "t_organization";
	private final String primaryKey = "id";

	public void getOrgByProjectId() {
		List<JsonTreeData> trees = new ArrayList<JsonTreeData>();
		String projectId = getPara("projectId");
		Record project = find("t_project", primaryKey, projectId).get(0);
		List<Record> records = query("getOrgByProjectId", projectId);
			for (Record r : records) {
				JsonTreeData vo = new JsonTreeData();
				vo.setId(r.getStr("org_code"));
				if (StringUtil.isBlankOrNull(r.getStr("parent_id"))) {
					vo.setText(project.getStr("short_name"));// 把根节点换成项目名称
				} else {
					vo.setText(r.getStr("org_name"));
				}
				vo.setPid(r.getStr("parent_id"));
				trees.add(vo);
			}
		trees = TreeNodeUtil.getfatherNode(trees);
		renderJson(trees);
	}
   
	public void getOrgListByProId(){
		String projectId = getPara("projectId");
		List<Record> records = query("getOrgByProjectId", projectId);
		renderJson(records);
	}
	
	
	public void saveOrgData() {
		UserVO userVo = getSessionAttr("user");
		Map<String, Object> data = new HashMap<String, Object>();
		Map<String, String[]> map = getParaMap();
		for (String key : map.keySet()) {
			data.put(key, map.get(key)[0]);
		}
		try {
			if ("".equals(data.get(primaryKey)) || data.get(primaryKey) == null) {
				data.put("create_user", userVo.getLoginName());
				data.put("create_time", DateUtils.getCurrDateTimeStr());
				data.put("update_user", userVo.getLoginName());
				data.put("update_time", DateUtils.getCurrDateTimeStr());
				String primaryValue = saveOrUpdate(tableName, primaryKey, data);
			} else {
				data.put("update_user", userVo.getLoginName());
				data.put("update_time", DateUtils.getCurrDateTimeStr());
				Record record = new Record();
				for (final Map.Entry<String, Object> entry : data.entrySet()) {
					record.set(entry.getKey(), entry.getValue());
				}
				update(tableName, primaryKey, record);
			}
			renderJson(new Status(Boolean.TRUE, "操作成功"));
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(Boolean.FALSE, "操作失败："));
		}
	}
	public void deleteByOrgIdAndProjectId(){
		String orgCode=getPara("orgCode");
		String projectId=getPara("projectId");
    	List<Record> resRecord=query("getOrgDataByprojectIdAndorgCode", projectId,orgCode);
    	if(resRecord!=null&&resRecord.size()>0){
    		//删除它的孩子节点
    		delete(tableName, primaryKey, resRecord.get(0));
    	}
    	Status st=new Status(true,"删除成功.");
    	renderJson(st);
	}
	
	/**
	 * 通过项目id和orgCode查询组织机构数据
	 */
	public void getOrgDataByprojectIdAndorgCode(){
		String orgCode=getPara("orgCode");
		String projectId=getPara("projectId");
    	List<Record> resRecord=query("getOrgDataByprojectIdAndorgCode", projectId,orgCode);
    	if(resRecord!=null&&resRecord.size()>0){
    		renderJson(resRecord.get(0));
    	}
	}
	
	/**
	 * 通过projectId获取组织机构排除Pid为空的数据
	 */
	public void getOrgByProjectIdExpPidNULL(){
		String projectId=getPara("projectId");
    	List<Record> resRecord=query("getOrgByProjectIdExpPidNULL", projectId);
        renderJson(resRecord);
	}
	
	/**
	 * 在参数表里边获取施工单位param_name='org_type'
	 */
	public void getOrgType(){
		Map<String, String> caMap = new HashMap<String, String>();
		String  consArea=getParamValueByName("org_type");
		consArea=consArea.replace("[{","");
		consArea=consArea.replace("}]","");
    	String[] consAreas=consArea.split(",");
    	if(consAreas.length>0){
    		for(String ca:consAreas)
    			if(!StringUtil.isBlankOrNull(ca)&&ca.contains(":")){
    				caMap.put(ca.split(":")[0].trim(), ca.split(":")[1]);				
    			}
    		}
           renderJson(caMap);
	}
}
