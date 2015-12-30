package org.cqiyi.permission.model;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.cqiyi.core.PrimaryKey;
import org.cqiyi.core.SessionHelper;

import cn.dreampie.orm.Model;
import cn.dreampie.orm.annotation.Table;

/**
 * <strong>[t_permission]权限表：系统权限及工程权限</strong><br/>
 * <strong>Name
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type, IsNull,
 * Description</strong>
 * 
 * <pre>
 * id                  String, False, 权限编码
 * domain              String, True, SYTSEM：系统权限；PROJECT：工程权限
 * allow_url           String, True, 允许请求的URL集合，每行一个，method:full_url，可以使用通配符
 * description         String, True, 备注
 * create_user         String, True, 创建人
 * create_time         DateTime, True, 创建时间
 * update_user         String, True, 修改人
 * update_time         DateTime, True, 修改时间
 * </pre>
 *
 * <i>Automatically generated using CodeSmith v6.5.0 at 2015/9/11 16:15:05</i>
 * 
 */
@Table(name = "t_permission", cached = true)
public class Permission extends Model<Permission> {

	public final static Permission DAO = new Permission();
	public final static List<Permission> EMPTY_ARRAY = new ArrayList<Permission>();

	public boolean save() {
		if (StringUtils.isEmpty(this.<String> get("id"))) {
			this.set("id", PrimaryKey.get());
		}
		this.set("create_user", SessionHelper.getCurrentUserId());
		this.set("update_user", SessionHelper.getCurrentUserId());
		return super.save();
	}

	public boolean update() {
		this.remove("create_user");
		this.remove("create_time");
		return super.update();
	}
}
