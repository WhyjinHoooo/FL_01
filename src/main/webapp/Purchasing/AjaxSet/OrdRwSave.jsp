<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%

	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		LocalDateTime today = LocalDateTime.now();
		DateTimeFormatter formatter_YMD = DateTimeFormatter.ofPattern("yyyyMMdd");
		String Rnow = today.format(formatter_YMD);
		DateTimeFormatter RegDateFormat= DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String RegDate = today.format(RegDateFormat);
		
		String FromType = request.getParameter("From");
		JSONObject dataToSend = new JSONObject(jsonString.toString());
		String InsertSql = "INSERT INTO request_rvw VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(InsertSql);
		if(FromType.equals("ESave")){
			pstmt.setString(1, dataToSend.getString("Entry_DocNum"));
			pstmt.setString(2, dataToSend.getString("Entry_MatCode"));
			String[] MatDesList = dataToSend.getString("Entry_MatDes").split("\\(");
			for(int i = 0 ; i < MatDesList.length ; i++){
				System.out.println(MatDesList[i]);
			}
			pstmt.setString(3, MatDesList[0]);
			pstmt.setString(4, MatDesList[1].replace(")", " "));
			pstmt.setString(5, dataToSend.getString("Entry_Count"));
			pstmt.setString(6, dataToSend.getString("Entry_Unit"));
			pstmt.setString(7, dataToSend.getString("Entry_UnitPrice"));
			double TotalPrice = dataToSend.getInt("Entry_Count") * dataToSend.getDouble("Entry_UnitPrice");
			pstmt.setDouble(8, TotalPrice);
			pstmt.setString(9, dataToSend.getString("Entry_Cur"));

			String[] VenList = dataToSend.getString("Entry_VCode").split("\\(");
			for(int i = 0 ; i < VenList.length ; i++){
				System.out.println(VenList[i]);
			}

			pstmt.setString(10, VenList[0]);
			pstmt.setString(11, VenList[1].replace(")", " "));
			pstmt.setString(12, dataToSend.getString("Entry_EndDate"));

			String[] SlocList = dataToSend.getString("Entry_Place").split("\\(");
			for(int i = 0 ; i < SlocList.length ; i++){
				System.out.println(SlocList[i]);
			}

			pstmt.setString(13, SlocList[0]);
			pstmt.setString(14, SlocList[1].replace(")", ""));
			pstmt.setString(15, "");
			pstmt.setString(16, "0");
			pstmt.setString(17, dataToSend.getString("Entry_Type"));
			pstmt.setString(18, dataToSend.getString("Client"));
			pstmt.setString(19, dataToSend.getString("PlantCode").substring(0,5));
			pstmt.setString(20, dataToSend.getString("ComCode"));
			pstmt.setString(21, dataToSend.getString("OrderDate"));
			pstmt.setString(22, dataToSend.getString("Client"));
			pstmt.setString(23, dataToSend.getString("Entry_DocNum"));
			pstmt.executeUpdate();
		}else{
			System.out.println(dataToSend);
			System.out.println(dataToSend.length());
			Iterator<String> keys = dataToSend.keys();
			List<String> KeyList = new ArrayList<>();
			while(keys.hasNext()) {
			    String key = keys.next();
			    KeyList.add(key);
			}
			System.out.println("KeyList : " + KeyList);
			System.out.println(KeyList.size());
			System.out.println("-----------");
			for(int i = 0 ; i < KeyList.size() ; i++){
				String first = "PXRO" + Rnow + "S00001";
				PreparedStatement CodePstmt = null;
				ResultSet rs = null;
				/* PREO20250310S00001 */
				String sql = "SELECT * FROM request_rvw WHERE PlanNumPO = ? ORDER BY PlanNumPO DESC";
				CodePstmt = conn.prepareStatement(sql);
				CodePstmt.setString(1, first);
				rs = CodePstmt.executeQuery();
				
				CodePstmt = conn.prepareStatement(sql);
				boolean DupCheck = false;
				while(!DupCheck){
					CodePstmt.setString(1, first);
					rs = CodePstmt.executeQuery();
					if(!rs.next()){
						DupCheck = true;
					} else{
						String recentData = rs.getString("PlanNumPO");
						String numberPart = recentData.substring(14);
						int incrementedValue = Integer.parseInt(numberPart) + 1;
						first = first.substring(0, 13) + String.format("%05d", incrementedValue);
					}
				}
				System.out.println(KeyList.get(i));
				String ListKey = KeyList.get(i);
				JSONArray ArrayList = dataToSend.getJSONArray(ListKey);
				
				pstmt.setString(1, first); // 발주계획번호
				pstmt.setString(2, ArrayList.getString(0)); // 자재코드
				pstmt.setString(3, ArrayList.getString(1)); // 자재설명
				pstmt.setString(4, ArrayList.getString(2)); // 자재타입
				pstmt.setString(5, ArrayList.getString(3)); // 수량
				pstmt.setString(6, ArrayList.getString(4)); // 단위
				pstmt.setDouble(7, ArrayList.getDouble(5)); // 단위당단가
				pstmt.setDouble(8, ArrayList.getInt(3) * ArrayList.getDouble(5)); // 구매금액
				pstmt.setString(9, ArrayList.getString(6)); // 거래통화
				pstmt.setString(10, ArrayList.getString(7)); // 거래처
				pstmt.setString(11, ArrayList.getString(8)); // 거래처명
				pstmt.setString(12, ArrayList.getString(9)); // 납품요청일자
				String[] SlocList = ArrayList.getString(10).split("\\(");
				pstmt.setString(13, SlocList[0]); // 납품창고 
				pstmt.setString(14, SlocList[1].replace(")", "")); // 납품창고명
				pstmt.setString(15, ""); // 발주번호
				pstmt.setString(16, "0"); // Item번호
				pstmt.setString(17, "NMP"); // 구매요청유형
				pstmt.setString(18, ArrayList.getString(11)); // 구매담당자
				pstmt.setString(19, ArrayList.getString(12).substring(0,5)); // 공장
				pstmt.setString(20, ArrayList.getString(13)); // 회사
				pstmt.setString(21, RegDate); // 등록일자
				pstmt.setString(22, ArrayList.getString(11)); // 등록자
				pstmt.setString(23, first); // 키
				pstmt.executeUpdate();
				
				String SearSql = "UPDATE request_doc SET PlanNumPO = ?, PueOrdNum = ?, StatusPR = ? WHERE DocNumPR = ?";
				PreparedStatement SearPstmt = conn.prepareStatement(SearSql);
				SearPstmt.setString(1, first);
				SearPstmt.setString(2, "000");
				SearPstmt.setString(3, "B 발주준비");
				SearPstmt.setString(4, ArrayList.getString(14));
				SearPstmt.executeUpdate();
			}
		}
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	}catch(Exception e){
		JSONObject Result = new JSONObject();
		Result.put("status", "Fail");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
		e.printStackTrace();
	}
%>