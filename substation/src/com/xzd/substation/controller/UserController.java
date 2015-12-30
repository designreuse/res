package com.xzd.substation.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.xzd.substation.common.Constant;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.FileUtil;
import com.xzd.substation.util.IdcardInfoExtractor;
import com.xzd.substation.util.IdcardValidator;
import com.xzd.substation.util.POIExcelUtil;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.UserVO;


/**
 * 人员控制器
 */
public class UserController extends BaseController
{
	private final String tableName = "t_user";
	private final String primaryKey = "id";
	private final String excel_query_name = "getExcelInfo";
	private final String excel_param_value = "PARAM_VALUE";

	@Override
	public void index()
	{
		final Integer pageNumber = getParaToInt("pageNumber") == null ? 1 : getParaToInt("pageNumber");
		final Integer pageSize = getParaToInt("pageSize") == null ? 10 : getParaToInt("pageSize");
		String userName = getPara("userName");
		userName = ParamUtil.isEmpty(userName) ? "%%" : "%" + userName + "%";
		final String sqlText = getSqlText("getAllPerson");
		final Page<Record> rePage = querysSqlTextByPage(pageNumber, pageSize, sqlText, userName);
		renderJson(rePage);
	}

	public void add()
	{
		UserVO userVo=getSessionAttr("user");
		boolean isSetPass=false;//是否重置密码
		try
		{
			Map<String, Object> dataMap=new HashMap<String, Object>();
			Map<String, Object> roleUserDataMap=new HashMap<String, Object>();//角色人员关系表
	    	Map<String,String[]> map=getParaMap();
	    	for(String key:map.keySet()){
	    		if("id".equalsIgnoreCase(key)){
	    			roleUserDataMap.put("user_id", map.get(key)[0]);
	    			dataMap.put(key, map.get(key)[0]);	   
	    		}
	    		
	    		if("project_id".equalsIgnoreCase(key)||"role_id".equalsIgnoreCase(key)||"organization_id".equalsIgnoreCase(key)||"ru_id".equals(key)){
	    			roleUserDataMap.put(key, map.get(key)[0]);
	    		}else if("isSetPassword".equals(key)){
	    			if("1".equals(map.get(key)[0])){
	    				isSetPass=true;
	    			}
	    			continue;
	    		}else{
	    			dataMap.put(key, map.get(key)[0]);	    
	    		}
	    	}
			//从身份证里边提取生日
			 IdcardValidator iv = new IdcardValidator();   
			 String primaryId=null;
			 if(iv.isValidate18Idcard((String) dataMap.get("identity_card"))){
				 IdcardInfoExtractor ie = new IdcardInfoExtractor((String) dataMap.get("identity_card"));   
				 dataMap.put("birth_date", DateUtils.format(ie.getBirthday(),DateUtils.YYYY_MM_DD));
			 }
			 if(isSetPass){//是否重置密码 如果重置加密
        		dataMap.put("password", StringUtil.SHA256Encode(dataMap.get("password").toString()));				 
			 }
			 if("".equals(dataMap.get("state"))||dataMap.get("state")==null){
				 dataMap.put("state","1");
			 }
			 if("".equals(dataMap.get(primaryKey))||dataMap.get(primaryKey)==null){
				   //通过用户名验证用户是否存在
				    String  userName=String.valueOf(dataMap.get("user_name"));
				    List<Record> records=find(tableName, "user_name", userName);
				    if(records!=null&&records.size()>0){
				    	renderJson(new Status(Boolean.FALSE, "数据已存在"));
				    	return;
				    }
					dataMap.put("create_user", userVo.getLoginName());
					dataMap.put("create_time", DateUtils.getCurrDateTimeStr());
					dataMap.put("update_user", userVo.getLoginName());
					dataMap.put("update_time", DateUtils.getCurrDateTimeStr());
					dataMap.put("slat", "123456");
					primaryId=this.saveOrUpdate(tableName, primaryKey, dataMap);
			}else{
				dataMap.put("update_user", userVo.getLoginName());
				dataMap.put("update_time", DateUtils.getCurrDateTimeStr());
				dataMap.put("slat", "123456");
				Record record = new Record();
	      		for (final Map.Entry<String, Object> entry : dataMap.entrySet())
	      		{
	      			record.set(entry.getKey(), entry.getValue());
	      		}
				update(tableName, primaryKey, record);
			}
			 //更新t_user_role表
			 if(roleUserDataMap.size()>0){
				 if("".equals(roleUserDataMap.get("ru_id"))||roleUserDataMap.get("ru_id")==null){
					 roleUserDataMap.put("create_user", userVo.getLoginName());
					 roleUserDataMap.put("craete_time", DateUtils.getCurrDateTimeStr());
					 roleUserDataMap.put("update_user", userVo.getLoginName());
					 roleUserDataMap.put("update_time", DateUtils.getCurrDateTimeStr());
					 if(primaryId!=null&&!"".equals(primaryId)){
						 roleUserDataMap.put("user_id", primaryId);
					 }
					 roleUserDataMap.remove("ru_id");
					 this.saveOrUpdate("t_user_role", "id", roleUserDataMap);
				}else{
					Record res=new Record();;
					if(roleUserDataMap.get("ru_id")!=null&&!"".equals(roleUserDataMap.get("ru_id"))){
						res=this.find("t_user_role", "id", String.valueOf(roleUserDataMap.get("ru_id"))).get(0);		
					}
					res.set("project_id", roleUserDataMap.get("project_id"));
					res.set("user_id", roleUserDataMap.get("user_id"));
					res.set("role_id", roleUserDataMap.get("role_id"));
					res.set("organization_id", roleUserDataMap.get("organization_id"));
					res.set("update_user", userVo.getLoginName());
				    res.set("update_time", DateUtils.getCurrDateTimeStr());
				    if(primaryId!=null&&!"".equals(primaryId)){
						 roleUserDataMap.put("user_id", primaryId);
					 }
					update("t_user_role", "id", res);
				}
			 }
				renderJson(new Status(Boolean.TRUE, "操作成功"));
		}
		catch (final Exception e)
		{
			e.printStackTrace();
			renderJson(new Status(Boolean.FALSE, "人员添加失败：" ));
		}
	}

