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
	String ComCode = HeaderInfoList.getString("ComCode");
	
	String Count_Sql = "SELECT COUNT(Mmpo) AS MmpoCount FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Count_Pstmt = conn.prepareStatement(Count_Sql);
	ResultSet Count_Rs = null;
	Count_Pstmt.setString(1, mmpo);
	Count_Rs = Count_Pstmt.executeQuery();
	int ItemCount = 0;
	if(Count_Rs.next()){
		ItemCount = Count_Rs.getInt("MmpoCount");
	};

	String Delete_Sql = "DELETE FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Delete_Pstmt = conn.prepareStatement(Delete_Sql);
	Delete_Pstmt.setString(1, mmpo);

	String POsql = "INSERT INTO request_ord VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement POpstmt = conn.prepareStatement(POsql);
	
	String Info_Sql = "SELECT * FROM ordertable WHERE Mmpo = ?";
	PreparedStatement Info_Pstmt = conn.prepareStatement(Info_Sql);
	Info_Pstmt.setString(1, mmpo);
	ResultSet Info_Rs = Info_Pstmt.executeQuery();
	
	while(Info_Rs.next()){
		POpstmt.setString(1, Info_Rs.getString("Mmpo"));
		POpstmt.setString(2, Info_Rs.getString("ItemNo"));
		POpstmt.setString(3, Info_Rs.getString("Material"));
		POpstmt.setString(4, Info_Rs.getString("MatDes"));
		POpstmt.setString(5, Info_Rs.getString("Type"));
		POpstmt.setString(6, Info_Rs.getString("Count"));
		POpstmt.setString(7, Info_Rs.getString("BuyUnit"));
		POpstmt.setString(8, Info_Rs.getString("OriPrice"));
		POpstmt.setString(9, Info_Rs.getString("Price"));
		POpstmt.setString(10, Info_Rs.getString("money"));
		POpstmt.setString(11, vendorCode);
		POpstmt.setString(12, vendorDes);
		POpstmt.setString(13, Info_Rs.getString("Hope"));
		POpstmt.setString(14, Info_Rs.getString("Warehouse"));
		
		String SLocSql = "SELECT * FROM storage WHERE STORAGR_ID = ?";
		PreparedStatement SLocPstmt = conn.prepareStatement(SLocSql);
		SLocPstmt.setString(1, Info_Rs.getString("Warehouse"));
		ResultSet SLocRs = SLocPstmt.executeQuery();
		if(SLocRs.next()){
			POpstmt.setString(15, SLocRs.getString("STORAGR_NAME"));
		}
		
		String IQCsql = "SELECT * FROM matmaster WHERE Material_code = ?";
	    PreparedStatement IQCpstmt = conn.prepareStatement(IQCsql);
	    IQCpstmt.setString(1, Info_Rs.getString("Material"));
	    ResultSet IQCrs = IQCpstmt.executeQuery();
	    if(IQCrs.next()){
	    	int number = IQCrs.getInt("IQC");
	    	switch(number){
	    	case 1:
	    		POpstmt.setString(16, "Y");
	    		break;
	    	default:
	    		POpstmt.setString(16, "N");
	    	}
	    }
		POpstmt.setString(17, "0");
		POpstmt.setString(18, "0");
		POpstmt.setString(19, Info_Rs.getString("Count"));
		POpstmt.setString(20, Info_Rs.getString("PurState"));
	    POpstmt.setString(21, id); // 구매담당자
	    POpstmt.setString(22, plantCode); // 공장
	    POpstmt.setString(23, ComCode); // 회사
	    POpstmt.setString(24, ordDate); // 발주일자
	    POpstmt.setString(25, id); // 등록자
	    POpstmt.setString(26, Info_Rs.getString("Mmpo") + Info_Rs.getString("ItemNo") + plantCode);
		POpstmt.executeUpdate();
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