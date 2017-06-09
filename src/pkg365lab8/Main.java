/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pkg365lab8;

import java.sql.*;


/**
 *
 * @author Matthew
 */
public class Main
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)
    {
        Connection conn = null;
        String url = "jdbc:mysql://cslvm74.csc.calpoly.edu/";
        String user = "mpbryan";
        String password = "JP3E2Ca9";
        String statement = "select * from list";
        try
        {
            conn = DriverManager.getConnection(url, user, password);
        }
        catch (Exception ex)
        {
            System.out.println("Could not open connection");
        }
    }
}
