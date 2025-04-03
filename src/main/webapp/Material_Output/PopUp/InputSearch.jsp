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
			        <th>창고코드</th>
			    </tr>
			</thead>
			<tbody>
			<%
			    try{
			    String outCode = request.getParameter("OutCode");
			    System.out.println(outCode);
			    String sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc != ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, outCode.split(",")[3].substring(0, 7));
			    pstmt.setString(2, outCode.split(",")[0]);
			    pstmt.setString(3, outCode.split(",")[2]);
			    pstmt.setString(4, outCode.split(",")[1]);
			    pstmt.setString(5, outCode.split(",")[4]);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>			    
				<td>
					<a href="javascript:void(0)" onClick="
					var StorId = '<%=rs.getString("StorLoc")%>';
					window.opener.document.querySelector('.InputStorage').value=StorId;
					window.opener.document.querySelector('.InputStorage').dispatchEvent(new Event('change'));
					window.close();">
					<%=rs.getString("StorLoc") %>
					</a>
				</td>
			</tr>

			<%  
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
