<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String SlipCode = request.getParameter("SlipCode");
	String Inputer = request.getParameter("User");
	String InputerComCode = request.getParameter("ComCode");
	String InputerBA = request.getParameter("BA");
	String InputerCoCt = request.getParameter("COCT");
	
	System.out.println("SlipCode : " + SlipCode);
	System.out.println("Inputer : " + Inputer);
	System.out.println("InputerComCode : " + InputerComCode);
	System.out.println("InputerBA : " + InputerBA);
	System.out.println("InputerCoCt : " + InputerCoCt);
	
	try{

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
		
		String FinalSearchSql = "SELECT * FROM workflow WHERE DocNum = ?";
		PreparedStatement FSS_Pstmt = conn.prepareStatement(FinalSearchSql);
		FSS_Pstmt.setString(1, SlipCode);
		ResultSet FSS_rs = FSS_Pstmt.executeQuery();
		if(!FSS_rs.next()){
			// WorkFlow에 데이터가 없는 경우
			SearchHead = "SELECT * FROM fldochead WHERE DocNum = '"+ SlipCode +"'";
			SH_Pstmt = conn.prepareStatement(SearchHead);
			SH_rs =SH_Pstmt.executeQuery();
			if(SH_rs.next()){
				System.out.println("테스트22222222222222222222222222");
				String DWFH_In_Sql = "INSERT INTO docworkflowhead ("
						+ "`DocNum`,"
						+ "`DocType`,"
						+ "`BizArea`,"
						+ "`DocInputDepart`,"
						+ "`InputPerson`,"
						+ "`DocDescrip`,"
						+ "`SubmitTime`,"
						+ "`WFStatus`,"
						+ "`WFStep`,"
						+ "`ElapsedHour`,"
						+ "`ComCode`,"
						+ "`TableKeyIndex`"
						+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement DWFH_In_Pstmt = conn.prepareStatement(DWFH_In_Sql);
				DWFH_In_Pstmt.setString(1, SlipCode);
				DWFH_In_Pstmt.setString(2, SlipCode.substring(0, 3));
				DWFH_In_Pstmt.setString(3, InputerBA);
				DWFH_In_Pstmt.setString(4, InputerCoCt);
				DWFH_In_Pstmt.setString(5, Inputer);
				DWFH_In_Pstmt.setString(6, SH_rs.getString("DocDescrip"));
				DWFH_In_Pstmt.setString(7, "A");
				DWFH_In_Pstmt.setInt(8, 0);
				DWFH_In_Pstmt.setInt(9, 0);
				DWFH_In_Pstmt.setString(10, InputerComCode);
				DWFH_In_Pstmt.setString(11, InputerComCode + SlipCode);
				
				DWFH_In_Pstmt.executeUpdate();
			} // if(SH_rs.next()){...}의 끝
		} else{
			// workflow에 데이터가 있는 경우
			SearchHead = "SELECT * FROM fldochead WHERE DocNum = '"+ SlipCode +"'";
			SH_Pstmt = conn.prepareStatement(SearchHead);
			SH_rs =SH_Pstmt.executeQuery();
			if(SH_rs.next()){
				String DWFH_In_Sql = "INSERT INTO docworkflowhead ("
						+ "`DocNum`,"
						+ "`DocType`,"
						+ "`BizArea`,"
						+ "`DocInputDepart`,"
						+ "`InputPerson`,"
						+ "`DocDescrip`,"
						+ "`WFStatus`,"
						+ "`WFStep`,"
						+ "`ElapsedHour`,"
						+ "`ComCode`,"
						+ "`TableKeyIndex`"
						+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement DWFH_In_Pstmt = conn.prepareStatement(DWFH_In_Sql);
				DWFH_In_Pstmt.setString(1, SlipCode);
				DWFH_In_Pstmt.setString(2, SlipCode.substring(0, 3));
				DWFH_In_Pstmt.setString(3, InputerBA);
				DWFH_In_Pstmt.setString(4, InputerCoCt);
				DWFH_In_Pstmt.setString(5, Inputer);
				DWFH_In_Pstmt.setString(6, SH_rs.getString("DocDescrip"));
				DWFH_In_Pstmt.setString(7, "A");
				DWFH_In_Pstmt.setInt(8, 0);
				DWFH_In_Pstmt.setInt(9, 0);
				DWFH_In_Pstmt.setString(10, InputerComCode);
				DWFH_In_Pstmt.setString(11, InputerComCode + SlipCode);
				DWFH_In_Pstmt.executeUpdate();
			}
			
			String UserInfo_Sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = '"+ Inputer +"'";
			PreparedStatement UserInfo_Pstmt = conn.prepareStatement(UserInfo_Sql);
			ResultSet UserInfo_Rs = UserInfo_Pstmt.executeQuery();
			if(UserInfo_Rs.next()){
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
                        + "`ComCode`,"
                        + "`Index`"
                        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement Writer_Pstmt = conn.prepareStatement(Writer_Sql);
				Writer_Pstmt.setString(1, SlipCode);
				Writer_Pstmt.setString(2, "0");
				Writer_Pstmt.setString(3, "NS"); // Not 상신
				Writer_Pstmt.setString(4, Inputer);
				Writer_Pstmt.setString(5, UserInfo_Rs.getString("EMPLOYEE_NAME"));
				Writer_Pstmt.setString(6, UserInfo_Rs.getString("POSITION"));
				Writer_Pstmt.setString(7, UserInfo_Rs.getString("COCT"));
				Writer_Pstmt.setString(8, "0");
				Writer_Pstmt.setString(9, "품의 상신 안됌");
				Writer_Pstmt.setString(10, InputerComCode);
				Writer_Pstmt.setString(11, InputerComCode + SlipCode + "0");
				
				Writer_Pstmt.executeUpdate();
			}
			
			FSS_rs.beforeFirst();
			/* 
			workflow에 데이터가 2개 있음에도 불구하고 if(!FSS_rs.next()) 때문에 workflow에에 저장된 첫번째 데이터를 읽어서 
			2개의 데이터 중 2번째 데이터만 입력되는 문제가 발생
			그래서 ResultSet 포인터를 처음으로 재설정하기 위해 FSS_rs.beforeFirst();를 추가
			*/
			
			int index = 1;
			while(FSS_rs.next()){
				String DWFL_Sql = "INSERT INTO docworkflowline ("
                        + "`DocNum`,"
                        + "`WFStep`,"
                        + "`WFType`,"
                        + "`ResponsePerson`,"
                        + "`RespPersonName`,"
                        + "`RespOffice`,"
                        + "`RepsDepart`,"
                        + "`WFResult`,"
                        + "`ComCode`,"
                        + "`Index`"
                        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement DWFL_In_Pstmt = conn.prepareStatement(DWFL_Sql);
                DWFL_In_Pstmt.setString(1, SlipCode);
                DWFL_In_Pstmt.setInt(2, index);
                DWFL_In_Pstmt.setString(3, FSS_rs.getString("WFType"));
                DWFL_In_Pstmt.setString(4, FSS_rs.getString("ResponsePerson"));
                DWFL_In_Pstmt.setString(5, FSS_rs.getString("RespPersonName"));
                DWFL_In_Pstmt.setString(6, FSS_rs.getString("RespOffice"));
                DWFL_In_Pstmt.setString(7, FSS_rs.getString("RepsDepart"));
                DWFL_In_Pstmt.setString(8, "0");
                DWFL_In_Pstmt.setString(9, InputerComCode);
                DWFL_In_Pstmt.setString(10, InputerComCode + SlipCode + index);
                
                DWFL_In_Pstmt.executeUpdate();
                index++;
			}
		
		}
		
		out.println("데이터 처리가 완료되었습니다.");
	}catch(SQLException e){
		e.printStackTrace();
		out.println("데이터 처리 중 오류가 발생했습니다: " + e.getMessage());
	}
%>
</body>
</html>