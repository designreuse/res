package org.cqiyi.user.partial;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.cqiyi.core.ApiResource;
import org.cqiyi.core.Utils;
import org.cqiyi.user.model.User;

import cn.dreampie.orm.transaction.Transaction;
import cn.dreampie.route.core.annotation.API;
import cn.dreampie.route.core.annotation.DELETE;
import cn.dreampie.route.core.annotation.GET;
import cn.dreampie.route.core.annotation.POST;
import cn.dreampie.route.core.annotation.PUT;

/**
 * 
 * <strong>REST API，[t_user]人员表：包括系统登录的用户，以及刷卡的人员信息</strong><br/>
 * <br/>
 *
 * <i><strong>DO NOT MODIFY</strong><br/>
 * Automatically generated using CodeSmith v6.5.0 at 2015/9/11 15:55:29</i><br/>
 * 
 */
@API("/user")
public class PartialUserResource extends ApiResource {

	@GET
	public List<User> getList(String columns, String where, String page) {
		columns = Utils.checkSyntax(columns);
		where = Utils.checkSyntax(where);
		if (StringUtils.isEmpty(columns)) {
			columns = "*";
		}
		int pageIndex = NumberUtils.toInt(page);
		if (pageIndex > 0) {
			if (StringUtils.isEmpty(where)) {
				return User.DAO.fullPaginateColsAll(pageIndex, DEFAULT_PAGE_SIZE, columns).getList();
			} else {
				return User.DAO.fullPaginateColsBy(pageIndex, DEFAULT_PAGE_SIZE, columns, where).getList();
			}
		}
		if (StringUtils.isEmpty(where)) {
			return User.DAO.findColsAll(columns);
		} else {
			return User.DAO.findColsBy(columns, where);
		}
	}

	//@GET("/count")
	public long getCount(String where) {
		where = Utils.checkSyntax(where);
		return StringUtils.isEmpty(where) ? User.DAO.countAll() : User.DAO.countBy(where);
	}

	@GET("/:id")
	public User getObject(String id) {
		User user = User.DAO.findFirstBy("id=?", id);
		return user;
	}

	@POST
	@Transaction
	public List<User> saveAll(List<User> models) {
		if (User.DAO.save(models)) {
			return models;
		}
		return User.EMPTY_ARRAY;
	}

	@PUT
	@Transaction
	public boolean update(User user) {
		return user.update();
	}

	@DELETE("/:id")
	@Transaction
	public boolean delete(String id) {
		return User.DAO.deleteById(id);
	}
}
