package com.xzd.substation.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.DocumentHandler;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.IllWordVO;
import com.xzd.substation.vo.ImageVO;
import com.xzd.substation.vo.UserVO;

import freemarker.template.utility.DateUtil;

/**
 * 违章控制器
 */
public class IllegalController extends BaseController
{   
	private static  int bh=1;//编号
    /**
     * 获取全部违章
     */
	public void getAllByPage(){
//	     UserVO userVo=getSessionAttr("user");
		 Integer pageNumber = getParaToInt("pageNumber")==null?1:getParaToInt("pageNumber");
		 Integer pageSize =getParaToInt("pageSize")==null?10:getParaToInt("pageSize"); 
		 String projectId=getPara("projectId");
		 String type=getPara("type");
		 String startDate=getPara("startDate");//起始时间
		 String endDate=getPara("endDate");//结束时间
		 String orgId=getPara("orgId");//组织机构
		 String wzContent=getPara("wzContent").trim();//内容
		 String wzPerson=getPara("wzPerson").trim();//人员
		 String isShowAll=getPara("isShowAll");//全部显示还是只显示提交的数据
		 List<Object> params=new ArrayList<Object>();
		 String sqlText="";
		 if("table".equals(type)){
			   sqlText=getSqlText("getIllegalRecord");
		 }else if("pic".equals(type)){
			 sqlText=getSqlText("getIllegalPic");
		 }
		 
		 //通过条件来拼接sql
		 if(!StringUtil.isBlankOrNull(projectId)){
			 sqlText+=" and  t.project_id =? ";
			 params.add(projectId);
		 }
		 if(!StringUtil.isBlankOrNull(startDate)){
			 sqlText+=" and  t.create_time>=? ";
			 params.add(startDate);
		 }
		 if(!StringUtil.isBlankOrNull(endDate)){
			 sqlText+=" AND t.create_time<=? ";
			 params.add(endDate);
		 }
		 if(!StringUtil.isBlankOrNull(wzContent)){
			 sqlText+="and  t.violate_content LIKE ? ";
			 params.add("%"+wzContent+"%");
		 }
		 if(!StringUtil.isBlankOrNull(orgId)){
			 sqlText+="AND t.orgCode= ? ";
			 params.add(orgId);
		 }
		 if(!StringUtil.isBlankOrNull(wzPerson)){
			 sqlText+="and  t.username LIKE  ? ";
			 params.add("%"+wzPerson+"%");
		 }
		 if(!"submit".equals(isShowAll)){
			 sqlText+="and  t.violate_status='1' ";
		 }
		 // 排序
		 sqlText += " order by create_time desc ";
		 
		 Page<Record> rePage=null;
		 if("table".equals(type)){
			  rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,params.toArray());
		 }else if("pic".equals(type)){
			 rePage=querysSqlTextByPage(pageNumber,pageSize,sqlText,params.toArray());
		 }
		renderJson(rePage);
}
	
	/**
	 * 通过违章id获取违章照片
	 */
	public void getIllPhoneByillId(){
		  String wzId=getPara("wzId");
		  List<Record> phones=query("getIllPhoneByillId", wzId);
		  renderJson(phones);
	}
	
	public void getPicJsp(){
		render("/wzPage/picIndex.jsp");
	}
	
	public void geTableJsp(){
		render("/wzPage/index.jsp");
	}
	
	public void delete(){
		String violateId=getPara("id");
		try {
			//查询`t_violate`表记录。
			List<Record>  tViolate=find("t_violate", "id", violateId);
			//查找t_violation_reson记录然后删除
			for(Record re:tViolate){
				 String voilateCode=re.getStr("voilate_code");
				 List<Record> tViolationReson=find("t_violation_reson", "violate_code", voilateCode);
				 for(Record tres:tViolationReson){
					 delete("t_violation_reson", "id", tres);
				 }
			}
			//查询t_violate_photo记录然后删除
			List<Record>  tViolatePhoto=find("t_violate_photo", "violate_id", violateId);
			for(Record photo:tViolatePhoto){
				 delete("t_violate_photo", "id", photo);
			 }
			
			//查找t_violate_user表记录然后删除
			List<Record>  tViolatePhotoUser=find("t_violate_user", "violate_id", violateId);
			for(Record user:tViolatePhotoUser){
				 delete("t_violate_user", "id", user);
			 }
			
			//删除`t_violate`表记录。
			for(Record violate:tViolate){
				 delete("t_violate", "id", violate);
			 }
			renderJson(new Status(true, "删除成功"));
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(false, "删除成功失败"));
		}
		
	}
	/**
	 * 提交违章信息
	 */
	public void submitIllRecord(){
		String ids=getPara("ids");
		 try {
			 if(!StringUtil.isBlankOrNull(ids)){
				 String[] illIds=ids.split(",");
				 for(String id:illIds){
					 Record re=find("t_violate", "id", id).get(0);
					 re.set("violate_status", "1");
					 update("t_violate", "id",re);
				 }
			 }
			 renderJson(new Status(true, "删除成功"));
		} catch (Exception e) {
			e.printStackTrace();
			renderJson(new Status(false, "删除成功失败"));
		}	
	}
	 /**
	  * 生成违章word文档
	  */
	 public void createWordByIllId(){
		 String illId=getPara("illId");
		 try {
			Map<String, Object> dataMap=new HashMap<String, Object>();
			List<Record>  illVos=query("createIllegalWordById",illId);
			if(!illVos.isEmpty()){
				Record record=illVos.get(0);
				IllWordVO illWordVO=new IllWordVO();
				DecimalFormat df=new DecimalFormat("00000");
				illWordVO.setBh(Calendar.getInstance().get(Calendar.YEAR)+df.format(bh++));
				illWordVO.setDw(record.getStr("org_name"));
				illWordVO.setIllCode(record.getStr("violate_code"));
				illWordVO.setIllContent(record.getStr("violate_content"));
				illWordVO.setFine(String.valueOf(record.getInt("violate_fine")));
				illWordVO.setProName(record.getStr("project_name"));
				String[] time=DateUtils.format(DateUtils.parse(String.valueOf(record.getTimestamp("create_time")), DateUtils.YYYY_MM_DD),DateUtils.YYYY_MM_DD).split("-");
				illWordVO.setPhoneTime(time[0]+"年"+time[1]+"月"+time[2]+"日");
				//查询对应的违章图片
				List<Record> illImages=find("t_violate_photo", "violate_id", illId);
				if(illImages!=null&&illImages.size()>0){
					List<ImageVO> imgStr=new ArrayList<ImageVO>();
					String base64Str;
					for(int i=0;i<illImages.size();i++){
						 String path="d:/upload-files/"+illImages.get(i).getStr("file_path");
						 base64Str=DocumentHandler.getImageByBase64Str(path);
						String whStr=DocumentHandler.getImageWidAndHei(path);
						 if(!StringUtil.isBlankOrNull(base64Str)){
							 imgStr.add(new ImageVO(("image"+i),base64Str,whStr.split(",")[0],whStr.split(",")[1]));					 
						 }
					}
					illWordVO.setImages(imgStr);
				}
				dataMap.put("illWordVO", illWordVO);
			}
			File file=DocumentHandler.createDoc(dataMap, "illInfo.ftl", "违章处罚通知书.doc");//模板名称  和导出的文件名称
//			InputStream ins = new BufferedInputStream(new FileInputStream(file));
//			byte [] buffer = new byte[ins.available()];
//			ins.read(buffer);
//			ins.close();
//			 getResponse().setContentType("application/octet-stream");
//			 getResponse().addHeader("Content-Length", "" + file.length());
//			 getResponse().addHeader("Content-Type", "text/html; charset=utf-8");  
//			 getResponse().addHeader("Content-Disposition", "attachment;filename=" +new String("违章处罚通知书.doc".getBytes("gbk"), "iso8859-1"));
//			 OutputStream ous = new BufferedOutputStream(getResponse().getOutputStream());
//			 ous.write(buffer);
//		     ous.flush();
//		     ous.close();
//		     renderNull();
		     renderFile(file);
		} catch (Exception e) {
			e.printStackTrace();
		}
	 }
}
