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

@WebServlet(name = "MovimientoServlet", urlPatterns = {"/MovimientoServlet"})
public class MovimientoServlet extends HttpServlet {

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
    
    String producto = request.getParameter("producto");
    String tipo = request.getParameter("tipo");
    String cantidadTexto = request.getParameter("cantidad");
    
    try (PrintWriter out = response.getWriter(); Connection conn = Conexion.getConnection()) {
        int cantidad = Integer.parseInt(cantidadTexto);
        // Buscar el stock actual
        String sqlBuscar = "SELECT stock FROM Inventario WHERE producto = ?";
        PreparedStatement psBuscar = conn.prepareStatement(sqlBuscar);
        psBuscar.setString(1, producto);
        ResultSet rs = psBuscar.executeQuery();
        if (!rs.next()) {
            out.print("NO_EXISTE");
            return;
        }
        int stock = rs.getInt("stock");
        // Actualizar stock
        if (tipo.equals("ENTRADA")) {
            stock += cantidad;
        } else {
            if (stock < cantidad) {
                out.print("SIN_STOCK");
                return;
            }
            stock -= cantidad;
        }
        String sqlUpdate = "UPDATE Inventario SET stock = ? WHERE producto = ?";
        PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
        psUpdate.setInt(1, stock);
        psUpdate.setString(2, producto);
        psUpdate.executeUpdate();
        // Registrar movimiento
        String fecha = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        String sqlInsert = "INSERT INTO Movimientos(fecha, producto, movimiento, cantidad) VALUES (?,?,?,?)";
        PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
        psInsert.setString(1, fecha);
        psInsert.setString(2, producto);
        psInsert.setString(3, tipo);
        psInsert.setInt(4, cantidad);
        psInsert.executeUpdate();
        out.print("OK");

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().print("ERROR");
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
