<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String UiCode = null;
	/* ----------------------------------- */
	String S_Word = request.getParameter("SelDute");
	String RoleSysBaseUI_Sql = "SELECT * FROM sys_dutebasicui WHERE RnRCode = ?";
	PreparedStatement RoleSysBaseUI_Pstmt = conn.prepareStatement(RoleSysBaseUI_Sql);
	RoleSysBaseUI_Pstmt.setString(1, S_Word);
	ResultSet RoleSysBaseUI_Rs = RoleSysBaseUI_Pstmt.executeQuery();
	/* ↑ 직무별시스템기본UI ↑ */
	JSONArray jsonArray = new JSONArray();
	try{
		while(RoleSysBaseUI_Rs.next()){
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("RnRCode", RoleSysBaseUI_Rs.getString("RnRCode"));
			jsonObject.put("RnRDescp", RoleSysBaseUI_Rs.getString("RnRDescp"));
			jsonObject.put("UiGroupDescrip", RoleSysBaseUI_Rs.getString("UiGroupDescrip"));
			UiCode = RoleSysBaseUI_Rs.getString("UiGroup");

			String UiGrp_Sql01 = "SELECT * FROM sys_uigroup WHERE UiGroup = ? AND GroupLevel = 1";
			PreparedStatement UiGrp_Pstmt01 = conn.prepareStatement(UiGrp_Sql01);
			UiGrp_Pstmt01.setString(1, UiCode);
			ResultSet UiGrp_Rs01 = UiGrp_Pstmt01.executeQuery();
			
			while(UiGrp_Rs01.next()){
				String UiGrp_Sql02 = "SELECT * FROM sys_uigroup WHERE UpperGroup = ? AND GroupLevel = 2";
				PreparedStatement UiGrp_Pstmt02 = conn.prepareStatement(UiGrp_Sql02);
				UiGrp_Pstmt02.setString(1, UiCode);
				ResultSet UiGrp_Rs02 = UiGrp_Pstmt02.executeQuery();
				
				JSONArray uiGroupDescripArray = new JSONArray(); 
				
				while(UiGrp_Rs02.next()){
					uiGroupDescripArray.add(UiGrp_Rs02.getString("UiGroupDescrip"));
				}
				jsonObject.put("UiGroupDescripList", uiGroupDescripArray);
			}
		}	
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(RoleSysBaseUI_Rs != null) try { RoleSysBaseUI_Rs.close(); } catch(SQLException e) {}
    if(RoleSysBaseUI_Pstmt != null) try { RoleSysBaseUI_Pstmt.close(); } catch(SQLException e) {}
}
%>
