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
			        <th>Mat.사용부서</th><th>부서명</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM dept";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){	
			        
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="var CoctType = '<%=rs.getString("COCT")%>'; var CoctDes = '<%=rs.getString("COCT_NAME")%>';window.opener.document.querySelector('.UseDepart').value= CoctType; window.opener.document.querySelector('.DepartName').value=CoctDes;window.opener.document.querySelector('.UseDepart').dispatchEvent(new Event('change')); window.opener.console.log('선택된 Mat.사용부서 : ' + CoctType + ', 부서명 ' + CoctDes ); window.close();"><%=rs.getString("COCT") %></a></td>
			    <td><%=rs.getString("COCT_NAME") %></td>
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
