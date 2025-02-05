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
        String ComCode = request.getParameter("ComCode"); // URL에서 Com_Cd 값을 가져옴
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM adjust WHERE Company = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ComCode); // ComCode 값을 sql 쿼리에 설정
        
        rs = pstmt.executeQuery();
        
        if(!rs.next()){ // 데이터가 없을 경우
    %>
        <tr>
            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Company Code에 해당하는 값이 없습니다.</a></td>
        </tr>
    <%  
        } else { // 데이터가 있을 경우
            do {
    %>
                <tr>
                    <td><%=rs.getString("Level") %></td>
                    <td>
	                    <a href="javascript:void(0)" onClick=
	                    "window.opener.document.querySelector('.matadjustCode').value='<%=rs.getString("Level")%>';
	                     window.opener.document.querySelector('.matadjustDes').value='<%=rs.getString("Name")%>'; 
	                     window.close();
	                     ">
	                     <%=rs.getString("Name") %>
	                     </a>
                     </td>
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
