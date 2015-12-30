package com.xzd.substation.interceptor;

import com.jfinal.core.Controller;
import com.jfinal.validate.Validator;
import com.xzd.substation.common.Constant;

public class LoginValidator  extends  Validator{

	@Override
	protected void validate(Controller c) {
		validateRequiredString("username", "nameMsg", "请输入用户名");
		validateRequiredString("password", "passMsg", "请输入密码");
		
	}

	@Override
	protected void handleError(Controller c) {
		c.keepPara("username");
		c.render(Constant.INDEX_PAGE );
	}
    
	
}
