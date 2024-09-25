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
	String S_Word = request.getParameter("SelDute"); // 예: PUR00
	System.out.println("권한 신청 확인요 : " + S_Word);
	System.out.println("권한 신청 ajax 성공01");
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
			UiCode = RoleSysBaseUI_Rs.getString("UiGroup"); // 예: MM00
			String UiGrp_Sql01 = "SELECT * FROM sys_uigroup WHERE UiGroup = ? AND GroupLevel = 1";
			PreparedStatement UiGrp_Pstmt01 = conn.prepareStatement(UiGrp_Sql01);
			UiGrp_Pstmt01.setString(1, UiCode);
			ResultSet UiGrp_Rs01 = UiGrp_Pstmt01.executeQuery();
			
			while(UiGrp_Rs01.next()){
				String UiGrp_Sql02 = "SELECT * FROM sys_uigroup WHERE UpperGroup = ? AND GroupLevel = 2 ORDER BY UiGroup ASC";
				PreparedStatement UiGrp_Pstmt02 = conn.prepareStatement(UiGrp_Sql02);
				UiGrp_Pstmt02.setString(1, UiCode);
				ResultSet UiGrp_Rs02 = UiGrp_Pstmt02.executeQuery();
				
				JSONArray uiGroupLv2Array = new JSONArray(); 
				
				while(UiGrp_Rs02.next()){
					uiGroupLv2Array.add(UiGrp_Rs02.getString("UiGroupDescrip")); // 예: 구매계획
					Lv2_UpGrp = UiGrp_Rs02.getString("UiGroup"); // 구매계획의 UiGroup -> MMPL00
					
					String UiGrp_Sql03 = "SELECT * FROM sys_uigroup WHERE UpperGroup = ? AND GroupLevel = 3 ORDER BY UiGroup ASC";
					PreparedStatement UiGrp_Pstmt03 = conn.prepareStatement(UiGrp_Sql03);
					UiGrp_Pstmt03.setString(1, Lv2_UpGrp);
					ResultSet UiGrp_Rs03 = UiGrp_Pstmt03.executeQuery();
					
					JSONArray uiGroupLv3Array = new JSONArray();
					while(UiGrp_Rs03.next()){
						uiGroupLv3Array.add(UiGrp_Rs03.getString("UiGroupDescrip"));
						Lv3_UiGrp = UiGrp_Rs03.getString("UiGroup");
						
						String UiGrp_Sql04 = "SELECT * FROM sys_uinum WHERE UiGroup = ?";
						PreparedStatement  UiGrp_Pstmt04 = conn.prepareStatement(UiGrp_Sql04);
						UiGrp_Pstmt04.setString(1, Lv3_UiGrp);
						ResultSet UiGrp_Rs04 = UiGrp_Pstmt04.executeQuery();
						
						JSONArray uiGroupLv4Array = new JSONArray();
						
						while(UiGrp_Rs04.next()){
							uiGroupLv4Array.add(UiGrp_Rs04.getString("UiNumber"));
							System.out.println("UiNumber: " + UiGrp_Rs04.getString("UiNumber"));
							uiGroupLv4Array.add(UiGrp_Rs04.getString("UiDescrip"));	
						}
						jsonObject.put(UiGrp_Rs03.getString("UiGroupDescrip"), uiGroupLv4Array);
						//jsonObject.put("UiGroup4LvList", uiGroupLv4Array);
					}
					jsonObject.put(UiGrp_Rs02.getString("UiGroupDescrip"), uiGroupLv3Array);
					//jsonObject.put("UiGroup3LvList", uiGroupLv3Array);
				}
				jsonObject.put("UiGroup2LvList", uiGroupLv2Array);
			}
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
    if(RoleSysBaseUI_Rs != null) try { RoleSysBaseUI_Rs.close(); } catch(SQLException e) {}
    if(RoleSysBaseUI_Pstmt != null) try { RoleSysBaseUI_Pstmt.close(); } catch(SQLException e) {}
}
%>
