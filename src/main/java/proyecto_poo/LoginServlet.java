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
import java.util.ArrayList; 
import java.util.List;      

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String txtUser = request.getParameter("usuario"); 
        String txtPass = request.getParameter("contrasena"); 
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = Conexion.getConnection();
            
            // 1. Validar credenciales
            String sql = "SELECT username, rol FROM Usuarios WHERE username = ? AND password = ? AND estado = 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, txtUser);
            ps.setString(2, txtPass);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", rs.getString("username"));
                session.setAttribute("rol", rs.getString("rol"));
                
                int totalItems = 0;
                int stockTotal = 0;
                int stockCritico = 0;
                
                // 2. Contar ítems únicos (Usando la misma conexión abierta)
                String sqlCount = "SELECT COUNT(*) AS total FROM Inventario";
                try (PreparedStatement psCount = conn.prepareStatement(sqlCount);
                     ResultSet rsCount = psCount.executeQuery()) {
                    if (rsCount.next()) {
                        totalItems = rsCount.getInt("total");
                    }
                }
                
                // 3. Sumar existencias totales
                String sqlSum = "SELECT SUM(stock) AS total_stock FROM Inventario"; 
                try (PreparedStatement psSum = conn.prepareStatement(sqlSum);
                     ResultSet rsSum = psSum.executeQuery()) {
                    if (rsSum.next()) {
                        stockTotal = rsSum.getInt("total_stock");
                    }
                }
                
                // 4. Contar Stock Crítico (Menor o igual a 2 unidades)
                String sqlCritico = "SELECT COUNT(*) AS total_critico FROM Inventario WHERE stock <= 2"; 
                try (PreparedStatement psCrit = conn.prepareStatement(sqlCritico);
                     ResultSet rsCrit = psCrit.executeQuery()) {
                    if (rsCrit.next()) {
                        stockCritico = rsCrit.getInt("total_critico");
                    }
                }

                // Guardamos los valores reales directamente en la SESIÓN global
                session.setAttribute("totalItems", totalItems);
                session.setAttribute("stockTotal", stockTotal);
                session.setAttribute("stockCritico", stockCritico);

                // Movimientos de HOY (antes estaba hardcodeado en 18)
                int movimientosHoy = 0;
                String hoy = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                String sqlHoy = "SELECT COUNT(*) AS total FROM Movimientos WHERE fecha LIKE ?";
                try (PreparedStatement psHoy = conn.prepareStatement(sqlHoy)) {
                    psHoy.setString(1, hoy + "%");
                    try (ResultSet rsHoy = psHoy.executeQuery()) {
                        if (rsHoy.next()) {
                            movimientosHoy = rsHoy.getInt("total");
                        }
                    }
                }
                session.setAttribute("movimientosHoy", movimientosHoy);
                List<Producto> listaAgotarse = new ArrayList<>();
                String sqlAgotarse = "SELECT codigo, producto, stock FROM Inventario WHERE stock <= 5 ORDER BY stock ASC";
                try (PreparedStatement psAgot = conn.prepareStatement(sqlAgotarse); 
                     ResultSet rsAgot = psAgot.executeQuery()) {
                    while (rsAgot.next()) {
                        Producto p = new Producto();
                        p.setCodigo(rsAgot.getString("codigo"));
                        p.setNombre(rsAgot.getString("producto"));
                        p.setStock(rsAgot.getInt("stock"));
                        listaAgotarse.add(p);
                    }
                }
                session.setAttribute("listaAgotarse", listaAgotarse);

                // 6. Obtener Últimas Operaciones (TOP 5)
                List<Movimiento> listaMovs = new ArrayList<>();
                // Si usas SQL Server usa TOP 5, si usas MySQL usa LIMIT 5 al final de la consulta
                String sqlMovs = "SELECT TOP 5 movimiento, producto, cantidad FROM Movimientos ORDER BY id DESC"; 
                try (PreparedStatement psMov = conn.prepareStatement(sqlMovs); 
                     ResultSet rsMov = psMov.executeQuery()) {
                   // En tu LoginServlet, cambia la lógica de asignación así:
                while (rsMov.next()) {
                    Movimiento m = new Movimiento();
                    m.setTipo(rsMov.getString("movimiento")); // Usando el setter
                    m.setProducto(rsMov.getString("producto"));
                    m.setCantidad(rsMov.getInt("cantidad"));
                    listaMovs.add(m);
                }
                }
                session.setAttribute("listaMovs", listaMovs);

                // ... (luego tu redirect)
                response.sendRedirect("dashboard.jsp");
                
                
                
            } else {
                response.sendRedirect("Login.html?error=invalid");
            }
            
        } catch (SQLException e) {
            System.err.println("Error en el LoginServlet: " + e.getMessage());
            response.sendRedirect("Login.html?error=db");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}