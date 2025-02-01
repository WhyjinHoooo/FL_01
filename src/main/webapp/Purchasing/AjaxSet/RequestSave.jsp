<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	String UserId = (String)session.getAttribute("id");
	String userComCode = (String)session.getAttribute("depart");
	String UserIdNumber = (String)session.getAttribute("UserIdNumber");

	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
try{
	JSONObject saveListData = new JSONObject(jsonString.toString());
	LocalDateTime now = LocalDateTime.now();
	String RegistedDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	String Ent_Doc = saveListData.getString("Entry_DocNum");
	
	String Ent_Mat = saveListData.getString("Entry_MatCode");
	String Ent_MatDes = saveListData.getString("Entry_MatDes");
	
	String Ent_MatType = null;
	String Ent_Plant = null;
	String Ent_Com = null;
	
	String sq01 = "SELECT * FROM matmaster WHERE Material_code = ?";
	PreparedStatement pstmt01 = conn.prepareStatement(sq01);
	pstmt01.setString(1, Ent_Mat);
	ResultSet rs01 = pstmt01.executeQuery();
	if(rs01.next()){
		Ent_MatType = rs01.getString("Type");
		Ent_Plant = rs01.getString("Plant");
		Ent_Com = rs01.getString("Company");
	}
	
	String Ent_Quantity = saveListData.getString("Entry_Count");
	String Ent_Unit = saveListData.getString("Entry_Unit");
	String Ent_ReqDate = saveListData.getString("Entry_EndDate");
	String Ent_StoCode = saveListData.getString("Entry_PCode");
	String Ent_StoCoDes = saveListData.getString("Entry_PCodeDes");
	String Ent_Ref = saveListData.getString("Entry_Ref");
	String Ent_ReqType = "NRP";
	String Ent_PurPerson = saveListData.getString("Entry_Client");
	String Ent_ReqPerson = saveListData.getString("Entry_Client");
	String Ent_State = "A 구매요청";
	
	String Finalsql = "INSERT INTO request_doc " +
		    "(DocNumPR, MatCode, MatDesc, MatType, QtyPR, Unit, RequestDate, " +
		    "StorLoca, StorLocaDesc, Reference, StatusPR, PurReqType, PurPerson, ReqPerson, " +
		    "Plant, ComCode, RegistDate, RegistPerson, `Key`) " +
		    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement Finalpstmt = conn.prepareStatement(Finalsql);

	Finalpstmt.setString(1, Ent_Doc);
	Finalpstmt.setString(2, Ent_Mat);
	Finalpstmt.setString(3, Ent_MatDes);
	Finalpstmt.setString(4, Ent_MatType);
	Finalpstmt.setString(5, Ent_Quantity);
	Finalpstmt.setString(6, Ent_Unit);
	Finalpstmt.setString(7, Ent_ReqDate);
	Finalpstmt.setString(8, Ent_StoCode);
	Finalpstmt.setString(9, Ent_StoCoDes);
	Finalpstmt.setString(10, Ent_Ref);
	Finalpstmt.setString(11, Ent_State);
	Finalpstmt.setString(12, Ent_ReqType);
	Finalpstmt.setString(13, Ent_PurPerson);
	Finalpstmt.setString(14, Ent_ReqPerson);
	Finalpstmt.setString(15, Ent_Plant);
	Finalpstmt.setString(16, Ent_Com);
	Finalpstmt.setString(17, RegistedDate);
	Finalpstmt.setString(18, UserIdNumber);
	Finalpstmt.setString(19, Ent_Doc);
	Finalpstmt.executeUpdate();
	
	JSONObject Result = new JSONObject();
	Result.put("status", "Success");
	
    response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(Result.toString());
}catch(SQLException e){
		e.printStackTrace();
	}
%>