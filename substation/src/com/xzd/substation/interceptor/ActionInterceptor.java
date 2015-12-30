package com.xzd.substation.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.xzd.substation.vo.UserVO;


public class ActionInterceptor implements Interceptor
{

	//private static final Logger logger = Logger.getLogger(ActionInterceptor.class);
	@Override
	public void intercept(final Invocation ai)
	{
		System.out.println("----------------------------开始进入Action！！！----------------------------");

		final Controller controller = ai.getController();
		final UserVO userVO = (UserVO) controller.getSessionAttr("user");
		if (userVO != null || ai.getMethodName().indexOf("-") > -1 || ai.getControllerKey().equals("/downapp"))
		{
			System.out.println("session中存在用户登陆信息,允许操作!!!!!!!!!!");
			ai.invoke();
		}
		else
		{
			System.out.println("session中不存在用户登陆信息,不允许操作!即将跳转至登陆页!");
			controller.redirect("/index");
		}
		System.out.println("ActionKey:--------------------------" + ai.getActionKey());
		System.out.println("ControllerKey:----------------------" + ai.getControllerKey());
		System.out.println("MethodName:-------------------------" + ai.getMethodName());
		System.out.println("ViewPath:---------------------------" + ai.getViewPath());
		System.out.println("Controller:-------------------------" + ai.getController());
		System.out.println("Method:-----------------------------" + ai.getMethod());
		System.out.println("MethodName:-------------------------" + ai.getMethodName());
		System.out.println("ReturnValue:------------------------" + ai.getReturnValue());
		System.out.println("----------------------------Action执行完毕！！！----------------------------");
	}
}
