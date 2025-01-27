<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
			    <tr>
			        <th>코드(Code)</th><th>이름(Description)</th>
			    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			   	String ComCode = request.getParameter("ComCode");
			   	String level = request.getParameter("Level");
			    int Upper_Group = 0; //변수 초기화
			    
			    if (level != null && !level.isEmpty()) {
			    	Upper_Group = Integer.parseInt(level);
			    	System.out.println("Upper_Group: " + Upper_Group);
			    }
			    
			    String sql = "SELECT * FROM coct WHERE ComCode = ? AND COCTG_LEV = ?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ComCode);
			    pstmt.setInt(2, Upper_Group-1);
			    rs = pstmt.executeQuery();
			    
			    if(Upper_Group == 0){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">레벨을 선택해주세요.</a></td>
				</tr>
			<%
			    } else if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">회사코드를 선택해주세요.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" onClick=
				    "window.opener.document.querySelector('.Upper-CCT-Group').value='<%=rs.getString("COCT_GROUP")%>';
				     window.opener.document.querySelector('.Upper-Cct-Name').value='<%=rs.getString("COCT_NAME")%>';
				     window.opener.document.querySelector('.Upper-CCT-Group').dispatchEvent(new Event('change'));
				     window.close();
				     ">
				     <%=rs.getString("COCT_GROUP") %>
				     </a>
			      </td>
			    <td><%=rs.getString("COCT_NAME") %></td>
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
