<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String SLOCCode = request.getParameter("sloccode");
	
	System.out.println("전달받은 납품S.Location Code : " + SLOCCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM storage WHERE STORAGR_ID = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, SLOCCode);
	
	rs = pstmt.executeQuery();
	
	JSONObject jsonObject = new JSONObject();
	
	if(rs.next()){
		String SLOC_name = rs.getString("STORAGR_NAME");
		System.out.println("Storage Name : " + SLOC_name);
		
		jsonObject.put("SLocName", SLOC_name);
	}
	
	response.setContentType("application/json"); /* 데이터의 형식이 json임을 알려줌 */
	response.setCharacterEncoding("UTF-8"); /* UTF-8로 번역을 해줌 */
	response.getWriter().write(jsonObject.toString()); /* JSONObject를 문자열로 변환한 결과를 쓰는 역할을 합니다. 이를 통해 서버는 JSON 형식의 데이터를 클라이언트에게 전송 */
	
} catch(SQLException e){
	e.printStackTrace();
}
%>

