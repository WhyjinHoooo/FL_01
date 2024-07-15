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
	//			0		1			2				3			
	};
	String[] Approver = {
			"AppCoCtName", "AppCoCt", "AppName", "AppRank", "ApproverCode", "PayOp",
	//			  0				1		  2		     3			  4		      5			
	};
	int numRecords = 0;
	String ST_numRecords = null;
	if(CombinedData != null){
		System.out.println("1차 성공");
		UserInfo = (JSONObject)CombinedData.get("InputInfo");
		ApproverInfo = (JSONObject)CombinedData.get("EvaluList");
		
		numRecords = ApproverInfo.size() / Approver.length;
		//						12					6
		ST_numRecords = String.valueOf(ApproverInfo.size());
		
		for (int i = 1; i <= numRecords; i++) { // 예시로 3번까지 그룹화
			JSONObject approverGroup = new JSONObject();
			for (String key : Approver) {
				String groupKey = key + "_" + i;
				approverGroup.put(key, ApproverInfo.get(groupKey)); // 이 부분도 수정 없음
			}
			ApproverInfo.put(i, approverGroup); // 그룹화된 데이터를 새로운 키로 저장
		}
		// 그룹화된 ApproverInfo 출력
		System.out.println("그룹화된 ApproverInfo: " + ApproverInfo.toJSONString());
		System.out.println("그룹화된 ApproverInfo의 길이: " + ApproverInfo.size());
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
		for(int A = 1 ; A <= numRecords ; A++){
			for(int j = 0 ; j <= User.length ; j++){
				String USer_Key = User[j];
				String USer_Val = (UserInfo.get(USer_Key) != null) ? UserInfo.get(USer_Key).toString() : "없음";
				
				switch(USer_Key){
					case "SlipNo": // 0
						WF_Pstmt.setString(1, USer_Val);
						WF_Pstmt.setString(2, USer_Val.substring(0, 3));
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
					case "Company": // 4
						WF_Pstmt.setString(13, );
						break;
				}
			}
		}
	}catch(SQLException e){
		e.printStackTrace();
	}
%>