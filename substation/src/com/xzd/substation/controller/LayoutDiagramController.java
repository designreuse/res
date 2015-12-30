package com.xzd.substation.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.sun.el.lang.FunctionMapperImpl.Function;
import com.xzd.substation.common.Status;
import com.xzd.substation.util.DateUtils;
import com.xzd.substation.util.FileUtil;
import com.xzd.substation.util.StringUtil;
import com.xzd.substation.vo.ProjectPicInfoVO;

/**
 * 平面布局图
 * @author Administrator
 *
 */
public class LayoutDiagramController  extends BaseController{
	private final String tableName = "t_project_map";
	private final String primaryKey = "id";
	
	/**
	 * 通过工程Id获取每个用户的轨迹
	 */
     public void getPointByProjectId(){
    	 Long sDate=Long.parseLong(getPara("sDate")); 
    	 Long eDate=Long.parseLong(getPara("eDate"));
    	 String projectId=getPara("project_id");
    	 String userId=getPara("userId");
    	 List<Record>  recs=new ArrayList<Record>();
			Record  uR=null;
			List<Record> oneUserRecs=query("getUserPointsByProjectId", projectId,userId,sDate,eDate);		
			if(oneUserRecs.size()>0){
				uR=new Record();
				//把一个人的记录拼起来
				for(int i=0;i<oneUserRecs.size();i++){
					Record rc=oneUserRecs.get(i);
					if(i==0){
						uR=rc;
					}else{
						uR.set("gps_longitude", uR.get("gps_longitude")+","+rc.getStr("gps_longitude"));
						uR.set("gps_latitude", uR.get("gps_latitude")+","+rc.getStr("gps_latitude"));
						uR.set("act", uR.get("act")+","+rc.getStr("act"));
						uR.set("tid", uR.get("tid")+","+rc.getStr("tid"));
						uR.set("userid", uR.get("userid")+","+rc.getStr("userid"));
					}
				}
				recs.add(uR);
			}
        renderJson(recs);
     }
     
     /**
      * 获取工程图片信息
      */
     public void getProjectPicInfo(){
    	 String projectId=getPara("projectId");
    	 List<Record> records=find(tableName, "project_id", projectId);
    	 if(!records.isEmpty()){
    		 Record rc=records.get(0);
    		 ProjectPicInfoVO vo=new ProjectPicInfoVO();
    		 vo.setName(rc.getStr("lay_image_path"));
    		 //获取图片的真实大小
    		 File picture = new File("d:/upload-files/"+vo.getName());  
			BufferedImage sourceImg;
			try {
				sourceImg = ImageIO.read(new FileInputStream(picture));
				vo.setWidth(Double.valueOf(sourceImg.getWidth()));
				vo.setHeight(Double.valueOf(sourceImg.getHeight()));
				renderJson(vo); 
			} catch (IOException e) {
				e.printStackTrace();
			}
    	 }
     }
     
     /**
      * 获取当前工程下的用户
      */
     public void getUserByProjectId(){
    	 String projectId=getPara("project_id");
    	 List<Record>  list=query("getUserByProjectAndDate", projectId);
    	 renderJson(list);
     }
     /**
      * 通过project_id获取当前工程的地图初始化信息
      */
     public void getInitMapData(){
    	   String project_id=getPara("project_id");
    	   Record record=null;
    	   if(!StringUtil.isBlankOrNull(project_id)){
    		   record=queryOne("getInitMapData", project_id);
    	   }
    	   if(record==null){//如果为空获取默认的数据
    		   record=queryOne("getInitMapData","DEFAULT");
    	   }
    	   renderJson(record);
     }
     
     public void saveOrUpdate(){
    	    Map<String, Object> data=new HashMap<String, Object>();
	     	Map<String,String[]> map=getParaMap();
	     	for(String key:map.keySet()){
	     		data.put(key, map.get(key)[0]);
	     	}
	     	  try {
	        	  if("".equals(data.get(primaryKey))||data.get(primaryKey)==null){
	        		 saveOrUpdate(tableName, primaryKey , data); 
	          	}else{
	          		Record record = new Record();
	          		for (final Map.Entry<String, Object> entry : data.entrySet())
	          		{
	          			record.set(entry.getKey(), entry.getValue());
	          		}
	          		update(tableName, primaryKey , record);
	          	}
	        	  renderJson(new Status(Boolean.TRUE, "操作成功"));
	    	} catch (Exception e) {
	    		e.printStackTrace();
	    		renderJson(new Status(Boolean.FALSE, "操作失败："));
	    	}
     }
     
     public void saveImage(){
    	 try {
    		 UploadFile files =  getFile();
             String  fileName=new Date().getTime()+files.getFileName().substring(files.getFileName().indexOf("."));  //为了防止图片名称重复改用时间戳来命名图片名称
    		 FileUtil.copyFile(files.getSaveDirectory()+"\\"+files.getFileName(), "d:\\upload-files\\"+fileName);
    		 FileUtil.deleteFile(files.getSaveDirectory()+files.getFileName());
    		 //返回上传的图片名称
    		 renderJson(new Status(Boolean.TRUE, fileName));
		} catch (Exception e) {
			e.printStackTrace();
    		renderJson(new Status(Boolean.FALSE, "操作失败："));
		}
     }
     
     /**
      * 通过违章id查询当前违章信息和照片
      */
     public void getViolateInfo(){
    	 String tid=getPara("tid");
		 List<Record> rePage=query("getViolateById", tid);
		 renderJson(rePage);
     }
     
     public static void main(String[] args) {
    	 String date=DateUtils.getCurrDateStr()+" 00:00:00";
    	 System.out.println(DateUtils.getSpecifiedDayAfter(date));
		 try {
			System.out.println(DateUtils.parse(date,DateUtils.formatStr_yyyyMMddHHmmss).getTime());
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
}
