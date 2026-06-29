package proyecto_poo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Porroa
 */
@WebServlet(name = "TablaMovimientosServlet", urlPatterns = {"/TablaMovimientosServlet"})
public class TablaMovimientosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

        String tipo = request.getParameter("tipo");
        String fecha = request.getParameter("fecha");
        String producto = request.getParameter("producto");

        if (tipo == null) tipo = "TODOS";
        if (fecha == null) fecha = "";
        if (producto == null) producto = "";

        try (PrintWriter out = response.getWriter();
             Connection conn = Conexion.getConnection()) {
            String sql =
                    "SELECT fecha, producto, movimiento, cantidad " +
                    "FROM Movimientos WHERE 1=1";
            if (!tipo.equals("TODOS")) {
                sql += " AND movimiento=?";
            }
            if (!fecha.equals("")) {
                sql += " AND fecha LIKE ?";
            }
            if (!producto.equals("")) {
                sql += " AND producto LIKE ?";
            }
            sql += " ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            int indice = 1;
            if (!tipo.equals("TODOS")) {
                ps.setString(indice++, tipo);
            }
            if (!fecha.equals("")) {
                String[] partes = fecha.split("-");
                String fechaSQL =
                        partes[2] + "/" +
                        partes[1] + "/" +
                        partes[0];
                ps.setString(indice++, fechaSQL + "%");
            }
            if (!producto.equals("")) {
                ps.setString(indice, "%" + producto + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.println(
                        rs.getString("fecha") + "|" +
                        rs.getString("producto") + "|" +
                        rs.getString("movimiento") + "|" +
                        rs.getInt("cantidad")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
