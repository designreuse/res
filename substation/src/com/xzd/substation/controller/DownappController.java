package com.xzd.substation.controller;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

/**
 * 
 */
public class DownappController extends BaseController
{   
	private HttpClient client = new DefaultHttpClient();
	
	@Override
	public void index(){
		Record r = Db.findFirst("SELECT param_value FROM t_parameter t WHERE param_name = 'AppId'");
		setAttr("appId", r.get("param_value"));
		setAttr("appType", getPara("t"));
		
		String url = "http://www.apicloud.com/getAllUnpack?appId=" + r.get("param_value") + "&startNum=0&num=1";
		
		String JSON;
		String appDownloadURL;
		String appVer;
		
		try {
			JSON = getJSON(client, url);
			appDownloadURL = getAppDownloadURL(JSON, getPara("t"));
			appVer = getAppVer(JSON);
			
			setAttr("status", "ok");
			setAttr("appDownloadURL", appDownloadURL);
			setAttr("appVer", appVer);
		} catch (IOException e) {
			setAttr("errMsg", e.getMessage());
		}
		
		render("/downapp.jsp");
	}
	
	private static String getJSON(HttpClient client, String url)
			throws IOException, ClientProtocolException {

		HttpGet get = new HttpGet(url);
		HttpResponse response = client.execute(get);
		
		int statusCode = response.getStatusLine().getStatusCode();
		if (statusCode == 200) {
			HttpEntity entity = response.getEntity();
			String content = EntityUtils.toString(entity);

			return content;
		}
		
		return null;
	}
	
	public static String getAppVer(String JSON) {
		Matcher m = Pattern.compile("\"upkVer\": \"(.*)\"").matcher(JSON);
		if (m.find()) {
			String v = m.group(1);
			return v;
		}
		return null;
	}
	
	private static String getAppDownloadURL(String JSON, String appType) {
		String key = null;
		if ("ipa".equals(appType)) {
			key = "upkIpaUrl";
		} else if ("apk".equals(appType)){
			key = "upkApkUrl";
		} else {
			return null;
		}
		
		Matcher m = Pattern.compile("\"" + key + "\": \"(.*)\"").matcher(JSON);
		if (m.find()) {
			String v = m.group(1);
			return v;
		}
		return null;
	}
}