	public void disable()
	{
		try
		{
			final String id = getPara("id");
			final Record record = Db.findById(tableName, primaryKey, id);
			final int oldState = record.getInt("STATE");
			record.set("STATE", (oldState == 0 ? 1 : 0));
			this.update(tableName, primaryKey, record);
			renderJson(new Status(Boolean.TRUE, "人员更新成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "人员更新失败：" ));
		}
	}

	public void delete()
	{
		try
		{
			final String id = getPara("id");
			//删除t_user_role数据
			List<Record> resList=find("t_user_role", "user_id", id);
			for(Record r:resList){
				delete("t_user_role", "id",r);
			}
			//删除t_user表数据
			Db.deleteById(tableName, primaryKey, id);
			renderJson(new Status(Boolean.TRUE, "人员删除成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "人员删除失败："));
		}
	}

	public void delete2()
	{
		try
		{
			final String id = getPara("id");
			final String projectId = getPara("projectId");
			final String organizationId = getPara("organizationId");
			if (ParamUtil.isEmpty(organizationId))
			{
				Db.deleteById("t_user_role", "user_id,project_id", id, projectId);
			}
			else
			{
//				Db.update("update t_user t set t.organization_id = '' where t.id = ?", id);
				Db.deleteById("t_user_role", "user_id,project_id,organization_id", id, projectId,organizationId);
			}
			renderJson(new Status(Boolean.TRUE, "人员删除成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "人员删除失败："));
		}
	}


	public void upload()
	{  
		UserVO userVo=getSessionAttr("user");
		final UploadFile uploadFile = getFile();
		try
		{
			final Workbook workbook = POIExcelUtil.getExcelWorkbook(uploadFile.getFile());
			final Sheet sheet = POIExcelUtil.getSheetByNum(workbook, 1);
			final List<Map<String, Object>> sheetDatas = POIExcelUtil.getSheetDataMapAndId(sheet);
			//需要两个参数,开始行,列顺序
			final int startIndex =1;
			final String[] columns =new String[]{"user_name","real_name","mobile_phone","email","sex","identity_card","corporation","department","specialty","part_manage","description"};

			int dataLength = -1;
			
            List<String> unImportData=new ArrayList<>();

			for (int i = startIndex; i < sheetDatas.size(); i++)
			{
				final List<String> dataLists = (List<String>) sheetDatas.get(i).get("data");
				if (dataLength == -1)
				{
					dataLength = columns.length > dataLists.size() ? dataLists.size() : columns.length;
				}
				final Map<String, Object> dataMap = new HashMap<String, Object>();
				for (int start = 0; start < dataLength; start++)
				{   
					if("sex".equals(columns[start])){
						if("男".equals(dataLists.get(start))){
							dataMap.put(columns[start], "man");
						}else if("女".equals(dataLists.get(start))){
							dataMap.put(columns[start], "weman");
						}
					}else if("identity_card".equals(columns[start])){
						dataMap.put(columns[start], dataLists.get(start));		
						//从身份证里边提取生日
						 IdcardValidator iv = new IdcardValidator();   
						 if(iv.isValidate18Idcard((String)dataLists.get(start))){
							 IdcardInfoExtractor ie = new IdcardInfoExtractor((String) dataLists.get(start));   
							 dataMap.put("birth_date", DateUtils.format(ie.getBirthday(),DateUtils.YYYY_MM_DD));
						 }
						
					}else{
						dataMap.put(columns[start], dataLists.get(start));						
					}
				}
				//密码加密
				dataMap.put("password", StringUtil.SHA256Encode("123456"));
				dataMap.put("create_user", userVo.getLoginName());
				dataMap.put("create_time", DateUtils.getCurrDateTimeStr());
				dataMap.put("state",1);
				//查询库里边是否存在要是存在直接放弃
				List<Record> records=find(tableName, "user_name", String.valueOf(dataMap.get("user_name")));
				if(records.isEmpty()){
					this.saveOrUpdate(tableName, primaryKey, dataMap);					
				}else{
					unImportData.add(i+"");
				}
			}
			uploadFile.getFile().delete();
			if(unImportData.size()==0){
				renderJson(new Status(Boolean.TRUE, "数据导入成功"));				
			}else{
				String rows="";
				for(String index:unImportData){
					rows+=index+",";
				}
				if(rows.contains(",")){
					rows=rows.substring(0, rows.length()-1);
				}
				renderJson(new Status(Boolean.TRUE, "数据导入成功,该Excel中第"+rows+"行数据库里边存在,未导入成功"));	
			}
		}
		catch (final Exception e)
		{
			uploadFile.getFile().delete();
			e.printStackTrace();
			renderJson(new Status(Boolean.FALSE, "数据导入失败:" ));
		}

	}

	public void userDetail()
	{
		final Map<String, String> params = ParamUtil.convertStringParamToMapParam(getPara());
		final String userId = params.get("userId");
		final String projectId = params.get("projectId");
		final Record userRecord = this.queryOne("getPersonId", userId);
		//获取角色
		final List<Record> roles = this.query("getUserRole", userId, projectId);
		String rolesString = "";
		String roleId = "";
		for (int i = 0; i < roles.size(); i++)
		{
			rolesString = rolesString + "," + roles.get(i).getStr("ROLE_NAME");
			roleId = roleId + "," + roles.get(i).getStr("ID");
		}
		rolesString = (rolesString.length() > 0 ? rolesString.substring(1) : rolesString);
		roleId = (roleId.length() > 0 ? roleId.substring(1) : roleId);
		setAttr("userRecord", userRecord);
		setAttr("role", rolesString);
		setAttr("roleId", roleId);
		setAttr("projectId", projectId);
		renderJsp("/mainPage/grzx.jsp");
	}

	public void projectInfo()
	{
		final Map<String, String> params = ParamUtil.convertStringParamToMapParam(getPara());
		final String userId = params.get("userId");
		final String projectId = params.get("projectId");
		final Record record = Db.findFirst("select * from t_project t where t.id = ?", projectId);
		setAttr("userId", userId);
		setAttr("projectId", projectId);
		setAttr("record", record);
		renderJsp("/mainPage/gcgk.jsp");
	}

	public void userInfo()
	{
		final Map<String, String> params = ParamUtil.convertStringParamToMapParam(getPara());
		final String userId = params.get("userId");
		final String projectId = params.get("projectId");
		//USER
		 Record userRecord =find(tableName, primaryKey, userId).get(0);
		 if("man".equals(userRecord.get("SEX"))){
			 userRecord.set("SEX","男");
		 }else if("weman".equals(userRecord.get("SEX"))){
			 userRecord.set("SEX","女");
		 }else{
			 userRecord.set("SEX","");
		 }
		String duty=userRecord.getStr("duty");
		if(!StringUtil.isBlankOrNull(duty)){
			Record record =Db.findFirst("select * from t_role r where r.role_code=?", duty);
			userRecord.set("duty", record.get("role_name"));
		}
		//进站记录
		final List<Record> inoutRecord = Db.find(
				"select t.* , DATE_FORMAT(t.in_time, '%Y-%m-%d') date ,substring(timediff(t.out_time, t.in_time),1,5) time from t_inout t where  t.user_id = ? order by in_time asc",
				userId);
		//违章记录
		final List<Record> violateRecord = Db.find(
				"select * from t_violate t where  t.id in (select violate_id from t_violate_user where user_id = ?)",
				 userId);
		//培训记录
		final List<Record> trainRecord = Db.find(
				"select t.* , (select course_name from t_course where id = t.course_id and project_id = ?) course_name from t_training t where t.user_id = ?",
				projectId, userId);
		//标签信息
		final List<Record> tagRecord = Db.find(
				"select t.tag_id ,(select tag_mac from t_tag_library WHERE id = t.tag_id ) tag_mac, (select tag_name from t_tag_library WHERE id = t.tag_id ) tag_name , t.part from t_user_tag t where  t.user_id = ?",
				userId);

		setAttr("tagRecord", tagRecord);
		setAttr("tagCount", tagRecord.size());
		setAttr("trainRecord", trainRecord);
		setAttr("trainCount", trainRecord.size());
		setAttr("violateRecord", violateRecord);
		setAttr("violateCount", violateRecord.size());
		setAttr("inoutRecord", inoutRecord);
		setAttr("inoutCount", inoutRecord.size());
		setAttr("userRecord", userRecord);
		setAttr("projectId", projectId);
		renderJsp("/mainPage/userDetail.jsp?userId="+userId);
	}

	public void cpassword()
	{
		final String userId = getPara("userId");
		final String oldPassword = getPara("oldPassword");
		final String newPassword = getPara("newPassword");
		final Record record = Db.findById(tableName, "ID,PASSWORD", userId, StringUtil.SHA256Encode(oldPassword));
		if (record == null)
		{
			renderJson(new Status(Boolean.FALSE, "更新失败"));
		}
		else
		{
			record.set("PASSWORD", StringUtil.SHA256Encode(newPassword));
			final boolean update = this.update(tableName, primaryKey, record);
			if (update)
			{
				renderJson(new Status(Boolean.TRUE, "更新成功"));
			}
			else
			{
				renderJson(new Status(Boolean.FALSE, "更新失败"));
			}
		}
	}

	public void editUser()
	{
		final Map<String, Object> dataMap = ParamUtil.convertMap(getParaMap());

		try
		{
			final String projectId = dataMap.get("projectId").toString();
			final String role = dataMap.get("role").toString();
			final String userId = dataMap.get("id").toString();
			ParamUtil.removeMapElement(dataMap, "projectId");
			ParamUtil.removeMapElement(dataMap, "role");

			dataMap.put("sex", ("on".equals(dataMap.get("sex")) ? "男" : "女"));

			this.update(tableName, primaryKey, ParamUtil.convertRecord(dataMap));
			Db.update(this.getSqlText("updateRole"), role, projectId, userId);

			renderJson(new Status(Boolean.TRUE, "用户修改成功:"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "用户修改失败:" ));
		}
	}

	public void zzjguser()
	{
		final Integer pageNumber = getParaToInt("pageNumber") == null ? 1 : getParaToInt("pageNumber");
		final Integer pageSize = getParaToInt("pageSize") == null ? 10 : getParaToInt("pageSize");
		final String projectId = getPara("projectId");
		String organizationId = getPara("organizationId");
		String userName = getPara("userName");
		userName = ParamUtil.isEmpty(userName) ? "%%" : "%" + userName + "%";
		organizationId = ParamUtil.isEmpty(organizationId) ? "%%" : "%" + organizationId + "%";
		String sqlText=getSqlText("getUserByorgIdOrProject");
		 Page<Record> rePage = querysSqlTextByPage(pageNumber, pageSize, sqlText, projectId, projectId, projectId, projectId,
					projectId, projectId, projectId, projectId, projectId,organizationId, userName);
		renderJson(rePage);
	}

	public void addjg()
	{
		try
		{
			final Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("id", getPara("id"));
			dataMap.put("project_id", getPara("projectId"));
			dataMap.put("org_name", getPara("jgName"));
			dataMap.put("org_code", getPara("jgCode"));
			dataMap.put("create_time", new Date());
			dataMap.put("create_user", ((UserVO) getSessionAttr("user")).getUserName());
			dataMap.put("description", getPara("comment"));
			if (ParamUtil.isEmpty(getPara("id")))
			{
				this.saveOrUpdate("t_organization", "id", dataMap);
			}
			else
			{
				this.update("t_organization", "id", ParamUtil.convertRecord(dataMap));
			}
			renderJson(new Status(Boolean.TRUE, "组织机构增加成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "组织机构增加失败：" ));
		}
	}

	public void deletejg()
	{
		final String id = getPara("id");
		try
		{
			Db.deleteById("t_organization", "id", id);
			renderJson(new Status(Boolean.TRUE, "组织机构删除成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "组织机构删除失败：" ));
		}
	}

	public void addzzjguser()
	{
		try
		{

			final Map<String, Object> map = ParamUtil.convertMap(getParaMap());
			//TODO
			final String password = map.get("password").toString();
			if ("123456".equals(password))
			{
				map.put("password", StringUtil.SHA256Encode("123456"));
			}
			final Record record = ParamUtil.convertRecord(map);
			this.saveOrUpdate(tableName, primaryKey, record);

			renderJson(new Status(Boolean.TRUE, "组织机构人员增加成功"));
		}
		catch (final Exception e)
		{
			renderJson(new Status(Boolean.FALSE, "组织机构人员增加失败：" ));
		}

	}

	public void downloadT()
	{
		String path=getRequest().getSession().getServletContext().getRealPath("")+ "\\source\\doc\\人员导入格式以及样例.xls";
		renderFile(new File(path));
	}
	/**
	 * 通过身份证号码查询用户
	 */
	public void findUserByIdCard(){
		String telephone=getPara("telephone");
		String projectId=getPara("projectId");
		List<Record> res=query("findUserByIdCard", projectId,projectId,projectId,projectId,projectId,telephone);
		if(res!=null&&res.size()>0){
			renderJson(res.get(0));
		}else{
			renderJson(new Record());
		}
	}
	
	/**
	 * 上传用户头像
	 */
	public  void  savePhoto(){
		 try {
    		 UploadFile files =  getFile();
             String path=getRequest().getSession().getServletContext().getRealPath("");
    		 FileUtil.copyFile(files.getSaveDirectory()+"\\"+files.getFileName(),"d:\\upload-files\\"+files.getFileName());
    		 FileUtil.deleteFile(files.getSaveDirectory()+files.getFileName());
    		 renderJson(new Status(Boolean.TRUE, "操作成功"));
		} catch (Exception e) {
			e.printStackTrace();
    		renderJson(new Status(Boolean.FALSE, "操作失败："));
		}
	}
}
