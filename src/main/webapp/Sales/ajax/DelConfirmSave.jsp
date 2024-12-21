<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.YearMonth"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	
	// 변수모음
	String UserId = (String)session.getAttribute("id");
	String firstValue = null;
	boolean allSame = true; // 모든 값이 같은지 확인할 변수
	LocalDateTime today = LocalDateTime.now();
	
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
	DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyyMMdd");
	String Time = today.format(formatter);
	String DateSplit = today.format(formatter2);
	
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }

	JSONArray saveListData = new JSONArray(jsonString.toString());
	JSONObject DataList = null;

	System.out.println(Time);
	try{
		
		String HeadUp_Sql = "UPDATE sales_delrequestcmdheader SET DelivConfirmDate = ? WHERE KeyValue = ?";
		String LineUp_Sql = "UPDATE sales_delrequestcmdline SET DelivConfirmDate = ? WHERE KeyValue = ?";
		
		String Line_Search_Sql01 = "SELECT * FROM sales_delrequestcmdline WHERE KeyValue = ?";
		String SOS_UP_Sql = "UPDATE sales_ordstatus SET PlanDelivSumQty = ?, DelivOrdSumQty = ? WHERE CustOrdNum = ? AND MatCode = ?";
		
		PreparedStatement Head_Pstmt = conn.prepareStatement(HeadUp_Sql);
		PreparedStatement Line_Pstmt = conn.prepareStatement(LineUp_Sql);

		PreparedStatement Line_Search_Pstmt01 = conn.prepareStatement(Line_Search_Sql01);
		ResultSet rs01 = null;
		
		Head_Pstmt.setString(1, saveListData.getJSONArray(1).getString(0) + " " +  Time); // 반출일자
		Head_Pstmt.setString(2, saveListData.getJSONArray(1).getString(1) + saveListData.getJSONArray(1).getString(2)); // 납품번호
		System.out.println(saveListData.getJSONArray(1).getString(0) + Time);
		System.out.println(saveListData.getJSONArray(1).getString(1) + saveListData.getJSONArray(1).getString(2));
		
		for(int i = 0 ; i < saveListData.getJSONArray(0).length() ; i++){
			Line_Pstmt.setString(1, saveListData.getJSONArray(1).getString(0)); // 항번
			Line_Pstmt.setString(2, saveListData.getJSONArray(0).getString(i)); // 품번
				
			System.out.println(saveListData.getJSONArray(1).getString(0));
			System.out.println(saveListData.getJSONArray(0).getString(i));
			
  			Line_Pstmt.executeUpdate();
  			
  			Line_Search_Pstmt01.setString(1, saveListData.getJSONArray(0).getString(i));
  			rs01 = Line_Search_Pstmt01.executeQuery();
  			if(rs01.next()){
  				String ConFirmOrdNum = rs01.getString("SalesOrdNum");
  				String MatCode = rs01.getString("MatCode");
  				String Line_Search_Sql02 = "SELECT * FROM sales_delplanline WHERE SalesOrdNum = ? AND MatCode = ?";
  				
  				PreparedStatement Line_Search_Pstmt02 = conn.prepareStatement(Line_Search_Sql02);
  				Line_Search_Pstmt02.setString(1, ConFirmOrdNum);
  				Line_Search_Pstmt02.setString(2, MatCode);
  				ResultSet rs02 = Line_Search_Pstmt02.executeQuery();
  				if(rs02.next()){
  					String CustOrdNum = rs02.getString("CustOrdNum");
  					
  					String SOS_Search_Sql = "SELECT * FROM sales_ordstatus WHERE CustOrdNum = ? AND MatCode = ?";
  					PreparedStatement SOS_Pstmt = conn.prepareStatement(SOS_Search_Sql);
  					SOS_Pstmt.setString(1, CustOrdNum);
  					SOS_Pstmt.setString(2, MatCode);
  					ResultSet SOS_rs = SOS_Pstmt.executeQuery();
  					if(SOS_rs.next()){
	 	   				int PlanningData = SOS_rs.getInt("PlanDelivSumQty"); // 저장된 납품계획수량
	 	   				int OrdSumData = SOS_rs.getInt("DelivOrdSumQty") + PlanningData;
	 	   				int Reset = 0;
	 	   				
	 	   				PreparedStatement SOS_Up_Pstmt = conn.prepareStatement(SOS_UP_Sql);
	 	   				SOS_Up_Pstmt.setInt(1, Reset);
	 	   				SOS_Up_Pstmt.setInt(2, OrdSumData);
	 	   				SOS_Up_Pstmt.setString(3, CustOrdNum);
	 	   				SOS_Up_Pstmt.setString(4, MatCode);
	 	   				
	 	   				SOS_Up_Pstmt.executeUpdate();
  					}
  				}
  			}
  			
		}
		Head_Pstmt.executeUpdate();
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(SQLException e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>
