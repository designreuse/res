package com.xzd.substation.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.jfinal.plugin.activerecord.Record;


public class ParamUtil
{
	/**
	 * 将String参数转换为Map<String,String>
	 *
	 * @param templateData
	 *           String参数
	 * @return Map<String,String>
	 */
	public static Map<String, String> convertStringParamToMapParam(final String templateData)
	{

		final Map<String, String> paramMap = new LinkedHashMap<String, String>();
		final String paramString[] = templateData.split("&");
		for (int i = 0; i < paramString.length; i++)
		{
			String[] temp = paramString[i].split("=");
			//对于不规范的数据，做预处理
			if (temp.length == 1)
			{
				final String[] temp2 = new String[]
				{ temp[0], "" };
				temp = temp2;
			}
			temp[1] = temp[1].replace("+", " ");
			if (paramMap.get(temp[0]) == null)
			{
				paramMap.put(temp[0], temp[1]);
			}
			else
			{
				final String tempValue = paramMap.get(temp[0]);
				paramMap.put(temp[0], tempValue + "," + temp[1]);
			}
		}
		return paramMap;
	}
	
	public static Map<String, Object> convertMap(Map<String, String[]> sourceMap){
		Map<String, Object> map = new HashMap<String, Object>();
		for(Map.Entry<String, String[]> source : sourceMap.entrySet()){
			map.put(source.getKey(), source.getValue()[0]);
		}
		return map;
		
	}
	
	public static Record convertRecord(Map<String , Object> dataMap){
		Record record = new Record();
		for(Map.Entry<String, Object> map : dataMap.entrySet()){
			record.set(map.getKey(), map.getValue());
		}
		return record;
	}

	public static Map<String, Object> removeMapElement(final Map<String, Object> map, final String key)
	{
		final Iterator<Map.Entry<String, Object>> it = map.entrySet().iterator();
		while (it.hasNext())
		{
			final Map.Entry<String, Object> entry = it.next();
			final String tempKey = entry.getKey();
			if (key.equals(tempKey))
			{
				it.remove();
			}
		}
		return map;
	}
	
	public static Map<String, String> removeMapElement2(final Map<String, String> map, final String key)
	{
		final Iterator<Map.Entry<String, String>> it = map.entrySet().iterator();
		while (it.hasNext())
		{
			final Map.Entry<String, String> entry = it.next();
			final String tempKey = entry.getKey();
			if (key.equals(tempKey))
			{
				it.remove();
			}
		}
		return map;
	}

	public static String translateByRegex(final String regex, final String source)
	{
		final Pattern pattern = Pattern.compile(regex);
		final Matcher matcher = pattern.matcher(source);
		if (matcher.find())
		{
			return matcher.group();
		}
		return "";
	}

	public static boolean isEmpty(final Object obj)
	{
		return obj == null || "".equals(obj.toString().trim());
	}

	public static boolean isNotEmpty(final Object obj)
	{
		return !isEmpty(obj);
	}

	public static String replaceBlank(final String source)
	{
		String dest = "";
		if (source != null)
		{
			final Pattern p = Pattern.compile("\\s*|\t|\r|\n");
			final Matcher m = p.matcher(source);
			dest = m.replaceAll("");
		}
		return dest;
	}

	public static String replaceSingleQuotes(final String source)
	{
		return source.replaceAll("'", "");
	}

	public static boolean isAllEmpty(final List<String> data)
	{
		for (int i = 0; i < data.size(); i++)
		{
			final boolean isEmpty = isEmpty(data.get(i));
			if (!isEmpty)
			{
				return false;
			}
		}
		return true;
	}

	/**
	 * 指定长度的字符串
	 * 
	 * @param length
	 * @return ID
	 */
	public static String randomString(final int length)
	{ //length表示生成字符串的长度  
		final String base = "abcdefghijklmnopqrstuvwxyz0123456789";
		final Random random = new Random();
		final StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++)
		{
			final int number = random.nextInt(base.length());
			sb.append(base.charAt(number));
		}
		return sb.toString();
	}

	/**
	 * 指定长度的数字串
	 * 
	 * @param strLength
	 * @return ID
	 */
	public static long randomNumber(final int strLength)
	{
		final Random rm = new Random();
		// 获得随机数  
		final double pross = (1 + rm.nextDouble()) * Math.pow(10, strLength);
		System.out.println(pross);
		// 将获得的获得随机数转化为字符串  
		final String fixLenthString = String.valueOf(pross);
		System.out.println(fixLenthString);
		// 返回固定的长度的随机数  
		return Long.parseLong(fixLenthString.substring(2, strLength + 2));
	}

	public static void main(final String[] args)
	{
		System.out.println(randomString(32));
	}
}
