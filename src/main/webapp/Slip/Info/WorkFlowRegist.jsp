<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	BufferedReader reader = request.getReader();
	StringBuilder sb = new StringBuilder();
	String line;
	JSONObject jsonResponse = new JSONObject();
	while((line = reader.readLine()) != null){
		sb.append(line);
	}
	/* 
	ajax에서 전달한 데이터를 BufferedReader reader에 받아온다.
	그리고 reader.readLine()을 한 줄씩 읽으면서 line변수에 저장해서, 해당 값이 null인지 점검
	그렇게 해서, null값이 아니면 StringBuilder sb에 한 줄씩 저장
	*/
	String jsonData = sb.toString();
	JSONParser parser = new JSONParser();
	JSONObject CombinedData = (JSONObject) parser.parse(jsonData); // DecPatPath.jsp에서 받은 list IntegratedList
	
	JSONObject UserInfo = new JSONObject();
	JSONObject ApproverInfo = new JSONObject();
	
	String[] User = {
			"SlipNo", "User", "UserBizArea", "TargetDepartCd", "Company",
	//			0		1			2				3			   4
	};
	String[] Approver = {
			 "AppCoCt", "AppName", "AppRank", "ApproverCode", "PayOp",
	//			  0				1		  2		     3			  4		      5			
	};
	int numRecords = 0;
	String ST_numRecords = null;
	if(CombinedData != null){
		System.out.println("1차 성공");
		UserInfo = (JSONObject)CombinedData.get("InputInfo");
		ApproverInfo = (JSONObject)CombinedData.get("EvaluList");
		
		numRecords = ApproverInfo.size() / Approver.length;
		//	2					10					5
		ST_numRecords = String.valueOf(ApproverInfo.size());
		
		for (int i = 1; i <= numRecords; i++) { // 예시로 3번까지 그룹화
			JSONObject approverGroup = new JSONObject();
			for (String key : Approver) {
				String groupKey = key + "_" + i;
				approverGroup.put(key, ApproverInfo.get(groupKey)); // 이 부분도 수정 없음
			}
			// ApproverInfo.put(i, approverGroup); // 그룹화된 데이터를 새로운 키로 저장
			ApproverInfo.put("Group_" + i, approverGroup); 
		}
	}
	String WF_Sql = "INSERT INTO workflow ("
            + "`DocNum`, "
            + "`DocType`, "
            + "`BizArea`, "
            + "`DocInputDepart`, "
            + "`InputPerson`, "
            + "`WFStep`, "
            + "`WFType`, "
            + "`ResponsePerson`, "
            + "`RespPersonName`, "
            + "`RespOffice`, "
            + "`RepsDepart`, "
            + "`ComCode`, "
            + "`TableKeyIndex`"
            + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement WF_Pstmt = conn.prepareStatement(WF_Sql);
	try{
		for(int j = 1 ; j <= numRecords ; j++){
			for(int k = 0 ; k < User.length ; k++){
				String USer_Key = User[k];
				String USer_Val = (UserInfo.get(USer_Key) != null) ? UserInfo.get(USer_Key).toString() : "없음";
				/* System.out.println("입력자 정보 : " + USer_Val); */
				switch(USer_Key){
					case "SlipNo": // 0
						WF_Pstmt.setString(1, USer_Val);
						WF_Pstmt.setString(2, USer_Val.substring(0, 3));
						WF_Pstmt.setInt(6, j);
						WF_Pstmt.setString(13, UserInfo.get(User[k+4]).toString() + USer_Val + j);
						break;
					case "User": // 1
						WF_Pstmt.setString(5, USer_Val);
						break;
					case "UserBizArea": // 2
						WF_Pstmt.setString(3, USer_Val);
						break;
					case "TargetDepartCd": // 3
						WF_Pstmt.setString(4, USer_Val);
						break;
					case "Company":
						WF_Pstmt.setString(12, USer_Val);
						break;
				}
			}
			//JSONObject approverData = (JSONObject) ApproverInfo.get(String.valueOf(j));
			/*
			-> JSONObject approverData = (JSONObject) ApproverInfo.get("Group_" + j);
			를 사용하는 이유는 위에서 
			-> ApproverInfo.put("Group_" + i, approverGroup);
			다음과 같이 그룹화했기 떄문이다.
			-> ApproverInfo.put(i, approverGroup); 이렇게 숫자 키로 저장하면 기존의 저장된 데이터의 문자 키와 혼동이 생겨 데이터를 관리하기 어렵기 때문
			*/
			JSONObject approverData = (JSONObject) ApproverInfo.get("Group_" + j); 
			/* System.out.println(approverData); */
			if(approverData != null){
				for(int a = 0 ; a < Approver.length ; a++){
					String AppKey = Approver[a];
					String AppValue = (approverData.get(AppKey) != null) ? approverData.get(AppKey).toString() : "없음";
					//System.out.println("결재자 정보 : " + AppValue);
						switch (AppKey) {
	                    case "AppCoCt": // 0
	                        WF_Pstmt.setString(11, AppValue);
	                        break;
	                    case "AppName": // 1
	                        WF_Pstmt.setString(8, AppValue);
	                        break;
	                    case "AppRank": // 2
	                        WF_Pstmt.setString(10, AppValue);
	                        break;
	                    case "ApproverCode": // 3
	                        WF_Pstmt.setString(7, AppValue);
	                        break;
	                    case "PayOp": // 4
	                        WF_Pstmt.setString(9, AppValue);
	                        break;
	                    default:
	                        break;
                	}
				}
			}
			WF_Pstmt.executeUpdate();
		}
		jsonResponse.put("status", "success");
	}catch(SQLException e){
		e.printStackTrace();
		e.printStackTrace();
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
	}finally {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }
%>