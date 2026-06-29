package proyecto_poo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Devuelve en JSON los datos en VIVO del panel "Inicio" del dashboard
 * (consulta la BD cada vez que se llama, a diferencia de los datos
 * guardados en sesión durante el login, que quedan desactualizados).
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        int totalItems = 0;
        int stockTotal = 0;
        int stockCritico = 0;
        int movimientosHoy = 0;
        StringBuilder agotarseJson = new StringBuilder("[");
        StringBuilder movsJson = new StringBuilder("[");

        try (Connection conn = Conexion.getConnection();
             PrintWriter out = response.getWriter()) {

            // 1. Total de items registrados
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM Inventario");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalItems = rs.getInt("total");
            }

            // 2. Stock total
            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(stock) AS total_stock FROM Inventario");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stockTotal = rs.getInt("total_stock");
            }

            // 3. Stock crítico (<= 2 unidades)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) AS total_critico FROM Inventario WHERE stock <= 2");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stockCritico = rs.getInt("total_critico");
            }

            // 4. Movimientos de HOY (antes estaba hardcodeado en 18)
            //    La fecha se guarda como texto "dd/MM/yyyy HH:mm"
            String hoy = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) AS total FROM Movimientos WHERE fecha LIKE ?")) {
                ps.setString(1, hoy + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) movimientosHoy = rs.getInt("total");
                }
            }

            // 5. Productos por agotarse (stock <= 5)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT codigo, producto, stock FROM Inventario WHERE stock <= 5 ORDER BY stock ASC");
                 ResultSet rs = ps.executeQuery()) {
                boolean primero = true;
                while (rs.next()) {
                    if (!primero) agotarseJson.append(",");
                    primero = false;
                    agotarseJson.append("{\"codigo\":\"").append(escapar(rs.getString("codigo")))
                            .append("\",\"nombre\":\"").append(escapar(rs.getString("producto")))
                            .append("\",\"stock\":").append(rs.getInt("stock")).append("}");
                }
            }
            agotarseJson.append("]");

            // 6. Últimos 5 movimientos
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT TOP 5 movimiento, producto, cantidad FROM Movimientos ORDER BY id DESC");
                 ResultSet rs = ps.executeQuery()) {
                boolean primero = true;
                while (rs.next()) {
                    if (!primero) movsJson.append(",");
                    primero = false;
                    movsJson.append("{\"tipo\":\"").append(escapar(rs.getString("movimiento")))
                            .append("\",\"producto\":\"").append(escapar(rs.getString("producto")))
                            .append("\",\"cantidad\":").append(rs.getInt("cantidad")).append("}");
                }
            }
            movsJson.append("]");

            String json = "{"
                    + "\"totalItems\":" + totalItems + ","
                    + "\"stockTotal\":" + stockTotal + ","
                    + "\"stockCritico\":" + stockCritico + ","
                    + "\"movimientosHoy\":" + movimientosHoy + ","
                    + "\"listaAgotarse\":" + agotarseJson + ","
                    + "\"listaMovs\":" + movsJson
                    + "}";

            out.print(json);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String escapar(String texto) {
        if (texto == null) return "";
        return texto.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
