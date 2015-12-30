package org.cqiyi.user;

import java.io.File;
import java.util.Date;

import org.cqiyi.core.UUIDFileRenamer;
import org.cqiyi.user.model.User;
import org.cqiyi.user.partial.PartialUserResource;

import cn.dreampie.common.http.UploadedFile;
import cn.dreampie.common.util.Encryptioner;
import cn.dreampie.route.core.annotation.GET;
import cn.dreampie.route.core.annotation.POST;
import cn.dreampie.route.core.multipart.FILE;

/**
 * 
 * <strong>REST API，[t_user]人员表：包括系统登录的用户，以及刷卡的人员信息</strong><br/>
 * <br/>
 * 
 */
public class UserResource extends PartialUserResource {

	@GET("/set/{password}")
	public boolean resetAllPassword(String password) {
		String hashedPassword = Encryptioner.sha256Encrypt(password);
		System.out.println("REST ALL USER PASSWORD:" + password + ", hashed length=" + hashedPassword.length());
		return User.DAO.updateColsAll("password, update_time", hashedPassword, new Date());
	}

	@GET("/{id}/photo")
	public File downloadPhoto(String id) {
		User user = User.DAO.findById(id);
		return new File(UPLOAD_DIRECTORY + user.<String> get("photo"));
	}

	@POST("/{id}/photo")
	@FILE(renamer = UUIDFileRenamer.class)
	public UploadedFile uploadPhoto(String id, UploadedFile file) {
		User user = User.DAO.findById(id);
		user.set("photo", file.getFileName());
		user.update();
		return file;
	}

	@POST("/cpwd/{userId}")
	public String changePassword(String userId, String password) {
		// TODO [完成] 修改密码，未完成
		String hashedPassword = Encryptioner.sha256Encrypt(password);
		return User.DAO.updateColsBy("password, update_time", "id = ?", hashedPassword,new Date(),userId)?"CHANGE SUCCESS":"CHANGE FAIL";
	}

}
