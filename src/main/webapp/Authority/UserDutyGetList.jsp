<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String UiCode = null;
	String Lv2_UpGrp = null;
	String Lv3_UiGrp = null;
	/* ----------------------------------- */
	String S_Word = request.getParameter("ID"); // 예: PUR00
	String USerRoleSearch_Sql = "SELECT * FROM dataadminkeytable WHERE UseriD = ?";
	PreparedStatement USerRoleSearch_Pstmt = conn.prepareStatement(USerRoleSearch_Sql);
	USerRoleSearch_Pstmt.setString(1, S_Word);
	ResultSet USerRoleSearch_Rs = USerRoleSearch_Pstmt.executeQuery();
	/* ↑ 직무별시스템기본UI ↑ */
	JSONArray jsonArray = new JSONArray();
	try{
		while(USerRoleSearch_Rs.next()){
			JSONArray UserDutyArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();
			
			UserDutyArray.add(USerRoleSearch_Rs.getString("UiNumber"));
			UserDutyArray.add(USerRoleSearch_Rs.getString("UiAuthority"));
			UserDutyArray.add(USerRoleSearch_Rs.getString("UiDescrip"));
			
			jsonObject.put(USerRoleSearch_Rs.getString("RnRCode"), UserDutyArray);
			jsonArray.add(jsonObject);
		}
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    PrintWriter jsonOut = response.getWriter();
	    jsonOut.print(jsonArray.toString()); // JSON 배열을 클라이언트에 전송
	    jsonOut.flush();
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(USerRoleSearch_Rs != null) try { USerRoleSearch_Rs.close(); } catch(SQLException e) {}
    if(USerRoleSearch_Pstmt != null) try { USerRoleSearch_Pstmt.close(); } catch(SQLException e) {}
}
%>
