<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
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
	BufferedReader reader = null;
	StringBuilder sb = new StringBuilder();
	try{
		reader = request.getReader();
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
		JSONObject OptionData = (JSONObject) parser.parse(jsonData);
		
		String OP_ComCode = (String)OptionData.get("UserComCode");
		String OP_BA = (String)OptionData.get("UserBizArea"); // 공백, 전표입룍 BA
		String OP_COCT = (String)OptionData.get("UserDepartCd"); // 공백, 전표입력부서
		String OP_Inputer = (String)OptionData.get("InputerId"); // 공백, 전표 입력자
		
		String OP_Approver = (String)OptionData.get("ApproverId"); // 공백, 결재 합의자
		
		String OP_From = (String)OptionData.get("TimeStamp From"); // 오늘 날짜
		String OP_End = (String)OptionData.get("TimeStamp To"); // 오늘 날짜
		
		String OP_State = (String)OptionData.get("UnSlipState"); // A
		
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String DocNum = null;
		String Step = null;
		int Number = 0;
		int C_Sum = 0;
		int D_Sum = 0;
		
		String SqlVer01 = null;
		String DocSearch_Sql = null;
		
		JSONArray jsonArray = new JSONArray();
		 if (OP_Approver != null && !OP_Approver.isEmpty()) {
			 // 결재합의자가 있는 경우
			System.out.println("결재합의자01");
			DocSearch_Sql = "SELECT * FROM docworkflowline WHERE ResponsePerson = '" + OP_Approver + "'";
			/* 
			1. 결재합의자가 입력된 상태에서 검색을 진행
			2. 먼저 결재자가 결재해야할 전표를 검색
			*/
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			while(DocSearch_Rs.next()){
				System.out.println("결재합의자02");
				JSONObject josnobject = new JSONObject();
				DocNum = DocSearch_Rs.getString("DocNum"); // 전표 번호
				Step = DocSearch_Rs.getString("WFStep"); // 결재합의자의 Level
				Number = Integer.parseInt(Step);
				/* 
				3. 전표가 있으면 그 전표 번호를 가져온다.
				*/
				String Refer_Slip_Query = "SELECT * FROM docworkflowline WHERE DocNum = '" + DocNum + "' AND WFType = 'S'";
				PreparedStatement Refer_Slip_Pstmt = conn.prepareStatement(Refer_Slip_Query);
				ResultSet Refer_Slip_Rs = Refer_Slip_Pstmt.executeQuery();
				/* 
				4. 결재자가 결재할 전표가 상신된 전표인지 확인한다.
				*/
				while(Refer_Slip_Rs.next()){ // 이 전표가 상신된 전표인 경우
					if(Number == 1){ // 결재합의자의 단계가 1인 경우
						if(!OP_From.equals(OP_End)){
							System.out.println("결재합의자02 case01");
							System.out.println("결재합의자02 case01 : " + DocNum);
							// SELECT * FROM docworkflowhead WHERE DocNum = '" + DocNum + "' AND postingDay >= '" + OP_From + "' AND postingDay <= '" + OP_End + "' AND WFStatus = '" + OP_State + "'";
							SqlVer01 = "SELECT " +
								      "    DATE(SubmitTime) AS DateOnly, " +
								      "    DocNum, " +
								      "    BizArea, " +
								      "    DocInputDepart, " +
								      "    InputPerson, " +
								      "    DocDescrip, " +
								      "    WFStatus, " +
								      "    WFStep, " +
								      "    ElapsedHour, " +
								      "    DocType " +
								      "FROM " +
								      "    docworkflowhead " +
								      "WHERE " +
								      "    DocNum = '" + DocNum + "' AND " +
								      "    postingDay >= '" + OP_From + "' AND " +
								      "    postingDay <= '" + OP_End + "'";
						}else{
							System.out.println("결재합의자02 case02");
							SqlVer01 = "SELECT " +
								      "    DATE(SubmitTime) AS DateOnly, " +
								      "    DocNum, " +
								      "    BizArea, " +
								      "    DocInputDepart, " +
								      "    InputPerson, " +
								      "    DocDescrip, " +
								      "    WFStatus, " +
								      "    WFStep, " +
								      "    ElapsedHour, " +
								      "    DocType " +
								      "FROM " +
								      "    docworkflowhead " +
								      "WHERE " +
								      "    DocNum = '" + DocNum + "' AND " +
								      "    postingDay = '" + OP_From + "'";
						}; // if(!OP_From.equals(OP_End)){...}else{...}의 끝

						// 그 전표 번호를 갖는 전표의 상신 일자, 전표번호, 발생회계단위, 입력부서, 입력자, 적요, 전표상태, 결재단계, 경과일수, 전표유형을 가져온다.
						PreparedStatement PstmtVer01 = conn.prepareStatement(SqlVer01);
						ResultSet RsVer01 = PstmtVer01.executeQuery();
						
						while(RsVer01.next()){
							if(RsVer01.getString("DateOnly") != null && !RsVer01.getString("DateOnly").isEmpty()){
								josnobject.put("Date", RsVer01.getString("DateOnly")); // 기표일자가 입력되어 있
							} else{
								josnobject.put("Date", "미상신 전표"); // 기표일자	
							}
							josnobject.put("DocCode", RsVer01.getString("DocNum")); // 전표번호
							josnobject.put("Script", RsVer01.getString("DocDescrip")); // 적요
							josnobject.put("BA", RsVer01.getString("BizArea")); // 전표입력 BA
							josnobject.put("CoCt", RsVer01.getString("DocInputDepart")); // 입력부서
							josnobject.put("Inputer", RsVer01.getString("InputPerson")); // 입력자
							josnobject.put("Status", RsVer01.getString("WFStatus")); // 전표상태
							josnobject.put("Step", RsVer01.getString("WFStep")); // 결재단계
							josnobject.put("Approver", OP_Approver); // 결재 또는 합의자
							josnobject.put("Time", RsVer01.getInt("ElapsedHour")); // 결과일수
							josnobject.put("Type", RsVer01.getString("DocType")); // 전표유형	
							
							String SqlVer02 = "SELECT * FROM fldocline WHERE DocNum = '"+ DocNum +"'";
							PreparedStatement PstmtVer02 = conn.prepareStatement(SqlVer02);
							ResultSet RsVer02 = PstmtVer02.executeQuery();
							while(RsVer02.next()){
								if(RsVer02.getString("DebCre").equals("D")){
									D_Sum += RsVer02.getInt("TAmount"); // 차변의 합계
								} else{
									C_Sum += RsVer02.getInt("TAmount"); // 대변의 합계
								}
							}
							
							josnobject.put("CSum", C_Sum); // 대변 합계
							josnobject.put("DSum", D_Sum); // 차변 합계
							
							jsonArray.add(josnobject);
						}
						
					} else { // 결재합의자가 1단계가 아닌 경우
						
					}
				}
			}			
		}else if(OP_Inputer != null && !OP_Inputer.isEmpty()){
			// 전표입력자가 있는 경우
			System.out.println("전표입력자01");
			if(!OP_From.equals(OP_End)){
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    InputPerson = '"+ OP_Inputer + "' AND " +
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay >= '" + OP_From + "' AND " +
						  "    postingDay <= '" + OP_End + "'";
			}else{
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    InputPerson = '"+ OP_Inputer + "' AND " +
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay = '" + OP_From + "'";
			};
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			if(DocSearch_Rs.next()){
				DocNum = DocSearch_Rs.getString("DocNum");
			}
			System.out.println("전표입력자01-1 : " + OP_Inputer);
			
			DocSearch_Rs.beforeFirst();
			
			while(DocSearch_Rs.next()){
				System.out.println("전표입력자02");
				JSONObject josnobject = new JSONObject();
				
				josnobject.put("Date", DocSearch_Rs.getString("postingDay")); // 기표일자
				josnobject.put("DocCode", DocSearch_Rs.getString("DocNum")); // 전표번호
				josnobject.put("Script", DocSearch_Rs.getString("DocDescrip")); // 적요
				josnobject.put("BA", DocSearch_Rs.getString("BizArea")); // 전표입력 BA
				josnobject.put("CoCt", DocSearch_Rs.getString("DocInputDepart")); // 입력부서
				josnobject.put("Inputer", DocSearch_Rs.getString("InputPerson")); // 입력자
				josnobject.put("Status", DocSearch_Rs.getString("WFStatus")); // 전표상태
				josnobject.put("Step", DocSearch_Rs.getString("WFStep")); // 결재단계
				josnobject.put("Approver", "없음"); // 결재 또는 합의자
				josnobject.put("Time", DocSearch_Rs.getInt("ElapsedHour")); // 경과일수
				josnobject.put("Type", DocSearch_Rs.getString("DocType")); // 전표유형	
				
				String SqlVer02 = "SELECT * FROM fldocline WHERE DocNum = '"+ DocNum +"'";
				PreparedStatement PstmtVer02 = conn.prepareStatement(SqlVer02);
				ResultSet RsVer02 = PstmtVer02.executeQuery();
				while(RsVer02.next()){
					if(RsVer02.getString("DebCre").equals("D")){
						D_Sum += RsVer02.getInt("TAmount"); // 차변의 합계
					} else{
						C_Sum += RsVer02.getInt("TAmount"); // 대변의 합계
					}
				}
				josnobject.put("CSum", C_Sum); // 대변 합계
				josnobject.put("DSum", D_Sum); // 차변 합계
				
				jsonArray.add(josnobject);
			}
		} else if(OP_COCT != null && !OP_COCT.isEmpty()){
			// 전표입력부서가 입력된 경우
			System.out.println("전표입력부서01");
			if(!OP_From.equals(OP_End)){
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    DocInputDepart = '"+ OP_COCT + "' AND " + 
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay >= '" + OP_From + "' AND " +
						  "    postingDay <= '" + OP_End + "'";
			}else{
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    DocInputDepart = '"+ OP_COCT + "' AND " +
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay = '" + OP_From + "'";
			};
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			if(DocSearch_Rs.next()){
				DocNum = DocSearch_Rs.getString("DocNum");
			};
			
			DocSearch_Rs.beforeFirst();
			
			while(DocSearch_Rs.next()){
				System.out.println("전표입력부서02");
				JSONObject josnobject = new JSONObject();
				
				josnobject.put("Date", DocSearch_Rs.getString("postingDay")); // 기표일자
				josnobject.put("DocCode", DocSearch_Rs.getString("DocNum")); // 전표번호
				josnobject.put("Script", DocSearch_Rs.getString("DocDescrip")); // 적요
				josnobject.put("BA", DocSearch_Rs.getString("BizArea")); // 전표입력 BA
				josnobject.put("CoCt", DocSearch_Rs.getString("DocInputDepart")); // 입력부서
				josnobject.put("Inputer", DocSearch_Rs.getString("InputPerson")); // 입력자
				josnobject.put("Status", DocSearch_Rs.getString("WFStatus")); // 전표상태
				josnobject.put("Step", DocSearch_Rs.getString("WFStep")); // 결재단계
				josnobject.put("Approver", "없음"); // 결재 또는 합의자
				josnobject.put("Time", DocSearch_Rs.getInt("ElapsedHour")); // 경과일수
				josnobject.put("Type", DocSearch_Rs.getString("DocType")); // 전표유형	
				//jsonArray.add(josnobject);
				
				String SqlVer02 = "SELECT * FROM fldocline WHERE DocNum = '"+ DocNum +"'";
				PreparedStatement PstmtVer02 = conn.prepareStatement(SqlVer02);
				ResultSet RsVer02 = PstmtVer02.executeQuery();
				while(RsVer02.next()){
					if(RsVer02.getString("DebCre").equals("D")){
						D_Sum += RsVer02.getInt("TAmount"); // 차변의 합계
					} else{
						C_Sum += RsVer02.getInt("TAmount"); // 대변의 합계
					}
				}
				josnobject.put("CSum", C_Sum); // 대변 합계
				josnobject.put("DSum", D_Sum); // 차변 합계
				
				jsonArray.add(josnobject);
			}
		}else if(OP_BA != null && !OP_BA.isEmpty()){
			// 전표입력 BA가 입력된 경우
			System.out.println("전표입력BA01");
			if(!OP_From.equals(OP_End)){
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    BizArea = '"+ OP_BA + "' AND " + 
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay >= '" + OP_From + "' AND " +
						  "    postingDay <= '" + OP_End + "'";
			}else{
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    BizArea = '"+ OP_BA + "' AND " +
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay = '" + OP_From + "'";
			};
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			if(DocSearch_Rs.next()){
				DocNum = DocSearch_Rs.getString("DocNum");
			}
			
			DocSearch_Rs.beforeFirst();
			
			while(DocSearch_Rs.next()){
				System.out.println("전표입력BA02");
				JSONObject josnobject = new JSONObject();
				
				josnobject.put("Date", DocSearch_Rs.getString("postingDay")); // 기표일자
				josnobject.put("DocCode", DocSearch_Rs.getString("DocNum")); // 전표번호
				josnobject.put("Script", DocSearch_Rs.getString("DocDescrip")); // 적요
				josnobject.put("BA", DocSearch_Rs.getString("BizArea")); // 전표입력 BA
				josnobject.put("CoCt", DocSearch_Rs.getString("DocInputDepart")); // 입력부서
				josnobject.put("Inputer", DocSearch_Rs.getString("InputPerson")); // 입력자
				josnobject.put("Status", DocSearch_Rs.getString("WFStatus")); // 전표상태
				josnobject.put("Step", DocSearch_Rs.getString("WFStep")); // 결재단계
				josnobject.put("Approver", "없음"); // 결재 또는 합의자
				josnobject.put("Time", DocSearch_Rs.getInt("ElapsedHour")); // 경과일수
				josnobject.put("Type", DocSearch_Rs.getString("DocType")); // 전표유형	
				//jsonArray.add(josnobject);
				
				String SqlVer02 = "SELECT * FROM fldocline WHERE DocNum = '"+ DocNum +"'";
				PreparedStatement PstmtVer02 = conn.prepareStatement(SqlVer02);
				ResultSet RsVer02 = PstmtVer02.executeQuery();
				while(RsVer02.next()){
					if(RsVer02.getString("DebCre").equals("D")){
						D_Sum += RsVer02.getInt("TAmount"); // 차변의 합계
					} else{
						C_Sum += RsVer02.getInt("TAmount"); // 대변의 합계
					}
				}
				josnobject.put("CSum", C_Sum); // 대변 합계
				josnobject.put("DSum", D_Sum); // 차변 합계
				
				jsonArray.add(josnobject);
			}
		}else if(OP_ComCode != null && !OP_ComCode.isEmpty()){
			// 법인이 입력된 경우
			System.out.println("법인01");
			if(!OP_From.equals(OP_End)){
				System.out.println("case01");
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    ComCode = '"+ OP_ComCode + "' AND " +
					      "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay >= '" + OP_From + "' AND " +
						  "    postingDay <= '" + OP_End + "'";
//				DocSearch_Sql = "SELCT * FROM docworkflowhead WHERE ";
			}else{
				System.out.println("case02");
				System.out.println("OP_From : " + OP_From + ", OP_End : " + OP_End);
				DocSearch_Sql = "SELECT " +
					      " * " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    ComCode = '"+ OP_ComCode + "' AND" +
						  "    WFStatus = '"+ OP_State + "' AND " +
						  "    postingDay = '" + OP_From + "'";
			};
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			if(DocSearch_Rs.next()){
				DocNum = DocSearch_Rs.getString("DocNum");
			}
			
			DocSearch_Rs.beforeFirst();
			
			while(DocSearch_Rs.next()){
				System.out.println("법인02");
				JSONObject josnobject = new JSONObject();
				
				josnobject.put("Date", DocSearch_Rs.getString("postingDay")); // 기표일자
				josnobject.put("DocCode", DocSearch_Rs.getString("DocNum")); // 전표번호
				josnobject.put("Script", DocSearch_Rs.getString("DocDescrip")); // 적요
				josnobject.put("BA", DocSearch_Rs.getString("BizArea")); // 전표입력 BA
				josnobject.put("CoCt", DocSearch_Rs.getString("DocInputDepart")); // 입력부서
				josnobject.put("Inputer", DocSearch_Rs.getString("InputPerson")); // 입력자
				josnobject.put("Status", DocSearch_Rs.getString("WFStatus")); // 전표상태
				josnobject.put("Step", DocSearch_Rs.getString("WFStep")); // 결재단계
				josnobject.put("Approver", "없음"); // 결재 또는 합의자
				josnobject.put("Time", DocSearch_Rs.getInt("ElapsedHour")); // 경과일수
				josnobject.put("Type", DocSearch_Rs.getString("DocType")); // 전표유형	
				//jsonArray.add(josnobject);
				
				String SqlVer02 = "SELECT * FROM fldocline WHERE DocNum = '"+ DocNum +"'";
				PreparedStatement PstmtVer02 = conn.prepareStatement(SqlVer02);
				ResultSet RsVer02 = PstmtVer02.executeQuery();
				while(RsVer02.next()){
					if(RsVer02.getString("DebCre").equals("D")){
						D_Sum += RsVer02.getInt("TAmount"); // 차변의 합계
					} else{
						C_Sum += RsVer02.getInt("TAmount"); // 대변의 합계
					}
				}
				josnobject.put("CSum", C_Sum); // 대변 합계
				josnobject.put("DSum", D_Sum); // 차변 합계
				
				jsonArray.add(josnobject);
			}
		}
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonArray.toString());
	}catch(Exception e){
		e.printStackTrace();
	}
%>