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
			        <th>코드(Code)</th><th>이름(Description)</th>
			    </tr>
			<%
			    try{
			   	String CoCd = request.getParameter("CoCd");
			   	
			    String sql = "SELECT * FROM taxarea WHERE Main_TA = ? ";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, CoCd);
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="3"><a href="javascript:void(0)" onClick="window.close();">회사코드를 선택해주세요.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="var TaxArea = '<%=rs.getString("TaxArea")%>';window.opener.document.querySelector('.TA-code').value= TaxArea ;window.opener.document.querySelector('.TA-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("TaxArea") %></a></td>
			    <td><%=rs.getString("TA_Name") %></td>
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
