<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%
	response.setContentType("application/json");
	JSONObject jsonResponse = new JSONObject();
	String Slipcode = request.getParameter("DocCode");
	
	String sql01 = null;
	String sql02 = null;
	String sql03 = null;
	PreparedStatement pstmt01 = null;
	PreparedStatement pstmt02 = null;
	PreparedStatement pstmt03 = null;
	ResultSet rs01 = null;
	ResultSet rs02 = null;
	ResultSet rs03 = null;
	
	String state = null;
	String Approve  = null;
	try{
		sql01 = "SELECT * FROM workflow WHERE DocNum = ?";
		pstmt01 = conn.prepareStatement(sql01);
		pstmt01.setString(1, Slipcode);
		rs01 = pstmt01.executeQuery();
		if(rs01.next()){
			// 결재경로가 등록되어 있는 경우
			sql02 = "SELECT * FROM docworkflowhead WHERE DocNum = ?";
			pstmt02 = conn.prepareStatement(sql02);
			pstmt02.setString(1, rs01.getString("DocNum"));
			rs02 = pstmt02.executeQuery();
			if(rs02.next()){
				// 전표가 Head테이블에 등록이 되어 있는 경우
				Approve = rs02.getString("WFStatus");
				if(Approve.equals("A")){
					state = "B";
				} else{
					state = "A";
				}
			}
		} else{
			// 결재경로가 등록 안 된 경우 -> '저장'만 한 경우 => 품의 상신도 안 된 전표
			state = "C";
		}
		
		jsonResponse.put("status", state);
	}catch(SQLException e){
		jsonResponse.put("status", "error");
		jsonResponse.put("message", e.getMessage());
		e.printStackTrace();
	}
	out.print(jsonResponse.toString());
    out.flush();
%>