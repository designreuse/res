package com.xzd.substation.controller;

import java.util.List;

import com.jfinal.aop.Clear;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Constant;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.MailUtil;
import com.xzd.substation.util.ParamUtil;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.UserVO;

public class IndexController extends BaseController {
    
	@Override
	@Clear
	public void index() {
		if (ParamUtil.isEmpty(getSessionAttr("user"))) {
			final String userName = getPara("username");
			final String passWord = getPara("password");
			//从参数配置里边获取公司名称以及版本号等信息
			setAttr("company", getParamValueByName("Company"));
			if (ParamUtil.isNotEmpty(userName) && ParamUtil.isNotEmpty(passWord)) {
				if (doLogin(userName, passWord).isSuccess()) {
					forwardAction("/permission/getMenu");
				} else {
					render(Constant.INDEX_PAGE + "?type=error&message=" + doLogin(userName, passWord).getMessage());
				}
			} else {
				render(Constant.INDEX_PAGE + "?type=login");
			}
		} else {
			forwardAction("/permission/getMenu");
		}
	}

	public  Status doLogin(final String userName, final String passWord) {
		final String md5Password = StringUtil.SHA256Encode(passWord);
		final List<Record> userRecord = this.query("getUser", userName, md5Password);
		if (userRecord.size() > 0) {
			final Record record = userRecord.get(0);
			System.out.println(record.get("STATE"));
			if ("1".equals(String.valueOf(record.get("STATE")))) {
				return new Status(Boolean.FALSE, "用户被禁止登录.");
			}
			final UserVO userVO = new UserVO(record.get("ID")==null?"":record.get("ID").toString(), record.get("REAL_NAME")==null?"":record.get("REAL_NAME").toString(),
					record.get("USER_NAME")==null?"":record.get("USER_NAME").toString(), record.get("MOBILE_PHONE")==null?"":record.get("MOBILE_PHONE").toString(),
							record.get("EMAIL")==null?"":record.get("EMAIL").toString(),  record.get("ROLE_CODES")==null?"":record.get("ROLE_CODES").toString(),
									record.get("ROLE_NAMES")==null?"":record.get("ROLE_NAMES").toString());
			setSessionAttr("user", userVO);
			setAttr("user", userVO);
			return new Status(Boolean.TRUE, "用户登录成功.");
		} else {
			return new Status(Boolean.FALSE, "账户或者密码错误.");
		}
	}

	public void logout() {
		removeSessionAttr("user");
		redirect("/index");
	}

	@Clear
	public void getPassword() {
		renderJsp("/register/findPwd.jsp");
	}

	@Clear
	public void getPhoneAndEmail() {
		final String username = getPara("username");
		setSessionAttr("username", username);
		// 根据userName拿到phone以及email
		final List<Record> query = this.query("phoneAndEmailByUserName", username);
		if (query.size() != 1) {
			renderJson(new Status(false, "请检查用户名是否正确！"));
		} else {
			renderJson(new Status(true, "成功获取用户信息", query));
		}
	}

	@Clear
	public void sendPhoneAndEmail() {
		final String type = getPara("type");
		final String value = getPara("value");
		if ("email".equals(type)) {
			final String emailValidateCode = ParamUtil.randomString(5);
			setSessionAttr("validateCode", emailValidateCode);
			try {
				MailUtil.send(new String[] { value }, false, "找回密码验证码",
						"<h3>您正在找回登录密码，您需要的验证码为：" + emailValidateCode + "<h3>", true, null);
				renderJson(new Status(true, "发送成功！"));
			} catch (Exception e) {
				e.printStackTrace();
				renderJson(new Status(false, e.getMessage()));
			}
		} else if ("phone".equals(type)) {
			// TODO
			renderJson(new Status(true, "发送成功！"));
		}
	}

	@Clear
	public void validateInputCode() {
		final String code = getPara("code");
		final Object object = getSessionAttr("validateCode");
		if (object != null) {
			final String serverCode = object.toString();
			if (serverCode.equals(code)) {
				renderJson(new Status(true, "发送成功！"));
			} else {
				renderJson(new Status(false, "验证码输入不正确！"));
			}
		} else {
			renderJson(new Status(false, "验证码输入不正确！"));
		}
	}

	@Clear
	public void repassword() {
		final String password = getPara("password");
		final String userName = getSessionAttr("username");

		try {
			final int update = Db.update(this.getSqlText("resetUserPassword"), StringUtil.SHA256Encode(password),
					userName);
			if (update > 0) {
				renderJson(new Status(true, "密码修改成功！"));
			} else {
				renderJson(new Status(false, "密码修改失败:用户不存在！"));
			}
		} catch (final Exception e) {
			e.printStackTrace();
			renderJson(new Status(false, "密码修改失败:" + e.getMessage()));
		}
	}

	public static void main(String[] args) {
		System.out.println(StringUtil.SHA256Encode("admin"));
		;
	}
}
