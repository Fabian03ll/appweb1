/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package proyecto_poo;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("eliminar".equals(accion)) {
            eliminar(request, response);
        } else {
            request.getRequestDispatcher("inventario.jsp").forward(request, response);
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String codigo = request.getParameter("codigo");
        try (Connection conn = Conexion.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM Inventario WHERE codigo = ?");
            ps.setString(1, codigo);
            ps.executeUpdate();
            response.sendRedirect("InventarioServlet");
        } catch (SQLException e) {
            response.sendRedirect("InventarioServlet");
        }
    }
}