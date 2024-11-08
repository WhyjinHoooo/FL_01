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
				        <th>거래처(TradingPartner)</th><th>거래처명(PartnerDesc)</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String CoCd = request.getParameter("ComCode");
			    String sql = "SELECT * FROM project.sales_trandingpartner WHERE ComCode = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, CoCd);
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">해당 거래처(은)는 없습니다.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.DealComCode').value = '<%= rs.getString("TradingPartner") %>';
				           window.opener.document.querySelector('.DealComCodeDes').value = '<%= rs.getString("PartnerDesc") %>';
				           window.opener.document.querySelector('.DealComCode').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("TradingPartner") %>
				    </a>
				</td>
			    <td><%=rs.getString("PartnerDesc") %></td>
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
