package com.xzd.substation.util;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import com.xzd.substation.vo.TestWord;

import Decoder.BASE64Encoder;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * Word文档生成
 * 
 * @author Administrator
 *
 */
public class DocumentHandler {
	private static Configuration configuration = null;

	static {
		configuration = new Configuration();
		configuration.setClassicCompatible(true);// 空值处理
		configuration.setDefaultEncoding("utf-8");
	}

	/**
	 * 
	 * @param dataMap
	 *            要填入模本的数据文件
	 * @param templateName
	 *            模板的名称
	 * @param fileName
	 *            文件要保存的名称 
	 * @throws UnsupportedEncodingException
	 */
	public static File createDoc(Map<String, Object> dataMap, String templateName, String fileName)
			throws UnsupportedEncodingException {
		Template t = null;
		File outFile=null;
		try {
			String basePath= DocumentHandler.class.getClassLoader().getResource("").getPath();  
		    int end = basePath.length() - "WEB-INF/classes/".length();  
		    basePath = basePath.substring(1, end);  
			configuration.setDirectoryForTemplateLoading(new File(basePath+"/template"));
			// test.ftl为要装载的模板
			t = configuration.getTemplate(templateName);
			outFile = new File(basePath+"/createWord/"+fileName);
			Writer out = null;
			FileOutputStream fos = null;
			fos = new FileOutputStream(outFile);
			OutputStreamWriter oWriter = new OutputStreamWriter(fos, "UTF-8");
			out = new BufferedWriter(oWriter);
			t.process(dataMap, out);
			out.close();
			fos.close();
		} catch (TemplateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("-----------Word输出完成----------------");
		return outFile;
	}
	
	/**
	 * 生成一张图片的Base64编码字符串
	 * @param imgFile
	 * @return
	 */
	public static String getImageByBase64Str(String imgFile) {
        InputStream in = null;
        byte[] data = null;
        try {
        	File file=new File(imgFile);
        	if(!file.exists()){
        		return "";
        	}
            in = new FileInputStream(file);
            data = new byte[in.available()];
            in.read(data);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);
    }
	
	/**
	 * 获取图片的长和宽
	 * @param imgFile
	 * @return
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 */
	public static String getImageWidAndHei(String imgFile) throws FileNotFoundException, IOException{
		String width="0",heigth="0";
		File picture = new File(imgFile);  
		BufferedImage sourceImg =ImageIO.read(new FileInputStream(picture));
		width=String.valueOf(sourceImg.getWidth());
		heigth=String.valueOf(sourceImg.getHeight());
		return width+","+heigth;
		
	}
	
	public static void main(String[] args) {
//		Map<String, Object> dataMap=new HashMap<String, Object>();
//		dataMap.put("name", "刘永超");
//		dataMap.put("age", 26);
//		List<TestWord> userList=new ArrayList<>();
//		TestWord tw=new TestWord();
//		tw.setId("1");
//		tw.setName("刘永超");
//		tw.setAge("26");
//		tw.setSex("男");
//		TestWord tw1=new TestWord();
//		tw1.setId("1-1");
//		tw1.setName("刘永超-1");
//		tw1.setAge("26-1");
//		tw1.setSex("男-1");
//		userList.add(tw);
//		userList.add(tw1);
//		//生成表格
//		dataMap.put("rows", userList);
//		//生成图片
//		dataMap.put("images", getImageByBase64Str("d:/test.jpg"));
//		try {
//			File file=DocumentHandler.createDoc(dataMap, "test.ftl", "test.doc");
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
		String path = DocumentHandler.class.getClassLoader().getResource("").getPath();  
	    int end = path.length() - "WEB-INF/classes/".length();  
	    path = path.substring(1, end);  
	    System.out.println(path);
	}
}
