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
        int DeleteCount = 0;
        int Count = 0;
        long YetMinus = 0;
        
        
        // 삭제된 항목들에 대해 반복
        for (int i = 0; i < deletedItems.size(); i++) {
            JSONObject item = (JSONObject) deletedItems.get(i);
            DocCode = (String) item.get("DocCode");
            
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
        }
			System.out.println("삭제할 DocCode: " + DocCode);  // log 추가
            System.out.println("삭제할 DocCodeNum: " + DocCodeNum);  // log 추가
            System.out.println("삭제할 LineItem: " + LineItem);  // log 추가
            System.out.println("삭제할 DeleteCount: " + DeleteCount);  // log 추가
            
            if(!DocCode.substring(0, 3).equals("CRE")){
            	String DocSql = "DELETE FROM tmpaccfldocline WHERE DocNum='" + DocCode + "' AND DocLineItem= '"+ DocCodeNum + "'";
                String NumReset01 = "SET @CNT = 0";
                String NumReset02 = "UPDATE tmpaccfldocline SET tmpaccfldocline.DocLineItem = @CNT:=@CNT+1";
                
                try {
                    int DocResult = DocSt.executeUpdate(DocSql);
                    if (DocResult > 0) {
                        ResetSt01.executeUpdate(NumReset01);
                        ResetSt02.executeUpdate(NumReset02);
                        jsonResponse.put("result", true);  // jsonResponse 사용
                    } else {
                        jsonResponse.put("result", false);  // jsonResponse 사용
                        jsonResponse.put("message", "삭제할 항목이 데이터베이스에 존재하지 않습니다.");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    jsonResponse.put("result", false);  // jsonResponse 사용
                    jsonResponse.put("message", "삭제 작업 중 오류가 발생했습니다.");
                }
            } else{
            	 // 해당 항목을 DB에서 삭제
                String DocSql = "DELETE FROM tmpaccfldocline WHERE DocNum='" + DocCode + "' AND DocLineItem= '"+ DocCodeNum + "'";
                String NumReset01 = "SET @CNT = 0";
                String NumReset02 = "UPDATE tmpaccfldocline SET tmpaccfldocline.DocLineItem = @CNT:=@CNT+1";
                
                int DocResult = DocSt.executeUpdate(DocSql);
                ResetSt01.executeUpdate(NumReset01);
                ResetSt02.executeUpdate(NumReset02);
                
    			String DocNumSql = "DELETE FROM tmpaccfidoclineinform WHERE DocNum_Line = '" + LineItem + "'";
                int DocNumResult = DocNumSt.executeUpdate(DocNumSql);
            	
	            if (DocResult > 0 && DocNumResult > 0) {
	                // 삭제 성공
	                //if(DeleteCount == 1){
	                	System.out.println("1번");
	                	try{
	                    	String SearchSql = "SELECT * FROM tmpaccfldocline";
	                    	PreparedStatement SeaPstmt = conn.prepareStatement(SearchSql);
	                    	ResultSet SeaRs = SeaPstmt.executeQuery();
	                    	String EditDocCode = null;
	                    	while(SeaRs.next()){
	                    		System.out.println("여기까지");
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
	                                
	                                /* String preparedQuery = EditPstmt.toString();
	                				System.out.println("Prepared SQL Query: " + preparedQuery); */
	                                
	                                EditPstmt.executeUpdate();
	                                DocLineUpd_pstmt.executeUpdate();
	                            }
	                    	}
	                    }catch(SQLException e){
	                    	e.printStackTrace();
	                    }
	                	/*}  else {
	                	System.out.println("2번");
	                	try{
	                		String SearchSql = "SELECT * FROM tmpaccfldocline";
	                		PreparedStatement SeaPstmt = conn.prepareStatement(SearchSql);
	                    	ResultSet SeaRs = SeaPstmt.executeQuery();
	                    	String DocNum = null;
	                    	String DocLineItem = null;
	                    	String Original = null;
	                    	while(SeaRs.next()){
	                    		DocNum = SeaRs.getString("DocNum"); // 테이블 tmpaccfldocline의 컬럼 DocNum에 저장된 데이터 : CRE20240626S0001
	                    		DocLineItem = String.format("%04d", SeaRs.getInt("DocLineItem")); // 테이블 tmpaccfldocline의 컬럼 DocLineItem에 저장된 데이터를 000N형태로 변환
	                    		Original = SeaRs.getInt("Original").substring(SeaRs.getInt("Original").lastIndexOf('_') + 1); //0001
	                    		System.out.println("DocNum(예:CRE20240626S0001) : " + DocNum);
	                    		System.out.println("DocLineItem(예:0001) : " + DocLineItem);
	                    		System.out.println("Original의 뒷부분(예:CRE20240626S0001_0001) : " + Original);
	                    		if(!DocLineItem.equals(Original)){
	                    			String DocLineUpdSql = "UPDATE tmpaccfldocline SET Original = ? WHERE DocNum = ? AND DocLineItem = ?";
	                    			PreparedStatement DocLineUpd_pstmt = conn.prepareStatement(DocLineUpdSql);
	                    			DocLineUpd_pstmt.setString(1, DocNum + "_" + DocLineItem);
	                    			DocLineUpd_pstmt.setString(2, DocNum);
	                    			DocLineUpd_pstmt.setString(3, DocLineItem);
	                    		}
	                    	}
	                	}catch(){
	                		
	                	}
	                } */
	                jsonResponse.put("result", true);  // jsonResponse 사용
	            } else {
	                // 삭제 실패
	                jsonResponse.put("result", false);  // jsonResponse 사용
	                jsonResponse.put("message", "해당 항목이 데이터베이스에 존재하지 않습니다.");  // jsonResponse 사용
	            } // if (DocResult > 0 && DocNumResult > 0){...}else{...}의 끝
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
