package com.xzd.substation.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.xzd.substation.common.Constant;

public class FileUtil {

	public static String filePath = "" ; 
	
	public static void setFilePath(){
		Record record = Db.findById("T_PARAMETER", "ID", Constant.UPLOAD_ID);
		filePath = record.getStr("PARAM_VALUE");
	}
	
	public static String getFilePath(){
		if(ParamUtil.isEmpty(filePath)){
			setFilePath();
		}
		return filePath ; 
	}
	
	public static File getFileByName(String fileName){
		File file = new File(getFilePath()+fileName);
		return file ; 
	}
	
	public static InputStream getFileInputStreamByFile(File file){
		try {
			return new FileInputStream(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static InputStream getFileInputStreamByName(String fileName){
		File file = getFileByName(fileName);
		return getFileInputStreamByFile(file);
	}
	/**
	 * 删除文件夹
	 * 
	 * @param folderPath
	 *            文件夹路径及名称 如c:/fqf
	 * @throws GlobalException 
	 * 
	 */
	public static void delFolder(String folderPath) throws Exception {
		try {
			delAllFile(folderPath); // 删除完里面所有内容
			String filePath = folderPath;
			filePath = filePath.toString();
			java.io.File myFilePath = new java.io.File(filePath);
			myFilePath.delete(); // 删除空文件夹

		} catch (Exception e) {
			//e.printStackTrace();
			throw new Exception("" + e.getMessage());
		}

	}
	
	/**
	 * 删除文件夹里面的所有文件
	 * 
	 * @param path
	 *            文件夹路径 如 c:/fqf
	 * @throws GlobalException 
	 * 
	 */
	public static void delAllFile(String path) throws Exception {
		File file = new File(path);
		if (!file.exists()) {
			return;
		}
		if (!file.isDirectory()) {
			return;
		}
		String[] tempList = file.list();
		File temp = null;
		for (int i = 0; i < tempList.length; i++) {
			if (path.endsWith(File.separator)) {
				temp = new File(path + tempList[i]);
			} else {
				temp = new File(path + File.separator + tempList[i]);
			}
			if (temp.isFile()) {
				temp.delete();
			}
			if (temp.isDirectory()) {
				delAllFile(path + "/" + tempList[i]);// 先删除文件夹里面的文件
				delFolder(path + "/" + tempList[i]);// 再删除空文件夹
			}
		}
	}
	 
	/**
	 * 文件复制
	 * @param oldPath
	 * @param newPath
	 */
	 public static void copyFile(String oldPath, String newPath) {  
	        try {  
	            int bytesum = 0;  
	            int byteread = 0;  
	            File oldfile = new File(oldPath);  
	            if (oldfile.exists()) { // 文件存在时  
	                InputStream inStream = new FileInputStream(oldPath); // 读入原文件  
	                FileOutputStream fs = new FileOutputStream(newPath);  
	                byte[] buffer = new byte[1444];  
	                while ((byteread = inStream.read(buffer)) != -1) {  
	                    bytesum += byteread; // 字节数 文件大小  
	                    fs.write(buffer, 0, byteread);  
	                }  
	                inStream.close();  
	            }  
	        } catch (Exception e) {  
	            e.printStackTrace();  
	        }  
	    }
	 
	// 删除文件  
	    public static boolean deleteFile(String filePath) {  
	        boolean flag = false;  
	        File file = new File(filePath);  
	        // 路径为文件且不为空则进行删除  
	        if (file.isFile() && file.exists()) {  
	            file.delete();  
	            flag = true;  
	        }  
	        return flag;  
	    }
}
