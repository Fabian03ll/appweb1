package proyecto_poo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // Cambiamos la ruta para apuntar a tu nueva instancia Express
    private static final String IP_INSTANCIA = "localhost\\SQLEXPRESS";
    private static final String BD = "Proyecto_POO_Gestion";
    
    // NOTA: Como usas Windows Authentication, estos pueden quedar vacíos si usas integratedSecurity
    private static final String USUARIO = ""; 
    private static final String CONTRASENA = ""; 

    public static Connection getConnection() {
        Connection conexion = null;
        try {
            // OBLIGATORIO PARA PROYECTOS WEB: Registrar el driver manualmente
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Armamos la nueva cadena con SQL Server 2022 y confianza de certificado
            /*String cadenaConexion = "jdbc:sqlserver://" + IP_INSTANCIA 
                    + ";databaseName=" + BD
                    + ";integratedSecurity=true" // Para que use tu cuenta de Windows
                    + ";encrypt=true"
                    + ";trustServerCertificate=true;";*/ // El check que activamos en SSMS
                String cadenaConexion = "jdbc:sqlserver://DESKTOP-NOL4MLB"
                    + ";databaseName=Proyecto_POO_Gestion"
                    + ";user=vale"
                    + ";password=capybara"
                    + ";encrypt=true"
                    + ";trustServerCertificate=true";
            conexion = DriverManager.getConnection(cadenaConexion);
            System.out.println("¡Conexión exitosa a SQL Server desde la Web!");

        } catch (ClassNotFoundException e) {
            System.err.println("Error: ¿Falta el Driver JDBC en las dependencias? " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error al conectar a la BD: " + e.getMessage());
        }
        return conexion;
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