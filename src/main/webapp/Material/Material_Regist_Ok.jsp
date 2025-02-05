<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.imageio.plugins.tiff.ExifParentTIFFTagSet"%>
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
	try {
		JSONObject saveListData = new JSONObject(jsonString.toString());
		LocalDateTime now = LocalDateTime.now();
		String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		/* String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); */
		
		String MatCode = saveListData.getString("matCode");//1
		String Type = saveListData.getString("matTypeCode");//2
		String TypeDes = saveListData.getString("matTypeDes");//3
		String MatDes = saveListData.getString("Des");//4
		String ComCode = saveListData.getString("plantComCode");//5
		String Plant = saveListData.getString("plantCode");//6
		String Unit = saveListData.getString("unit");//7
		String Warehouse = saveListData.getString("StorageCode");//8
		String Size = saveListData.getString("size");//9
		String MatGrouopCode = saveListData.getString("matGroupCode");//10
		String MatadjustCode = saveListData.getString("matadjustCode");//11
		boolean Iqc = Boolean.parseBoolean(saveListData.getString("examine"));//12
		boolean Use = Boolean.parseBoolean(saveListData.getString("useYN"));//13
		
		int id1 = 17011381;//1
		int id2 = 76019202;//1
	    // MatCode 검증
	    String sql_check = "SELECT count(*) FROM matmaster WHERE Material_code = ?";
	    PreparedStatement pstmt_check = conn.prepareStatement(sql_check);
	    pstmt_check.setString(1, MatCode);
	    ResultSet rs = pstmt_check.executeQuery();
	    rs.next();
	    if(rs.getInt(1) > 0) {
	        String[] parts = MatCode.split("-");
	        int numberPart = Integer.parseInt(parts[1]) + 1;
	        String newNumberPart = String.format("%05d", numberPart); // 숫자 부분을 5자리로 맞춤
	        MatCode = parts[0] + "-" + newNumberPart; // 새로운 MatCode 생성
	    }	
		String sql = "INSERT INTO matmaster VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		PreparedStatement pstmt = conn.prepareStatement(sql);
	
	
		pstmt.setString(1, MatCode);
		pstmt.setString(2, Type);
		pstmt.setString(3, TypeDes);
		pstmt.setString(4, MatDes);
		pstmt.setString(5, ComCode);
		pstmt.setString(6, Plant);
		pstmt.setString(7, Unit);
		pstmt.setString(8, Warehouse);
		pstmt.setString(9, Size);
		pstmt.setString(10, MatGrouopCode);
		pstmt.setString(11, MatadjustCode);
		pstmt.setBoolean(12, Iqc);
		pstmt.setBoolean(13, Use);
		pstmt.setString(14, date);
		pstmt.setInt(15, id1);
		pstmt.setString(16, date);
		pstmt.setInt(17, id2);
		
		pstmt.executeUpdate();
		
		JSONArray MatData = new JSONArray();
		MatData.put(MatCode);
		MatData.put(MatDes);
		MatData.put(saveListData.getString("StorageCode") + "(" + saveListData.getString("StorageDes") + ")");
		MatData.put(Size);
		MatData.put(MatGrouopCode);
		MatData.put(MatadjustCode);
		MatData.put(Unit);
		MatData.put(Iqc);
		MatData.put(Use);
		

		JSONObject Result = new JSONObject();
		Result.put("Material", MatData);
		Result.put("status", "Success");
	    
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	}
%>