package com.xzd.substation.common;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.CaseInsensitiveContainerFactory;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.render.ViewType;
import com.xzd.substation.interceptor.ActionInterceptor;
import com.xzd.substation.interceptor.ServiceInterceptor;


public class CommonConfig extends JFinalConfig
{

	@Override
	public void configConstant(final Constants me)
	{
		me.setDevMode(Constant.DEV_MODEL);
		me.setViewType(ViewType.JSP);
		me.setBaseViewPath(Constant.VIEW_PATH);
		me.setError404View("/404.html");
		me.setUploadedFileSaveDirectory(Constant.UPLOAD_ID);
		me.setUrlParaSeparator(Constant.URL_SEPARATOR);
	}

	@Override
	public void configRoute(final Routes me)
	{
		me.add(new BaseRoute());

	}

	@Override
	public void configPlugin(final Plugins me)
	{
		//数据源---主要针对系统数据源
		final C3p0Plugin basicPlugin = new C3p0Plugin(Constant.JDBC_URL_BASIC, Constant.USER_BASIC, Constant.PASSWORD_BASIC);
		me.add(basicPlugin);
		final ActiveRecordPlugin basicArp = new ActiveRecordPlugin("basic", basicPlugin);
		basicArp.setShowSql(Constant.SHOW_SQL);
		basicArp.setDialect(new MysqlDialect());
		// 配置属性名(字段名)大小写不敏感容器工厂
		basicArp.setContainerFactory(new CaseInsensitiveContainerFactory());
		me.add(basicArp);
	}

	@Override
	public void configInterceptor(final Interceptors me)
	{
		me.addGlobalActionInterceptor(new ActionInterceptor());
		me.addGlobalServiceInterceptor(new ServiceInterceptor());
	}

	@Override
	public void configHandler(final Handlers me)
	{
		//增加全局Handler的处理，处理查询配置
		me.add(new BasicHandler());
		me.add(new QueryHandler());
	}

	@Override
	public void afterJFinalStart()
	{
		super.afterJFinalStart();
		System.out.println("JFinal Start OK !!!");
	}

	@Override
	public void beforeJFinalStop()
	{
		super.beforeJFinalStop();
		System.out.println("Before JFinal Stop !!!");
	}
}
