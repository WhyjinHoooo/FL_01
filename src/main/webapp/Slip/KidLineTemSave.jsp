<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
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
	JSONObject CombinedData = (JSONObject) parser.parse(jsonData);
	
	JSONObject TempChild = new JSONObject();
	JSONObject TempLineForm = new JSONObject();

	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	String todayDate = today.format(formatter);
	
	String[] ChildKey = {
		    "SlipNo", "DocNumber","Original", "AccSubject", "AccSubjectDes", "DeCre", "money-code","DealPrice","ledcurrency","ledPrice",
		    "Deptd","DeptdDes","AdminAlloc","briefs","Date","UserDepart","User",
		};

	String[] LineKey = {
		    "SlipNo", "DocNumber","CardNumVal","ApprovalDateVal","ApprovalNumVal","UseNationVal","TaxIdentiNumVal","UsingPlaceAddVal",
		};
	String[] HeadKey = {
			"SlipNo", "Date", "briefs", "Deptd", "AdminAlloc", "UserDepart", "User", "InputDate", 
		//		0		1		 2		   3		  4				5		    6		   7
	};

		if(CombinedData != null){
		    if(CombinedData.containsKey("TmpAccFLForm")){
		        System.out.println("1번");
		        
		        TempChild = (JSONObject)CombinedData.get("TmpAccFLine");
		        TempLineForm = (JSONObject)CombinedData.get("TmpAccFLForm");
		        /* for(String Ckey : ChildKey){
					System.out.println(Ckey + ": " + TempChild.get(Ckey));
				} */
				/*for(String Lkey : LineKey){
					System.out.println(Lkey + ": " + TempLineForm.get(Lkey));
				} */
		        /* for(String Hkey : HeadKey){
					System.out.println(Hkey + ": " + TempChild.get(Hkey));
				} */
				String TemFlHeadSql = "INSERT INTO tmpaccfldochead(DocType, DocNum, PostingDate, DocDescrip, DocInputDepart, DocInputBA, ComCode, InputPerson, DocCreteDate) "+
										"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement TemFlHeadPstmt = conn.prepareStatement(TemFlHeadSql);
				
				String TemFlHeadCheck_Sql = "SELECT * FROM tmpaccfldochead WHERE DocNum = ?";
				PreparedStatement TemFlHeadCheck_Pstmt = conn.prepareStatement(TemFlHeadCheck_Sql);
				ResultSet TemFlHCheck_rs = null;
				
		        String TemFlLineSql = "INSERT INTO tmpaccfldocline(DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson) " +
		                             "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		        PreparedStatement TemFlLinePstmt = conn.prepareStatement(TemFlLineSql);
		        try{
		        	TemFlHeadCheck_Pstmt.setString(1, TempChild.get(HeadKey[0]).toString());
	        		TemFlHCheck_rs = TemFlHeadCheck_Pstmt.executeQuery();
	        		
	        		if (!TemFlHCheck_rs.next()) {
	                    for (int k = 0; k < HeadKey.length; k++) {
	                        String HKey = HeadKey[k];
	                        String HeadValue = (TempChild.get(HKey) != null) ? TempChild.get(HKey).toString() : "몰?루";

	                        switch (HKey) {
	                            case "SlipNo": // k=0
	                                TemFlHeadPstmt.setString(1, HeadValue.substring(0, 3)); // DocType
	                                TemFlHeadPstmt.setString(2, HeadValue); // DocNum
	                                break;
	                            case "Date": // k=1
	                                TemFlHeadPstmt.setString(3, HeadValue); // PostingDate
	                                break;
	                            case "briefs": // k=2
	                                TemFlHeadPstmt.setString(4, HeadValue); // DocDescrip
	                                break;
	                            case "Deptd": // k=3
	                                TemFlHeadPstmt.setString(5, HeadValue); // DocInputDepart
	                                break;
	                            case "AdminAlloc": // k=4
	                                TemFlHeadPstmt.setString(6, HeadValue); // DocInputBA
	                                break;
	                            case "UserDepart": // k=5
	                                TemFlHeadPstmt.setString(7, HeadValue); // ComCode
	                                break;
	                            case "User": // k=6
	                                TemFlHeadPstmt.setString(8, HeadValue); // InputPerson
	                                break;
	                            case "InputDate": // k=7
	                                TemFlHeadPstmt.setString(9, todayDate); // DocCreteDate
	                                break;
	                            default:
	                                // 해당 필드가 없다면 처리하지 않습니다.
	                                break;
	                        }
	                    }

	                    String HeadPstmtCheck = TemFlHeadPstmt.toString();
	                    System.out.println("Prepared SQL Query: " + HeadPstmtCheck);

	                    TemFlHeadPstmt.executeUpdate();
	                }
		        	
		            for(int i = 0 ; i < ChildKey.length ; i++){
		                String key = ChildKey[i]; 
		                String value = (TempChild.get(key) != null) ? TempChild.get(key).toString() : TempChild.get(ChildKey[0]).toString() + "_" + TempChild.get(ChildKey[1]).toString();
		                
		                if(key.equals("DocNumber")) {
		                    TemFlLinePstmt.setInt(i+1, Integer.parseInt(value));
		                } else if(key.equals("DealPrice")){
		                    TemFlLinePstmt.setDouble(i+1, Double.parseDouble(value));
		                } else if(key.equals("Original")){
		                    TemFlLinePstmt.setString(i+1, value);
		                } else {
		                    TemFlLinePstmt.setString(i+1, value);
		                }
		            }
		            
		            String preparedQuery = TemFlLinePstmt.toString();
		            System.out.println("Prepared SQL Query: " + preparedQuery);
		            
		            TemFlLinePstmt.executeUpdate();
				
				String TemLineSql = "INSERT INTO tmpaccfidoclineinform(DocNum_LineDetail, DocNum_Line, DispSeq, AcctInfoCode, InfoDescrip, InfoValue) VALUES(?,?,?,?,?,?)";
				//	String TemLineSql = "INSERT INTO tmpaccfidoclineinform(DocNum_LineDetail, DocNum_Line, DispSeq, AcctInfoCode, InfoDescrip, InfoValue) VALUES(1,2,3,4,5,6)";																																								
				PreparedStatement TemLinePstmt = conn.prepareStatement(TemLineSql);
				
				for(int j = 0 ; j < LineKey.length ; j++){
					String Element = LineKey[j];
					String Merit = TempLineForm.get(Element).toString();
					if(Element.equals("SlipNo")){ // j가 0인 상황
						TemLinePstmt.setString(j+1/* 1 */, Merit + "_" + TempLineForm.get(LineKey[j+1]).toString() + "-" + j + 1);
					} else if(Element.equals("DocNumber")){ // j가 1인 상황
						TemLinePstmt.setString(j+1/* 2 */, Merit + "_" + TempLineForm.get(LineKey[j+1]).toString());
					} else {
						switch(Element){
							case "CardNumVal": // j가 2인 상황
								TemLinePstmt.setString(j-1/* 1 */, TempLineForm.get(LineKey[j-2]).toString() + "_" + TempLineForm.get(LineKey[j-1]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j/* 1 */, TempLineForm.get(LineKey[j-2]).toString() + "_" + TempLineForm.get(LineKey[j-1]).toString());
								TemLinePstmt.setInt(j+1/* 3 */, j-1/* 1 */); // DispSeq(조회순서) ->3
								TemLinePstmt.setString(j+2/* 4 */, "CardNum"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j+3/* 5 */, "신용카드번호"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j+4/* 5 */, Merit); // InfoValue(관리정보값)
								
								TemLinePstmt.executeUpdate();
								break;
							case "ApprovalDateVal": // j가 3인 상황
								TemLinePstmt.setString(j-2/* 1 */, TempLineForm.get(LineKey[j-3]).toString() + "_" + TempLineForm.get(LineKey[j-2]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j-1/* 1 */, TempLineForm.get(LineKey[j-3]).toString() + "_" + TempLineForm.get(LineKey[j-2]).toString());
								TemLinePstmt.setInt(j/* 3 */, j-1/* 2 */); // DispSeq(조회순서)
								TemLinePstmt.setString(j+1/* 4 */, "ApprovalDate"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j+2/* 5 */, "승인일자"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j+3/* 5 */, Merit); // InfoValue(관리정보값)
								TemLinePstmt.executeUpdate();
								break;
							case "ApprovalNumVal": // j가 4인 상황
								TemLinePstmt.setString(j-3/* 1 */, TempLineForm.get(LineKey[j-4]).toString() + "_" + TempLineForm.get(LineKey[j-3]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j-2/* 1 */, TempLineForm.get(LineKey[j-4]).toString() + "_" + TempLineForm.get(LineKey[j-3]).toString());
								TemLinePstmt.setInt(j-1/* 3 */, j-1/* 3 */); // DispSeq(조회순서)
								TemLinePstmt.setString(j/* 4 */, "ApprovalNum"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j+1/* 5 */, "승인번호"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j+2/* 5 */, Merit); // InfoValue(관리정보값)
								TemLinePstmt.executeUpdate();
								break;
							case "UseNationVal": // j가 5인 상황
								TemLinePstmt.setString(j-4/* 1 */, TempLineForm.get(LineKey[j-5]).toString() + "_" + TempLineForm.get(LineKey[j-4]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j-3/* 1 */, TempLineForm.get(LineKey[j-5]).toString() + "_" + TempLineForm.get(LineKey[j-4]).toString());
								TemLinePstmt.setInt(j-2/* 3 */, j-1); // DispSeq(조회순서)
								TemLinePstmt.setString(j-1/* 4 */, "UseNation"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j/* 5 */, "사용국가"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j+1/* 5 */, Merit); // InfoValue(관리정보값)
								TemLinePstmt.executeUpdate();
								break;
							case "TaxIdentiNumVal": // j가 6인 상황
								TemLinePstmt.setString(j-5/* 1 */, TempLineForm.get(LineKey[j-6]).toString() + "_" + TempLineForm.get(LineKey[j-5]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j-4/* 1 */, TempLineForm.get(LineKey[j-6]).toString() + "_" + TempLineForm.get(LineKey[j-5]).toString());
								TemLinePstmt.setInt(j-3/* 3 */, j-1); // DispSeq(조회순서)
								TemLinePstmt.setString(j-2/* 4 */, "TaxIdentiNum"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j-1/* 5 */, "사업자등록번호"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j/* 5 */, Merit); // InfoValue(관리정보값)
								TemLinePstmt.executeUpdate();
								break;
							case "UsingPlaceAddVal": // j가 7인 상황
								TemLinePstmt.setString(j-6/* 1 */, TempLineForm.get(LineKey[j-7]).toString() + "_" + TempLineForm.get(LineKey[j-6]).toString() + "-" + (j - 1));
								TemLinePstmt.setString(j-5/* 1 */, TempLineForm.get(LineKey[j-7]).toString() + "_" + TempLineForm.get(LineKey[j-6]).toString());
								TemLinePstmt.setInt(j-4/* 3 */, j-1); // DispSeq(조회순서)
								TemLinePstmt.setString(j-3/* 4 */, "UsingPlaceAdd"); // AcctInfoCode(계정관리항목)
								TemLinePstmt.setString(j-2/* 5 */, "사용처주소"); // InfoDescrip(관리정보명)
								TemLinePstmt.setString(j-1/* 5 */, Merit); // InfoValue(관리정보값)
								TemLinePstmt.executeUpdate();
								break;
						}
					}
				}
				response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(TempChild.toJSONString());
			}catch(SQLException e){
				e.printStackTrace();
			}
		} else {
			System.out.println("2번");
			TempChild = (JSONObject)CombinedData.get("TmpAccFLine");
			try{
				String TemFlHeadSql = "INSERT INTO tmpaccfldochead(DocType, DocNum, PostingDate, DocDescrip, DocInputDepart, DocInputBA, ComCode, InputPerson, DocCreteDate) "+
						"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement TemFlHeadPstmt = conn.prepareStatement(TemFlHeadSql);
				
				String TemFlHeadCheck_Sql = "SELECT * FROM tmpaccfldochead WHERE DocNum = ?";
				PreparedStatement TemFlHeadCheck_Pstmt = conn.prepareStatement(TemFlHeadCheck_Sql);
				ResultSet TemFlHCheck_rs = null;
				
				String TemFlLineSql = "INSERT INTO tmpaccfldocline(DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson) " +
                        "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
   				PreparedStatement TemFlLinePstmt = conn.prepareStatement(TemFlLineSql);
   				
   				TemFlHeadCheck_Pstmt.setString(1, TempChild.get(HeadKey[0]).toString());
        		TemFlHCheck_rs = TemFlHeadCheck_Pstmt.executeQuery();
        		
        		if (!TemFlHCheck_rs.next()) {
                    for (int k = 0; k < HeadKey.length; k++) {
                        String HKey = HeadKey[k];
                        String HeadValue = (TempChild.get(HKey) != null) ? TempChild.get(HKey).toString() : "몰?루";

                        switch (HKey) {
                            case "SlipNo": // k=0
                                TemFlHeadPstmt.setString(1, HeadValue.substring(0, 3)); // DocType
                                TemFlHeadPstmt.setString(2, HeadValue); // DocNum
                                break;
                            case "Date": // k=1
                                TemFlHeadPstmt.setString(3, HeadValue); // PostingDate
                                break;
                            case "briefs": // k=2
                                TemFlHeadPstmt.setString(4, HeadValue); // DocDescrip
                                break;
                            case "Deptd": // k=3
                                TemFlHeadPstmt.setString(5, HeadValue); // DocInputDepart
                                break;
                            case "AdminAlloc": // k=4
                                TemFlHeadPstmt.setString(6, HeadValue); // DocInputBA
                                break;
                            case "UserDepart": // k=5
                                TemFlHeadPstmt.setString(7, HeadValue); // ComCode
                                break;
                            case "User": // k=6
                                TemFlHeadPstmt.setString(8, HeadValue); // InputPerson
                                break;
                            case "InputDate": // k=7
                                TemFlHeadPstmt.setString(9, todayDate); // DocCreteDate
                                break;
                            default:
                                // 해당 필드가 없다면 처리하지 않습니다.
                                break;
                        }
                    }

                    String HeadPstmtCheck = TemFlHeadPstmt.toString();
                    System.out.println("Prepared SQL Query: " + HeadPstmtCheck);

                    TemFlHeadPstmt.executeUpdate();
                }
   				
   				for(int i = 0 ; i < ChildKey.length ; i++){
	                String key = ChildKey[i]; 
	                String value = (TempChild.get(key) != null) ? TempChild.get(key).toString() : TempChild.get(ChildKey[0]).toString() + "_" + TempChild.get(ChildKey[1]).toString();
	                
	                if(key.equals("DocNumber")) {
	                    TemFlLinePstmt.setInt(i+1, Integer.parseInt(value));
	                } else if(key.equals("DealPrice")){
	                    TemFlLinePstmt.setDouble(i+1, Double.parseDouble(value));
	                } else if(key.equals("Original")){
	                    TemFlLinePstmt.setString(i+1, value);
	                } else {
	                    TemFlLinePstmt.setString(i+1, value);
	                }
	            }
   				String preparedQuery = TemFlLinePstmt.toString();
				System.out.println("Prepared SQL Query: " + preparedQuery);
				
				TemFlLinePstmt.executeUpdate();
				
				response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(TempChild.toJSONString());
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
	}
%>