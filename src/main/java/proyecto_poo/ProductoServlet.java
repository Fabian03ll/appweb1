package proyecto_poo;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ProductoServlet", urlPatterns = {"/ProductoServlet"})
public class ProductoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("eliminar".equals(accion)) {
            eliminarProducto(request, response);
        } else {
            request.getRequestDispatcher("productos.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        agregarProducto(request, response);
    }

    private void agregarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String tipoExistente = request.getParameter("tipo");
        String tipoNuevo = request.getParameter("tipoNuevo");
        String tipo = (tipoNuevo != null && !tipoNuevo.trim().isEmpty()) ? tipoNuevo.trim() : tipoExistente;

        try (Connection conn = Conexion.getConnection()) {
            // ← VALIDACIÓN DE DUPLICADOS
            String sqlCheck = "SELECT COUNT(*) FROM Productos WHERE LOWER(nombre) = LOWER(?)";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, nombre.trim());
            ResultSet rsCheck = psCheck.executeQuery();
            rsCheck.next();
            if (rsCheck.getInt(1) > 0) {
                request.setAttribute("error", "Este producto ya está registrado: " + nombre);
                request.getRequestDispatcher("productos.jsp").forward(request, response);
                return;
            }
            
            String prefijo = obtenerPrefijo(conn, tipo);
            String codigo = generarCodigo(conn, prefijo);

            String sqlProd = "INSERT INTO Productos (codigo, nombre, tipo) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sqlProd);
            ps.setString(1, codigo);
            ps.setString(2, nombre.toUpperCase());
            ps.setString(3, tipo);
            ps.executeUpdate();

            String sqlInv = "INSERT INTO Inventario (codigo, tipo, producto, pabellon, stock) VALUES (?, ?, ?, ?, 0)";
            PreparedStatement psInv = conn.prepareStatement(sqlInv);
            psInv.setString(1, codigo);
            psInv.setString(2, tipo);
            psInv.setString(3, nombre.toUpperCase());
            psInv.setString(4, "P" + Integer.parseInt(prefijo));
            psInv.executeUpdate();

            response.sendRedirect("ProductoServlet");
        } catch (SQLException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("productos.jsp").forward(request, response);
        }
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String codigo = request.getParameter("codigo");
        try (Connection conn = Conexion.getConnection()) {
            PreparedStatement psInv = conn.prepareStatement("DELETE FROM Inventario WHERE codigo = ?");
            psInv.setString(1, codigo);
            psInv.executeUpdate();

            PreparedStatement ps = conn.prepareStatement("DELETE FROM Productos WHERE codigo = ?");
            ps.setString(1, codigo);
            ps.executeUpdate();

            response.sendRedirect("ProductoServlet");
        } catch (SQLException e) {
            response.sendRedirect("ProductoServlet");
        }
    }

    private String obtenerPrefijo(Connection conn, String tipo) throws SQLException {
        String sql = "SELECT TOP 1 LEFT(codigo, 2) FROM Productos WHERE tipo = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, tipo);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getString(1);

        String sqlMax = "SELECT MAX(CAST(LEFT(codigo, 2) AS INT)) FROM Productos";
        PreparedStatement psMax = conn.prepareStatement(sqlMax);
        ResultSet rsMax = psMax.executeQuery();
        int max = rsMax.next() ? rsMax.getInt(1) : 0;
        return String.format("%02d", max + 1);
    }

    private String generarCodigo(Connection conn, String prefijo) throws SQLException {
        String sql = "SELECT MAX(CAST(RIGHT(codigo, 2) AS INT)) FROM Productos WHERE LEFT(codigo, 2) = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, prefijo);
        ResultSet rs = ps.executeQuery();
        int max = rs.next() ? rs.getInt(1) : 0;
        return prefijo + String.format("%02d", max + 1);
    }
}