<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jsonResponse = new JSONObject();  // response를 jsonResponse로 이름 변경
    String jsonData = request.getParameter("List");
    JSONParser parser = new JSONParser();
    try {
        // 파라미터로 받은 JSON 데이터를 파싱
        JSONArray deletedItems = (JSONArray) parser.parse(jsonData);
        
        // MySQL 연결
        Statement DocSt = conn.createStatement();
        Statement DocNumSt = conn.createStatement();
        
        Statement ResetSt01 = conn.createStatement();
        Statement ResetSt02 = conn.createStatement();
        
        String DocCode = null;
        String DocCodeNum = null;
        String LineItem = null;
        String AccountCode = null;
        
        String nothing01 = "";
        String nothing02 = "";
        
        int DeleteCount = 0;
        int Count = 0;
        long YetMinus = 0;
        
        // 삭제된 항목들에 대해 반복
        for (int i = 0; i < deletedItems.size(); i++) {
            JSONObject item = (JSONObject) deletedItems.get(i);
            DocCode = (String) item.get("DocCode");
            AccountCode = (String) item.get("GLAccountCode");
            DocCodeNum = (String) item.get("DocCodeNumber");
            LineItem = DocCode + "_"  + DocCodeNum;
            
            Object delCountObj = item.get("DelConut");
	        if (delCountObj instanceof Long) {
	        	YetMinus = (Long) delCountObj;
	        } else if (delCountObj instanceof Integer) {
	        	YetMinus = ((Integer) delCountObj).longValue();
			} else {
				// 데이터가 Long이나 Integer가 아닌 경우 처리 (예: 예외 발생)
				throw new IllegalArgumentException("DelConut 값이 숫자 형식이 아닙니다: " + delCountObj);
	        }
            DeleteCount = (int) YetMinus;
        
			System.out.println("삭제할 DocCode: " + DocCode);  // log 추가
            System.out.println("삭제할 DocCodeNum: " + DocCodeNum);  // log 추가
            System.out.println("삭제할 LineItem: " + LineItem);  // log 추가
            System.out.println("삭제할 DeleteCount: " + DeleteCount);  // log 추가
            System.out.println("삭제할 AccountCode: " + AccountCode);  // log 추가
            
            if(!AccountCode.equals("2003500") && !AccountCode.equals("2003510") && !AccountCode.equals("2003520")){
            	String DocSql = "DELETE FROM tmpaccfldocline WHERE DocNum='" + DocCode + "' AND DocLineItem= '"+ DocCodeNum + "'";
                String NumReset01 = "SET @CNT = 0";
                String NumReset02 = "UPDATE tmpaccfldocline SET tmpaccfldocline.DocLineItem = @CNT:=@CNT+1";
                
					int DocResult = DocSt.executeUpdate(DocSql);
					if (DocResult > 0) {
                        ResetSt01.executeUpdate(NumReset01);
                        ResetSt02.executeUpdate(NumReset02);
                        jsonResponse.put("result", true);  // jsonResponse 사용
					} else {
                        jsonResponse.put("result", false);  // jsonResponse 사용
                        jsonResponse.put("message", "삭제할 항목이 데이터베이스에 존재하지 않습니다.");
					}
				/*
				추가해야 할지 고민되는 코드
				String LF_Check = "SELECT distinct(DocNum_Line) FROM project.tmpaccfidoclineinform"; // tmpaccfidoclineinform에서 DocNum_Line의 값을 검색
				PreparedStatement LF_Pstmt = conn.prepareStatement(LF_Check);
				ResultSet LF_Rs = LF_Pstmt.executeQuery();
				
                 while(LF_Rs.next()){
					nothing01 = LF_Rs.getString("DocNum_Line");
					String L_Check = "SELECT * FROM tmpaccfldocline WHERE Original = '" + nothing01 + "'";
					PreparedStatement L_Pstmt = conn.prepareStatement(L_Check);
					ResultSet L_rs = L_Pstmt.executeQuery();
					if(L_rs.next()){
						String L_Update = "UPDATE tmpaccfldocline SET Original = ? WHERE DocNum = ? AND DocLineItem = ?";
					}
				};
				*/
            } else{
            	 // 해당 항목을 DB에서 삭제
            	System.out.println("1번");
                String DocSql = "DELETE FROM tmpaccfldocline WHERE DocNum='" + DocCode + "' AND DocLineItem= '"+ DocCodeNum + "'";
                String NumReset01 = "SET @CNT = 0";
                String NumReset02 = "UPDATE tmpaccfldocline SET tmpaccfldocline.DocLineItem = @CNT:=@CNT+1";
                
                int DocResult = DocSt.executeUpdate(DocSql);
                ResetSt01.executeUpdate(NumReset01);
                ResetSt02.executeUpdate(NumReset02);
               
                /* String LineCheck = "SELECT * FROM tmpaccfldochead WHERE DocNum = '"+ LineItem + "'";
                PreparedStatement LineCheck_Pstmt = conn.prepareStatement(LineCheck);
				ResultSet LineCheck_rs = LineCheck_Pstmt.executeQuery();
				if(LineCheck_rs.next()){
					nothing01 = LineCheck_rs.getString("Original");;
				} */
                
    			String DocNumSql = "DELETE FROM tmpaccfidoclineinform WHERE DocNum_Line = '" + LineItem + "'";
                int DocNumResult = DocNumSt.executeUpdate(DocNumSql);
                
                System.out.println("DocResult : " + DocResult);
                System.out.println("DocNumResult : " + DocNumResult);
	            if (DocResult > 0 && DocNumResult > 0) {
	                	System.out.println("2번");
	                    	String SearchSql = "SELECT * FROM tmpaccfldocline";
	                    	PreparedStatement SeaPstmt = conn.prepareStatement(SearchSql);
	                    	ResultSet SeaRs = SeaPstmt.executeQuery();
	                    	String EditDocCode = null;
	                    	while(SeaRs.next()){
	                    		System.out.println("3번");
	                    		String ItemNumber = String.format("%04d", SeaRs.getInt("DocLineItem")); // 0002
	                    		String OriItem = SeaRs.getString("Original").substring(SeaRs.getString("Original").lastIndexOf('_') + 1); // 0003 <- Original컬럼에 저장된 데이터의 뒷부분
	                    		String OriDocCode = SeaRs.getString("Original"); // CRE20240624S0001_0003
	                    		System.out.println("ItemNumber : " + ItemNumber);
	                    		System.out.println("OriItem : " + OriItem);
	                    		System.out.println("OriDocCode : " + OriDocCode);
	                    		if(!ItemNumber.equals(OriItem)) {
	                    			EditDocCode = SeaRs.getString("DocNum") + "_" + ItemNumber; // CRE20240624S0001 + "_" + 0002
	                                
	                    			String DocLineUpdSql = "UPDATE tmpaccfldocline SET Original = ? WHERE DocNum = ? AND DocLineItem = ?";
	                    			PreparedStatement DocLineUpd_pstmt = conn.prepareStatement(DocLineUpdSql);
	                    			
	                    			String editSql = "UPDATE tmpaccfidoclineinform " +
	                    	                 "SET " +
	                    	                 "    DocNum_Line = CASE " +
	                    	                 "        WHEN DocNum_Line = ? THEN ? " +
	                    	                 "        ELSE DocNum_Line " +
	                    	                 "    END, " +
	                    	                 "    DocNum_LineDetail = CASE " +
	                    	                 "        WHEN DocNum_LineDetail LIKE ? THEN " +
	                    	                 "            REPLACE(DocNum_LineDetail, ?, ?) " +
	                    	                 "        ELSE DocNum_LineDetail " +
	                    	                 "    END " +
	                    	                 "WHERE " +
	                    	                 "    DocNum_Line = ? " +
	                    	                 "    OR DocNum_LineDetail LIKE ?";
	                                PreparedStatement EditPstmt = conn.prepareStatement(editSql);
	                                EditPstmt.setString(1, OriDocCode);
	                                EditPstmt.setString(2, EditDocCode);
	                                EditPstmt.setString(3, "%" + OriDocCode + "%");
	                                EditPstmt.setString(4, OriDocCode);
	                                EditPstmt.setString(5, EditDocCode);
	                                EditPstmt.setString(6, OriDocCode);
	                                EditPstmt.setString(7, "%" + OriDocCode + "%");
	                                
	                                DocLineUpd_pstmt.setString(1, EditDocCode);
	                                DocLineUpd_pstmt.setString(2, SeaRs.getString("DocNum"));
	                                DocLineUpd_pstmt.setString(3, ItemNumber);
	                                
	                                String preparedQuery = EditPstmt.toString();
	                				System.out.println("Prepared SQL Query: " + preparedQuery);
	                                
	                                EditPstmt.executeUpdate();
	                                DocLineUpd_pstmt.executeUpdate();
	                            }
	                    	}
	                jsonResponse.put("result", true);  // jsonResponse 사용
	            } else {
	                // 삭제 실패
	                jsonResponse.put("result", false);  // jsonResponse 사용
	                jsonResponse.put("message", "해당 항목이 데이터베이스에 존재하지 않습니다.");  // jsonResponse 사용
	            } // if (DocResult > 0 && DocNumResult > 0){...}else{...}의 끝
            }
    	}
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("result", false);  // jsonResponse 사용
        jsonResponse.put("message", e.getMessage());  // jsonResponse 사용
    }
    response.setContentType("application/json");  // response 객체의 setContentType 메서드 사용
    response.setCharacterEncoding("UTF-8");  // response 객체의 setCharacterEncoding 메서드 사용
    response.getWriter().write(jsonResponse.toString());  // response 객체의 getWriter 메서
    
%>
