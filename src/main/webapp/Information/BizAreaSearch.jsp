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
			   	
			    String sql = "SELECT * FROM bizarea WHERE Com_Code = ?";
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
				           window.opener.document.querySelector('.Biz_Code').value = '<%= rs.getString("BIZ_AREA") %>';
				           window.opener.document.querySelector('.Biz_Code_Des').value = '<%= rs.getString("BA_Name") %>';
				           window.opener.document.querySelector('.Biz_Code').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("BIZ_AREA") %>
				    </a>
				</td>
			    <td><%=rs.getString("BA_Name") %></td>
			</tr>

			<%  
			    	}while(rs.next());
			    }
			    }catch(SQLException e){
			        e.printStackTrace();
			    }
			%>
				<tbody>
			</table>	
		</div>	
	</center>
</body>
</html>
