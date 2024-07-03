<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
PreparedStatement pstmt = null;
ResultSet rs = null;
try{
	String Type = request.getParameter("type"); // 전표유형 FIG
	String Number = request.getParameter("No"); // 전표번호\
	String Date = request.getParameter("Date"); // 정표 입력 일자 20230530
	String DateForNo = request.getParameter("Date").replace("-", ""); // 정표 입력 일자 20230530
	System.out.println("Type : " + Type + ", Date : " + DateForNo);
	String first = Type + DateForNo + "S0001";
	System.out.println("first : " + first);
	
	String sql = "SELECT * FROM FlDocHead WHERE DocNum = ? ORDER BY DocNum DESC";
	pstmt = conn.prepareStatement(sql);
	/* if(!rs.next()) {
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
    } */
	 while (true) { // 계속 반복
        pstmt.setString(1, first);
        String CheckQuery02 = pstmt.toString();
        System.out.println("Prepared SQL Query: " + CheckQuery02);
        
        rs = pstmt.executeQuery();

        // 만약에 데이터가 존재하면, 전표 번호를 증가시키고 다시 검사
        if (rs.next()) {
            String recentData = rs.getString("DocNum");
            String numberPart = recentData.substring(12, 16);
            int incrementedValue = Integer.parseInt(numberPart) + 1;
            first = Type + DateForNo + "S" + String.format("%04d", incrementedValue);
            
            System.out.println("Recent Data: " + recentData);
            System.out.println("Number Part: " + numberPart);
            System.out.println("Incremented Value: " + incrementedValue);
            System.out.println("first: " + first);
        } else {
            // 데이터가 없으면 해당 전표 번호를 사용할 수 있음
            break;
        }
    }
	out.print(first.trim());
} catch(SQLException e) {
    e.printStackTrace();
} finally {
    // 리소스 정리
    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>


