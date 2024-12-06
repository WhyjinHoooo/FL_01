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
    String DealComDes = saveListData.getString(3);
	try{
	    String Sql = "SELECT * FROM sales_clientorder WHERE TradingPartner = ? AND BizArea = ? AND ComCode = ?";
	    PreparedStatement Pstmt = conn.prepareStatement(Sql);
	    Pstmt.setString(1, DealCom);
	    Pstmt.setString(2, UBizArea);
	    Pstmt.setString(3, UCom);
	    ResultSet rs = Pstmt.executeQuery();
	    JSONArray jsonArray = new JSONArray();
	    while(rs.next()){
	    	JSONObject josnobject = new JSONObject();
	    	josnobject.put("DealCom", DealCom); 
	    	josnobject.put("DealComDes", DealComDes);
	    	josnobject.put("OreNumber", rs.getString("CustOrdNum")); // 고객주문번호
	    	josnobject.put("Seq", rs.getString("OrditemSeq")); // 항번
	    	josnobject.put("MatCode", rs.getString("MatCode")); // 품번
	    	josnobject.put("MatCodeDes", rs.getString("MatDesc")); // 품명
	    	josnobject.put("Unit", rs.getString("QtyUnit")); // 수량단위
	    	josnobject.put("OrderCount", rs.getString("SalesOrdQty")); // 주문 수량
	    	josnobject.put("DelPlanQty", 0); // 납품 계획 수량
	    	josnobject.put("DeliveredQty", 0); // 납품 완료 수량
	    	josnobject.put("OrderBalance", rs.getString("SalesOrdQty")); // 주문 잔량
	    	josnobject.put("DeliverDate", rs.getString("ExpArrivDate")); // 회망도착일자
	    	josnobject.put("ArrivePlace", rs.getString("ArrivCustPlace")); // 납품장소
	    	josnobject.put("RecvDate", rs.getString("OrdReceiptDate")); // 수주접수일자
	    	
	    	jsonArray.put(josnobject);
	    }
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonArray.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
