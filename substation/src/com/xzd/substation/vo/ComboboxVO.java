package com.xzd.substation.vo;

import java.util.Map;

public class ComboboxVO {
	private String id;
    private String text;
    private Map<String, Object> attribute;

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

    public Map<String, Object> getAttribute() {
        return attribute;
    }

    public void setAttribute(Map<String, Object> attribute) {
        this.attribute = attribute;
    }

    @Override
    public String toString() {
        return "ComboboxPO{" + "id=" + id + ", text=" + text + ", attribute=" + attribute + '}';
    }
}
