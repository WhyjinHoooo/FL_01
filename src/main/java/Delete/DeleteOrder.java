package Delete;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.json.JSONObject;


/**
 * Servlet implementation class DeleteOrder
 */
@WebServlet("/DeleteOrder")
public class DeleteOrder extends HttpServlet {
    public DeleteOrder() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder jsonBuilder = new StringBuilder();
	    String line;
	    BufferedReader reader = request.getReader();
	    while ((line = reader.readLine()) != null) {
	        jsonBuilder.append(line);
	    }
	    String jsonData = jsonBuilder.toString();

	    // JSON 라이브러리를 사용하여 jsonData를 파싱합니다. (예: org.json 라이브러리)
	    // 예제에서는 org.json 라이브러리의 JSONObject를 사용하고 있다고 가정합니다.
	    JSONObject jsonObject = new JSONObject(jsonData);
	    String page = jsonObject.getString("page");
	    
		// 페이지에서 ".(점)"을 기준으로 문자열을 잘라냅니다.
		int dotIndex = page.indexOf('.');
		if (dotIndex != -1) { // 페이지에 "."이 있는 경우에만 자르기
		    page = page.substring(0, dotIndex);
		}
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		DataSource dataFactory;
		
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource)envContext.lookup("jdbc/mysql");
			conn = dataFactory.getConnection();
			
			if(page.equals("OrderRegistform")) {	
				String sql = "Delete From project.ordertable";
				pstmt = conn.prepareStatement(sql);
				
				int rowsAffected = pstmt.executeUpdate(); // 삭제된 행의 수를 반환
				
				if (rowsAffected > 0) {
	                System.out.println("발주 페이지의 모든 주문 데이터가 삭제되었습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("발주 페이지의 모든 주문 데이터가 삭제되었습니다.");
	            } else {
	                System.out.println("발주 페이지에서 삭제할 데이터가 없습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("발주 페이지에서 삭제할 데이터가 없습니다.");
	            }
			} else if(page.equals("MatInput")) {
				
				String sql = "Delete From project.temtable";
				pstmt = conn.prepareStatement(sql);
				
				int rowsAffected = pstmt.executeUpdate(); // 삭제된 행의 수를 반환
				
				if (rowsAffected > 0) {
	                System.out.println("입고 페이지의 모든 주문 데이터가 삭제되었습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("입고 페이지의 모든 주문 데이터가 삭제되었습니다.");
	            } else {
	                System.out.println("입고 페이지에서 삭제할 데이터가 없습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("입고 페이지에서 삭제할 데이터가 없습니다.");
	            }
			} else if(page.equals("CreateSlip")) {
				String sql = "CALL DeleteAllData()";
				pstmt = conn.prepareStatement(sql);
				
				int rowsAffected = pstmt.executeUpdate();
				if (rowsAffected > 0) {
	                System.out.println("전표입력 페이지의 모든 데이터가 삭제되었습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("전표입력 페이지의 모든 데이터가 삭제되었습니다.");
	            } else {
	                System.out.println("전표입력 페이지에서 삭제할 데이터가 없습니다."); // 서버 콘솔에 메시지 출력
	                response.setContentType("text/html");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("전표입력 페이지에서 삭제할 데이터가 없습니다.");
	            }
			}
		} catch (Exception e) {
			e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}finally {
			try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {
            	e.printStackTrace();
            }
		}
	}

}
