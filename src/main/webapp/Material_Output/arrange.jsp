<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
<%
	BufferedReader reader = request.getReader();
	StringBuilder sb = new StringBuilder();
	String line;
	while((line = reader.readLine()) != null) {
		sb.append(line);
	}
	String jsonData = sb.toString();
	
	JSONObject DataGroup = (JSONObject) JSONValue.parse(jsonData);
/* 	System.out.println("-----------------");
	System.out.println("Parsed JSON Data : " + DataGroup.toJSONString());
	System.out.println("-----------------"); */
	String[] keys = {
			"Doc_Num", "GINo", "MatCode", "MatDes", "MatType", "movCode",
			"OutCount", "OrderUnit", "UseDepart", "Out_date", "MatLotNo", "StorageCode", "plantCode","InputStorage","LotNumber", "MakeDate", "DeadDete", "plantComCode", "MaterialCode"
			/* 문서번호!, 품목번호, 자재!, 자재설명, 자재유형, 출고구분 
			수량, 단위, 사용부서, 출고일자!, 자재Lot번호, 출고창고!, 공장!, 입고찰고
			*/
		};
	System.out.println("Received Data : ");
	for(String key : keys){
		System.out.println(key + ": " + DataGroup.get(key));
	}
	String sql = "INSERT INTO placetable(DocName, ItemNO, MatCode, MatDes, MatType, MovType, Count, Unit, Depart, OutDate, LotNo, Storage, Plant, InputStorage, LotNumber, MakeDate, DeadDate, ComCode, MatetialCode) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt  = conn.prepareStatement(sql);
	
	
	String sqlSH = "INSERT INTO storehead(MatDocNum, PostingDate, PONum, FIDocNum, PlantCode, SLocation, VendorCode, CreateDate, InputPerson) VALUES(?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt_SH = conn.prepareStatement(sqlSH);
	
	String checkSql = "SELECT * FROM storehead WHERE MatDocNum = ?";
    PreparedStatement pstmt_check = conn.prepareStatement(checkSql);
    pstmt_check.setString(1, DataGroup.get("Doc_Num").toString());
    ResultSet rs = pstmt_check.executeQuery();
	
	try{
		
		if(!rs.next()){
			pstmt_SH.setString(1, DataGroup.get("Doc_Num").toString());
			pstmt_SH.setString(2, DataGroup.get("Out_date").toString());
			pstmt_SH.setString(3, DataGroup.get("MatCode").toString());
			pstmt_SH.setString(4, "Nope");
			pstmt_SH.setString(5, DataGroup.get("plantCode").toString());
			pstmt_SH.setString(6, DataGroup.get("StorageCode").toString());
			pstmt_SH.setString(7, "Nope");
			pstmt_SH.setString(8, DataGroup.get("Out_date").toString());
			pstmt_SH.setInt(9, 752952); 
			pstmt_SH.executeUpdate();
	    }
		
		for(int i = 0 ; i < keys.length ; i ++){
			String key = keys[i];
			String value = (DataGroup.get(key) == null || DataGroup.get(key).toString().isEmpty()) ? "EMPTY" : DataGroup.get(key).toString();

			if(key.equals("GI_Item_No")){
				value = DataGroup.get(key).toString();
				pstmt.setInt(i + 1, Integer.parseInt(value));
			}else if(key.equals("UseDepart") || key.equals("InputStorage") || key.equals("LotNumber")){
				pstmt.setString(i+1, value);
			}else {
				pstmt.setString(i+1, value);
			}
		}
		pstmt.executeUpdate();
		
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(DataGroup.toJSONString());
	}catch(SQLException e){
		e.printStackTrace();
	}finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();	
		}
		
	}
	conn.close();
%>