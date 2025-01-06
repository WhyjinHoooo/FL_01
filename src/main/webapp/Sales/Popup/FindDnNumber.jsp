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
				        <th>납품지시번호</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String ComCode = request.getParameter("ComCode");
			   	String BizArea = request.getParameter("Biz");
			   	String DealCom = request.getParameter("Deal");
			    String sql = "SELECT * FROM sales_delrequestcmdheader "+ 
			    			 "WHERE ComCode = ? AND BizArea = ? AND TradingPartner = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ComCode);
			    pstmt.setString(2, BizArea);
			    pstmt.setString(3, DealCom);
			    rs = pstmt.executeQuery();
			    if(!rs.next()){
			%>
				<tr>
					<td><a href="javascript:void(0)" onClick="window.close();">해당 납품지시번호(은)는 없습니다.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.EDNumber').value = '<%= rs.getString("DelivNoteNum") %>';
				           window.opener.document.querySelector('.EDNumber').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("DelivNoteNum") %>
				    </a>
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
