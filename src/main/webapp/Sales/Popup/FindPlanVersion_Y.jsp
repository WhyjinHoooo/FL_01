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
		<div class="Sales_PlanVer_board">
			<table class="PlanVerTable">
				<thead>
				    <tr>
				        <th>계획버전(PlanVersion)</th><th>계획이름(Description)</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String CoCd = request.getParameter("ComCode");
			   	String Year = request.getParameter("Year");
			   	String CombiWord = "YP"+ Year;
			   	System.out.println(CombiWord);
			    String sql = "SELECT * FROM sales_planversion WHERE LEFT(PlanVer, 6) IN (?) AND ComCode = ? AND XO = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, CombiWord);
			    pstmt.setString(2, CoCd);
			    pstmt.setString(3, "X");
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">해당 계획버전은 없습니다.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.DocCode').value = '<%= rs.getString("PlanVer") %>';
				           window.opener.document.querySelector('.DocCodeDes').value = '<%= rs.getString("PlanVerDesc") %>';
				           window.opener.document.querySelector('.DocCode').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("PlanVer") %>
				    </a>
				</td>
			    <td><%=rs.getString("PlanVerDesc") %></td>
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
