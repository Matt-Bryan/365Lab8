/*
 * Avinash Sharma and Matt Bryan
 * CPE 365 Lab 8
 * 
 */
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
        output.println("<!DOCTYPE html>");
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

        // First Query Part 1
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select COUNT(Ticker) as NumSecurities "
                    + "from AdjustedPrices where Day = '2016-01-04'");
            
            output.println("<p>");
            output.println("<h2>General Analytical Data #1</h2>");
            output.println("This shows the number of securities traded at the start of 2016.");
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
        
        // First Query Part 2
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select COUNT(Ticker) as NumSecurities "
                    + "from AdjustedPrices where Day = '2016-12-30';");
            
            output.println("<p>");
            output.println("This shows the number of securities traded at the end of 2016.");
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
        
        // First Query Part 3
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select COUNT(*) as NumIncreases "
                    + "from (select Sixteen.Ticker, IF(Sixteen.SixClose > Fifteen.FifClose, 'Increase', 'Decrease') as IncDec from (select AP.Ticker, AP.Close as FifClose "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = (select MAX(AP.Day) AS Max "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2015)) Fifteen, "
                    + "(select AP.Ticker, AP.Close as SixClose "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = (select MAX(AP.Day) AS Max "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2016)) Sixteen "
                    + "where Fifteen.Ticker = Sixteen.Ticker) Changes "
                    + "where Changes.IncDec = 'Increase';");
            
            output.println("<p>");
            output.println("This shows the number of securities whose prices increased between end of 2015 and end of 2016.");
            output.println("</p>");
            
            output.println("<table>");
            
            output.println("<tr>");
            output.println("<th>NumIncreases</th>");
            output.println("</tr>");

            output.println("<tr>");
            result.next();
            output.print("<td>");
            output.print(result.getString("NumIncreases"));
            output.println("</td>");
            output.println("</tr>");
            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // First Query Part 4
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select COUNT(*) as NumDecreases "
                    + "from (select Sixteen.Ticker, IF(Sixteen.SixClose < Fifteen.FifClose, 'Decrease', 'Increase') as IncDec "
                    + "from (select AP.Ticker, AP.Close as FifClose "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = (select MAX(AP.Day) AS Max "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2015)) Fifteen, "
                    + "(select AP.Ticker, AP.Close as SixClose "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = (select MAX(AP.Day) AS Max "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2016)) Sixteen "
                    + "where Fifteen.Ticker = Sixteen.Ticker) Changes "
                    + "where Changes.IncDec = 'Decrease';");
            
            output.println("<p>");
            output.println("This shows the number of securities whose prices decreased between end of 2015 and end of 2016.");
            output.println("</p>");
            
            output.println("<table>");
            
            output.println("<tr>");
            output.println("<th>NumDecreases</th>");
            output.println("</tr>");

            output.println("<tr>");
            result.next();
            output.print("<td>");
            output.print(result.getString("NumDecreases"));
            output.println("</td>");
            output.println("</tr>");
            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Second Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select distinct S.Name, AP.Ticker "
                    + "from AdjustedPrices AP, Securities S "
                    + "where AP.Ticker = S.Ticker "
                    + "and YEAR(AP.Day) = 2016 "
                    + "order by AP.Volume desc "
                    + "limit 10;");
            
            output.println("<p>");
            output.println("<h2>General Analytical Data #2</h2>");
            output.println("Report top 10 stocks that were most heavily traded in 2016.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Name, Ticker</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Name") + ", " + result.getString("Ticker"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Third Query Part 1
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2010-01-04') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2010-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y1 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2011-01-03') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2011-12-30') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y2 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2012-01-03') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2012-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y3 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2013-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2013-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y4 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2014-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2014-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y5 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2015-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2015-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y6 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) as AbsolutePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2016-01-04') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2016-12-30') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by AbsolutePrice desc "
                    + "limit 5) as Y7;");
            
            output.println("<p>");
            output.println("<h2>General Analytical Data #3</h2>");
            output.println("For each year, report top 5 stocks in terms of absolute price increase.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, AbsolutePrice</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("AbsolutePrice"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Third Query Part 2
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2010-01-04') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2010-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y1 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2011-01-03') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2011-12-30') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y2 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2012-01-03') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2012-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y3 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2013-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2013-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y4 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2014-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2014-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y5 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2015-01-02') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2015-12-31') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y6 "
                    + "UNION "
                    + "select * "
                    + "from (select YEAR(LastDay.Day) AS Year, LastDay.Ticker, (LastDay.Close - FirstDay.Open) / FirstDay.Open as RelativePrice "
                    + "from (select AP.Day, AP.Ticker, AP.Open "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2016-01-04') FirstDay, "
                    + "(select AP.Day, AP.Ticker, AP.Close "
                    + "from AdjustedPrices AP "
                    + "where AP.Day = '2016-12-30') LastDay "
                    + "where FirstDay.Ticker = LastDay.Ticker "
                    + "order by RelativePrice desc "
                    + "limit 5) as Y7;");
            
            output.println("<p>");
            output.println("For each year, report top 5 stocks in terms of relative price increase.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, RelativePrice</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("RelativePrice"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Fourth Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select Averages.Name, Averages.Ticker, Averages.Avg "
                    + "from (select S.Name, AP.Ticker, AVG(AP.Close) as Avg "
                    + "from AdjustedPrices AP, Securities S "
                    + "where AP.Ticker = S.Ticker "
                    + "and YEAR(AP.Day) = 2016 "
                    + "group by AP.Ticker) Averages "
                    + "order by Averages.Avg desc "
                    + "limit 10;");
            
            output.println("<p>");
            output.println("<h2>General Analytical Data #4</h2>");
            output.println("Top 10 stocks to watch in 2017 based on top 10 highest average closes of 2016.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Name, Ticker, Avg</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Name") + ", " + result.getString("Ticker") + ", " + result.getString("Avg"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Fifth Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select Percentages.Sector, CASE WHEN Percentages.Percentage < 0.0 THEN 'Tanking' "
                    + "WHEN Percentages.Percentage >= 0.0 and Percentages.Percentage < 0.1 THEN 'Average' "
                    + "WHEN Percentages.Percentage >= 0.1 and Percentages.Percentage < 0.2 THEN 'Above Average' "
                    + "ELSE  'Significantly Outperforming' END AS Performance "
                    + "from (select LastAvgs.Sector, (LastAvgs.AvgLastDayClose - FirstAvgs.AvgFirstDayClose) / FirstAvgs.AvgFirstDayClose as Percentage "
                    + "from (select S.Sector, AVG(AP.Close) as AvgFirstDayClose "
                    + "from AdjustedPrices AP, Securities S "
                    + "where AP.Ticker = S.Ticker "
                    + "and AP.Day = (select MIN(AP.Day) as FirstDay "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2016) "
                    + "and S.Sector <> 'Telecommunications Services' "
                    + "group by S.Sector) FirstAvgs, "
                    + "(select S.Sector, AVG(AP.Close) as AvgLastDayClose "
                    + "from AdjustedPrices AP, Securities S "
                    + "where AP.Ticker = S.Ticker "
                    + "and AP.Day = (select MAX(AP.Day) as LastDay "
                    + "from AdjustedPrices AP "
                    + "where YEAR(AP.Day) = 2016) "
                    + "and S.Sector <> 'Telecommunications Services' "
                    + "group by S.Sector) LastAvgs "
                    + "where FirstAvgs.Sector = LastAvgs.Sector) Percentages;");
            
            output.println("<p>");
            output.println("<h2>General Analytical Data #5</h2>");
            output.println("Performance of all sectors (excluding Telcommunication Services) in 2016. "
                    + "The sector is considered 'Tanking' if its value of the difference in the average "
                    + "close of the last day in 2016 and the average close of the first day in 2016, divided by the average "
                    + "close of the first day is a negative value. If the value is in between 0 and less than 0.1, the "
                    + "sector is considered 'Average'. If the value is in between 0.1 and less than 0.2, the sector is "
                    + "considered 'Above Average'. If the value is greater than 0.2, the sector is considered as 'Significantly "
                    + "Outperforming'. These ranges are based on estimates of different levels of how well the sector is "
                    + "performing in 2016.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Sector, Performance</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Sector") + ", " + result.getString("Performance"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // ----------------------------------------------------------------------------------------------------------------
        
        // First Individual Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select * "
            		+ "from (select AP.Ticker, MIN(AP.Day) as FirstDay, MAX(AP.Day) as LastDay "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "'" + ") Solar;");
            
            output.println("<p>");
            output.println("<h2>Individual Stock Data #1</h2>");
            output.println("Range of dates for which the pricing data is available.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Ticker, FirstDay, LastDay</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Ticker") + ", " + result.getString("FirstDay") + ", " + result.getString("LastDay"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Second Individual Query Part 1
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select YEAR(EndCloses.Day) as Year, EndCloses.Ticker, (EndCloses.Close - StartCloses.Close) as IncDecPrices "
            		+ "from (select AP.Ticker, AP.Day, AP.Close "
            		+ "from AdjustedPrices AP, "
            		+ "(select AP.Ticker, MIN(AP.Day) as Min "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "' "
            		+ "group by YEAR(AP.Day)) FirstDaysSolar "
            		+ "where AP.Ticker = FirstDaysSolar.Ticker "
            		+ "and AP.Day = FirstDaysSolar.Min) StartCloses, "
            		+ "(select AP.Ticker, AP.Day, AP.Close "
            		+ "from AdjustedPrices AP, "
            		+ "(select AP.Ticker, MAX(AP.Day) as Max "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "' "
            		+ "group by YEAR(AP.Day)) LastDaysSolar "
            		+ "where AP.Ticker = LastDaysSolar.Ticker "
            		+ "and AP.Day = LastDaysSolar.Max) EndCloses "
            		+ "where EndCloses.Ticker = StartCloses.Ticker "
            		+ "group by YEAR(EndCloses.Day);");
            
            output.println("<p>");
            output.println("<h2>Individual Stock Data #2</h2>");
            output.println("For each year, report the increase/decrease in prices year-over-year.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, IncDecPrices</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("IncDecPrices"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Second Individual Query Part 2
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select YEAR(AP.Day) as Year, AP.Ticker, SUM(AP.Volume) as Sum "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "' "
            		+ "group by YEAR(AP.Day);");
            
            output.println("<p>");
            output.println("For each year, report the volume of trading.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, Sum</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("Sum"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Second Individual Query Part 3
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Close), 2) as AvgClose "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "' "
            		+ "group by YEAR(AP.Day);");
            
            output.println("<p>");
            output.println("For each year, report the average closing price in a given year.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, AvgClose</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("AvgClose"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Second Individual Query Part 4
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select YEAR(AP.Day) as Year, AP.Ticker, ROUND(AVG(AP.Volume), 2) as AvgVolume "
            		+ "from AdjustedPrices AP "
            		+ "where AP.Ticker = '" + args[0] + "' "
            		+ "group by YEAR(AP.Day);");
            
            output.println("<p>");
            output.println("For each year, report the average trade volume per day.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Ticker, AvgVolume</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Ticker") + ", " + result.getString("AvgVolume"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Third Individual Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select MONTHNAME(Day) as Month, ROUND(AVG(Close), 2) as AvgClose, MAX(High) as HighestPrice, MIN(Low) as LowestPrice, ROUND(AVG(Volume), 2) as AvgVolume "
            		+ "from AdjustedPrices AP "
            		+ "where YEAR(Day) = 2016 "
            		+ "and Ticker = '" + args[0] + "' "
            		+ "group by MONTH(Day);");
            
            output.println("<p>");
            output.println("<h2>Individual Stock Data #3</h2>");
            output.println("For 2016, show the average closing price, the highest and the lowest price, and the average "
            		+ "daily trading volume by month.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Month, AvgClose, HighestPrice, LowestPrice, AvgVolume</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Month") + ", " + result.getString("AvgClose") + ", " + result.getString("HighestPrice")
                + ", " + result.getString("LowestPrice") + ", " + result.getString("AvgVolume"));
                output.println("</td>");
                output.println("</tr>");
            }

            output.println("</table>");
        } catch (SQLException e) {
            System.out.println("Uh oh");
        }
        
        // Fourth Individual Query
        try {
            Statement s = conn.createStatement();

            ResultSet result = s.executeQuery("select Year, Month "
            		+ "from (select T3.Year as Year, MONTHNAME(STR_TO_DATE(T3.Month, '%m')) as Month, MaxChange "
            		+ "from (select Year, MAX(AvgChange) as MaxChange "
            		+ "from (select YEAR(Day) as Year, MONTH(Day) as Month, (MAX(High) - MIN(Low)) as AvgChange "
            		+ "from AdjustedPrices AP "
            		+ "where Ticker = 'CB' "
            		+ "group by Year, Month) T1 "
            		+ "group by Year) T2, "
            		+ "(select YEAR(Day) as Year, MONTH(Day) as Month, (MAX(High) - MIN(Low)) as AvgChange "
            		+ "from AdjustedPrices AP "
            		+ "where Ticker = 'CB' "
            		+ "group by Year, Month) T3 "
            		+ "where T2.Year = T3.Year "
            		+ "and T2.MaxChange = T3.AvgChange "
            		+ "group by T3.Year, T3.Month "
            		+ ") T4;");
            
            output.println("<p>");
            output.println("<h2>Individual Stock Data #4</h2>");
            output.println("Determine the month of best performance for each of the years. We determined the best performance"
            		+ " by subtracting the maximum high of the stock by the minimum low of the stock and getting the maximum"
            		+ " difference to get the stock that increased the most within each month.");
            output.println("</p>");
            
            output.println("<table>");
            output.println("<tr>");
            output.println("<th align='left'>Year, Month</th>");
            output.println("</tr>");
            
            while (result.next()) {
                output.println("<tr>");
                output.print("<td>");
                output.print(result.getString("Year") + ", " + result.getString("Month"));
                output.println("</td>");
                output.println("</tr>");
            }

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