package com.xzd.substation.common;

import com.jfinal.config.Routes;
import com.xzd.substation.util.ScanningUtil;


/**
 *
 * @author lyy 自动扫描的规则： 1.扫描指定包下面的xxxController 2.默认的规则是("/xxx" , com.xx.xx.xxxController , "/")
 */
public class BaseRoute extends Routes
{

	@SuppressWarnings("unchecked")
	@Override
	public void config()
	{
		final ScanningUtil basicSanningUtil = new ScanningUtil();
		final String[] ctrlName = basicSanningUtil.getClassesPath(Constant.CONTROLLER_DIR);
		for (final String name : ctrlName)
		{
			final String[] names = name.split("\\.");
			String addressName = names[names.length - 2];
			addressName = addressName.substring(0, addressName.length() - 10).toLowerCase();
			add("/" + addressName, basicSanningUtil.getClassByName(name), "/");
		}
	}
}
