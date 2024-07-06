<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="ComSearch-board">
			<table>
			    <tr>
			        <th>하위 레벨</th>
			    </tr>
			<%
			    try{
			   	String ComCode = request.getParameter("ComCd");
			   	
			    String sql = "SELECT MAX(COCTG_LEV) AS MaxLevel, ComCode FROM coct WHERE ComCode=?";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ComCode);
			    rs = pstmt.executeQuery();
			    
			    if(ComCode.equals("") || ComCode.isEmpty()){
			%>
				<tr>
					<td><a href="javascript:void(0)" onClick="window.close();">회사코드를 선택해주세요.</a></td>
				</tr>
			<%
			    } else if(rs.next()){
			    		String getLevel = rs.getString("MaxLevel");
			    		int MaxLevel = (!getLevel.equals("0")) ? Integer.parseInt(getLevel) + 1 : 1;
			    for (int i = 1; i <= MaxLevel; i++) {
			%>
				<tr>
				    <td>
				        <a href="javascript:void(0)" 
				           onClick="
				               var Level = '<%= i %>';
				               var parentDocument = window.opener.document;
				
				               var levelElement = parentDocument.querySelector('.CCTR-level');
				               levelElement.value = Level;
				               levelElement.dispatchEvent(new Event('change'));
				
				               window.close();
				           ">
				           <%= i %>
				        </a>
				    </td>
				</tr>
			<% 
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
