package org.cqiyi.query.model;

import java.util.ArrayList;
import java.util.List;

import cn.dreampie.orm.Model;
import cn.dreampie.orm.annotation.Table;

/**
 * <strong>[t_query]</strong><br/>
 * <strong>Name
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type, IsNull,
 * Description</strong>
 * 
 * <pre>
 * query_id            String, False, 主键ID
 * query_name          String, True, 查询方法名称
 * query_describe      String, True, 查询内容
 * query_text          String, True, 查询语句
 * query_param         String, True, 查询参数
 * query_home          String, True, 查询人
 * query_comment       String, True, 备注
 * </pre>
 *
 * <i>Automatically generated using CodeSmith v6.5.0 at 2015/9/11 16:15:05</i>
 * 
 */
@Table(name = "t_query", cached = true)
public class Query extends Model<Query> {

	public final static Query DAO = new Query();
	public final static List<Query> EMPTY_ARRAY = new ArrayList<Query>();

	public boolean save() {
		return super.save();
	}

	public boolean update() {
		return super.update();
	}
}
