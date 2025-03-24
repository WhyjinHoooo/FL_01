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
				String Ent_MatCode = request.getParameter("MatCode");
				System.out.println(Ent_MatCode);
				String DeliverPlace = null;
			    String sql01 = "SELECT * FROM matmaster WHERE Material_code = ?";
			    PreparedStatement pstmt01 = null;
			    ResultSet rs01 = null;
			    
			    pstmt01 = conn.prepareStatement(sql01);
			    pstmt01.setString(1, Ent_MatCode);
			    rs01 = pstmt01.executeQuery();
			    
		        if(rs01.next()){
		        	DeliverPlace = rs01.getString("DefaultWARE");
		        	System.out.println(DeliverPlace);
		        	String sql02 = "SELECT * FROM storage WHERE STORAGR_ID = ?";
		        	PreparedStatement pstmt02 = conn.prepareStatement(sql02);
		        	pstmt02.setString(1, DeliverPlace);
		        	ResultSet rs02 = null;
		        	rs02 = pstmt02.executeQuery();
		        	while(rs02.next()){
		    %>
			    <tr>
			        <td>
			        	<a href="javascript:void(0)" onclick="
			        		var StoCode='<%=rs02.getString("STORAGR_ID")%>';
			        		var StoCoDes='<%=rs02.getString("STORAGR_NAME")%>';
			        		window.opener.document.querySelector('.Entry_PCode').value=StoCode;
			        		window.opener.document.querySelector('.Entry_PCodeDes').value=StoCoDes;
			        		window.opener.document.querySelector('.Entry_PCode').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
			        	<%=rs02.getString("STORAGR_ID") %>
			        	</a>
			        </td>
			        <td><%=rs02.getString("STORAGR_NAME") %></td>
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
