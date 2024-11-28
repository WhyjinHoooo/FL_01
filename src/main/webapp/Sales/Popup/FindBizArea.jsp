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
		<div class="Sales_TradeCom_board">
			<table class="TradeComTable">
				<thead>
				    <tr>
				        <th>회계단위(TradingPartner)</th><th>회계단위명(PartnerDesc)</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String CoCd = request.getParameter("ComCode");
			    String sql = "SELECT * FROM project.bizarea WHERE Com_Code = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, CoCd);
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">해당 회계단위(은)는 없습니다.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.BizCode').value = '<%= rs.getString("BIZ_AREA") %>';
				           window.opener.document.querySelector('.BizCodeDes').value = '<%= rs.getString("BA_Name") %>';
				           window.opener.document.querySelector('.BizCode').dispatchEvent(new Event('change'));
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
				</tbody>
			</table>	
		</div>	
	</center>
</body>
</html>
