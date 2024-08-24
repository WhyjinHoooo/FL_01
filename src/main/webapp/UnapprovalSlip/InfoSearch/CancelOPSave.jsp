<%@page import="java.time.Duration"%>
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
        String SlipCode = request.getParameter("SlipCode"); // 결재자 반려의견 작성한 전표
        String Opinion = request.getParameter("Opinion"); // 결재자의 반려의견
        String Name = (String)session.getAttribute("name"); // 결재자의 이름
        String UserCode = (String)session.getAttribute("UserCode"); // 결재자의 사원 코드 또는 ID
        
        System.out.println("ajax가 실행되는 확인하기 위해 전달받은 반려할 전표 : " + SlipCode);
        System.out.println("ajax가 실행되는 확인하기 위해 전달받은 반려할 결재자 : " + UserCode);
        
        String Text_Lv = null;
        int Num_Lv = 0;
        String BeforeDate = null;
       
    	LocalDateTime Calendar = LocalDateTime.now();
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    	String Today = Calendar.format(formatter);
        
		String SlipFind_Sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND ResponsePerson = ?";
		PreparedStatement SlipFind_Pstmt = conn.prepareStatement(SlipFind_Sql);
		SlipFind_Pstmt.setString(1, SlipCode);
		SlipFind_Pstmt.setString(2, UserCode);
		ResultSet SlipFind_Rs = SlipFind_Pstmt.executeQuery();
		
		if(SlipFind_Rs.next()){
			Num_Lv = Integer.parseInt(SlipFind_Rs.getString("WFStep")) - 1; // 전 결재자의 lv -> int형
			Text_Lv = Integer.toString(Num_Lv); // int타입으로 가져온 전 결재자의 lv를 String으로 형변환
		}
        
		String Before_Sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND WFStep = ?"; // 전 결재자의 정보 가져오기
		PreparedStatement Before_Pstmt = conn.prepareStatement(Before_Sql);
		Before_Pstmt.setString(1, SlipCode);
		Before_Pstmt.setString(2, Text_Lv);
		ResultSet Before_Rs = Before_Pstmt.executeQuery();
		
		if(Before_Rs.next()){
			LocalDateTime Example =  Before_Rs.getTimestamp("ReviewTime").toLocalDateTime();// 전 결재자가 작성한 시점
			BeforeDate = Example.format(formatter);
			System.out.println("ajax가 실행되는 확인하기 위해 전달받은 날짜 : "+ BeforeDate);
		}
		
        if(BeforeDate != null){
        	LocalDateTime BeforeDateResult = LocalDateTime.parse(BeforeDate, formatter);
        	Duration TimeGap = Duration.between(BeforeDateResult, Calendar);
        	
        	long hour = TimeGap.toHours();
        	long minute = TimeGap.toMinutes()%60;
        	long second = TimeGap.toSeconds()%60;

        	System.out.println("반려 시간 차이 : " + hour + "시간, " + minute + "분, " + second + "초");
        	
        	String Update_Sql = "UPDATE " +
                    "    docworkflowline " +
                    "SET " +
                    "    WFResult = ?, " +
                    "    DocReviewOpinion = ?, " +
                    "    ReviewTime = ?, " +
                    "    ElapsedHour1 = ?, " +
                    "    WFType = ? " +
                    "WHERE " +
                    "    DocNum = ? " +
                    "    AND ResponsePerson = ?";
			PreparedStatement Update_Pstmt = conn.prepareStatement(Update_Sql);
			Update_Pstmt.setString(1, "1");
			Update_Pstmt.setString(2, Opinion);
			Update_Pstmt.setString(3, Today);
			Update_Pstmt.setString(4, hour + ":" + minute+ ":" + second);
			Update_Pstmt.setString(5, "E");
			Update_Pstmt.setString(6, SlipCode);
			Update_Pstmt.setString(7, UserCode);
			Update_Pstmt.executeUpdate();
			
			String UpDate_Head_Slip = "UPDATE " +
                    "    docworkflowhead " +
                    "SET " +
                    "    WFStatus = ?" +
                    "WHERE " +
                    "    DocNum = ? ";
			PreparedStatement Update_Head_Pstmt = conn.prepareStatement(UpDate_Head_Slip);
			Update_Head_Pstmt.setString(1, "E");
			Update_Head_Pstmt.setString(2, SlipCode);
			Update_Head_Pstmt.executeUpdate();
        }
       jsonResponse.put("status", "success");
    } catch (SQLException e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResponse.toString());
%>
