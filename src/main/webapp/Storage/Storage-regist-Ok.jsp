<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../mydbcon.jsp" %>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String Time = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	String Id = request.getParameter("Storage_Id");
	String Des = request.getParameter("Des");
	
	String ComCode = request.getParameter("ComCode");
	String ComName = request.getParameter("Com_Name");
	
	String PlantCode = request.getParameter("Plant_Select");
	String PlantName = request.getParameter("Plant_Name");
	
	String LocaType = request.getParameter("Stor_Code");
	String LocaName = request.getParameter("Stor_Des"); 
	
	Boolean Rack = Boolean.parseBoolean(request.getParameter("Rack_YN"));
	
	Boolean Bin = Boolean.parseBoolean(request.getParameter("Bin_YN"));
	
	Boolean UseYN = Boolean.parseBoolean(request.getParameter("Code_YN"));
	
	int id1 = 17011381;
	int id2 = 76019202;
	
	String sql = "INSERT INTO storage VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1, Id);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, ComName);
		pstmt.setString(5, PlantCode);
		pstmt.setString(6, PlantName);
		pstmt.setString(7, LocaType);
		pstmt.setString(8, LocaName);
		pstmt.setBoolean(9, Rack);
		pstmt.setBoolean(10, Bin);
		pstmt.setBoolean(11, UseYN);
		pstmt.setString(12, Time);
		pstmt.setInt(13, id1);
		pstmt.setString(14, Time);
		pstmt.setInt(15, id2);
		
		pstmt.executeUpdate();
		response.sendRedirect("Storage-regist.jsp");
	}catch(SQLException e){
		e.printStackTrace();
        out.println("<script>");
        out.println("alert('등록에 실패하였습니다. 다시 시도해주세요.');");
        out.println("history.back();");
        out.println("</script>");		
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	conn.close();
%>
</body>
</html>