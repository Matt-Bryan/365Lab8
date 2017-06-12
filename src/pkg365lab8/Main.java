package lab08;

import java.sql.*;
public class Driver {

	public static void main(String[] args) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (ClassNotFoundException e) {
			System.out.println("Driver not found");
		}
		
		Connection conn = null;
		String url = "jdbc:mysql://cslvm74.csc.calpoly.edu/nyse";
		String user = "avsharma";
		String password = "So1ra1kh6";
		try {
			conn = DriverManager.getConnection(url, user, password);
		}
		catch (Exception e) {
			System.out.println("Could not open connection");
		}
		
		try {
			Statement s = conn.createStatement();
		

			ResultSet result = s.executeQuery("select * from Securities where Ticker = 'FSLR' OR Ticker = 'XOM'");
			
				
			while (result.next()) {
				System.out.println(result.getString("Ticker") + ", " + result.getString("Name"));
			}
		}
		catch (SQLException e) {
			System.out.println("Uh oh");
		}
	}

}
