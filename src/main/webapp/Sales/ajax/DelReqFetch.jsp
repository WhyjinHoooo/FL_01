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
	try{
	    String DPH_Sql = "SELECT *"+
	               "FROM project.sales_delplanheader "+
	               "WHERE DATE(DelivPlanDate) >= ? "+
	               "AND DATE(DelivPlanDate) <= ? "+
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
	    String MatCode = null;
	    JSONArray jsonArray = new JSONArray();
	    while(DPH_rs.next()){
	    	SalesOrdNum = DPH_rs.getString("SalesOrdNum");
	    	String DPL_Sql = "SELECT * FROM sales_delplanline WHERE SalesOrdNum = ?";
	    	PreparedStatement DPL_Pstmt = conn.prepareStatement(DPL_Sql);
	    	DPL_Pstmt.setString(1, SalesOrdNum);
	    	ResultSet DPL_Rs = DPL_Pstmt.executeQuery();
	    	
	    	while(DPL_Rs.next()){
		    	MatCode = DPL_Rs.getString("MatCode");
		    	String TW_Sql = "SELECT * FROM sales_transportway WHERE MatCode = ?";
		    	PreparedStatement TW_Pstmt = conn.prepareStatement(TW_Sql);
		    	TW_Pstmt.setString(1, MatCode);
		    	ResultSet TW_Rs = TW_Pstmt.executeQuery();
		    	System.out.println(MatCode);
	    		while(TW_Rs.next()){
		 	    	JSONObject josnobject = new JSONObject();
		 	    	josnobject.put("OutDate", DPL_Rs.getString("DelivPlanDate")); // 반출예정일자
		 	    	josnobject.put("DealCom", DPL_Rs.getString("TradingPartner")); // 거래처
		 	    	josnobject.put("DelPlanOrderNum", DPL_Rs.getString("SalesOrdNum")); // 납품계획번호
		 	    	josnobject.put("Seq", DPL_Rs.getString("SalesOrdSeq")); // 납품계획항번
		 	    	josnobject.put("MatCode", DPL_Rs.getString("MatCode")); // 품번
		 	    	josnobject.put("MatCodeDes", DPL_Rs.getString("MatDesc")); // 품명
		 	    	josnobject.put("DelQuantity", DPL_Rs.getString("SalesOrdQty")); // 납품수량
		 	    	josnobject.put("Unit", DPL_Rs.getString("QtyUnit")); // 수량단위
		 	    	josnobject.put("Channel", DPL_Rs.getString("SalesChannel")); // 판매경로
		 	    	TP = TW_Rs.getString("TransMean");
		 	    	if(TP == null || TP.isEmpty()){
		 	    		TP = "Nope";
		 	    		josnobject.put("TPWay", TP);
		 	    	} else{
		 	    		josnobject.put("TPWay", TP);
		 	    	}
		 	    	josnobject.put("ArrivePlace", DPL_Rs.getString("ArrivCustPlace")); // 인도장소
			    	
		 	    	jsonArray.put(josnobject);
	    		}
	    	}
	    }
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonArray.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
