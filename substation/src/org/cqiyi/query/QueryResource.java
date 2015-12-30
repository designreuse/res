package org.cqiyi.query;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.cqiyi.query.model.Query;
import org.cqiyi.query.partial.PartialQueryResource;

import cn.dreampie.orm.Record;
import cn.dreampie.route.core.annotation.GET;

/**
 * 
 * <strong>REST API，[t_query]</strong><br/>
 * <br/>
 * 
 */
public class QueryResource extends PartialQueryResource {

	public static final Record RECORD = new Record("record", false);

	@GET("/exec/{queryName}")
	public List<Record> executeNamedQuery(String queryName, String params, String page) {
		// TODO 执行sql，返回结果
		Query query = Query.DAO.findFirstBy("lower(query_name)=?", queryName.toLowerCase());

		int pageIndex = NumberUtils.toInt(page);
		String sql = query.<String> get("query_text");

		if (StringUtils.isNotEmpty(params)) {
			Object[] objs = (Object[]) params.split("`");
			if (pageIndex > 0) {
				return RECORD.fullPaginate(pageIndex, DEFAULT_PAGE_SIZE, sql, objs).getList();
			} else {
				return RECORD.find(sql, objs);
			}
		} else {
			if (pageIndex > 0) {
				return RECORD.fullPaginate(pageIndex, DEFAULT_PAGE_SIZE, sql).getList();
			} else {
				return RECORD.find(sql);
			}

		}
	}
}
