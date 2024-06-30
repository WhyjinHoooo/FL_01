<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

PreparedStatement TempPstmt = null;
ResultSet TempRs = null;

try{
	String Type = request.getParameter("type"); // 전표유형 FIG
	String Number = request.getParameter("No"); // 전표번호\
	String Date = request.getParameter("Date"); // 정표 입력 일자 20230530
	String DateForNo = request.getParameter("Date").replace("-", ""); // 정표 입력 일자 20230530
	System.out.println("Type : " + Type + ", Date : " + DateForNo);
	String first = Type + DateForNo + "S0001";
	System.out.println("first : " + first);
	
	String TempSql = "SELECT * FROM tmpaccfldochead WHERE DocNum = ? ORDER BY DocNum DESC";	
	TempPstmt = conn.prepareStatement(TempSql);
	TempPstmt.setString(1, first);
	
	String sql = "SELECT * FROM FlDocHead WHERE DocNum = ? ORDER BY DocNum DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, first);
	
	String CheckQuery01 = TempPstmt.toString();
	String CheckQuery02 = pstmt.toString();
    System.out.println("Prepared SQL Query: " + CheckQuery01);
    System.out.println("Prepared SQL Query: " + CheckQuery02);
	
	
	rs = pstmt.executeQuery();
	TempRs = TempPstmt.executeQuery();
	
	if(!rs.next()) {
		/* if(TempRs.next()){
			String recentData = TempRs.getString("DocNum");
			String numberPart = recentData.substring(12, 16);
			int incrementedValue = Integer.parseInt(numberPart) + 1;
			first = first.substring(0, 12) + String.format("%05d", incrementedValue);
			
			System.out.println("TempRs가 된 경우");
			System.out.println("Recent Data: " + recentData);
	        System.out.println("Number Part: " + numberPart);
	        System.out.println("Incremented Value: " + incrementedValue);
	        System.out.println("first: " + first);
		} else{
			first = first;	
		} */
		first = first;	
	} else {
		String recentData = rs.getString("DocNum");
        String numberPart = recentData.substring(12, 16);
        int incrementedValue = Integer.parseInt(numberPart) + 1;
        first = first.substring(0, 12) + String.format("%05d", incrementedValue);
        
        System.out.println("Recent Data: " + recentData);
        System.out.println("Number Part: " + numberPart);
        System.out.println("Incremented Value: " + incrementedValue);
        System.out.println("first: " + first);
    }
	out.print(first.trim());
} catch(SQLException e) {
    e.printStackTrace();
} finally {
    // 리소스 정리
    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
   if (TempRs != null) try { TempRs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (TempPstmt != null) try { TempPstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>

