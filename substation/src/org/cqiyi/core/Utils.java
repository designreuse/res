package org.cqiyi.core;

import java.util.Random;

import org.apache.commons.lang3.StringUtils;

public class Utils {

	public static String getRandomUUID() {
		String str = java.util.UUID.randomUUID().toString().replaceAll("-", StringUtils.EMPTY);
		return str.toLowerCase();

	}

	public static Random randGen = new Random();
	private static char[] character = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();

	public static final String getRandomString(int length) {
		if (length < 1) {
			throw new IllegalArgumentException("Length must be greater than 0，length=" + length);
		}
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = character[randGen.nextInt(character.length - 1)];
		}
		return new String(randBuffer);
	}

	public static String checkSyntax(String sql) {
		// TODO SQL语法检查，SQL注入检测及处理
		return sql;
	}
}
