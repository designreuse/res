package com.xzd.substation.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.handler.Handler;


public class QueryHandler extends Handler
{

	public static String QUERY = "query";

	@Override
	public void handle(String target, final HttpServletRequest request, final HttpServletResponse response,
			final boolean[] isHandled)
	{
		System.out.println("target:"+target);
		final String[] targetArray = target.split("/");
		if (QUERY.equals(targetArray[1]))
		{
			target = "/" + targetArray[1] + "/queryName=" + targetArray[2];
			if (targetArray.length == 4)
			{
				target = target + "&" + targetArray[3];
			}
			System.out.println("url recreate result:" + target);
		}
		nextHandler.handle(target, request, response, isHandled);
	}

}
