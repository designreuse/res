package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.StringUtil;

/**
 * 进出站控制器
 */
public class InOutController extends BaseController
{
	@Override
	public void index()
	{
		  Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		  Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		  String projectId=getPara("projectId");
		  String inOutName = getPara("inOutName");
		  String roleName = getPara("roleName");
		  String inStartDate = getPara("inStartDate");
		  String inEndDate = getPara("inEndDate");
		  String outStartDate = getPara("outStartDate");
		  String outEndDate = getPara("outEndDate");
		  List<Object> params=new ArrayList<Object>();
		  String sqlText=getSqlText("getinOutRecord");
		  //通过条件来拼接sql
		 if(!StringUtil.isBlankOrNull(projectId)){
			 sqlText+=" and  tv.project_id =? ";
			 params.add(projectId);
		 }
		 if(!StringUtil.isBlankOrNull(roleName)){
			 sqlText+=" and  tv.role_name  like ? ";
			 params.add("%"+roleName+"%");
		 }
		 if(!StringUtil.isBlankOrNull(inOutName)){
			 sqlText+=" and  tv.real_name  like  ? ";
			 params.add("%"+inOutName+"%");
		 }
		 if(!StringUtil.isBlankOrNull(inStartDate)){
			 sqlText+=" and  tv.in_time>=? ";
			 params.add(inStartDate);
		 }
		 if(!StringUtil.isBlankOrNull(inEndDate)){
			 sqlText+=" and  tv.in_time<=? ";
			 params.add(inEndDate);
		 }
		 if(!StringUtil.isBlankOrNull(outStartDate)){
			 sqlText+=" and  tv.out_time>=? ";
			 params.add(outStartDate);
		 }
		 if(!StringUtil.isBlankOrNull(outEndDate)){
			 sqlText+=" and  tv.out_time<=? ";
			 params.add(outEndDate);
		 }
		  Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,params.toArray());
		  renderJson(rePage);
	}

	/**
	 * 获取进出站的时间记录type , userId , projectId
	 */
	public void dates()
	{

	}

	/**
	 * 进出站的总数 type,userId , projectId
	 */
	public void count()
	{

	}

	/**
	 * 进出站详情 type , userId , projectId
	 */
	public void inOutDetail()
	{

	}
}
