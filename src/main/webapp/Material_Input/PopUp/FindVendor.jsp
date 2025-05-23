<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
<title>Insert title here</title>
</head>
<body>
<h1>검색</h1>
<hr>
    <center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
			        <tr>
			            <th>공급업체</th><th>공급업체 프로필</th>
			        </tr>
		        </thead>
				<tbody>
		    <%
			try{
		        String ComCode = request.getParameter("ComCode");
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT * FROM vendor WHERE ComCode = ?";
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, ComCode);
		        
		        rs = pstmt.executeQuery();
		        
		        if(!rs.next()){
		    %>
		        <tr>
		            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Plant를 선택해주세요.</a></td>
		        </tr>
		    <%  
		        } else {
		            do {
		    %>
		        <tr>
		        	<td>
		        		<a href="javascript:void(0)" onClick="
						window.opener.document.querySelector('.VendorCode').value='<%=rs.getString("VenCode")%>';
						window.opener.document.querySelector('.VendorDes').value='<%=rs.getString("Des")%>';
						window.opener.document.querySelector('.VendorCode').dispatchEvent(new Event('input'));
			            window.close();">
						<%=rs.getString("VenCode") %>
						</a>
					</td>
					<td><%=rs.getString("Des") %></td>
				</tr>
		    <%  
		            } while(rs.next());
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
 