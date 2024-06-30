<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Insert title here</title>
</head>
<body>
<h1>검색</h1>
<hr>
    <center>
<div class="ComSearch-board">
    <table>
        <tr>
            <th>코드</th><th>설명</th>
        </tr>
	<%
        try{
        String ComCode = request.getParameter("ComCode"); // URL에서 Com_Cd 값을 가져옴
        System.out.println("ComCode: " + ComCode); // ComCode 값을 console에 출력
        
        if(ComCode == null || ComCode.isEmpty()){
	%>
		<tr>
		<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Plant를(을) 선택해주세요.</a></td>
		</tr>
	<%
        } else{
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM vendor WHERE ComCode = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ComCode);
        
        rs = pstmt.executeQuery();
   		
        if(!rs.next()){
	%>
        <tr>
            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Company Code에 해당하는 값이 없습니다.</a></td>
        </tr>
	<%
        } else{
        	do{
    %>
		<tr>
			<td><%=rs.getString("VenCode") %></td>
			<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.VendorCode').value='<%=rs.getString("VenCode")%>'; window.opener.document.querySelector('.VendorDes').value='<%=rs.getString("Des")%>'; window.close();"><%=rs.getString("Des") %></a></td>
		</tr>    
    <%    		
	    	    	}while(rs.next());
    	    	}
        	}
        }catch(SQLException e){
            e.printStackTrace();
        }
	%>
    </table>    
</div>    
    </center>
</body>
</html>
