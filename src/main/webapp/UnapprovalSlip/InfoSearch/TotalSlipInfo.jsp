<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");

	String Slipcode = request.getParameter("Slip");
	System.out.println("전달받은 전표번호 : " + Slipcode);
	
	String Head_Select_Sql = null;
	PreparedStatement Head_Pstmt = null;
	ResultSet Head_rs = null;
	
	String Line_Select_Sql = null;
	PreparedStatement Line_Pstmt = null;
	ResultSet Line_rs = null;
	
	String Trans_Sql = null;
	PreparedStatement Trans_Pstmt = null;
	ResultSet Trans_rs = null;
	
	String Fr_Curr = null;
	String To_Curr = null;
	String Rate = null;
	Double D_Rate = 0.0;
	int total = 0;
	
	JSONObject jsonResponse = new JSONObject(); // 최종 JSON 응답 객체
	JSONArray headArray = new JSONArray(); // Head 정보를 담을 배열
	JSONArray lineArray = new JSONArray(); // Line 정보를 담을 배열
	System.out.println("잉");
	try{
		System.out.println("잉잉");
		Head_Select_Sql = "SELECT * FROM docworkflowhead WHERE DocNum = ?";
		Head_Pstmt = conn.prepareStatement(Head_Select_Sql);
		Head_Pstmt.setString(1, Slipcode);
		Head_rs = Head_Pstmt.executeQuery();
		
		if(Head_rs.next()){
			JSONObject HeadInfo = new JSONObject();
			HeadInfo.put("H_ComCode", Head_rs.getString("ComCode"));
			HeadInfo.put("H_BA", Head_rs.getString("BizArea"));
			HeadInfo.put("H_CoCt", Head_rs.getString("DocInputDepart"));
			HeadInfo.put("H_Inputer", Head_rs.getString("InputPerson"));
			HeadInfo.put("H_Type", Head_rs.getString("DocType"));
			HeadInfo.put("H_Date", Head_rs.getString("postingDay"));
			headArray.put(HeadInfo);
		}
		
		Line_Select_Sql = "SELECT * FROM fldocline WHERE DocNum = ?";
		Line_Pstmt = conn.prepareStatement(Line_Select_Sql);
		Line_Pstmt.setString(1, Slipcode);
		Line_rs = Line_Pstmt.executeQuery();
		
		while(Line_rs.next()){
			JSONObject LineInfo = new JSONObject();
			Fr_Curr = Line_rs.getString("LCurr");
			To_Curr = Line_rs.getString("TCurr");
			
			Trans_Sql = "SELECT * FROM exchangerate WHERE FrCurrency = ? AND ToCurrency = ? ORDER BY LocalDateTime DESC";
			Trans_Pstmt = conn.prepareStatement(Trans_Sql);
			Trans_Pstmt.setString(1, Fr_Curr);
			Trans_Pstmt.setString(2, To_Curr);
			Trans_rs = Trans_Pstmt.executeQuery();
			if(Trans_rs.next()){
				Rate = Trans_rs.getString("ExchRate").replace(",", "");
				D_Rate = Double.parseDouble(Rate);
				total = (int)Math.round(D_Rate);
			}
			
			LineInfo.put("L_Account", Line_rs.getString("GLAccount"));
			LineInfo.put("L_AccountDes", Line_rs.getString("AcctDescrip"));
			LineInfo.put("L_CD", Line_rs.getString("DebCre"));
			LineInfo.put("L_TransMoney", Line_rs.getString("LAmount"));
			LineInfo.put("L_TransUnit", Line_rs.getString("LCurr"));
			LineInfo.put("L_LocalMoney", Line_rs.getString("TAmount"));
			LineInfo.put("L_LocalUnit", Line_rs.getString("TCurr"));
			LineInfo.put("L_CoCt", Line_rs.getString("UsingDepart"));
			LineInfo.put("L_Ba", Line_rs.getString("UsingBA"));
			LineInfo.put("L_Des", Line_rs.getString("DocDescrip"));
			LineInfo.put("L_Rate", total);
			lineArray.put(LineInfo);
		}
		
		// 최종 응답 객체에 Head와 Line 배열을 추가
		jsonResponse.put("HeadInfo", headArray);
		jsonResponse.put("LineInfo", lineArray);

		// JSON 응답을 출력
		response.getWriter().write(jsonResponse.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}finally {
	    if (Head_rs != null) try { Head_rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (Head_Pstmt != null) try { Head_Pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (Line_rs != null) try { Line_rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (Line_Pstmt != null) try { Line_Pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (Trans_rs != null) try { Trans_rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (Trans_Pstmt != null) try { Trans_Pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	}
%>