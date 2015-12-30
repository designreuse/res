package com.xzd.substation.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;


public class ServiceInterceptor implements Interceptor
{

	@Override
	public void intercept(final Invocation ai)
	{
		System.out.println("----------------------------开始进入Service！！！----------------------------");
		ai.invoke();
		System.out.println("----------------------------Service执行完毕！！！----------------------------");
	}
}
