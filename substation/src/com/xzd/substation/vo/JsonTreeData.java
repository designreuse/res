package com.xzd.substation.vo;

import java.util.List;

public class JsonTreeData {
	public String id;       //json id
    public String pid;      //
    public String text;     //json 显示文本
    public String state;    //json 'open','closed'
    public  boolean checked=false;//选中状态 true
    public List<JsonTreeData> children;       //
     
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getText() {
        return text;
    }
    public void setText(String text) {
        this.text = text;
    }
    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }
    public List<JsonTreeData> getChildren() {
        return children;
    }
    public void setChildren(List<JsonTreeData> children) {
        this.children = children;
    }
    public String getPid() {
        return pid;
    }
    public void setPid(String pid) {
        this.pid = pid;
    }
	public boolean isChecked() {
		return checked;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
    
}
