package com.xzd.substation.common;

import com.jfinal.core.JFinal;


/**
 *
 */
public class Start
{
	/**
	 * @param args
	 */
	public static void main(final String[] args)
	{
		JFinal.start("WebContent", Constant.PORT, "/", 5);
	}
}
