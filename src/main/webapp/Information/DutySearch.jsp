<!-- test.jsp -->
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="ComSearch-board">
			<table>
			    <tr>
			        <th>코드</th><th>설명</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM jobpos ORDER BY code ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			    <tr>
			        <td><%=rs.getString("code") %></td>
			        <td><a href="javascript:void(0)" onClick="var DutyCode = '<%=rs.getString("code")%>'; var DutyName = '<%=rs.getString("name")%>'; window.opener.document.querySelector('.duty_code').value=DutyCode; window.opener.document.querySelector('.duty_code').dispatchEvent(new Event('change')); window.opener.document.querySelector('.duty_Des').value=DutyName; window.opener.console.log('Selected DutyCode: ' + DutyCode + ', DutyName: ' + DutyName); window.close();"><%=rs.getString("name") %></a></td>
			    </tr>
			<%  
			    }
			    }catch(SQLException e){
			        e.printStackTrace();
			    }
			%>
			</table>	
		</div>	
	</center>
</body>
</html>
