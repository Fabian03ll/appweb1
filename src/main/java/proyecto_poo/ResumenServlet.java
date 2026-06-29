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

@WebServlet(name = "ResumenServlet", urlPatterns = {"/ResumenServlet"})
public class ResumenServlet extends HttpServlet {

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
        try (PrintWriter out = response.getWriter();
            Connection conn = Conexion.getConnection()) {

           // Total de productos
           PreparedStatement ps1 = conn.prepareStatement(
                   "SELECT COUNT(*) total FROM Inventario");
           ResultSet rs1 = ps1.executeQuery();
           rs1.next();
           int totalProductos = rs1.getInt("total");

           // Stock total
           PreparedStatement ps2 = conn.prepareStatement(
                   "SELECT SUM(stock) stock FROM Inventario");
           ResultSet rs2 = ps2.executeQuery();
           rs2.next();
           int stockTotal = rs2.getInt("stock");

           // Entradas
           PreparedStatement ps3 = conn.prepareStatement(
                   "SELECT COUNT(*) total FROM Movimientos WHERE movimiento='ENTRADA'");
           ResultSet rs3 = ps3.executeQuery();
           rs3.next();
           int entradas = rs3.getInt("total");

           // Salidas
           PreparedStatement ps4 = conn.prepareStatement(
                   "SELECT COUNT(*) total FROM Movimientos WHERE movimiento='SALIDA'");
           ResultSet rs4 = ps4.executeQuery();
           rs4.next();
           int salidas = rs4.getInt("total");

           // Último movimiento
           PreparedStatement ps5 = conn.prepareStatement(
                   "SELECT TOP 1 producto, movimiento FROM Movimientos ORDER BY id DESC");
           ResultSet rs5 = ps5.executeQuery();

           String ultimo = "Sin movimientos";

           if (rs5.next()) {
               ultimo = rs5.getString("movimiento")
                       + " - "
                       + rs5.getString("producto");
           }

           out.println(totalProductos);
           out.println(stockTotal);
           out.println(entradas);
           out.println(salidas);
           out.println(ultimo);

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
