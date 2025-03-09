<%@ page import ="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@page import="org.json.simple.JSONValue"%>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>  

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		JSONObject dataToSend = new JSONObject(jsonString.toString());
		String Que_Sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		if (dataToSend.isNull("MatCode") || dataToSend.getString("MatCode").isEmpty()){
			Que_Sql = "SELECT * FROM request_doc WHERE ComCode = ? AND Plant = ? AND StatusPR = ?";
			pstmt = conn.prepareStatement(Que_Sql);
			pstmt.setString(1, dataToSend.getString("ComCode"));
			pstmt.setString(2, dataToSend.getString("PlantCode").substring(0,5));
			pstmt.setString(3, dataToSend.getString("State"));
		}else{
			Que_Sql = "SELECT * FROM request_doc WHERE ComCode = ? AND Plant = ? AND StatusPR = ? AND MatCode = ?";
			pstmt = conn.prepareStatement(Que_Sql);
			pstmt.setString(1, dataToSend.getString("ComCode"));
			pstmt.setString(2, dataToSend.getString("PlantCode").substring(0,5));
			pstmt.setString(3, dataToSend.getString("State"));
			pstmt.setString(4, dataToSend.getString("MatCode"));
		}
		rs = pstmt.executeQuery();
		JSONArray jsonArray = new JSONArray();
		while(rs.next()){
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("MatCode", rs.getString("MatCode"));
			jsonObject.put("MatDesc", rs.getString("MatDesc"));
			jsonObject.put("MatType", rs.getString("MatType"));
			jsonObject.put("QtyPR", rs.getString("QtyPR"));
			jsonObject.put("Unit", rs.getString("Unit"));
			
			String CouSql = "SELECT COUNT(*) as RouCount FROM purprice WHERE MatCode = ? ";
			PreparedStatement CouPstmt = conn.prepareStatement(CouSql);
			CouPstmt.setString(1, rs.getString("MatCode"));
			ResultSet CouRs = CouPstmt.executeQuery();
			if(CouRs.next() && CouRs.getInt("RouCount") == 1){
				String PriSql = "SELECT * FROM purprice WHERE MatCode = ? ";
				PreparedStatement PriPstmt = conn.prepareStatement(PriSql);
				PriPstmt.setString(1, rs.getString("MatCode"));
				ResultSet PriRs = PriPstmt.executeQuery();
				if(PriRs.next()){
					jsonObject.put("UnitPrice", PriRs.getDouble("PurPrices") / PriRs.getDouble("PriceBaseQty")); // 구매단가
					jsonObject.put("Price",  rs.getInt("QtyPR") * PriRs.getDouble("PurPrices") / PriRs.getDouble("PriceBaseQty")); // 구매금액
					jsonObject.put("PurCurr", PriRs.getString("PurCurr")); // 거래통화
					jsonObject.put("VendCode", PriRs.getString("VendCode")); // 공급업체 코드
					jsonObject.put("VendDes", PriRs.getString("VendDes")); // 공급업체 이름
				}
			}else{
				String PriSql = "SELECT * FROM purprice WHERE MatCode = ? ";
				PreparedStatement PriPstmt = conn.prepareStatement(PriSql);
				PriPstmt.setString(1, rs.getString("MatCode"));
				ResultSet PriRs = PriPstmt.executeQuery();
				if(PriRs.next()){
					jsonObject.put("UnitPrice", PriRs.getDouble("PurPrices") / PriRs.getDouble("PriceBaseQty")); // 구매단가
					jsonObject.put("Price",  rs.getInt("QtyPR") * PriRs.getDouble("PurPrices") / PriRs.getDouble("PriceBaseQty")); // 구매금액
					jsonObject.put("PurCurr", PriRs.getString("PurCurr")); // 거래통화
					jsonObject.put("VendCode", "Null"); // 공급업체 코드
					jsonObject.put("VendDes", "Null"); // 공급업체 이름
				}
			}
			jsonObject.put("RequestDate", rs.getString("RequestDate")); // 납품요청일자
			jsonObject.put("StorLocaDesc", rs.getString("StorLocaDesc")); // 납품장소
			jsonObject.put("Reference", rs.getString("Reference")); // 구매요청사항
			jsonObject.put("DocNumPR", rs.getString("DocNumPR"));
			jsonArray.add(jsonObject);
		}
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(jsonArray.toString());
	} catch(SQLException e){
		e.printStackTrace();
	}
%>

