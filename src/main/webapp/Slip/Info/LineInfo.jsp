<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h1>검색</h1>
<hr>
	<center>
	    <div class="ComSearch-board">
	        <table id="resultTable">
	            <thead>
	                <tr>
	                    <th>전표번호_라인</th><th>조회 순서</th><th>계정관리항목</th><th>관리정보명</th><th>관리정보값</th>
	                </tr>
	            </thead>
	            <tbody>
				<%
					String SearchingDoc = request.getParameter("SearchDoc");
					System.out.println(SearchingDoc);
					try {
						String sql = "SELECT * FROM tmpaccfidoclineinform WHERE DocNum_Line = ?";
						PreparedStatement pstmt = null;
	                    ResultSet rs = null;
	
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, SearchingDoc);
						rs = pstmt.executeQuery();
	
					if(!rs.next()) {    
				%>
					<tr>
						<td colspan="5"><a href="javascript:void(0)" onClick="window.close();">해당 전표의 관리항목은 없습니다.</a></td>
					</tr>
				<%
					} else {
						do {
				%>
					<tr>
	                    <td><%=rs.getString("DocNum_Line") %></td>
	                    <td><%=rs.getInt("DispSeq") %></td>
	                    <td><%=rs.getString("AcctInfoCode") %></td>
	                    <td><%=rs.getString("InfoDescrip") %></td>
	                    <td><%=rs.getString("InfoValue") %></td>
	                </tr>
				<%
						} while(rs.next());
					}
					} catch(SQLException e) {
						e.printStackTrace();
					}
				%>
	            </tbody>
	        </table>    
	    </div>    
	</center>
</body>
</html>
