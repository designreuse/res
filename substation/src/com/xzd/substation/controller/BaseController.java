package com.xzd.substation.controller;

import java.util.List;
import java.util.Map;

import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.util.ParamUtil;


public class BaseController extends QueryController
{

	@Override
	public void index()
	{
		final String target = getAttr("target");
		renderJsp(target);
	}

	public String saveOrUpdate(final String tableName, final String primaryKey, final Map<String, Object> map)
	{
		final Record record = new Record();
		for (final Map.Entry<String, Object> entry : map.entrySet())
		{
			record.set(entry.getKey(), entry.getValue());
		}
		System.out.println(JsonKit.toJson(record));
		String primaryValue=saveOrUpdate(tableName, primaryKey, record);
		return primaryValue;
	}

	public String saveOrUpdate(final String tableName, final String primaryKey, final Record record)
	{   
		String primaryValue=ParamUtil.randomString(32);
		final String pkValue = record.get(primaryKey);
		if (ParamUtil.isEmpty(pkValue))
		{
			record.set(primaryKey, primaryValue);
			insert(tableName, primaryKey, record);
		}
		else
		{
			final List<Record> exsitRecords = find(tableName, primaryKey, record.getStr(primaryKey));
			if (exsitRecords.size() > 0)
			{
				for (final Record updateRecord : exsitRecords)
				{
					update(tableName, primaryKey, updateRecord);
				}
			}
			else
			{
				insert(tableName, primaryKey, record);
			}
		}
		return primaryValue;//返回插入数据的id
	}

	public boolean insert(final String tableName, final String primaryKey, final Record record)
	{
		return Db.save(tableName, primaryKey, record);
	}

	public List<Record> find(final String tableName, final String primaryKey, final String primaryValue)
	{
		return Db.find("SELECT * FROM " + tableName + " WHERE " + primaryKey + " = ?", primaryValue);
	}

	public boolean update(final String tableName, final String primaryKey, final Record record)
	{
		return Db.update(tableName, primaryKey, record);
	}

	public boolean delete(final String tableName, final String primaryKey, final Record record)
	{
		return Db.delete(tableName, primaryKey, record);
	}
	
	/**
	 * 返回主键
	 * @param tableName
	 * @param primaryKey
	 * @param record
	 * @return
	 */
	public String save (final String tableName, final String primaryKey, final Record record)
	{
		    String primaryValue=ParamUtil.randomString(32);
			record.set(primaryKey, primaryValue);
			insert(tableName, primaryKey, record);
			return primaryValue;
	}
	
	/**
	 * 通过参数名称获取参数值
	 * @param paramName
	 * @return
	 */
	public String getParamValueByName(String paramName){
		List<Record> records=find("t_parameter", "param_name", paramName);
    	if(records!=null&&records.size()>0)
    		return records.get(0).getStr("param_value");
    	else
    		return "";
	}
}
