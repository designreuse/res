package org.cqiyi.core;

import cn.dreampie.common.util.properties.Prop;
import cn.dreampie.common.util.properties.Proper;
import cn.dreampie.log.Logger;
import cn.dreampie.route.core.Resource;
import cn.dreampie.route.core.annotation.API;

@API(ApiResource.API_ROOT)
public class ApiResource extends Resource {
	private final static Logger logger = Logger.getLogger(ApiResource.class);
	public static final String API_ROOT = "/api/v1.0";

	/*
	 * 默认的分页记录数
	 */
	public static int DEFAULT_PAGE_SIZE;
	/*
	 * 上传文件的根目录
	 */
	public static String UPLOAD_DIRECTORY;

	static {
		Prop constants = null;
		try {
			constants = Proper.use("application.properties");
		} catch (Exception e) {
			logger.warn(e.getMessage());
		}

		DEFAULT_PAGE_SIZE = constants.getInt("app.defaultPageSize", 10);
		UPLOAD_DIRECTORY = constants.get("app.uploadDirectory");
	}
}
