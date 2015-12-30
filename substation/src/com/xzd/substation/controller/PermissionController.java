package com.xzd.substation.controller;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Constant;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.MenuVO;
import com.xzd.substation.vo.UserVO;

/**
 * 权限控制
 * @author LYC
 *
 */
public class PermissionController extends BaseController{
    
	
	/**
	 * 通过用户来获取其有权限的菜单
	 * @return
	 */
	public void  getMenu(){
		List<MenuVO>  menuList=new ArrayList<MenuVO>();
		UserVO userVo=getSessionAttr("user");
		List<Record>  menu=query("getMenuByUserId", userVo.getUserId(),"f4b2eead61ba11e5b26c0050568173ac");
		int i=0;
		if(menu!=null&&menu.size()>0){
			for(Record r:menu){
				MenuVO vo=new MenuVO();
				vo.setId(r.getStr("ID"));
				vo.setCode(r.getStr("CODE"));
				vo.setName(r.getStr("NAME"));
				String uri="";
				if(!StringUtil.isBlankOrNull(r.getStr("NAVIGATE_URI"))){
					uri=r.getStr("NAVIGATE_URI")+"?menu_id="+r.getStr("ID");
				}
				vo.setUrl(uri);
				vo.setPid(r.getStr("PARENT_ID"));
				vo.setIco(r.getStr("ICO"));
				if(i==0) vo.setActive("active");
				i++;
				menuList.add(vo);
			}
		}
		//查询二级菜单
		for(MenuVO muVo:menuList){
			List<Record>  menuChildren=query("getMenuByUserId", userVo.getUserId(),muVo.getId());
			if(menuChildren!=null&&menuChildren.size()>0){
				for(Record rc:menuChildren){
					MenuVO voChildren=new MenuVO();
					voChildren.setId(rc.getStr("ID"));
					voChildren.setCode(rc.getStr("CODE"));
					voChildren.setName(rc.getStr("NAME"));
					String uri="";
					if(!StringUtil.isBlankOrNull(rc.getStr("NAVIGATE_URI"))){
						uri=rc.getStr("NAVIGATE_URI")+"?menu_id="+rc.getStr("ID");
					}
					voChildren.setUrl(uri);
					voChildren.setPid(rc.getStr("PARENT_ID"));
					voChildren.setIco(rc.getStr("ICO"));
					muVo.getChildren().add(voChildren);
				}
			}
		}
		setAttr("menuList", menuList);//菜单
		//从参数配置里边获取公司名称以及版本号等信息
		setAttr("company", getParamValueByName("Company"));
		setAttr("version", getParamValueByName("Version"));
		render(Constant.MAIN_PAGE);
	}
	/**
	 * 获取当前用户可访问的工程
	 */
	public void getProjectByUser(){
		UserVO userVo=getSessionAttr("user");
		String userId=userVo.getUserId();
		List<Record>  project=new ArrayList<Record>();;
		if(userVo.getRoleCodes()!=null&&userVo.getRoleCodes().contains("pro_admin")){
			project=query("getAllProject");
		}else{
			project=query("getProjectByUser", userId);
		}
		 
		renderJson(project);
	}
	
	/**
	 * 通过菜单id和当前登录用户获取页面的增删改权限
	 * 
	 * create 拥有增加权限
	 * 
	 * delete 拥有删除权限
	 * 
	 * update 拥有更新权限
	 */
	public void getPagePermByMenu(){
		UserVO userVo=getSessionAttr("user");
		String menu_id=getPara("menu_id");
		List<Record>  pagePerm=new ArrayList<Record>();
		if(!StringUtil.isBlankOrNull(menu_id)){//获取权限
			  pagePerm=query("getCRDPermission", menu_id,userVo.getUserId());
		}
		renderJson(pagePerm);
	}
	
	
}
