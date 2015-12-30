package org.cqiyi.query.partial;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.cqiyi.core.ApiResource;
import org.cqiyi.core.Utils;
import org.cqiyi.query.model.Query;

import cn.dreampie.orm.transaction.Transaction;
import cn.dreampie.route.core.annotation.API;
import cn.dreampie.route.core.annotation.DELETE;
import cn.dreampie.route.core.annotation.GET;
import cn.dreampie.route.core.annotation.POST;
import cn.dreampie.route.core.annotation.PUT;

/**
 * 
 * <strong>REST API，[t_query]</strong><br/>
 * <br/>
 *
 * <i><strong>DO NOT MODIFY</strong><br/>
 * Automatically generated using CodeSmith v6.5.0 at 2015/9/11 15:55:29</i><br/>
 * 
 */
@API("/query")
public class PartialQueryResource extends ApiResource {

	@GET
	public List<Query> getList(String columns, String where, String page) {
		columns = Utils.checkSyntax(columns);
		where = Utils.checkSyntax(where);
		if (StringUtils.isEmpty(columns)) {
			columns = "*";
		}
		int pageIndex = NumberUtils.toInt(page);
		if (pageIndex > 0) {
			if (StringUtils.isEmpty(where)) {
				return Query.DAO.fullPaginateColsAll(pageIndex, DEFAULT_PAGE_SIZE, columns).getList();
			} else {
				return Query.DAO.fullPaginateColsBy(pageIndex, DEFAULT_PAGE_SIZE, columns, where).getList();
			}
		}
		if (StringUtils.isEmpty(where)) {
			return Query.DAO.findColsAll(columns);
		} else {
			return Query.DAO.findColsBy(columns, where);
		}
	}

	//@GET("/count")
	public long getCount(String where) {
		where = Utils.checkSyntax(where);
		return StringUtils.isEmpty(where) ? Query.DAO.countAll() : Query.DAO.countBy(where);
	}

	@GET("/:id")
	public Query getObject(String id) {
		// TODO 此表没有ID字段，此处需要修改
		Query query = Query.DAO.findFirstBy("id=?", id);
		return query;
	}

	@POST
	@Transaction
	public List<Query> saveAll(List<Query> models) {
		if (Query.DAO.save(models)) {
			return models;
		}
		return Query.EMPTY_ARRAY;
	}

	@PUT
	@Transaction
	public boolean update(Query query) {
		return query.update();
	}

	@DELETE("/:id")
	@Transaction
	public boolean delete(String id) {
		return Query.DAO.deleteById(id);
	}
}
