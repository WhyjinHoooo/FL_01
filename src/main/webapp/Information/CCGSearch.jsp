<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
			    <tr>
			        <th>코드(Code)</th><th>이름(Description)</th>
			    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String CoCd = request.getParameter("ComCode");
			   	
			    String sql = "SELECT * FROM coct WHERE ComCode = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, CoCd);
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">회사코드를 선택해주세요.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.CCG').value = '<%= rs.getString("COCT_GROUP") %>';
				           window.opener.document.querySelector('.CCG_Des').value = '<%= rs.getString("COCT_NAME") %>';
				           window.opener.document.querySelector('.CCG').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("COCT_GROUP") %>
				    </a>
				</td>

			    <td><%=rs.getString("COCT_NAME") %></td>
			</tr>

			<%  
			    	}while(rs.next());
			    }
			    }catch(SQLException e){
			        e.printStackTrace();
			    }
			%>
				</tbody>
			</table>	
		</div>	
	</center>
</body>
</html>
