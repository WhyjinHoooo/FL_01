<%@page import="java.sql.SQLException"%>
<%@page import="javax.imageio.plugins.tiff.ExifParentTIFFTagSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Insert title here</title>
</head>
<body>
<% 
	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	/* String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); */
	
	String MatCode = request.getParameter("matCode");//1
	String Type = request.getParameter("matTypeCode");//2
	String TypeDes = request.getParameter("matTypeDes");//3
	String MatDes = request.getParameter("Des");//4
	String ComCode = request.getParameter("plantComCode");//5
	String Plant = request.getParameter("plantCode");//6
	String Unit = request.getParameter("unit");//7
	String Warehouse = request.getParameter("StorageCode");//8
	String Size = request.getParameter("size");//9
	String MatGrouopCode = request.getParameter("matGroupCode");//10
	String MatadjustCode = request.getParameter("matadjustCode");//11
	boolean Iqc = Boolean.parseBoolean(request.getParameter("examine"));//12
	boolean Use = Boolean.parseBoolean(request.getParameter("useYN"));//13
	
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
	
	try{
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

        // 성공한 경우 Material_Regist.jsp로 이동
        response.sendRedirect("Material_Regist.jsp");

	    } catch (SQLException e) {
	        e.printStackTrace();
	
	        // 실패한 경우 이전 페이지로 이동
	        response.sendRedirect(request.getHeader("referer"));
	    } finally {
	        try {
	            if (pstmt != null && !pstmt.isClosed()) {
	                pstmt.close();
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    conn.close();
%>
</body>
</html>