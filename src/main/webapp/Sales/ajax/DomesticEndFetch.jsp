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
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }
	JSONArray saveListData = new JSONArray(jsonString.toString());
	// 배열 값 가져오기
    String UCom = saveListData.getString(0);
    String UBizArea = saveListData.getString(1);
    String DealCom = saveListData.getString(2);
    String StartDateValue = saveListData.getString(3);
    String EndDateValue = saveListData.getString(4);
    String TP = null;
    
	System.out.println(UCom);
	System.out.println(UBizArea);
	System.out.println(DealCom);
	System.out.println(StartDateValue);
	System.out.println(EndDateValue);
	
	try{
	    String DPL_Sql01 = "SELECT *"+
	               "FROM project.sales_delrequestcmdline "+
	               "WHERE DATE(DispatureDate) >= ? "+
	               "AND DATE(DispatureDate) <= ? "+
	               "AND TradingPartner = ? "+
	               "AND BizArea = ? "+
	               "AND ComCode = ? ";
	    PreparedStatement DPL_Pstmt01 = conn.prepareStatement(DPL_Sql01);
	    DPL_Pstmt01.setString(1, StartDateValue);
	    DPL_Pstmt01.setString(2, EndDateValue);
	    DPL_Pstmt01.setString(3, DealCom);
	    DPL_Pstmt01.setString(4, UBizArea);
	    DPL_Pstmt01.setString(5, UCom);
	    ResultSet DPL_rs01 = DPL_Pstmt01.executeQuery();
	    
	    String ClosingMonth = null;
	    int ClosingNum = 0;
	    String SalesConfirmDate = null;
	    JSONArray jsonArray = new JSONArray();
	    while(DPL_rs01.next()){
	    	ClosingMonth = DPL_rs01.getString("ClosingMonth");
	    	ClosingNum = Integer.parseInt(DPL_rs01.getString("ClosingNum"));
	    	SalesConfirmDate = DPL_rs01.getString("SalesConfirmDate");
	    	String DPL_Sql02 = "SELECT * FROM sales_delrequestcmdline WHERE ClosingMonth IS NULL AND ClosingNum IS NULL AND SalesConfirmDate IS NULL";
	    	PreparedStatement DPL_Pstmt02 = conn.prepareStatement(DPL_Sql02);
	    	
	    	ResultSet DPL_Rs02 = DPL_Pstmt02.executeQuery();
	    	
	    	while(DPL_Rs02.next()){
	    		String MatCode = DPL_Rs02.getString("MatCode");
		 	    JSONObject josnobject = new JSONObject();
		 	    josnobject.put("OutDate", DPL_Rs02.getString("DispatureDate")); // 반출일자
		 	    josnobject.put("OrderNum", DPL_Rs02.getString("DelivNoteNum")); // 납품번호
		 	    josnobject.put("Seq", DPL_Rs02.getString("DelivNoteSeq")); // 항번
		 	    josnobject.put("MatCode", DPL_Rs02.getString("MatCode")); // 품번
		 	    josnobject.put("MatCodeDes", DPL_Rs02.getString("MatDesc")); // 품명
		 	    josnobject.put("Quantity", DPL_Rs02.getString("DelivOrdQty")); // 납품수량
		 	    josnobject.put("Unit", DPL_Rs02.getString("QtyUnit")); // 수량단위
		 	   	josnobject.put("DealCom", DPL_Rs02.getString("TradingPartner")); // 거래처
		 	   
		 	   	String PriceSql = "SELECT * FROM ";
		 	    
		 	    
		 	    jsonArray.put(josnobject);
	    	}
	    }
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonArray.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
