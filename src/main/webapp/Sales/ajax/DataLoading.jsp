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
    String OrderNumber = saveListData.getString(3);
    String TP = null;
    
	System.out.println(UCom);
	System.out.println(UBizArea);
	System.out.println(DealCom);
	System.out.println(OrderNumber);
	
	try{
	    JSONArray jsonArray = new JSONArray();
	    
    	String Sql = "SELECT * FROM sales_dosalesclosing " +
    					"WHERE DelivNoteNum = ? AND BizArea = ? AND ComCode = ? AND TradingPartner = ?";
    	PreparedStatement Pstmt = conn.prepareStatement(Sql);
    	Pstmt.setString(1, OrderNumber);
    	Pstmt.setString(2, UBizArea);
    	Pstmt.setString(3, UCom);
    	Pstmt.setString(4, DealCom);
    	ResultSet Rs = Pstmt.executeQuery();
	    while(Rs.next()){
		   	JSONObject josnobject = new JSONObject();
		    josnobject.put("OutDate", Rs.getString("MatCode")); // 품번
		    josnobject.put("OrderNum", Rs.getString("MatDesc")); // 품명
		    josnobject.put("Seq", Rs.getString("QtyUnit")); // 수량단위
		    josnobject.put("MatCode", Rs.getString("DelivOrdQty")); // 수량
		    josnobject.put("MatCodeDes", Rs.getString("SalesUnitPrice")); // 판매단가
		    josnobject.put("Quantity", Rs.getString("TranCurr")); // 거래통화
		    josnobject.put("Unit", Rs.getString("TranSalesAmt")); // 거래통화매출금액
			jsonArray.put(josnobject);
	    }

	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonArray.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
