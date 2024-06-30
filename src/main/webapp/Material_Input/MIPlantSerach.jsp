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
			    String sql = "SELECT * FROM plant";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>
			    <td><%=rs.getString("Plant_ID") %></td>
			    <td hidden><%=rs.getString("COMCODE") %></td>
			    <%-- <td hidden><%=rs.getString("LO_CURRENCY") %></td> --%>
			    <td><a href="javascript:void(0)" onClick="var PlantCode = '<%=rs.getString("PLANT_ID")%>'; var PlantName = '<%=rs.getString("PLANT_NAME")%>'; var ComCode = '<%=rs.getString("COMCODE")%>'; window.opener.document.querySelector('.plantCode').value=PlantCode; window.opener.document.querySelector('.plantDes').value=PlantName; window.opener.document.querySelector('.plantComCode').value=ComCode; window.opener.document.querySelector('.plantComCode').dispatchEvent(new Event('input')); window.opener.console.log('Selected PlantCode: ' + PlantCode + ', PlantName: ' + PlantName + ', ComCode: ' + ComCode); window.close();"><%=rs.getString("PLANT_NAME") %></a></td>
			    <%-- <td><a href="javascript:void(0)" onClick="var PlantCode = '<%=rs.getString("PLANT_ID")%>'; var PlantName = '<%=rs.getString("PLANT_NAME")%>'; var ComCode = '<%=rs.getString("COMCODE")%>'; var Currency = '<%=rs.getString("LO_CURRENCY")%>'; window.opener.document.querySelector('.MonUnit').value=Currency; window.opener.document.querySelector('.plantCode').value=PlantCode; window.opener.document.querySelector('.plantDes').value=PlantName; window.opener.document.querySelector('.plantComCode').value=ComCode; window.opener.document.querySelector('.plantDes').dispatchEvent(new Event('change')); window.opener.console.log('Selected PlantCode: ' + PlantCode + ', PlantName: ' + PlantName + ', ComCode: ' + ComCode); window.close();"><%=rs.getString("PLANT_NAME") %></a></td> --%>
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
