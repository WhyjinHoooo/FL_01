<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String PlantCode = request.getParameter("plant");
	String VendorCode = request.getParameter("vendor");
	String Complete = "yet";
	System.out.println("전달받은 Plant코드 : " + PlantCode + " 전달받은 Vendor코드 : " + VendorCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT Mmpo FROM poheader WHERE PlantCode = ? AND VenCode = ? AND Complete = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, PlantCode);
	pstmt.setString(2, VendorCode);
	pstmt.setString(3, Complete);
	
	rs = pstmt.executeQuery();
	/* System.out.println("MMPO 값: " + rs.getString("Mmpo")); */
	JSONArray jsonArray = new JSONArray();
	
	while(rs.next()){
		/* String mmpo = rs.getString("Mmpo"); */
		System.out.println("MMPO 값: " + rs.getString("Mmpo"));
		String Check = "A";
		PreparedStatement pstmt2 = null;
		String sql2 = "SELECT pochild.keyValue, pochild.MMPO, pochild.ItemNo, " +
	              "pochild.MatCode, pochild.MatDes, pochild.MatType, " + 
	              "pochild.Quantity, pochild.PoUnit, pochild.PO_Rem, " + 
	              "pochild.Money, pochild.Hdate, pochild.Storage, "+ 
	              "pochild.PlantCode, pochild.Count " + 
	              "FROM pochild " + 
	              "WHERE MMPO = ? AND DeadLine = ?";

        pstmt2 = conn.prepareStatement(sql2);
        pstmt2.setString(1, rs.getString("Mmpo"));
        pstmt2.setString(2, Check);

        ResultSet rs2 = pstmt2.executeQuery();
        
        while(rs2.next()) {
            JSONObject jsonObject = new JSONObject();

            jsonObject.put("Key", rs2.getString("keyValue"));
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

