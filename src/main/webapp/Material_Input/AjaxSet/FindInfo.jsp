<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	System.out.println("1");
	String PlantCode = request.getParameter("plant");
	String VendorCode = request.getParameter("vendor");
	
	String Complete = "yet";
	String Check = "A";
	PreparedStatement Head_pstmt = null;
	ResultSet Head_rs = null;
	
	String Head_sql = "SELECT * FROM poheader WHERE PlantCode = ? AND VenCode = ? AND Complete = ?";
	Head_pstmt = conn.prepareStatement(Head_sql);
	
	Head_pstmt.setString(1, PlantCode);
	Head_pstmt.setString(2, VendorCode);
	Head_pstmt.setString(3, Complete);
	
	Head_rs = Head_pstmt.executeQuery();
	JSONArray jsonArray = new JSONArray();
	
	while(Head_rs.next()){
		System.out.println("2");
		PreparedStatement pstmt2 = null;
		String sql2 = "SELECT * FROM pochild WHERE MMPO = ? AND DeadLine = ?";

        pstmt2 = conn.prepareStatement(sql2);
        pstmt2.setString(1, Head_rs.getString("Mmpo"));
        pstmt2.setString(2, Check);

        ResultSet rs2 = pstmt2.executeQuery();
        
        while(rs2.next()) {
            JSONObject jsonObject = new JSONObject();
            
            jsonObject.put("KeyValue", rs2.getString("keyValue")); // PO번호
            jsonObject.put("MMPO", rs2.getString("MMPO")); // PO번호
            jsonObject.put("ItemNo", rs2.getInt("ItemNo")); // ITEM 번호
            jsonObject.put("MatCode", rs2.getString("MatCode")); // material Num
            jsonObject.put("MatDes", rs2.getString("MatDes")); // material Des
            jsonObject.put("MatType", rs2.getString("MatType")); // Material Type
            jsonObject.put("Quantity", rs2.getInt("Quantity")); // 발주 수량
            jsonObject.put("PoUnit", rs2.getString("PoUnit")); // 구매단위
            jsonObject.put("Count", rs2.getString("Count"));//입고 수량 없음
            jsonObject.put("PO_Rem", rs2.getInt("PO_Rem")); // 미입고 수량
            jsonObject.put("Money", rs2.getString("Money")); // 거래통화
            jsonObject.put("Hdate", rs2.getString("Hdate")); // 입고예정일자
            jsonObject.put("Storage", rs2.getString("Storage")); // 입고 창고
            jsonObject.put("PlantCode", rs2.getString("PlantCode")); // Plant코드
            jsonObject.put("Vendor", Head_rs.getString("VenCode")); // Plant코드
            jsonObject.put("VendorDes", Head_rs.getString("VenDes")); // Plant코드
            jsonArray.add(jsonObject);
        }
    }
	
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
} catch(SQLException e){
	e.printStackTrace();
}
%>

