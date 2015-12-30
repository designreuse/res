package com.xzd.substation.common;

public class Constant
{
	public static final boolean SHOW_SQL = true;

//	public static final String JDBC_URL_BASIC = "jdbc:mysql://192.168.1.155:3309/substation_v3?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull";
	public static final String JDBC_URL_BASIC = "jdbc:mysql://localhost:3306/substation_v3?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull";
	public static final String USER_BASIC = "root";
	public static final String PASSWORD_BASIC = "";

	public static final Boolean DEV_MODEL = true;
	public static final String CONTROLLER_DIR = "com.xzd.substation.controller";
	public static final String MODEL_DIR = "com.xzd.substation.pojo";
	public static final String VIEW_PATH = "/";
	public static final int PORT =8888;
	public static final String UPLOAD_ID = "3tn2mkglv1bei73kupc1jrzeis5xxxwo";

	public static final String URL_SEPARATOR = "&";

	public static final String INDEX_PAGE = "/index.jsp";
	public static final String MAIN_PAGE = "/main.jsp";

	//mail相关
	public static final String MAIL_DISPLAY_NAME = "系统管理员";
	public static final String MAIL_SENDER = "yuan496_01@163.com";
	public static final String MAIL_SMTP_SERVER = "smtp.163.com";
	public static final String MAIL_USER_NAME = "yuan496_01@163.com";
	public static final String MAIL_PASSWORD = "yuan111496";
	public static final String MAIL_CHARSET = "utf-8";
 
	//Excel相关
	public static final String EXCEL_START = "d2aadc8a514211e5b26c0050568173ad";
	public static final String EXCEL_COLUMN = "d2aadc8a514211e5b26c0050568173ae";

}
