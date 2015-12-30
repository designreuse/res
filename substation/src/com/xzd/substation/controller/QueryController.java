package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.util.ParamUtil;


/**
 * QueryController
 */
public class QueryController extends Controller
{
	static final Object[] NULL_PARA_ARRAY = new Object[0];

	/**
	 * 查询配置入口: eg: query/index/queryName=xxx&p1=xx&p2=xx... or eg: query/queryName=xxx&p1=xx&p2=xx...
	 */
	public void index()
	{
		final Map<String, String> paramMap = ParamUtil.convertStringParamToMapParam(getPara());
		final String queryName = paramMap.get("queryName");
		ParamUtil.removeMapElement2(paramMap, "queryName");
		

		final List<String> sqlParams = new ArrayList<String>();

		for (final Map.Entry<String, String> entry : paramMap.entrySet())
		{
			sqlParams.add(entry.getValue());
		}
		renderJson(query(queryName, sqlParams.toArray()));
	}

	/**
	 * @param queryName
	 *           查询配置名
	 * @param args
	 *           参数列表
	 * @return 返回查询结果集
	 */
	public List<Record> query(final String queryName, final Object... args)
	{  
		final String queryText = Db.queryStr("SELECT T.QUERY_TEXT FROM T_QUERY T WHERE T.QUERY_NAME = ?", queryName);
		return Db.find(queryText, args);
	}
	
	/**
	 * @param queryName
	 *           查询配置名
	 * @param args
	 *           参数列表
	 * @return 返回查询结果集
	 */
	public Page<Record> queryByPage(final int pageNumber,final int pageSize,final String queryName, final Object... args)
	{  
		final String queryText = Db.queryStr("SELECT T.QUERY_TEXT FROM T_QUERY T WHERE T.QUERY_NAME = ?", queryName);
		return Db.paginate(pageNumber, pageSize, "select *",queryText,args);
	}
	
	/**
	 * 
	 * @param pageNumber
	 * @param pageSize
	 * @param queryText
	 *               sql文本
	 * @param args
	 * @return
	 */
	public Page<Record> querysSqlTextByPage(final int pageNumber,final int pageSize,final String queryText, final Object... args)
	{  
		return Db.paginate(pageNumber, pageSize, "select *",queryText,args);
	}
	
	/**
	 * 
	 * @param pageNumber
	 * @param pageSize
	 * @param queryText
	 *               sql文本
	 * @param args
	 * @return
	 */
	public Page<Record> querysSqlTextByPage(final int pageNumber,final int pageSize,final String queryText)
	{  
		return querysSqlTextByPage(pageNumber, pageSize, "select *",queryText);
	}
	/**
	 * 
	 * @param queryName
	 *                查询配置名
	 * @return
	 *               sqlText
	 */
	public String getSqlText(final String queryName){
		return Db.queryStr("SELECT T.QUERY_TEXT FROM T_QUERY T WHERE T.QUERY_NAME = ?", queryName);
	}
	/**
	 * @param queryName
	 *           查询配置名
	 * @param args
	 *           参数列表
	 * @return 返回查询结果集
	 */
	public Record queryOne(final String queryName, final Object... args)
	{
		final String queryText = Db.queryStr("SELECT T.QUERY_TEXT FROM T_QUERY T WHERE T.QUERY_NAME = ?", queryName);
		List<Record> records = Db.find(queryText, args);
		return records.isEmpty() ? null : records.get(0);
	}
	/**
	 * @param queryName
	 *           查询配置名
	 * @return 返回查询结果集
	 */
	public List<Record> query(final String queryName)
	{
		return query(queryName, NULL_PARA_ARRAY);
	}


}
