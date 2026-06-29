<%-- 
    Document   : inventario
    Created on : 27 jun 2026, 9:05:54 p.m.
    Author     : smite
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventario</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #f0f2f5; padding: 24px; }
        .card { background: white; border-radius: 12px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); animation: fadeIn 0.3s ease; }
        .card h2 { color: #1a2940; margin-bottom: 18px; font-size: 16px; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a2940; color: white; padding: 12px 16px; text-align: left; font-weight: 500; font-size: 13px; }
        td { padding: 11px 16px; border-bottom: 1px solid #f0f2f5; font-size: 14px; }
        tr:hover td { background: #f8f9ff; transition: background 0.2s; }
        .btn { padding: 7px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 500; transition: all 0.2s; text-decoration: none; display: inline-block; }
        .btn-danger { background: #ff4757; color: white; }
        .btn-danger:hover { background: #ff3346; transform: translateY(-1px); }
        .btn-primary { background: #2ed573; color: white; padding: 10px 22px; }
        .btn-primary:hover { background: #26c265; transform: translateY(-1px); }
        .btn-secondary { background: #f0f2f5; color: #1a2940; padding: 10px 18px; }
        .btn-secondary:hover { background: #e2e5ea; }
        input, select { width: 100%; padding: 9px 13px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; outline: none; transition: border 0.2s; background: #fafafa; }
        input:focus, select:focus { border-color: #2ed573; background: white; }
        label { display: block; margin-bottom: 5px; font-size: 12px; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .filter-bar { display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; margin-bottom: 16px; }
        .filter-bar select, .filter-bar input { width: auto; min-width: 180px; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
        .badge-normal { background: #e8f5e9; color: #2e7d32; }
        .badge-bajo { background: #fff8e1; color: #f57f17; }
        .badge-sin { background: #ffebee; color: #c62828; }
        .stock-normal { color: #2e7d32; font-weight: 600; }
        .stock-bajo { color: #f57f17; font-weight: 600; }
        .stock-sin { color: #c62828; font-weight: 600; }
        .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 20px; }
        .stat-card { background: white; border-radius: 12px; padding: 20px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        .stat-card .num { font-size: 32px; font-weight: 700; margin-bottom: 4px; }
        .stat-card .lbl { font-size: 13px; color: #888; }
        .num-normal { color: #2e7d32; }
        .num-bajo { color: #f57f17; }
        .num-sin { color: #c62828; }
        .checkbox-group { display: flex; align-items: center; gap: 8px; padding: 9px 0; }
        .checkbox-group input { width: auto; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<%
String filtroTipo = request.getParameter("filtroTipo") != null ? request.getParameter("filtroTipo") : "TODOS";
String soloSinStock = request.getParameter("sinStock") != null ? request.getParameter("sinStock") : "";
%>

<%-- ESTADÍSTICAS --%>
<%
int totalNormal = 0, totalBajo = 0, totalSin = 0;
try (Connection connStat = proyecto_poo.Conexion.getConnection()) {
    ResultSet rsStat = connStat.createStatement().executeQuery("SELECT stock FROM Inventario");
    while (rsStat.next()) {
        int s = rsStat.getInt("stock");
        if (s == 0) totalSin++;
        else if (s <= 10) totalBajo++;
        else totalNormal++;
    }
} catch(Exception e) {}
%>

<div class="stats">
    <div class="stat-card">
        <div class="num num-normal"><%= totalNormal %></div>
        <div class="lbl">Stock Normal</div>
    </div>
    <div class="stat-card">
        <div class="num num-bajo"><%= totalBajo %></div>
        <div class="lbl">Stock Bajo (≤10)</div>
    </div>
    <div class="stat-card">
        <div class="num num-sin"><%= totalSin %></div>
        <div class="lbl">Sin Stock</div>
    </div>
</div>

<%-- TABLA INVENTARIO --%>
<div class="card">
    <h2>📦 Control de Inventario</h2>

   <form method="GET" action="InventarioServlet">
        <div style="display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; margin-bottom:16px;">
            <div style="display:flex; flex-direction:column;">
                <label>Filtrar por tipo</label>
                <select name="filtroTipo" style="height:38px; padding:0 12px; border:1.5px solid #e0e0e0; border-radius:8px; font-size:14px; background:#fafafa; outline:none;">
                    <option value="TODOS" <%= filtroTipo.equals("TODOS") ? "selected" : "" %>>Todos</option>
                    <%
                    try (Connection conn = proyecto_poo.Conexion.getConnection()) {
                        ResultSet rs = conn.createStatement().executeQuery("SELECT DISTINCT tipo FROM Inventario ORDER BY tipo");
                        while (rs.next()) {
                            String t = rs.getString("tipo");
                    %>
                        <option value="<%= t %>" <%= filtroTipo.equals(t) ? "selected" : "" %>><%= t %></option>
                    <%  } } catch(Exception e) {} %>
                </select>
            </div>

            <div style="display:flex; flex-direction:column;">
                <label>Stock</label>
                <div style="display:flex; align-items:center; gap:6px; height:38px; border:1.5px solid #e0e0e0; border-radius:8px; padding:0 12px; background:#fafafa;">
                    <input type="checkbox" name="sinStock" value="1"
                           <%= soloSinStock.equals("1") ? "checked" : "" %>
                           style="width:15px; height:15px; cursor:pointer; margin:0; flex-shrink:0;"/>
                    <span style="font-size:14px; color:#333;">Sin stock</span>
                </div>
            </div>

            <div style="display:flex; gap:8px; align-items:flex-end; height:38px;">
                <button type="submit" class="btn btn-primary">Filtrar</button>
                <a href="InventarioServlet" class="btn btn-secondary">Limpiar</a>
            </div>
        </div>
    </form>

    <table>
        <thead>
            <tr>
                <th>Código</th>
                <th>Tipo</th>
                <th>Producto</th>
                <th>Pabellón</th>
                <th>Stock</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
        <%
        try (Connection conn = proyecto_poo.Conexion.getConnection()) {
            String sql;
            PreparedStatement ps;
            boolean tieneTipo = !filtroTipo.equals("TODOS");
            boolean sinStockFiltro = soloSinStock.equals("1");

            if (tieneTipo && sinStockFiltro) {
                sql = "SELECT * FROM Inventario WHERE tipo = ? AND stock = 0 ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, filtroTipo);
            } else if (tieneTipo) {
                sql = "SELECT * FROM Inventario WHERE tipo = ? ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, filtroTipo);
            } else if (sinStockFiltro) {
                sql = "SELECT * FROM Inventario WHERE stock = 0 ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
            } else {
                sql = "SELECT * FROM Inventario ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
            }

            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                int stock = rs.getInt("stock");
                String estadoClass = stock == 0 ? "badge-sin" : stock <= 10 ? "badge-bajo" : "badge-normal";
                String estadoTxt = stock == 0 ? "Sin Stock" : stock <= 10 ? "Stock Bajo" : "Normal";
                String stockClass = stock == 0 ? "stock-sin" : stock <= 10 ? "stock-bajo" : "stock-normal";
        %>
        <tr>
            <td><strong><%= rs.getString("codigo") %></strong></td>
            <td><%= rs.getString("tipo") %></td>
            <td><%= rs.getString("producto") %></td>
            <td><%= rs.getString("pabellon") %></td>
            <td class="<%= stockClass %>"><%= stock %></td>
            <td><span class="badge <%= estadoClass %>"><%= estadoTxt %></span></td>
            <td>
                <a href="InventarioServlet?accion=eliminar&codigo=<%= rs.getString("codigo") %>"
                   onclick="return confirm('¿Eliminar este registro de inventario?')"
                   class="btn btn-danger">Eliminar</a>
            </td>
        </tr>
        <%  }
            if (count == 0) { %>
        <tr><td colspan="7" style="text-align:center;color:#aaa;padding:24px;">No se encontraron registros</td></tr>
        <% } } catch(Exception e) { out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>"); } %>
        </tbody>
    </table>
</div>

</body>
</html>