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
	<div class="Total_board NewMaterialPrice">
		<table class="TotalTable NewMaterialPriceTable">
			<thead>
				<tr>
			        <th>코드</th><th>설명</th>
			    </tr>
			</thead>
			<tbody>
		<%
		try{
		    String sql = "SELECT Material_code, Description, InvUnit, Standard, IQC FROM matmaster WHERE Type = 'RAWM' AND Material_code NOT IN (SELECT MatCode FROM purprice)";
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    pstmt = conn.prepareStatement(sql);
		    rs = pstmt.executeQuery();
		    
	        while(rs.next()){
	    %>
		    <tr>
		        <td>
		        	<a href="javascript:void(0)" onclick="
		        		var NMCode='<%=rs.getString("Material_code")%>';
		        		var NMCoDes='<%=rs.getString("Description")%>';
		        		var NMInvUnit='<%=rs.getString("InvUnit")%>';
		        		var Standard='<%=rs.getString("Standard")%>';
		        		var IQC='<%=rs.getString("IQC")%>';
		        		var NWPackUnit=Standard.split('/')[1];
		        		window.opener.document.querySelector('.NewMaterialCode').value=NMCode;
		        		window.opener.document.querySelector('.NewMaterialCodeDes').value=NMCoDes;
		        		window.opener.document.querySelector('.NewMaterialInvUnit').value=NMInvUnit;
		        		window.opener.document.querySelector('.NewMaterialWrapUnit').value=NWPackUnit;
		        		window.opener.document.querySelector('.IQC').value=IQC;
		        		window.opener.document.querySelector('.NewMaterialCode').dispatchEvent(new Event('change'));
		        		window.close();
		        	">
		        	<%=rs.getString("Material_code") %>
		        	</a>
		        </td>
		        <td><%=rs.getString("Description") %></td>
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
</body>
</html>
