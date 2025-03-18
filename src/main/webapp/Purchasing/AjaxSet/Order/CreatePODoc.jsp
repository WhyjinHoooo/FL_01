<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page import ="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%@page import="org.json.simple.JSONValue"%>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String PoType = request.getParameter("Case");
	JSONArray jsonArray = new JSONArray();
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter YYYYMMDD = DateTimeFormatter.ofPattern("yyyyMMdd");
	String Rnow = today.format(YYYYMMDD);
	String EntryDocCode = "PO" + Rnow + "S0001";
	String CreatePOCode = "SELECT * FROM request_ord WHERE ActNumPO = ?";
	PreparedStatement CreatePStmt = conn.prepareStatement(CreatePOCode);
	CreatePStmt.setString(1, EntryDocCode);
	ResultSet CreateRs = CreatePStmt.executeQuery();
	boolean Chk = false;
	while(!Chk){
		CreatePStmt.setString(1, EntryDocCode);
		CreateRs = CreatePStmt.executeQuery();
		
		if(!CreateRs.next()){
			Chk = true;
		}else{
			String RegistedDocCode = CreateRs.getString("ActNumPO");
			String NumberPart = RegistedDocCode.substring(11);
			int ChangedNumpart = Integer.parseInt(NumberPart) + 1;
			EntryDocCode = "PO" + Rnow + "S" + String.format("%04d", ChangedNumpart);
		}
	}
	jsonArray.add(EntryDocCode);
	switch(PoType){
	case "NA":
		String MatCode = request.getParameter("MatCode");
		String VenCode = request.getParameter("VenCode");
		System.out.println(VenCode);
		System.out.println(MatCode);
		String Sql = "SELECT * FROM request_rvw WHERE Vendor = ? AND MatCode = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		pstmt = conn.prepareStatement(Sql);
		pstmt.setString(1, VenCode);
		pstmt.setString(2, MatCode);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("POCode", EntryDocCode); // 자재코드
			jsonObject.put("MatCode", rs.getString("MatCode")); // 자재코드
			jsonObject.put("MatDesc", rs.getString("MatDesc")); // 자재이름
			jsonObject.put("MatType", rs.getString("MatType")); // 재고유형
			jsonObject.put("PlanPOQty", rs.getString("PlanPOQty")); // 발줄계획수량
			jsonObject.put("Unit", rs.getString("Unit")); // 단위
			jsonObject.put("Vendor", rs.getString("Vendor")); // 공급업체
			jsonObject.put("VenderDesc", rs.getString("VenderDesc")); // 공급업체이름
			jsonObject.put("PricePerUnit", rs.getString("PricePerUnit")); // 구매단가
			jsonObject.put("TotalPrice", rs.getInt("PlanPOQty") * rs.getInt("PricePerUnit")); // 구매단가
			jsonObject.put("TCur", rs.getString("TCur")); // 거래통화
			jsonObject.put("RequestDate", rs.getString("RequestDate")); // 납품요청일자
			jsonObject.put("StorLoca", rs.getString("StorLoca") + "(" + rs.getString("StorLocaDesc") + ")"); // 납품장소
			jsonObject.put("PlanNumPO", rs.getString("PlanNumPO")); // 발주계획번호
			jsonArray.add(jsonObject);
		}
		break;
	}
	
   response.setContentType("application/json");
   response.setCharacterEncoding("UTF-8");
   response.getWriter().write(jsonArray.toString());
} catch(Exception e){
	e.printStackTrace();
}
%>

