package com.xzd.substation.vo;

import java.io.Serializable;


public class UserVO implements Serializable
{
	private static final long serialVersionUID = 1L;
	private String userId;
	private String userName;
	private String loginName;
	private String celphone;
	private String email;
	private String roleCodes;
	private String roleNames;

	public UserVO()
	{
	}

	public UserVO(final String userId, final String userName, final String loginName, final String celphone, final String email, final String roleCodes, final String roleNames)
	{
		super();
		this.userId = userId;
		this.userName = userName;
		this.loginName = loginName;
		this.celphone = celphone;
		this.email = email;
		this.roleCodes = roleCodes;
		this.roleNames = roleNames;
	}

	public String getUserId()
	{
		return userId;
	}

	public void setUserId(final String userId)
	{
		this.userId = userId;
	}

	public String getUserName()
	{
		return userName;
	}

	public void setUserName(final String userName)
	{
		this.userName = userName;
	}
    
	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public String getCelphone()
	{
		return celphone;
	}

	public void setCelphone(final String celphone)
	{
		this.celphone = celphone;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(final String email)
	{
		this.email = email;
	}
    
	public String getRoleCodes() {
		return roleCodes;
	}

	public void setRoleCodes(String roleCodes) {
		this.roleCodes = roleCodes;
	}

	public String getRoleNames() {
		return roleNames;
	}

	public void setRoleNames(String roleNames) {
		this.roleNames = roleNames;
	}

	@Override
	public String toString()
	{
		return "UserVO [userId=" + userId + ", userName=" + userName + ", celphone=" + celphone + ", email=" + email + "]";
	}
}
