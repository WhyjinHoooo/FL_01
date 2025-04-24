package Order;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class OrderDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private DataSource dataFactory;

	private void connDB() {
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jjdbc/mysql");
			conn = dataFactory.getConnection();
			System.out.println("DB 접속 성공");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
