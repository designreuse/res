package com.xzd.substation.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.handler.Handler;


public class BasicHandler extends Handler
{

	public static String SUBFIX = ".jsp";

	@Override
	public void handle(String target, final HttpServletRequest request, final HttpServletResponse response,
			final boolean[] isHandled)
	{
		System.out.println("target:" + target);
		if (target.indexOf(SUBFIX) > -1)
		{
			request.setAttribute("target", target);
			target = "/base";
		}
		nextHandler.handle(target, request, response, isHandled);
	}

}
