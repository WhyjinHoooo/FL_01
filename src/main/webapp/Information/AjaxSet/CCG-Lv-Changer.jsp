<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try {
    String Level = request.getParameter("Level");
    String Code = request.getParameter("Company");
    int CCG_Lv = 0;
    
    if (Level != null && !Level.isEmpty()) {
    	CCG_Lv = Integer.parseInt(Level);
    }
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    JSONArray array=new JSONArray();
    
    if(CCG_Lv == 0){
    	JSONObject obj=new JSONObject();
    	obj.put("CCGroup","nothing"); // Check this line
    	obj.put("CCG_Name","nothing"); // Add this line for BAGroup
    	array.add(obj);
    } else{
        String sql = "SELECT * FROM bizareagroup WHERE ComCode = ? AND BAGLevel = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, Code);
    	pstmt.setInt(2, CCG_Lv-1);
    	rs = pstmt.executeQuery();	
		while(rs.next()){
			JSONObject obj=new JSONObject();
			obj.put("BAGroup",rs.getString("BAGroup")); // Check this line
			obj.put("BAG_Name",rs.getString("BAG_Name"));
			array.add(obj);   
 		}
    }
	out.print(array.toString());
} catch(SQLException | NumberFormatException e){
   e.printStackTrace();
}
%>
