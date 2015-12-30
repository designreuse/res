package org.cqiyi.core;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.cqiyi.permission.model.Permission;
import org.cqiyi.user.model.User;

import cn.dreampie.log.Logger;
import cn.dreampie.security.AuthenticateService;
import cn.dreampie.security.PasswordService;
import cn.dreampie.security.Principal;
import cn.dreampie.security.credential.Credential;

public class MyAuthenticateService extends AuthenticateService {
	private final static Logger logger = Logger.getLogger(MyAuthenticateService.class);

	private static final long serialVersionUID = -849736065388225921L;

	public Principal getPrincipal(String username) {
		User user = User.DAO.findFirstBy("user_name=?", username);
		if (user == null) {
			return null;
		}

		String userId = user.<String> get("id");

		Set<String> permissionCodes = null;
		List<Permission> permissions = Permission.DAO
				.findBy("id in (select permission_id from t_role_permission where role_id in (select role_id from t_user_role where user_id = ?))",
						userId);
		if (permissions != null) {
			permissionCodes = new HashSet<String>();
			for (Permission permission : permissions) {
				permissionCodes.add(permission.<String> get("code"));
			}
		}

		return new Principal<User>(userId, user.<String>get("password"), permissionCodes, user);

	}

	public Set<Credential> getAllCredentials() {
		List<Permission> permissions = Permission.DAO.findBy("rest_apis is not null and code is not null");
		Set<Credential> credentials = new HashSet<Credential>();

		// credentials.add(new Credential("*", "/api/v1.0/session/**",
		// "session"));

		for (Permission permission : permissions) {

			String[] restApis = permission.<String> get("rest_apis").split("\n");
			for (String api : restApis) {
				if (StringUtils.isEmpty(api) || api.indexOf("::") < 0) {
					logger.warn("Permissions format parsing error,Format is: <httpMethod>::<httpUri>，restapi={0}", api);
					continue;
				}
				logger.info("api=" + api + ", code=" + permission.<String> get("code"));
				String[] rest = api.split("::");

				credentials.add(new Credential(rest[0], ApiResource.API_ROOT + rest[1], permission.<String> get("code")));
			}
		}
		return credentials;
	}

	@Override
	public PasswordService getPasswordService() {
		// TODO salt尚未生效
		return Sha256PasswordService.instance();
	}

}
