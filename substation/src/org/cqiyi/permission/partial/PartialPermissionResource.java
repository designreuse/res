package org.cqiyi.permission.partial;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.cqiyi.core.ApiResource;
import org.cqiyi.core.Utils;
import org.cqiyi.permission.model.Permission;

import cn.dreampie.orm.transaction.Transaction;
import cn.dreampie.route.core.annotation.API;
import cn.dreampie.route.core.annotation.DELETE;
import cn.dreampie.route.core.annotation.GET;
import cn.dreampie.route.core.annotation.POST;
import cn.dreampie.route.core.annotation.PUT;

/**
 * 
 * <strong>REST API，[t_permission]权限表：系统权限及工程权限</strong><br/>
 * <br/>
 *
 * <i><strong>DO NOT MODIFY</strong><br/>
 * Automatically generated using CodeSmith v6.5.0 at 2015/9/11 15:55:29</i><br/>
 * 
 */
@API("/permission")
public class PartialPermissionResource extends ApiResource {

	@GET
	public List<Permission> getList(String columns, String where, String page) {
		columns = Utils.checkSyntax(columns);
		where = Utils.checkSyntax(where);
		if (StringUtils.isEmpty(columns)) {
			columns = "*";
		}
		int pageIndex = NumberUtils.toInt(page);
		if (pageIndex > 0) {
			if (StringUtils.isEmpty(where)) {
				return Permission.DAO.fullPaginateColsAll(pageIndex, DEFAULT_PAGE_SIZE, columns).getList();
			} else {
				return Permission.DAO.fullPaginateColsBy(pageIndex, DEFAULT_PAGE_SIZE, columns, where).getList();
			}
		}
		if (StringUtils.isEmpty(where)) {
			return Permission.DAO.findColsAll(columns);
		} else {
			return Permission.DAO.findColsBy(columns, where);
		}
	}

	//@GET("/count")
	public long getCount(String where) {
		where = Utils.checkSyntax(where);
		return StringUtils.isEmpty(where) ? Permission.DAO.countAll() : Permission.DAO.countBy(where);
	}

	@GET("/:id")
	public Permission getObject(String id) {
		Permission permission = Permission.DAO.findFirstBy("id=?", id);
		return permission;
	}

	@POST
	@Transaction
	public List<Permission> saveAll(List<Permission> models) {
		if (Permission.DAO.save(models)) {
			return models;
		}
		return Permission.EMPTY_ARRAY;
	}

	@PUT
	@Transaction
	public boolean update(Permission permission) {
		return permission.update();
	}

	@DELETE("/:id")
	@Transaction
	public boolean delete(String id) {
		return Permission.DAO.deleteById(id);
	}
}
