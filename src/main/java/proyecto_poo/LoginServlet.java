package proyecto_poo;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
// Esto mapea el formulario HTML con este código Java
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener los datos del formulario HTML
        String txtUser = request.getParameter("usuario"); // Revisa si tu <input> tiene name="usuario"
        String txtPass = request.getParameter("contrasena"); // Revisa si tu <input> tiene name="contrasena"
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // 2. Conectar a SQL Server usando tu clase Conexion
            conn = Conexion.getConnection();
            
            // 3. Consulta SQL para validar credenciales y estado activo
            String sql = "SELECT username, rol FROM Usuarios WHERE username = ? AND password = ? AND estado = 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, txtUser);
            ps.setString(2, txtPass);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // ¡Credenciales correctas! Creamos la sesión del usuario
                HttpSession session = request.getSession();
                session.setAttribute("usuario", rs.getString("username"));
                session.setAttribute("rol", rs.getString("rol"));
                
                // Redirigir al panel principal
                response.sendRedirect("dashboard.html");
            } else {
                // Datos incorrectos: mandar de vuelta al login con un mensaje de error
                response.sendRedirect("Login.html?error=invalid");
            }
            
        } catch (SQLException e) {
            System.err.println("Error en el LoginServlet: " + e.getMessage());
            response.sendRedirect("Login.html?error=db");
        } finally {
            // Cerrar conexiones abiertas por seguridad
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}