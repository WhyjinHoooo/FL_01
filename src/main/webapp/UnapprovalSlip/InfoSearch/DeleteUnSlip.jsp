<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%
	response.setContentType("application/json");
	JSONObject jsonResponse = new JSONObject();
	String Slipcode = request.getParameter("DocCode");
	System.out.println("삭제할 전표 : " + Slipcode);
	String sql = null;
	PreparedStatement pstmt = null;
	try{
		String[] table = {"fldochead", "fldocline", "fidoclineinform", "workflow", "docworkflowhead", "docworkflowline"};
		for(String TableName : table){
			switch(TableName){
			case "fldochead":
				sql = "DELETE FROM fldochead WHERE DocNum = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode);
				pstmt.executeUpdate();
				break;
			case "fldocline":
				sql = "DELETE FROM fldocline WHERE DocNum = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode);
				pstmt.executeUpdate();
				break;			
			case "fidoclineinform":
				sql = "DELETE FROM fidoclineinform WHERE DocNum_LineDetail LIKE ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode + "%");
				pstmt.executeUpdate();
				break;
			case "workflow":
				sql = "DELETE FROM workflow WHERE DocNum = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode);
				String NumRest01 = "SET @CNT = 0";
				String NumRest02 = "UPDATE tmpaccfldocline SET tmpaccfldocline.DocLineItem = @CNT:=@CNT+1";
				
				PreparedStatement Reset01 = conn.prepareStatement(NumRest01);
				PreparedStatement Reset02 = conn.prepareStatement(NumRest02);
				Reset01.executeUpdate();
				Reset02.executeUpdate();
				pstmt.executeUpdate();
				break;
			case "docworkflowhead":
				sql = "DELETE FROM docworkflowhead WHERE DocNum = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode);
				pstmt.executeUpdate();
				break;
			case "docworkflowline":
				sql = "DELETE FROM docworkflowline WHERE DocNum = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, Slipcode);
				pstmt.executeUpdate();
				break;
			}
		}
		jsonResponse.put("status", "success");
	}catch(SQLException e){
		jsonResponse.put("status", "error");
		jsonResponse.put("message", e.getMessage());
		e.printStackTrace();
	}finally{
        if (pstmt != null) try {
        	pstmt.close(); 
        	} catch (SQLException ignore) {}
	}
	out.print(jsonResponse.toString());
    out.flush();
%>