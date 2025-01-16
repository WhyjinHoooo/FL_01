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
            <th>MMPO번호</th><th>Mterial Code</th><th>입고량</th><th>잔량</th><th>Material Description</th>
        </tr>
	<%
        try{
        String PlantCode = request.getParameter("plantcode"); // URL에서 Com_Cd 값을 가져옴
        String StorageCode = request.getParameter("storagecode");
        System.out.println("ComCode: " + PlantCode + "StorageCode : " + StorageCode); // ComCode 값을 console에 출력
        
        if((PlantCode == null || PlantCode.isEmpty()) || (StorageCode == null || StorageCode.isEmpty())){
	%>
		<tr>
		<td colspan="5"><a href="javascript:void(0)" onClick="window.close();">Plant 또는 출고창고를(을) 선택해주세요.</a></td>
		</tr>
	<%
        } else{
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM pochild WHERE PlantCode = ? AND Storage = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, PlantCode);
        pstmt.setString(2, StorageCode);
        
        rs = pstmt.executeQuery();
   		
        if(!rs.next()){
	%>
        <tr>
            <td colspan="5"><a href="javascript:void(0)" onClick="window.close();">해당하는 재료가 없습니다.</a></td>
        </tr>
	<%
        } else{
        	do{
    %>
		<tr>
			<td>
				<a href="javascript:void(0)" onclick="
			    window.opener.document.querySelector('.MatCode').value='<%=rs.getString("MatCode")%>';
			    window.opener.document.querySelector('.MatDes').value='<%=rs.getString("MatDes")%>';
			    window.opener.document.querySelector('.MatType').value='<%=rs.getString("MatType")%>';
			    window.opener.document.querySelector('.MatDocCode').value='<%=rs.getString("MMPO")%>';
			    window.opener.document.querySelector('.MatCode').dispatchEvent(new Event('change'));
			    window.close();">
				<%=rs.getString("MMPO") %>
				</a>
			</td>
			<td><%=rs.getString("MatCode") %></td>
			<td hidden><%=rs.getString("MatType") %></td>
			<td><%=rs.getString("Count") %></td>
			<td><%=rs.getString("PO_Rem") %></td>
			<td><%=rs.getString("MatDes")%></td>
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