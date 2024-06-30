<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String MatInputNumber = request.getParameter("MatNum");
	String GRItemNumber = request.getParameter("GItemNumber"); 
	
	System.out.println("2023-12-08v2 입력받은 Material 입고 번호 : " + MatInputNumber);
	System.out.println("2023-12-08v2 입력받은 GR Item Number : " + GRItemNumber);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	
	String sql = "SELECT * FROM storehead WHERE MatDocNum = ?";
	String sql2 = "SELECT * FROM storechild WHERE MatDocNum = ? AND ItemNum = ?";
	
	pstmt = conn.prepareStatement(sql);
	pstmt2 = conn.prepareStatement(sql2);
	
	
	
	JSONObject jsonObject = new JSONObject();
	
	while(true){
		pstmt.setString(1, MatInputNumber);
		rs = pstmt.executeQuery();
			if(!rs.next()){
				MatInputNumber = MatInputNumber;
				/*System.out.println("----------------------------------------");
				System.out.println("변경된 Material 입고 번호 : " + MatInputNumber);
				System.out.println("----------------------------------------"); */
				break;
			} else{
				String SavedData = rs.getString("MatDocNum");
				String NumPart = SavedData.substring(12, 17);
				int PlusValue = Integer.parseInt(NumPart) + 1;
				MatInputNumber = MatInputNumber.substring(0,12) + String.format("%05d", PlusValue);
				
				System.out.println("----------------------------------------");
				System.out.println("테이블 storehead에 미리 저장되어 있는 데이터 : " + SavedData);
				System.out.println("테이블 storehead에 미리 저장되어 있는 데이터의 번호 : " + NumPart);
				System.out.println("테이블 storehead에 미리 저장되어 있는 데이터의 번호 증가 : " + PlusValue);
				System.out.println("변경된 Material 입고 번호 : " + MatInputNumber);
				System.out.println("----------------------------------------");
			}
	}
	
	String NewMatInputNumber = MatInputNumber;
	System.out.println("2023-12-08v2 입력받은 New GR Item Number : " + NewMatInputNumber);
	
	while(true){
		pstmt2.setString(1, NewMatInputNumber);
		pstmt2.setString(2, GRItemNumber);
		rs2 = pstmt2.executeQuery();
			if(!rs2.next()){
				GRItemNumber = GRItemNumber;
				/*System.out.println("----------------------------------------");
				System.out.println("변경된 GR Item Number : " + GRItemNumber);
				System.out.println("----------------------------------------"); */
				break;
			} else{
				int resetNumber = Integer.parseInt(GRItemNumber) + 1;
				GRItemNumber = String.format("%05d", resetNumber);
				System.out.println("----------------------------------------");
				System.out.println("기존의 GR Item Number : " + GRItemNumber);
				System.out.println("변경된 GR Item Number : " + resetNumber);
				System.out.println("변경완료된 GR Item Number : " + GRItemNumber);
				System.out.println("----------------------------------------");
			}
	}
	
	out.print(MatInputNumber.trim() + "," + GRItemNumber.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>

