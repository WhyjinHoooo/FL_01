<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
</head>
<body>
<h1>검색</h1>
<hr>
	<div class="Total_board ForMatOut">
		<table class="TotalTable">
			<thead>
			    <tr>
			        <th>창고코드</th><th>자재</th><th>자재이름</th><th>수량</th>
			    </tr>
			</thead>
			<tbody>
		<%
		try{
		    String ComCode = request.getParameter("OutCode").split(",")[0];
		    String YYMMdate = request.getParameter("OutCode").split(",")[3].substring(0, 7);
		    String PlantCode = request.getParameter("OutCode").split(",")[1];
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    String sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Plant = ?";
		    pstmt = conn.prepareStatement(sql);
		    pstmt.setString(1, YYMMdate);
		    pstmt.setString(2, ComCode);
		    pstmt.setString(3, PlantCode);
		    rs = pstmt.executeQuery();
		if(!rs.next()){
		%>
	        <tr>
	            <td colspan="4">
	            	<a href="javascript:void(0)" onClick="window.close();">
	            	해당 기업과 공장에 만족하는 창고가 없습니다.
	            	</a>
	            </td>
	        </tr>			
		<% 
		}else{
			do{  
		%>
		<tr>
		    <td>
		    	<a href="javascript:void(0)" onClick=
		    	"var StorageCode = '<%=rs.getString("StorLoc")%>';
		    	 window.opener.document.querySelector('.StorageCode').value=StorageCode;
		    	 window.opener.document.querySelector('.StorageCode').dispatchEvent(new Event('change'));
		    	 window.close();">
		    	 <%=rs.getString("StorLoc") %>
		    	 </a>
			</td>
			<td><%=rs.getString("Material") %></td>
			<td><%=rs.getString("MaterialDes") %></td>
			<td><%=rs.getString("Purchase_In") %></td>
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
</body>
</html>