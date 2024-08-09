<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
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
	JSONObject ApprovalData = (JSONObject) parser.parse(jsonData); // DecPatPath.jsp에서 받은 list IntegratedList
	
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	DateTimeFormatter formatter02 = DateTimeFormatter.ofPattern("HH:mm");
	String todayDate = today.format(formatter);
	String todayTime = today.format(formatter02);
	
	String SlipCode = null;
	String UserId = null;
	String UserBizArea = null;
	String USerCoCt = null;
	String UserComCode = null;
	String SlipType = null;
	String briefs = null;
	String TableKeyIndex = null;
	String WriterName = (String)session.getAttribute("name");
	String EntryDate = null;
	
	try{
		// '품의상신' 버튼을 클릭했을 때, 임시저장테이블에 있던 데이터 저장 기능 추가
		String SearchHead = "SELECT * FROM tmpaccfldochead";
		PreparedStatement SH_Pstmt = conn.prepareStatement(SearchHead);
		ResultSet SH_rs =SH_Pstmt.executeQuery();
		
		String SearchChild = "SELECT * FROM tmpaccfldocline";
		PreparedStatement SC_Pstmt = conn.prepareStatement(SearchChild);
		ResultSet SC_rs =SC_Pstmt.executeQuery();
		
		String SearchLine = "SELECT * FROM tmpaccfidoclineinform";
		PreparedStatement SL_Pstmt = conn.prepareStatement(SearchLine);
		ResultSet SL_rs =SL_Pstmt.executeQuery();
		
		while(SH_rs.next()){
			String CopyHead = "INSERT INTO fldochead SELECT * FROM tmpaccfldochead";
			PreparedStatement CH_pstmt = conn.prepareStatement(CopyHead);
			CH_pstmt.executeUpdate();
			
			String DelHead = "DELETE FROM tmpaccfldochead";
			PreparedStatement DH_pstmt = conn.prepareStatement(DelHead);
			DH_pstmt.executeUpdate();
		} 
		while(SC_rs.next()){
			String CopyChild = "INSERT IGNORE INTO fldocline (DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson) " +
	                   "SELECT DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson " +
	                   "FROM tmpaccfldocline";
			PreparedStatement CC_pstmt = conn.prepareStatement(CopyChild);
			CC_pstmt.executeUpdate();
			
			String DelChild = "DELETE FROM tmpaccfldocline";
			PreparedStatement DC_pstmt = conn.prepareStatement(DelChild);
			DC_pstmt.executeUpdate();
		}
		while(SL_rs.next()){
			String CopyLineItem = "INSERT INTO fidoclineinform SELECT * FROM tmpaccfidoclineinform";
			PreparedStatement CL_pstmt = conn.prepareStatement(CopyLineItem);
			CL_pstmt.executeUpdate();
			
			String DelLine = "DELETE FROM tmpaccfidoclineinform";
			PreparedStatement DL_pstmt = conn.prepareStatement(DelLine);
			DL_pstmt.executeUpdate();
		}
		
		if(ApprovalData != null){
			System.out.println("ApprovalProcess.jsp: 1st Success");
	
			SlipCode = (String)ApprovalData.get("SlipNo");
			SlipType = SlipCode.substring(0, 3);
			UserId = (String)ApprovalData.get("User");
			UserBizArea = (String)ApprovalData.get("UserBizArea");
			USerCoCt = (String)ApprovalData.get("TargetDepartCd");
			UserComCode = (String)ApprovalData.get("UserDepart");
			briefs = (String)ApprovalData.get("briefs");
			TableKeyIndex = UserComCode + SlipCode;
			EntryDate = (String)ApprovalData.get("Date");
			
			
			System.out.println(SlipCode);
			System.out.println(SlipType);
			System.out.println(UserId);
			System.out.println(UserBizArea);
			System.out.println(USerCoCt);
			System.out.println(UserComCode);
			System.out.println(briefs);
			System.out.println(EntryDate);
			/* 
			1st Success
			FIG20240718S0001 : 전펴번호
			FIG : 전표유형
			2024060002 :전표 입력자
			BA101 : 전표입력 BA
			A1001 : 전표입력 부서
			E1000 : 회사
			asdasdasdasd : 적요
			*/
			String DH_S_Sql = "SELECT * FROM fldochead WHERE DocNum = ?"; // fldochead_Srearch_Sql
			PreparedStatement DH_S_Pstmt = conn.prepareStatement(DH_S_Sql);
			DH_S_Pstmt.setString(1, SlipCode);
			ResultSet DH_S_Rs = DH_S_Pstmt.executeQuery();
			
			String WFCH_Sql = "SELECT COUNT(ResponsePerson) as Total FROM workflow WHERE DocNum = ? AND DocType = ? AND BizArea = ? AND DocInputDepart = ? AND InputPerson = ? AND ComCode = ?";
			//WorkFlowCheck_Sql
			PreparedStatement WFCH_Pstmt = conn.prepareStatement(WFCH_Sql);
			WFCH_Pstmt.setString(1, SlipCode);
			WFCH_Pstmt.setString(2, SlipType);
			WFCH_Pstmt.setString(3, UserBizArea);
			WFCH_Pstmt.setString(4, USerCoCt);
			WFCH_Pstmt.setString(5, UserId);
			WFCH_Pstmt.setString(6, UserComCode);
			
			ResultSet WFCH_Rs = WFCH_Pstmt.executeQuery();
			int TotalPerson = 0;
			if(WFCH_Rs.next()){
				TotalPerson = WFCH_Rs.getInt("Total");
				System.out.println("WorkFlow 개수 : " + TotalPerson);
				
				String DWFH_In_Sql = "INSERT INTO docworkflowhead ("
					+ "`DocNum`,"
					+ "`DocType`,"
					+ "`postingDay`,"
					+ "`BizArea`,"
					+ "`DocInputDepart`,"
					+ "`InputPerson`,"
					+ "`DocDescrip`,"
					+ "`SubmitTime`,"
					+ "`CompleteTime`,"
					+ "`WFStatus`,"
					+ "`WFStep`,"
					+ "`ElapsedHour`,"
					+ "`ComCode`,"
					+ "`TableKeyIndex`"
					+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement DWFH_In_Pstmt = conn.prepareStatement(DWFH_In_Sql);
				DWFH_In_Pstmt.setString(1, SlipCode);
				DWFH_In_Pstmt.setString(2, SlipType);
				DWFH_In_Pstmt.setString(3, EntryDate);
				DWFH_In_Pstmt.setString(4, UserBizArea);
				DWFH_In_Pstmt.setString(5, USerCoCt);
				DWFH_In_Pstmt.setString(6, UserId);
				DWFH_In_Pstmt.setString(7, briefs);
				DWFH_In_Pstmt.setString(8, todayDate);
				DWFH_In_Pstmt.setNull(9, java.sql.Types.TIMESTAMP);
				DWFH_In_Pstmt.setString(10, "B");
				DWFH_In_Pstmt.setInt(11, 1);
				DWFH_In_Pstmt.setInt(12, 0);
				DWFH_In_Pstmt.setString(13, UserComCode);
				DWFH_In_Pstmt.setString(14, TableKeyIndex);
				
				DWFH_In_Pstmt.executeUpdate();
				
				String WFInfo_Sql = "SELECT * FROM workflow WHERE DocNum = '"+ SlipCode +"'";
	            PreparedStatement WFI_Pstmt = conn.prepareStatement(WFInfo_Sql);
	            ResultSet WFI_Rs = WFI_Pstmt.executeQuery();
				
	            String Writer_Info_SSql = "SELECT * FROM emp WHERE EMPLOYEE_ID = '" + UserId + "'"; // Writer_Info_S(earch)
	            PreparedStatement Writer_Info_SPstmt = conn.prepareStatement(Writer_Info_SSql);
	            ResultSet Writer_Info_SRs = Writer_Info_SPstmt.executeQuery();
	            if(Writer_Info_SRs.next()){
	            	String Writer_Sql = "INSERT INTO docworkflowline ("
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
		            PreparedStatement Writer_Pstmt = conn.prepareStatement(Writer_Sql);
		            Writer_Pstmt.setString(1, SlipCode);
		            Writer_Pstmt.setString(2, "0");
		            Writer_Pstmt.setString(3, "S");
		            Writer_Pstmt.setString(4, UserId);
		            Writer_Pstmt.setString(5, WriterName);
		            Writer_Pstmt.setString(6, Writer_Info_SRs.getString("POSITION"));
		            Writer_Pstmt.setString(7, Writer_Info_SRs.getString("COCT"));
		            Writer_Pstmt.setString(8, "0");
		            Writer_Pstmt.setString(9, "없음");
		            Writer_Pstmt.setString(10, todayDate);
		            Writer_Pstmt.setString(11, "00:00");
		            Writer_Pstmt.setString(12, UserComCode);
		            Writer_Pstmt.setString(13, UserComCode + SlipCode + "0");
		            
		            Writer_Pstmt.executeUpdate();
	            }
	            
	            int index = 1;
	            while (WFI_Rs.next()) {
	                String DWFL_Sql = "INSERT INTO docworkflowline ("
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
	                PreparedStatement DWFL_In_Pstmt = conn.prepareStatement(DWFL_Sql);

	                DWFL_In_Pstmt.setString(1, SlipCode);
	                DWFL_In_Pstmt.setString(2, WFI_Rs.getString("WFStep"));
	                DWFL_In_Pstmt.setString(3, WFI_Rs.getString("WFType"));
	                DWFL_In_Pstmt.setString(4, WFI_Rs.getString("ResponsePerson"));
	                DWFL_In_Pstmt.setString(5, WFI_Rs.getString("RespPersonName"));
	                DWFL_In_Pstmt.setString(6, WFI_Rs.getString("RespOffice"));
	                DWFL_In_Pstmt.setString(7, WFI_Rs.getString("RepsDepart"));
	                DWFL_In_Pstmt.setString(8, "0");
	                DWFL_In_Pstmt.setString(9, "00:00");
	                DWFL_In_Pstmt.setString(10, UserComCode);
	                DWFL_In_Pstmt.setString(11, UserComCode + SlipCode + index);
	                DWFL_In_Pstmt.executeUpdate();

	                index++;
	            } // while (WFI_Rs.next()){...}의 끝
				if(DH_S_Rs.next()){
					System.out.println("fldochead의 DocSubmit 변경 가능");
					String DH_Up_Sql = "UPDATE fldochead SET DocSubmit = ? WHERE DocNum = ? AND DocSubmit = ?"; // fldochead_Srearch_Sql
					// UPDATE fldochead SET DocSubmit = ? WHERE DocNum = ?;
					PreparedStatement DH_Up_Pstmt = conn.prepareStatement(DH_Up_Sql);
					
					if(DH_S_Rs.getString("DocSubmit").equals("No")){
						DH_Up_Pstmt.setString(1, "Yes");
						DH_Up_Pstmt.setString(2, SlipCode);
						DH_Up_Pstmt.setString(3, "No");
						
						DH_Up_Pstmt.executeUpdate();
					} // if(DH_S_Rs.getString("DocSubmit").equals("No")){...}의 끝
				} // if(DH_S_Rs.next()){...}의 끝
			} // if(WFCH_Rs.next()){...}의 끝
		} // if(ApprovalData != null){...}의 끝
		jsonResponse.put("status", "success");
        jsonResponse.put("message", "데이터 처리가 완료되었습니다.");
    } catch (SQLException e) {
        e.printStackTrace();
        jsonResponse.put("status", "error");
        jsonResponse.put("message", "데이터 처리 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
    	response.setContentType("application/json"); // HttpServletResponse를 사용하여 콘텐츠 타입 설정
        response.setCharacterEncoding("UTF-8"); // HttpServletResponse를 사용하여 문자 인코딩 설정
        out.print(jsonResponse.toJSONString());
        out.flush();
    }
%>