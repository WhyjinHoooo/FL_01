<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
	JSONObject HeaderInfoList = new JSONObject(jsonString.toString());
	
	LocalDateTime now = LocalDateTime.now();
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

	String mmpo = HeaderInfoList.getString("OrderNum");
	String orderType = HeaderInfoList.getString("ordType");
	String plantCode = HeaderInfoList.getString("PlantCode");
	String plantDes = HeaderInfoList.getString("PlantDes");
	String vendorCode = HeaderInfoList.getString("VendorCode");
	String vendorDes = HeaderInfoList.getString("VendorDes");
	String ordDate = HeaderInfoList.getString("date");
	String yet = "yet";
	String id = HeaderInfoList.getString("UserID");
	
	String Count_Sql = "SELECT COUNT(Mmpo) AS MmpoCount FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Count_Pstmt = conn.prepareStatement(Count_Sql);
	ResultSet Count_Rs = null;
	Count_Pstmt.setString(1, mmpo);
	Count_Rs = Count_Pstmt.executeQuery();
	int ItemCount = 0;
	if(Count_Rs.next()){
		ItemCount = Count_Rs.getInt("MmpoCount");
	};
	
	String Head_Sql = "INSERT INTO poheader VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement Head_Pstmt = conn.prepareStatement(Head_Sql);

	String Delete_Sql = "DELETE FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Delete_Pstmt = conn.prepareStatement(Delete_Sql);
	Delete_Pstmt.setString(1, mmpo);

	String Child_Sql = "INSERT INTO pochild VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement Child_Pstmt = conn.prepareStatement(Child_Sql);
	String empty = "A";
	
	Head_Pstmt.setString(1,mmpo);
	Head_Pstmt.setString(2,orderType);
	Head_Pstmt.setString(3,plantCode);
	Head_Pstmt.setString(4,plantDes);
	Head_Pstmt.setString(5,vendorCode);
	Head_Pstmt.setString(6,vendorDes);
	Head_Pstmt.setString(7,yet);
	Head_Pstmt.setInt(8,ItemCount);
	Head_Pstmt.setString(9,date);
	Head_Pstmt.setString(10,id);
	Head_Pstmt.setString(11,yet);
	Head_Pstmt.executeUpdate();
	
	String Info_Sql = "SELECT * FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Info_Pstmt = conn.prepareStatement(Info_Sql);
	Info_Pstmt.setString(1, mmpo);
	ResultSet Info_Rs = Info_Pstmt.executeQuery();
	
	while(Info_Rs.next()){
		Child_Pstmt.setString(1, Info_Rs.getString("KeyValue"));
		Child_Pstmt.setString(2, Info_Rs.getString("Mmpo"));
		Child_Pstmt.setString(3, Info_Rs.getString("ItemNo"));
		Child_Pstmt.setString(4, Info_Rs.getString("Material"));
		Child_Pstmt.setString(5, Info_Rs.getString("MatDes"));
		Child_Pstmt.setString(6, Info_Rs.getString("Type"));
		Child_Pstmt.setString(7, Info_Rs.getString("Count"));
		Child_Pstmt.setString(8, Info_Rs.getString("BuyUnit"));
		Child_Pstmt.setString(9, Info_Rs.getString("OriPrice"));
		Child_Pstmt.setString(10, Info_Rs.getString("PriUnit"));
		Child_Pstmt.setString(11, Info_Rs.getString("Price"));
		Child_Pstmt.setString(12, Info_Rs.getString("money"));
		Child_Pstmt.setString(13, Info_Rs.getString("Hope"));
		Child_Pstmt.setString(14, Info_Rs.getString("Warehouse"));
		Child_Pstmt.setString(15, Info_Rs.getString("Plant"));
		Child_Pstmt.setString(16, "0");
		Child_Pstmt.setString(17, Info_Rs.getString("Count"));
		Child_Pstmt.setString(18, empty);
		Child_Pstmt.executeUpdate();
	}
	int rowsAffected = Delete_Pstmt.executeUpdate();
	System.out.println("rowsAffected : " + rowsAffected);
		if (rowsAffected > 0) {
			out.println("Success");
		} else {
			out.println("Fail");
		}
	} catch(SQLException e){
		e.printStackTrace();
	}
%>