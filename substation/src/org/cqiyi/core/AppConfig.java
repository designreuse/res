package org.cqiyi.core;

import cn.dreampie.common.util.properties.Prop;
import cn.dreampie.common.util.properties.Proper;
import cn.dreampie.log.Logger;
import cn.dreampie.orm.ActiveRecordPlugin;
import cn.dreampie.orm.provider.c3p0.C3p0DataSourceProvider;
import cn.dreampie.route.config.Config;
import cn.dreampie.route.config.ConstantLoader;
import cn.dreampie.route.config.HandlerLoader;
import cn.dreampie.route.config.InterceptorLoader;
import cn.dreampie.route.config.PluginLoader;
import cn.dreampie.route.config.ResourceLoader;
import cn.dreampie.route.handler.cors.CORSHandler;
import cn.dreampie.route.interceptor.security.SecurityInterceptor;

public class AppConfig extends Config {
	private final static Logger logger = Logger.getLogger(AppConfig.class);

	public static int LIMITED_SESSIONS;

	static {
		Prop constants = null;
		try {
			constants = Proper.use("application.properties");
		} catch (Exception e) {
			logger.warn(e.getMessage());
		}

		LIMITED_SESSIONS = constants.getInt("app.limited_session", 1000);
	}

	public void configConstant(ConstantLoader constantLoader) {
		// 单页应用 避免被resty解析路径
		constantLoader.setDefaultForward("/");
	}

	public void configResource(ResourceLoader resourceLoader) {
		// 设置resource的目录 减少启动扫描目录
		resourceLoader.addIncludePackages("org.cqiyi");
	}

	public void configPlugin(PluginLoader pluginLoader) {
		C3p0DataSourceProvider c3p0 = new C3p0DataSourceProvider("default");
		ActiveRecordPlugin activeRecordPlugin = new ActiveRecordPlugin(c3p0);
		activeRecordPlugin.addIncludePackages("org.cqiyi");
		pluginLoader.add(activeRecordPlugin);
		// pluginLoader.add(new QuartzPlugin());
	}

	public void configInterceptor(InterceptorLoader interceptorLoader) {
		// 权限拦截器 limit 为最大登录session数
		interceptorLoader.add(new SecurityInterceptor(LIMITED_SESSIONS, new MyAuthenticateService()));

		// 事务的拦截器 @Transaction
		// interceptorLoader.add(new TransactionInterceptor());
	}

	public void configHandler(HandlerLoader handlerLoader) {
		// 跨域
		handlerLoader.add(new CORSHandler());
	}
}
