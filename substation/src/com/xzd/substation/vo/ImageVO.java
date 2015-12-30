package com.xzd.substation.vo;

/**
 * 生成word对应的图片类
 * 
 * @author Administrator
 *
 */
public class ImageVO {
	private String name;
	private String img;
	private String wid;// 图片的宽度
	private String hei;// 图片的高度

	public ImageVO(String name, String img, String wid, String hei) {
		super();
		this.name = name;
		this.img = img;
		this.wid = wid;
		this.hei = hei;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public String getWid() {
		return wid;
	}

	public void setWid(String wid) {
		this.wid = wid;
	}

	public String getHei() {
		return hei;
	}

	public void setHei(String hei) {
		this.hei = hei;
	}

}
