package pkg365lab8;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Scanner;

public class Driver {

    public static void main(String[] args) {
        String user = null;
        String password = null;
        File outFile = new File(args[0] + ".html");
        PrintWriter output = null;
        
        // Read in credentials file
        try {
            Scanner in = new Scanner(new File("credentials.in"));
            output = new PrintWriter(outFile);
            user = in.nextLine();
            password = in.nextLine();
        } catch (FileNotFoundException ex) {
            System.out.println("Credentials file not found");
        }
        
        // Output html tags
        output.println("<!DOCTYPE HTML>");
        output.println("<html>");
        output.println("<body>");
        
        // Check for driver
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found");
        }

        // Opening Connection
        Connection conn = null;
        String url = "jdbc:mysql://cslvm74.csc.calpoly.edu/nyse";
        try {
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println("Could not open connection");
        }

        // First Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select COUNT(Ticker) as NumSecurities from AdjustedPrices where Day = '2016-01-04'");
            
            output.println("<p>");
            output.println("This shows the number of securities traded at the start of 2016");
            output.println("</p>");
            
            output.println("<table>");
            
            output.println("<tr>");
            output.println("<th>NumSecurities</th>");
            output.println("</tr>");

            output.println("<tr>");
            result.next();
            output.print("<td>");
            output.print(result.getString("NumSecurities"));
            output.println("</td>");
            output.println("</tr>");
            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Output ending html tags
        output.println("</body>");
        output.println("</html>");
        output.flush();
    }

}
