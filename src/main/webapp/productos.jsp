
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Productos</title>
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
        .form-grid { display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 14px; align-items: end; }
        input, select { width: 100%; padding: 9px 13px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; outline: none; transition: border 0.2s; background: #fafafa; }
        input:focus, select:focus { border-color: #2ed573; background: white; }
        label { display: block; margin-bottom: 5px; font-size: 12px; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
        .badge-mp { background: #e8f5e9; color: #2e7d32; }
        .badge-pt { background: #e3f2fd; color: #1565c0; }
        .badge-other { background: #f3e5f5; color: #6a1b9a; }
        .filter-bar { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; flex-wrap: wrap; }
        .filter-bar select { width: auto; min-width: 180px; }
        .filter-bar input { width: auto; min-width: 220px; }
        .tag-nueva { display: inline-block; background: #fff3cd; color: #856404; border-radius: 6px; font-size: 11px; padding: 2px 8px; margin-left: 6px; font-weight: 600; }
        .nueva-cat-group { display: none; }
        .nueva-cat-group.visible { display: block; }
        .toggle-nueva { color: #2ed573; font-size: 12px; cursor: pointer; text-decoration: underline; margin-top: 4px; display: inline-block; }
        .count { font-size: 13px; color: #888; margin-left: auto; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
        .error-msg { background: #fff0f0; color: #c0392b; padding: 10px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
    </style>
</head>
<body>

<%
String filtroTipo = request.getParameter("filtroTipo") != null ? request.getParameter("filtroTipo") : "TODOS";
String filtroNombre = request.getParameter("filtroNombre") != null ? request.getParameter("filtroNombre") : "";
String errorMsg = (String) request.getAttribute("error");
%>

<% if (errorMsg != null) { %>
<div class="error-msg">⚠️ <%= errorMsg %></div>
<% } %>

<%-- FORMULARIO AGREGAR --%>
<div class="card">
    <h2>➕ Registrar Nuevo Producto</h2>
    <form action="ProductoServlet" method="POST">
        <div class="form-grid">
            <div>
                <label>Nombre del producto</label>
                <input type="text" name="nombre" placeholder="Ej: TELA DE ALGODÓN" required/>
            </div>
            <div>
                <label>Categoría existente</label>
                <select name="tipo" id="selectTipo">
                    <%
                    try (Connection conn = proyecto_poo.Conexion.getConnection()) {
                        String sql = "SELECT DISTINCT tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' ORDER BY tipo";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                        <option value="<%= rs.getString("tipo") %>"><%= rs.getString("tipo") %></option>
                    <%  } } catch(Exception e) { } %>
                </select>
                <span class="toggle-nueva" onclick="toggleNueva()">+ Nueva categoría</span>
            </div>
            <div class="nueva-cat-group" id="nuevaCatGroup">
                <label>Nueva categoría <span class="tag-nueva">NUEVO</span></label>
                <input type="text" name="tipoNuevo" id="tipoNuevo" placeholder="Ej: Insumos"/>
            </div>
            <div>
                <button type="submit" class="btn btn-primary">+ Registrar</button>
            </div>
        </div>
    </form>
</div>

<%-- FILTROS --%>
<div class="card">
    <h2>📋 Lista de Productos</h2>
    <form method="GET" action="ProductoServlet">
        <div class="filter-bar">
            <div>
                <label>Buscar por nombre</label>
                <input type="text" name="filtroNombre" placeholder="Buscar producto..." value="<%= filtroNombre %>"/>
            </div>
            <div>
                <label>Filtrar por tipo</label>
                <select name="filtroTipo">
                    <option value="TODOS" <%= filtroTipo.equals("TODOS") ? "selected" : "" %>>Todos</option>
                    <%
                    try (Connection conn = proyecto_poo.Conexion.getConnection()) {
                        String sql = "SELECT DISTINCT tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' ORDER BY tipo";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            String t = rs.getString("tipo");
                    %>
                        <option value="<%= t %>" <%= filtroTipo.equals(t) ? "selected" : "" %>><%= t %></option>
                    <%  } } catch(Exception e) { } %>
                </select>
            </div>
            <div style="display:flex;gap:8px;align-items:flex-end">
                <button type="submit" class="btn btn-primary">Filtrar</button>
                <a href="ProductoServlet" class="btn btn-secondary">Limpiar</a>
            </div>
        </div>
    </form>

    <table>
        <thead>
            <tr>
                <th>Código</th>
                <th>Nombre</th>
                <th>Tipo</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
        <%
        try (Connection conn = proyecto_poo.Conexion.getConnection()) {
            String sql;
            PreparedStatement ps;

            boolean tieneNombre = !filtroNombre.isEmpty();
            boolean tieneTipo = !filtroTipo.equals("TODOS");

            if (tieneNombre && tieneTipo) {
                sql = "SELECT codigo, nombre, tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' AND nombre LIKE ? AND tipo = ? ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + filtroNombre + "%");
                ps.setString(2, filtroTipo);
            } else if (tieneNombre) {
                sql = "SELECT codigo, nombre, tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' AND nombre LIKE ? ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + filtroNombre + "%");
            } else if (tieneTipo) {
                sql = "SELECT codigo, nombre, tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' AND tipo = ? ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, filtroTipo);
            } else {
                sql = "SELECT codigo, nombre, tipo FROM Productos WHERE tipo != 'CATEGORIA_BASE' ORDER BY codigo ASC";
                ps = conn.prepareStatement(sql);
            }

            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                String tipo = rs.getString("tipo");
                String badgeClass = tipo.contains("Prima") ? "badge-mp" : tipo.contains("Terminado") ? "badge-pt" : "badge-other";
        %>
        <tr>
            <td><strong><%= rs.getString("codigo") %></strong></td>
            <td><%= rs.getString("nombre") %></td>
            <td><span class="badge <%= badgeClass %>"><%= tipo %></span></td>
            <td>
                <a href="ProductoServlet?accion=eliminar&codigo=<%= rs.getString("codigo") %>"
                   onclick="return confirm('¿Eliminar este producto?')"
                   class="btn btn-danger">Eliminar</a>
            </td>
        </tr>
        <%  }
            if (count == 0) { %>
        <tr><td colspan="4" style="text-align:center;color:#aaa;padding:24px;">No se encontraron productos</td></tr>
        <% } } catch(Exception e) { out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>"); } %>
        </tbody>
    </table>
</div>

<script>
function toggleNueva() {
    const group = document.getElementById('nuevaCatGroup');
    const select = document.getElementById('selectTipo');
    const input = document.getElementById('tipoNuevo');
    const isVisible = group.classList.contains('visible');
    group.classList.toggle('visible');
    if (!isVisible) {
        select.disabled = true;
        input.required = true;
    } else {
        select.disabled = false;
        input.required = false;
        input.value = '';
    }
}
</script>

</body>
</html>