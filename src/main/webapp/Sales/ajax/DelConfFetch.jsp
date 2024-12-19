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
	    String DPH_Sql = "SELECT *"+
	               "FROM project.sales_delrequestcmdheader "+
	               "WHERE DATE(DispatureDate) >= ? "+
	               "AND DATE(DispatureDate) <= ? "+
	               "AND TradingPartner = ? "+
	               "AND BizArea = ? "+
	               "AND ComCode = ? ";
	    PreparedStatement DPH_Pstmt = conn.prepareStatement(DPH_Sql);
	    DPH_Pstmt.setString(1, StartDateValue);
	    DPH_Pstmt.setString(2, EndDateValue);
	    DPH_Pstmt.setString(3, DealCom);
	    DPH_Pstmt.setString(4, UBizArea);
	    DPH_Pstmt.setString(5, UCom);
	    ResultSet DPH_rs = DPH_Pstmt.executeQuery();
	    
	    String SalesOrdNum = null;
	    JSONArray jsonArray = new JSONArray();
	    while(DPH_rs.next()){
	    	SalesOrdNum = DPH_rs.getString("DelivNoteNum");
	    	String DPL_Sql = "SELECT * FROM sales_delrequestcmdline WHERE DelivNoteNum = ?";
	    	PreparedStatement DPL_Pstmt = conn.prepareStatement(DPL_Sql);
	    	DPL_Pstmt.setString(1, SalesOrdNum);
	    	ResultSet DPL_Rs = DPL_Pstmt.executeQuery();
	    	
	    	while(DPL_Rs.next()){
		 	    JSONObject josnobject = new JSONObject();
		 	    josnobject.put("OutDate", DPL_Rs.getString("DispatureDate")); // 반출일자
		 	    josnobject.put("OrderNum", DPL_Rs.getString("DelivNoteNum")); // 납품번호
		 	    josnobject.put("Seq", DPL_Rs.getString("DelivNoteSeq")); // 항번
		 	    josnobject.put("MatCode", DPL_Rs.getString("MatCode")); // 품번
		 	    josnobject.put("MatCodeDes", DPL_Rs.getString("MatDesc")); // 품명
		 	    josnobject.put("Quantity", DPL_Rs.getString("DelivOrdQty")); // 납품수량
		 	    josnobject.put("Unit", DPL_Rs.getString("QtyUnit")); // 수량단위
		 	    josnobject.put("TPWay", DPL_Rs.getString("TransMean")); // 운송수단
		 	    josnobject.put("Station", DPL_Rs.getString("DelivPlace")); // 인도장소
		 	    josnobject.put("ArrivePlace", DPL_Rs.getString("ArrivCustPlace")); // 납품장소
		 	    josnobject.put("DealCom", DPL_Rs.getString("TradingPartner")); // 거래처
		 	    
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
