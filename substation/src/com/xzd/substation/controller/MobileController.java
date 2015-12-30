package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.FileUtil;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.StringUtil;

/**
 * 移动端控制器
 */
public class MobileController extends BaseController
{

	@Override
	public void index()
	{
		final String userName = getPara("userName");
		final String passWord = getPara("password");
		final String md5Password = StringUtil.SHA256Encode(passWord);
		final Record userRecord = this.queryOne("getUser", userName, md5Password);
		//说明用户存在，否则，用户就是不存在的
		if (userRecord != null)
		{
			//返回用户角色，直接决定用户的页面显示
			Record roleRecord = this.queryOne("getUserRoleByUserName", userName);
			Map<String , Object> map = new LinkedHashMap<String , Object>();
			map.put("personId", userRecord.getStr("ID"));
			map.put("roleCode", roleRecord.getStr("ROLE_CODE"));
			renderJson(new Status(Boolean.TRUE, "用户验证通过", map));
			
		}
		else
		{
			renderJson(new Status(Boolean.FALSE, "用户密码不匹配！"));
		}
	}
	//$('<img src="/mobile/getUserLogo/admin" />').appendTo("body");
	public void getUserLogo(){
		final String userName = getPara(0);
		String photo = "";
		//根据用户名去找头像
		List<Record> list = this.query("getUserLogoByUserName", userName);
		if(list.size() > 0){
			photo = list.get(0).getStr("PHOTO");
		}
		if(!ParamUtil.isEmpty(photo)){
			renderFile(FileUtil.getFileByName(photo));
		}
	}
	
	public void getProjectUserDetails(){
		//找到工程下所有的人员
		String personId = getPara("personId");
		String projectId = getPara("projectId");
		projectId = ParamUtil.isEmpty(projectId) ? "%%" : "%"+projectId+"%" ;
		List<Record> userRecords = this.query("getPersonsUserPersonId", personId , projectId);
		List<Map<String , Object>> lists = new ArrayList<Map<String , Object>>();
		for(int i = 0 ; i < userRecords.size() ; i++){
			Record userRecord = userRecords.get(i);
			List<Record> tags = this.query("getUserTags", userRecord.getStr("PERSON_ID") , userRecord.getStr("PROJECT_ID"));
			Map<String , Object> map = new LinkedHashMap<String , Object>();
			map.put("personId", userRecord.getStr("PERSON_ID"));
			map.put("userName", userRecord.getStr("USER_NAME"));
			map.put("realName", userRecord.getStr("REAL_NAME"));
			map.put("duty", userRecord.getStr("DUTY"));
			map.put("tags", tags);
			List<String> tagsType = new ArrayList<String>();
			for(int j = 0 ; j < tags.size() ; j++){
				Record tag = tags.get(j);
				tagsType.add(tag.getStr("TAG_TYPE"));
			}
			map.put("tagsType", tagsType);
			lists.add(map);
		}
		Status status = new Status(Boolean.TRUE, "请求成功");
		status.setResult(lists);
		renderJson(status);
		
	}

}
