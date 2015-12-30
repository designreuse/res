package com.xzd.substation.vo;

import java.util.List;

/**
 * 生成违章word对应的VO
 * @author Administrator
 *
 */
public class IllWordVO {
       private String bh;//编号
       private String dw;//单位
       private String  phoneTime;//拍摄时间
       private String proName;//工程名称
       private String illContent;//违章内容
       private String illCode;//违章编码
       private String fine;//违章罚款
       private  List<ImageVO> images;//违章照片
	public String getBh() {
		return bh;
	}
	public void setBh(String bh) {
		this.bh = bh;
	}
	public String getDw() {
		return dw;
	}
	public void setDw(String dw) {
		this.dw = dw;
	}
	public String getPhoneTime() {
		return phoneTime;
	}
	public void setPhoneTime(String phoneTime) {
		this.phoneTime = phoneTime;
	}
	public String getProName() {
		return proName;
	}
	public void setProName(String proName) {
		this.proName = proName;
	}
	public String getIllContent() {
		return illContent;
	}
	public void setIllContent(String illContent) {
		this.illContent = illContent;
	}
	public String getIllCode() {
		return illCode;
	}
	public void setIllCode(String illCode) {
		this.illCode = illCode;
	}
	public String getFine() {
		return fine;
	}
	public void setFine(String fine) {
		this.fine = fine;
	}
	public List<ImageVO> getImages() {
		return images;
	}
	public void setImages(List<ImageVO> images) {
		this.images = images;
	}
    
       
}
