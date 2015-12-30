package com.xzd.substation.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.jfinal.kit.StrKit;


/**
 * StringUtil 继承自StrKit
 */
public class StringUtil extends StrKit
{
	private final static String[] hexDigits =
	{ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };

	/**
	 * 将字节数组转换为16进制的字符串
	 *
	 * @param byteArray
	 *           字节数组
	 * @return 16进制的字符串
	 */
	private static String byteArrayToHexString(final byte[] byteArray)
	{
		final StringBuffer sb = new StringBuffer();
		for (final byte byt : byteArray)
		{
			sb.append(byteToHexString(byt));
		}
		return sb.toString();
	}

	/**
	 * 将字节转换为16进制字符串
	 *
	 * @param byt
	 *           字节
	 * @return 16进制字符串
	 */
	private static String byteToHexString(final byte byt)
	{
		int n = byt;
		if (n < 0)
		{
			n = 256 + n;
		}
		return hexDigits[n / 16] + hexDigits[n % 16];
	}

	/**
	 * 将摘要信息转换为相应的编码
	 *
	 * @param code
	 *           编码类型
	 * @param message
	 *           摘要信息
	 * @return 相应的编码字符串
	 */
	private static String Encode(final String code, final String message)
	{
		MessageDigest md;
		String encode = null;
		try
		{
			md = MessageDigest.getInstance(code);
			encode = byteArrayToHexString(md.digest(message.getBytes()));
		}
		catch (final NoSuchAlgorithmException e)
		{
			e.printStackTrace();
		}
		return encode;
	}

	/**
	 * 将摘要信息转换成MD5编码
	 *
	 * @param message
	 *           摘要信息
	 * @return MD5编码之后的字符串
	 */
	public static String md5Encode(final String message)
	{
		return Encode("MD5", message);
	}

	/**
	 * 将摘要信息转换成SHA编码
	 *
	 * @param message
	 *           摘要信息
	 * @return SHA编码之后的字符串
	 */
	public static String shaEncode(final String message)
	{
		return Encode("SHA", message);
	}

	/**
	 * 将摘要信息转换成SHA-256编码
	 *
	 * @param message
	 *           摘要信息
	 * @return SHA-256编码之后的字符串
	 */
	public static String sha256Encode(final String message)
	{
		return Encode("SHA-256", message);
	}

	/**
	 * 将摘要信息转换成SHA-512编码
	 *
	 * @param message
	 *           摘要信息
	 * @return SHA-512编码之后的字符串
	 */
	public String sha512Encode(final String message)
	{
		return Encode("SHA-512", message);
	}

	/**
	 * @param message
	 * @return SHA-512编码之后的字符串
	 */
	public static String SHA256Encode(final String message)
	{
		final String sha256Encode = sha256Encode(message);
		/*
		 * System.out.println(sha256Encode); return sha256Encode(sha256Encode);
		 */
		return sha256Encode;
	}


	/**
	 * 输入指定字串返回非空字符
	 *
	 * @param str
	 *           指定字串
	 * @return 返回类型 String 返回非空字符
	 *
	 */
	public static String requote(String str)
	{
		if (str == null)
		{
			str = "";
		}
		if ("null".equalsIgnoreCase(str))
		{
			str = "";
		}
		return str;
	}

	/**
	 * 非空返回false
	 *
	 * @Title: @Description: TODO @param @param str @param @return @return 返回类型 @throws
	 */
	public static boolean isBlankOrNull(final String str)
	{
		return "".equals(requote(str)) ? true : false;
	}

	public static void main(final String[] args)
	{
		System.out.println(SHA256Encode("admin"));
	}
}
