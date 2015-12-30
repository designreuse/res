package org.cqiyi.core;

import cn.dreampie.common.util.Encryptioner;
import cn.dreampie.security.PasswordService;

public class Sha256PasswordService implements PasswordService {

	private static PasswordService passwordService = new Sha256PasswordService();

	public static PasswordService instance() {
		return passwordService;
	}

	public String hash(String password) {
		return Encryptioner.sha256Encrypt(password);
	}

	public boolean match(String password, String passwordHash) {
		return hash(password).equals(passwordHash);
	}
}
