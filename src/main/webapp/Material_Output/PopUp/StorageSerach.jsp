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
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
				    <tr>
				        <th>창고코드</th><th>창고설명</th>
				    </tr>
				</thead>
				<tbody>
			<%
			try{
			    String ComCode = request.getParameter("comcode");
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    String sql = "SELECT * FROM storage WHERE COMCODE = ?";
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ComCode);
			    rs = pstmt.executeQuery();
			if(!rs.next()){
			%>
		        <tr>
		            <td colspan="2">
		            	<a href="javascript:void(0)" onClick="window.close();">
		            	Company Code에 해당하는 값이 없습니다.
		            	</a>
		            </td>
		        </tr>			
			<% 
			}else{
				do{  
			%>
			<tr>
			    <td><%=rs.getString("STORAGR_ID") %></td>
			    <td>
			    	<a href="javascript:void(0)" onClick=
			    	"var StorageCode = '<%=rs.getString("STORAGR_ID")%>';
			    	 var StorageName = '<%=rs.getString("STORAGR_NAME")%>';
			    	 window.opener.document.querySelector('.StorageCode').value=StorageCode;
			    	 window.opener.document.querySelector('.StorageDes').value=StorageName;
			    	 window.opener.document.querySelector('.StorageCode').dispatchEvent(new Event('change'));
			    	 window.close();"><%=rs.getString("STORAGR_NAME") %></a>
				</td>
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