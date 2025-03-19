<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			        <th>코드</th><th>설명</th>
			    </tr>
			</thead>
			<tbody>
		<%
		try{
			String Type = request.getParameter("From");
			System.out.println(Type);
		    String sql = "SELECT * FROM vendor";
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    pstmt = conn.prepareStatement(sql);
		    rs = pstmt.executeQuery();
		if(Type.equals("General")){
			while(rs.next()){
	    %>
			<tr>
				<td>
					<a href="javascript:void(0)" onclick="
						var VCode='<%=rs.getString("VenCode")%>';
						var VCoDes='<%=rs.getString("Des")%>';
						window.opener.document.querySelector('.VendorCode').value=VCode + '(' + VCoDes + ')';
						window.opener.document.querySelector('.VendorCode').dispatchEvent(new Event('change'));
						window.close();
					">
					<%=rs.getString("VenCode") %>
			        </a>
				</td>
				<td><%=rs.getString("Des") %></td>
			</tr>		    
		<%
			}
		}
		else{
			while(rs.next()){
		%>
			<tr>
				<td>
					<a href="javascript:void(0)" onclick="
						var VCode='<%=rs.getString("VenCode")%>';
						var VCoDes='<%=rs.getString("Des")%>';
						window.opener.document.querySelector('.Entry_VCode').value=VCode + '(' + VCoDes + ')';
						window.opener.document.querySelector('.Entry_VCode').dispatchEvent(new Event('change'));
						window.close();
					">
					<%=rs.getString("VenCode") %>
			        </a>
				</td>
				<td><%=rs.getString("Des") %></td>
			</tr>
		<%
			}
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
