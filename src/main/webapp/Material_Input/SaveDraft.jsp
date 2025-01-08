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
	
	String jsonData = sb.toString();
	
	JSONParser parser = new JSONParser();
	JSONObject CombinedDate = (JSONObject) parser.parse(jsonData);
	
	JSONObject DataList = (JSONObject) CombinedDate.get("dList");
	JSONObject CountList = (JSONObject) CombinedDate.get("CList");
	
	String[] CountKeys = {
		"MatKeyData", "InputCount",
	};
	
	String[] keys = {
		"MatNum", "ItemNum", "PurOrdNo", "MovType", "MatType", "MatCode", "MatDes", "PlantCode", "VendorCode",
		"SLocCode", "Bin", "InputCount", "GoodUnit", "LotName", "MadeDate", "Deadline", "PlusMinus", "Money", "plantComCode", "KeyValue"
		// ItemNum,InputCount은 int
	};
	
	System.out.println("전달받은 D데이타: ");
	for(String Dkey : keys){
		System.out.println(Dkey + ": " + DataList.get(Dkey));
	}
	System.out.println("전달받은 C데이터: ");
	for(String Ckey : CountKeys){
		System.out.println(Ckey + ": " + CountList.get(Ckey));
	}
	
	String sql = "INSERT INTO temtable(MatNum, ItemNum, PurOrdNo, MovCode, MatType, MatCode, MatDes, PlantCode, VenCode, SLocCode, Bin, Count, Unit, LotName, MadeDate, DeadDate, PlusMinus, Money, ComCode, KeyValue) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	String sql2 = "SELECT * FROM pochild WHERE keyValue = ?";
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	
	String sql2_1 = "UPDATE pochild SET Count = ?, PO_Rem = ? WHERE keyValue = ?";
	PreparedStatement pstmt2_1 = conn.prepareStatement(sql2_1);
	
	
	try{
		for(int i = 0 ; i < keys.length; i++){
			String key = keys[i];
			String Value = DataList.get(key).toString();
			if(key.equals("ItemNum") || key.equals("InputCount")){
				pstmt.setInt(i+1, Integer.parseInt(Value));
			}else if(key.equals("Bin")){
				pstmt.setString(i+1, "NULL");
			}else{
				pstmt.setString(i+1, Value);
			}
		}
		pstmt.executeUpdate();
		
		String CV1 = ""; // MatKeyData에 저장된 값
	    String Count = ""; // Count에 저장된 값
	    String PoRem = ""; // PO_Rem에 저장된 값
		
		for(int j = 0 ; j < CountKeys.length ; j++){
			String CKey = CountKeys[j];
			String CValue = CountList.get(CKey).toString();
			
			if(CKey.equals("MatKeyData")){
				CV1 = CValue;
				pstmt2.setString(1, CValue);
				ResultSet rs = pstmt2.executeQuery();
					if(rs.next()){
						Count = rs.getString("Count");
						PoRem = rs.getString("PO_Rem");
					}
			} else if(CKey.equals("InputCount")){
				System.out.println("CV1 : " +  CV1);
				int CV2 = Integer.parseInt(CValue); // 입고할 수량 -> 입력한 수량
				int Edit_Count = Integer.parseInt(Count) + CV2; // 입고 수량
				int Edit_PoRem = Integer.parseInt(PoRem) - CV2; // 미입고수량
				pstmt2_1.setInt(1, Edit_Count);
				pstmt2_1.setInt(2, Edit_PoRem);
				pstmt2_1.setString(3, CV1);
				
				pstmt2_1.executeUpdate();
			}
		}
		
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(DataList.toJSONString());
	}catch(SQLException e){
		e.printStackTrace();
	}finally{
			try{
				if(pstmt != null && !pstmt.isClosed()){
					pstmt.close();
				}
				if(pstmt2 != null && !pstmt2.isClosed()){
					pstmt2.close();
				}
				if(pstmt2_1 != null && !pstmt2_1.isClosed()){
					pstmt2_1.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		
	}
	conn.close();
%>