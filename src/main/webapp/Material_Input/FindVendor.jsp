<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String PlantComCode = request.getParameter("PlantComCode");
	
	System.out.println("전달받은 Plant Code : " + PlantComCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM vendor WHERE ComCode = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, PlantComCode);
	
	rs = pstmt.executeQuery();
	
	JSONObject jsonObject = new JSONObject();
	
	if(rs.next()){
		String VenCode = rs.getString("VenCode");
		String VenDes = rs.getString("Des");
		System.out.println("Vendor Code : " + VenCode);
		System.out.println("Vendor Description : " + VenDes);
		
		jsonObject.put("VenCode", VenCode);
		jsonObject.put("VenDes", VenDes);
	}
	
	response.setContentType("application/json"); /* 데이터의 형식이 json임을 알려줌 */
	response.setCharacterEncoding("UTF-8"); /* UTF-8로 번역을 해줌 */
	response.getWriter().write(jsonObject.toString()); /* JSONObject를 문자열로 변환한 결과를 쓰는 역할을 합니다. 이를 통해 서버는 JSON 형식의 데이터를 클라이언트에게 전송 */
	
} catch(SQLException e){
	e.printStackTrace();
}
%>
 --%>
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
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT * FROM vendor WHERE ComCode = ?";
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, ComCode); // ComCode 값을 sql 쿼리에 설정
		        
		        rs = pstmt.executeQuery();
		        
		        if(!rs.next()){ // 데이터가 없을 경우
		    %>
		        <tr>
		            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Plant를 선택해주세요.</a></td>
		        </tr>
		    <%  
		        } else { // 데이터가 있을 경우
		            do {
		    %>
		                <tr>
		                	<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.VendorCode').value='<%=rs.getString("VenCode")%>'; window.opener.document.querySelector('.VendorDes').value='<%=rs.getString("Des")%>';window.opener.document.querySelector('.VendorCode').dispatchEvent(new Event('input')); window.close();"><%=rs.getString("VenCode") %></a></td>
		                    <td><%=rs.getString("Des") %></td>
		                </tr>
		    <%  
		            } while(rs.next());
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
 