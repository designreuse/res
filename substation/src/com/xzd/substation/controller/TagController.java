package com.xzd.substation.controller;

import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.util.ParamUtil;

/**
 * 标签库控制器
 */
public class TagController extends BaseController
{   
	@Override
	public void index(){
	  Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
	  Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
	  String tagName = getPara("tagName");
	   tagName = ParamUtil.isEmpty(tagName) ? "%%" : "%"+tagName+"%" ; 
	  String sqlText=getSqlText("getTagRecord");
	  Page<Record> rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,tagName);
	  renderJson(rePage);
	}
}
