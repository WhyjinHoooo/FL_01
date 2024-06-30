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
			    String sql = "SELECT * FROM company";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
		        if(!rs.next()){ // 데이터가 없을 경우
		    %>
		    	<tr>
		        	<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Company Code에 해당하는 값이 없습니다.</a></td>
		        </tr>
			<%  
		        }else{
		        	do{
		    %>
			    <tr>
			        <td><%=rs.getString("Com_Cd") %></td>
			        <td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.ComCode').value='<%=rs.getString("Com_Cd")%>'; window.opener.document.querySelector('.Com_Name').value='<%=rs.getString("Com_Des")%>'; window.opener.document.querySelector('.ComCode').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("Com_Des") %></a></td>
			    </tr>		    
		    <%
		        	}while(rs.next());
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
