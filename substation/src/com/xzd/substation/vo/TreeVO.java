package com.xzd.substation.vo;

import java.util.List;
import java.util.Map;

/**
 *
 * @author LYY
 */
public class TreeVO {

    private String id;
    private String text;
    private String state;
    private String iconCls;
    private boolean checked;
    private Map<String, String> attributes;
    private List<TreeVO> children;

    public TreeVO() {
    }

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

    public String getIconCls() {
        return iconCls;
    }

    public void setIconCls(String iconCls) {
        this.iconCls = iconCls;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public Map<String, String> getAttributes() {
        return attributes;
    }

    public void setAttributes(Map<String, String> attributes) {
        this.attributes = attributes;
    }

    public List<TreeVO> getChildren() {
        return children;
    }

    public void setChildren(List<TreeVO> children) {
        this.children = children;
    }

    @Override
    public String toString() {
        return "TreePO{" + "id=" + id + ", text=" + text + ", state=" + state + ", iconCls=" + iconCls + ", checked=" + checked + ", attributes=" + attributes + ", children=" + children + '}';
    }
}