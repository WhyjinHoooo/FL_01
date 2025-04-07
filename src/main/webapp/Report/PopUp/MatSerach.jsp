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
		<div class="Total_board ForMove">
			<table class="TotalTable">
				<thead>
			        <tr>
			            <th>코드</th><th>설명</th>
			        </tr>
			        </thead>
			        <tbody>
		    <%
		        try{
		        String ComCode = request.getParameter("ComCode");
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT * FROM matmaster WHERE Company = ?";
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, ComCode);
		        
		        rs = pstmt.executeQuery();
		        
		        if(!rs.next()){
		    %>
		        <tr>
		            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Company Code에 해당하는 자재가 없습니다.</a></td>
		        </tr>
		    <%  
		        } else {
		            do {
		    %>
		                <tr>
		                    <td>
		                    	<a href="javascript:void(0)" onClick="
		                    		window.opener.document.querySelector('.MatCode').value='<%=rs.getString("Material_code")%>';
		                    		window.opener.document.querySelector('.MatCode').dispatchEvent(new Event('change'));
		                    		window.close();">
		                    		<%=rs.getString("Material_code") %>
		                    	</a>
		                    </td>
		                    <td><%=rs.getString("Description") %></td>
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
