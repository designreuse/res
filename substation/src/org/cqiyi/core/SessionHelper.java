package org.cqiyi.core;

import org.apache.commons.lang3.StringUtils;
import org.cqiyi.user.model.User;

import cn.dreampie.security.Principal;
import cn.dreampie.security.Subject;

public class SessionHelper {
	public static String getCurrentUserId() {
		// TODO 获取当前Session中的用户ID
		Principal<User> principal = Subject.getPrincipal();
		String userId = null;
		if (principal != null) {
			userId = principal.getModel().get("id");
		}
		System.out.println("当前登录用户ID=" + userId);
		return userId;
	}
}
