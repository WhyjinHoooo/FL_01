<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
    response.setContentType("application/json");
    JSONObject jsonResponse = new JSONObject();

    try {
        String SlipCode = request.getParameter("SlipCode");
        String Opinion = request.getParameter("Opinion");
        
        String Name = (String)session.getAttribute("name"); // 전표입력자/사용자의 이름
        String UserCode = (String)session.getAttribute("UserCode");
        String UserLevel = null;
        String UserCoCt = null;
        String UserComCode = null;
		String UserInfo_Sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = '" + UserCode + "'";
		PreparedStatement UInfoPstmt = conn.prepareStatement(UserInfo_Sql);
		ResultSet UInfo_Rs = UInfoPstmt.executeQuery();
		
		if(UInfo_Rs.next()){
			UserLevel = UInfo_Rs.getString("POSITION");
			UserCoCt = UInfo_Rs.getString("COCT");
			UserComCode = UInfo_Rs.getString("COMCODE");
		}
        
        int level = 1;
        String ApprovalStatus = "B";
        LocalDateTime Date = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String SubmitDate = Date.format(formatter);
        
        String SearchSql = "SELECT * FROM docworkflowline WHERE DocNum = '" + SlipCode + "'";
        PreparedStatement SearchPstmt = conn.prepareStatement(SearchSql);
        ResultSet SearchRs = SearchPstmt.executeQuery();
        if(SearchRs.next()){ // docworkflowline에 SlipCode이 전표번호가 있으면 -> 결재경로가 사전에 등록된 전표 => Head랑 Line 업데이트
        	String Head_Up_Sql = "UPDATE docworkflowhead SET SubmitTime = ?, WFStatus = ?, WFStep = ? WHERE DocNum = ?";
        	PreparedStatement Head_Up_Pstmt = conn.prepareStatement(Head_Up_Sql);
        	Head_Up_Pstmt.setString(1, SubmitDate);
        	Head_Up_Pstmt.setString(2, ApprovalStatus);
        	Head_Up_Pstmt.setInt(3, level);
        	Head_Up_Pstmt.setString(4, SlipCode);
        	Head_Up_Pstmt.executeUpdate();
        	
        	String Line_Up_Sql = "UPDATE " +
                    "    docworkflowline " +
                    "SET " +
                    "    WFType = ?, " +
                    "    DocReviewOpinion = ?, " +
                    "    ReviewTime = ?, " +
                    "    ElapsedHour1 = ? " +
                    "WHERE " +
                    "    DocNum = ? AND " +
                    "    RespPersonName = ?";
			PreparedStatement Line_Up_Pstmt = conn.prepareStatement(Line_Up_Sql);
			Line_Up_Pstmt.setString(1, "S");
			Line_Up_Pstmt.setString(2, Opinion);
			Line_Up_Pstmt.setString(3, SubmitDate);
			Line_Up_Pstmt.setString(4, "00:00:00");
			Line_Up_Pstmt.setString(5, SlipCode);
			Line_Up_Pstmt.setString(6, Name);
			Line_Up_Pstmt.executeUpdate();
        	jsonResponse.put("status", "success");
        }else{ // docworkflowline에 SlipCode이 전표번호가 없는경우 -> 결재경로를 등록하지 않고 저장만 한 전표 => Head는 업데이트, Line은 등록
        	String Head_Up_Sql = "UPDATE docworkflowhead SET SubmitTime = ?, WFStatus = ?, WFStep = ? WHERE DocNum = ?";
        	PreparedStatement Head_Up_Pstmt = conn.prepareStatement(Head_Up_Sql);
        	Head_Up_Pstmt.setString(1, SubmitDate);
        	Head_Up_Pstmt.setString(2, ApprovalStatus);
        	Head_Up_Pstmt.setInt(3, level);
        	Head_Up_Pstmt.setString(4, SlipCode);
        	Head_Up_Pstmt.executeUpdate();
        	
        	String Inputer_Ins_Qry = "INSERT INTO docworkflowline (" // 전표입력자의 정보를 입력한 쿼리문
                    + "`DocNum`,"
                    + "`WFStep`,"
                    + "`WFType`,"
                    + "`ResponsePerson`,"
                    + "`RespPersonName`,"
                    + "`RespOffice`,"
                    + "`RepsDepart`,"
                    + "`WFResult`,"
                    + "`DocReviewOpinion`,"
                    + "`ReviewTime`,"
                    + "`ElapsedHour1`,"
                    + "`ComCode`,"
                    + "`Index`"
                    + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    		PreparedStatement Inputer_Ins_Pstmt = conn.prepareStatement(Inputer_Ins_Qry);
    		Inputer_Ins_Pstmt.setString(1, SlipCode);
    		Inputer_Ins_Pstmt.setString(2, "0");
    		Inputer_Ins_Pstmt.setString(3, "S");
    		Inputer_Ins_Pstmt.setString(4, UserCode);
    		Inputer_Ins_Pstmt.setString(5, Name);
    		Inputer_Ins_Pstmt.setString(6, UserLevel);
    		Inputer_Ins_Pstmt.setString(7, UserCoCt);
    		Inputer_Ins_Pstmt.setString(8, "0");
    		Inputer_Ins_Pstmt.setString(9, Opinion);
    		Inputer_Ins_Pstmt.setString(10, SubmitDate);
    		Inputer_Ins_Pstmt.setString(11, "00:00:00");
    		Inputer_Ins_Pstmt.setString(12, UserComCode);
    		Inputer_Ins_Pstmt.setString(13, UserComCode + SlipCode + "0");
    		Inputer_Ins_Pstmt.executeUpdate();
        	
        	String WF_Sel_Sql = "SELECT * FROM workflow WHERE DocNum = '" + SlipCode + "'";
        	PreparedStatement WF_Sel_Pstmt = conn.prepareStatement(WF_Sel_Sql);
        	ResultSet WF_Sel_Rs = WF_Sel_Pstmt.executeQuery();
        	int i = 1;
        	while(WF_Sel_Rs.next()){
        		String Line_Ins_Qry = "INSERT INTO docworkflowline (" // 결재합의자들의 정보를 입력하는 쿼리문
                        + "`DocNum`,"
                        + "`WFStep`,"
                        + "`WFType`,"
                        + "`ResponsePerson`,"
                        + "`RespPersonName`,"
                        + "`RespOffice`,"
                        + "`RepsDepart`,"
                        + "`WFResult`,"
                        + "`ElapsedHour1`,"
                        + "`ComCode`,"
                        + "`Index`"
                        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        		PreparedStatement Line_Ins_Pstmt = conn.prepareStatement(Line_Ins_Qry);
        		Line_Ins_Pstmt.setString(1, SlipCode);
        		Line_Ins_Pstmt.setString(2, WF_Sel_Rs.getString("WFStep"));
        		Line_Ins_Pstmt.setString(3, WF_Sel_Rs.getString("WFType"));
        		Line_Ins_Pstmt.setString(4, WF_Sel_Rs.getString("ResponsePerson"));
        		Line_Ins_Pstmt.setString(5, WF_Sel_Rs.getString("RespPersonName"));
        		Line_Ins_Pstmt.setString(6, WF_Sel_Rs.getString("RespOffice"));
        		Line_Ins_Pstmt.setString(7, WF_Sel_Rs.getString("RepsDepart"));
        		Line_Ins_Pstmt.setString(8, "0");
        		Line_Ins_Pstmt.setString(9, "00:00:00");
        		Line_Ins_Pstmt.setString(10, UserComCode);
        		Line_Ins_Pstmt.setString(11, UserComCode + SlipCode + i);
        		Line_Ins_Pstmt.executeUpdate();
        		i++;
        		
        	} // while(WF_Sel_Rs.next()){...}의 끝
        	jsonResponse.put("status", "success");
        }
    } catch (SQLException e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResponse.toString());
%>
