package com.xzd.substation.util;

import java.io.File;
import java.net.URL;

import com.jfinal.log.Logger;


public class ScanningUtil
{
	protected final Logger log = Logger.getLogger(getClass());
	static URL BASIC_PATH = ScanningUtil.class.getResource("/");

	public String[] getClassesPath(final String path)
	{
		String scanPath = BASIC_PATH + "/" + path.replace(".", "/");
		scanPath = scanPath.substring(6);
		final File controllerFiles = new File(scanPath);
		if (controllerFiles.isDirectory())
		{
			final String[] controllers = controllerFiles.list();
			for (int i = 0; i < controllers.length; i++)
			{
				controllers[i] = path + "." + controllers[i];
			}
			return controllers;
		}
		return new String[0];
	}

	@SuppressWarnings("rawtypes")
	public Class getClassByName(String className)
	{
		className = className.replace(".class", "");
		Class clazz = null;
		try
		{
			clazz = Class.forName(className);
		}
		catch (final Exception e)
		{
			log.error("没有找到" + className + "映射类，请检查是否存在。");
		}
		return clazz;
	}
}
