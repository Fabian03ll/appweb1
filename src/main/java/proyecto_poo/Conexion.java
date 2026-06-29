package proyecto_poo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // Cambiamos la ruta para apuntar a tu nueva instancia Express
   private static final String IP_INSTANCIA = "localhost";
    private static final String BD = "Proyecto_POO_Gestion";
    
    // NOTA: Como usas Windows Authentication, estos pueden quedar vacíos si usas integratedSecurity
    private static final String USUARIO = ""; 
    private static final String CONTRASENA = ""; 

   public static Connection getConnection() {
    Connection con = null;
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String usuario = "sa";
        String password = "Admin123456";
        String connectionUrl = "jdbc:sqlserver://localhost:1433;databaseName=Proyecto_POO_Gestion;encrypt=true;trustServerCertificate=true;";
        String cadena = "jdbc:sqlserver://localhost:1433;databaseName=Proyecto_POO_Gestion;"
                      + "user=" + usuario + ";password=" + password + ";"
                      + "encrypt=true;trustServerCertificate=true;";
        
        con = DriverManager.getConnection(cadena);
        System.out.println("--- CONEXIÓN EXITOSA ---");
        
    } catch (Exception e) {
        // AQUÍ ESTÁ EL TRUCO: Imprimimos el error real en la consola
        System.err.println("--- ERROR CRÍTICO AL CONECTAR ---");
        e.printStackTrace(); 
    }
    return con; // Si falla, devolverá null y causará el error que ya vimos
}
    public static void inicializarBaseDatos() {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Base de datos SQL Server lista.");
            }
        } catch (Exception e) {
            System.err.println("Error al inicializar la base de datos: " + e.getMessage());
        }
    }
}