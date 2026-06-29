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


@WebServlet(name = "ProductoServletD", urlPatterns = {"/ProductoServletD"})
public class ProductoServletD extends HttpServlet {

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

        String categoria = request.getParameter("categoria");
        String filtro = request.getParameter("filtro");

        if (filtro == null) {
            filtro = "";
        }
        
        String estado = request.getParameter("estado");
        if (estado == null) {
            estado = "TODOS";
        }
        
        try (PrintWriter out = response.getWriter();
             Connection conn = Conexion.getConnection()) {

            String sql = "SELECT codigo, producto, stock " +
                            "FROM Inventario " +
                            "WHERE tipo = ? " +
                            "AND producto LIKE ?";

            if (estado.equals("BAJO")) {
                sql += " AND stock < 30";
            }

            if (estado.equals("SIN")) {
                sql += " AND stock = 0";
            }

            sql += " ORDER BY codigo";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, categoria);
            ps.setString(2, "%" + filtro + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                out.println(
                    rs.getString("codigo") + "|" +
                    rs.getString("producto") + "|" +
                    rs.getInt("stock")
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
