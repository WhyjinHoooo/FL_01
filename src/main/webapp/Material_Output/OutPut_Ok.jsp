<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
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
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	String YYMM = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
	String today = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	/* String */ 
	
/* 	String DocNumber = request.getParameter("Doc_Num"); // Mat. 출고 문서번호
	
	String OutDate = request.getParameter("Out_date"); // 출고일자
	// String PONumber = request.getParemeter(""); // PONum -> placetable의 MatCode에서 가져올 예정
	String FIDocNum = "Nope";
	String PlantCode = request.getParameter("plantCode"); // PlantCode
	String OutStorage = request.getParameter("StorageCode"); // 출고창고
	String VendorCode = "Nope";
	String CreateDate = request.getParameter("Out_date"); // 생성한 날짜
	int Id = 95174645; */
	
	String sql01 = "SELECT * FROM placetable";
	PreparedStatement pstmt01 = conn.prepareStatement(sql01);
	ResultSet rs01 = pstmt01.executeQuery();
	
	String sql02 = "INSERT INTO storechild VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
	PreparedStatement pstmt02 = conn.prepareStatement(sql02);
	
	String sql03 = "DELETE FROM placetable";
	PreparedStatement pstmt03 = conn.prepareStatement(sql03);
	
	try{
		while(rs01.next()){
			int DeleteCount = pstmt03.executeUpdate();
			if (DeleteCount > 0) {
				out.println("삭제한 데이터 수 : " + DeleteCount);
			} else if (DeleteCount == 0) {
				out.println("삭제한 데이터 수 : " + DeleteCount);
			}
			
			String MatDocItemID = rs01.getString("DocName") + "-" + String.format("%04d", rs01.getInt("ItemNO")); // MatDocItemID
			// String today = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); // DocDate
			String MatDocNum = rs01.getString("DocName"); // MatDocNum
			int ItemNum = rs01.getInt("ItemNO"); // ItemNum
			String Material = rs01.getString("MatetialCode"); // Material
			String MatType = rs01.getString("MatType"); //MatType
			String MovType = rs01.getString("MovType"); //MovType
			int Quantity = rs01.getInt("Count"); //Quantity
			String InvUnit = rs01.getString("Unit"); //InvUnit
			String OrderNum = rs01.getString("MatCode"); //OrderNum
			String Depart = rs01.getString("Depart");//Depart
			String VendProdLotNum = rs01.getString("LotNo"); //VendProdLotNum
			String ManifacDate = rs01.getString("MakeDate"); //ManifacDate
			String ValidToDate = rs01.getString("DeadDate"); //ValidToDate
			String StoLoca = rs01.getString("Storage"); //StoLoca
			String Plant = rs01.getString("Plant"); //Plant 
			
			int zero = 0;
			Double none = 0.0;
			String Nope = "nope";
			int id = 17011381;
			
			pstmt02.setString(1, MatDocItemID);
			pstmt02.setString(2, today);
			pstmt02.setString(3, MatDocNum);
			pstmt02.setInt(4, ItemNum);
			pstmt02.setString(5, Material);
			pstmt02.setString(6, MatType);
			pstmt02.setString(7, MovType);
			pstmt02.setInt(8, Quantity);
			pstmt02.setString(9, InvUnit);
			pstmt02.setDouble(10, none);
			pstmt02.setString(11, Nope);
			pstmt02.setDouble(12, none);
			pstmt02.setString(13, Nope);
			pstmt02.setString(14, Nope);
			pstmt02.setString(15, OrderNum);
			pstmt02.setString(16, VendProdLotNum);
			pstmt02.setString(17, ManifacDate);
			pstmt02.setString(18, ValidToDate);
			pstmt02.setString(19, StoLoca);
			pstmt02.setString(20, Nope);
			pstmt02.setString(21, Plant);
			pstmt02.setInt(22, id);
			pstmt02.executeUpdate();
		}
		
	}catch(SQLException e){
		e.printStackTrace();
	} finally {
		if (rs01 != null) {
			rs01.close();
		}
		if (pstmt01 != null) {
			pstmt01.close();
		}
		if (pstmt02 != null) {
			pstmt02.close();
		}
		if (pstmt03 != null) {
			pstmt03.close();
		}
	}
%>
	<c:redirect url="/Material_Output/MatOutput.jsp"/>
</body>
</html>