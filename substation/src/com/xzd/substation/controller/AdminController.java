package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.aop.Clear;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.vo.MenuVO;

public class AdminController  extends BaseController{
	private final String tableName = "t_query";
	private final String primaryKey = "ID";
	private final String main_page = "admin/main.jsp";
	private List<String[]>   menu=new ArrayList<>();
	@Override
	public void index(){
		menu.add(new String[]{"查询配置","admin/queryConfig/index.jsp"});
		List<MenuVO>  menuList=new ArrayList<MenuVO>();
		int i=0;
		if(menu!=null&&menu.size()>0){
			for(String[] me:menu){
				MenuVO vo=new MenuVO();
				vo.setName(me[0]);
				vo.setUrl(me[1]);
				if(i==0) vo.setActive("active");
				i++;
				menuList.add(vo);
			}
		}
		setAttr("menuList", menuList);
		render(main_page);
	}
	
	/**
	 * 得到分页的查询配置数据
	 */
	public void getData(){
		  Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		  Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		  String queryName = getPara("queryName");
		  queryName = ParamUtil.isEmpty(queryName) ? "%%" : "%"+queryName+"%" ; 
		  Page<Record> res=queryByPage(pageNumber, pageSize, "getQueryData",queryName);
		  renderJson(res);
	}
	
	/**
	 * 保存查询配置数据
	 */
	public void saveQueryData(){
		Map<String, Object> data=new HashMap<String, Object>();
    	Map<String,String[]> map=getParaMap();
    	for(String key:map.keySet()){
    		data.put(key, map.get(key)[0]);
    	}
    	try {
    		if("".equals(data.get(primaryKey))||data.get(primaryKey)==null){
    			//保存之前查询此查询配置名称是否存在
    			String queryName=String.valueOf(data.get("QUERY_NAME")).trim();
    			List<Record> records=query("isHaveQueryName", queryName);
    			if(records==null||records.isEmpty()){
	    				saveOrUpdate(tableName, primaryKey , data);    		
	    				renderJson(new Status(Boolean.TRUE, "添加成功"));
    			}else{
    				renderJson(new Status(Boolean.FALSE, "查询名称已存在."));
    			}
    		}else{
    			Record record = new Record();
    			for (final Map.Entry<String, Object> entry : data.entrySet())
    			{
    				record.set(entry.getKey(), entry.getValue());
    			}
    			update(tableName, primaryKey , record);
    			renderJson(new Status(Boolean.TRUE, "修改成功"));
    		}
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(Boolean.FALSE, "添加失败："));
		}
	}
	/**
	 * 删除查询配置的数据
	 */
	public void deleteById(){
    	String id=getPara("id");
    	try {
    		Record  rec= queryOne("getQueryById", new Object[]{id});
    		delete(tableName, primaryKey, rec);
    		renderJson(new Status(Boolean.TRUE, "删除成功"));
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(Boolean.FALSE, "删除失败："));
		}
    }
	
	/**
	 * 通过id获取查询配置
	 */
	 public void getQueryById(){
	    	String idStr=getPara("id");
	    	Record resRecord=find(tableName, primaryKey, idStr).get(0);
	    	renderJson(resRecord);
	    }
}
