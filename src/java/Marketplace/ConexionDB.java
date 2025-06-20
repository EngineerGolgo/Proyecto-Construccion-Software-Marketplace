package Marketplace;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionDB {
    public static Connection obtenerConexion() {
        Connection conexion = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/marketplace", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conexion;
    }
}