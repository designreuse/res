package org.cqiyi.user.model;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.cqiyi.core.PrimaryKey;
import org.cqiyi.core.SessionHelper;

import cn.dreampie.orm.Model;
import cn.dreampie.orm.annotation.Table;

/**
 * <strong>[t_user]人员表：包括系统登录的用户，以及刷卡的人员信息</strong><br/>
 * <strong>Name
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type, IsNull,
 * Description</strong>
 * 
 * <pre>
 * id                  String, False, 主键ID
 * user_name           String, True, 用户登录名
 * real_name           String, True, 真实姓名
 * mobile_phone        String, True, 手机
 * password            String, True, 密码，加密方式：Sha256Hash(Sha256Hash(原密码）+slat)
 * slat                String, True, 8位的随机数，每次修改或重置密码重新取值
 * email               String, True, 
 * sex                 String, True, 性别
 * birth_date          Date, True, 出生日期
 * identity_card       String, True, 身份证号码
 * photo               String, True, 照片（文件）名称 直接存储照片的文件名（人员ID来命名照片文件名称）
 * organization_id     String, True, 所在单位编码
 * corporation         String, True, 所在单位
 * department          String, True, 部门
 * duty                String, True, 职务
 * create_user         String, True, 
 * description         String, True, 
 * create_time         DateTime, True, 
 * update_user         String, True, 
 * update_time         DateTime, True,
 * </pre>
 *
 * <i>Automatically generated using CodeSmith v6.5.0 at 2015/9/11 16:15:05</i>
 * 
 */
@Table(name = "t_user", cached = true)
public class User extends Model<User> {

	public final static User DAO = new User();
	public final static List<User> EMPTY_ARRAY = new ArrayList<User>();

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
