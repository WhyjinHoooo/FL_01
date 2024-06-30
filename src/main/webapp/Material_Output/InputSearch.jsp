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
			        <th>창고코드</th><th>창고설명</th>
			    </tr>
			<%
			    try{
			    String outStorage = request.getParameter("outStorage");
			    String sql = "SELECT * FROM storage WHERE STORAGR_ID != ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, outStorage);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>			    
				<td><a href="javascript:void(0)" onClick="var StorId = '<%=rs.getString("STORAGR_ID")%>'; var StorDes = '<%=rs.getString("STORAGR_NAME")%>'; var StorPlantCd = '<%=rs.getString("PLANT")%>'; window.opener.document.querySelector('.TransPlantCode').value=StorPlantCd ; window.opener.document.querySelector('.InputStorage').value=StorId; window.opener.document.querySelector('.TransComCode').value='<%=rs.getString("COMCODE")%>'; window.opener.document.querySelector('.InputStorage').dispatchEvent(new Event('change')); window.opener.console.log('선택한 입고 창고 ' + StorId); window.close();"><%=rs.getString("STORAGR_ID") %></a></td>
			    <td><%=rs.getString("STORAGR_NAME") %></td>
			    <td hidden><%=rs.getString("PLANT") %></td>
			    <td hidden><%=rs.getString("COMCODE") %></td>
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
