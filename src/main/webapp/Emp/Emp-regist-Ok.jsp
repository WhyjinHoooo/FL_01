<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%! 
    // 메서드 정의는 JSP 선언문 내에서 수행
    public String generateRandomString() {
        int length = 8; // 문자열 길이 8로 고정
        String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder result = new StringBuilder(length);
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            result.append(characters.charAt(index));
        }
        return result.toString();
    }
%>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		JSONObject saveListData = new JSONObject(jsonString.toString());
		
		LocalDateTime now = LocalDateTime.now();
		String Time = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		String ID = saveListData.getString("Emp_id");
		String Id_Des = saveListData.getString("Des");
		
		String ComCode = saveListData.getString("ComCode");
		String ComName = saveListData.getString("Com_Name");
		
		String CCCode = saveListData.getString("CC_Code");
		String CCName = saveListData.getString("CC_Name");
		
		String P_Code = saveListData.getString("AddrCode");
		
		String AddrDetail = saveListData.getString("Addr") + "," + saveListData.getString("AddrDetail");
		
		String Birth = saveListData.getString("Birth");
		
		int Jumin_1st = Integer.parseInt(saveListData.getString("Jumin_1st"));
		int Jumin_2nd = Integer.parseInt(saveListData.getString("Jumin_2nd"));
		
		String gender = null;
		switch((Jumin_2nd / 1000000) % 2){
			case 1:
				gender = "male";
				break;
			case 0:
				gender = "female";
				break;
			default:
				break;
		}
		
		String randomEmail = generateRandomString() + "@naver.com";
		
		String Join = saveListData.getString("join");
		String Retire = saveListData.getString("retire");
		
		if (Retire == null || Retire.trim().isEmpty()) {
			Retire = null;
		}
		
		String Duty = saveListData.getString("duty_code") + "("+ saveListData.getString("duty_Des") +")";
		String Duty_Start = saveListData.getString("duty_Start");
		
		String Title = saveListData.getString("title_Code") + "("+ saveListData.getString("title_Des") +")";
		String Title_Start = saveListData.getString("promot");
		
		String UserDuty = saveListData.getString("UserDutyCode") + "("+ saveListData.getString("UserDutyDes") +")";
		
		int id1 = 17011381;
		int id2 = 76019202;
		
		String sql = "INSERT INTO emp VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		

		pstmt.setString(1, ID);
		pstmt.setString(2, Id_Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, ComName);
		pstmt.setString(5, CCCode);
		pstmt.setString(6, CCName);
		pstmt.setString(7, P_Code);
		pstmt.setString(8, AddrDetail);
		pstmt.setString(9, UserDuty);
		pstmt.setString(10, Birth);
		pstmt.setInt(11, Jumin_1st);
		pstmt.setInt(12, Jumin_2nd);
		pstmt.setString(13, Join);
		pstmt.setString(14, Retire);
		pstmt.setString(15, Duty);
		pstmt.setString(16, Duty_Start);
		pstmt.setString(17, Title);
		pstmt.setString(18, Title_Start);
		pstmt.setString(19, Time);
		pstmt.setInt(20, id1);
		pstmt.setString(21, Time);
		pstmt.setInt(22, id2);
		pstmt.executeUpdate();
		
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
		Result.put("message", "로그인 성공");
		    
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>