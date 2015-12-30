<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import="java.sql.*,java.util.*,java.io.*" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>文件预览</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<%
   out.clear();
   out = pageContext.pushBody();
   response.setContentType("image/jpeg");//设置显示文件或图片的格式如:application/pdf
 
   try {
   String imgName = request.getParameter("fileName");
    if(imgName.contains("?")){
    	imgName=imgName.substring(0, imgName.indexOf("?"));
    }
    String imgPath= "d://upload-files/"+imgName;
     
    //判断该路径下的文件是否存在
    File file = new File(imgPath);
    if (file.exists()&& !imgName.equals("")) {
     DataOutputStream temps = new DataOutputStream(response
       .getOutputStream());
     DataInputStream in = new DataInputStream(
       new FileInputStream(imgPath));
 
     byte[] b = new byte[2048];
     while ((in.read(b)) != -1) {
      temps.write(b);
      temps.flush();
     }
 
     in.close();
     temps.close();
    }
   } catch (Exception e) {
    out.println(e.getMessage());
   }
%>
<head>
</head>
<body>
</body>
</html>
