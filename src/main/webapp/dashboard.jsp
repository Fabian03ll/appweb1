<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestión de Inventario</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>

    <div class="dashboard-wrapper">
        
        <header class="top-header">
            <div class="logo-container">
                <img src="resources/cartoon.jpg" alt="Logo" class="logo">
                <h2>Gestión de Inventario</h2>
            </div>
            <div class="user-info">
                <span>Administrador</span> </div>
        </header>

        <div class="main-container">
            
            <aside class="sidebar">
                <nav>
                    <ul class="menu">
                        <li><a href="#" class="menu-btn active" data-target="inicio">Inicio</a></li>
                        <li><a href="#" class="menu-btn" data-target="inventario">Inventario</a></li>
                        <li><a href="#" class="menu-btn" data-target="productos">Productos</a></li>
                        <li><a href="#" class="menu-btn" data-target="movimientos">Movimientos</a></li>                        
                    </ul>
                </nav>
            </aside>

            <main class="content-area">
    
                <section id="inicio" class="content-section active-section">
                    <div class="welcome-header">
                        <h3>Panel Principal</h3>
                        <p>Resumen logístico del estado de los productos en almacén.</p>
                    </div>

                    <div class="kpi-container">
                        <div class="kpi-card">
                            <div class="kpi-icon blue">📦</div>
                            <div class="kpi-data">
                                <h4>Ítems Registrados</h4>
                                <p class="kpi-value">${not empty sessionScope.totalItems ? sessionScope.totalItems : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-icon green">📥</div>
                            <div class="kpi-data">
                                <h4>Stock Total</h4>
                                <p class="kpi-value">${not empty sessionScope.stockTotal ? sessionScope.stockTotal : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card alert">
                            <div class="kpi-icon red">⚠️</div>
                            <div class="kpi-data">
                                <h4>Stock Crítico / Cero</h4>
                                <p class="kpi-value">${not empty sessionScope.stockCritico ? sessionScope.stockCritico : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-icon purple">🔄</div>
                            <div class="kpi-data">
                                <h4>Movimientos (Hoy)</h4>
                                <p class="kpi-value">${not empty sessionScope.movimientosHoy ? sessionScope.movimientosHoy : 0}</p>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-details">

                        <div class="detail-box">
                            <h4><span class="status-dot red">•</span> Productos por Agotarse</h4>
                            <div class="table-responsive">
                                <table class="mini-table">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Producto</th>
                                            <th>Stock Act.</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="p" items="${sessionScope.listaAgotarse}">
                                        <tr>
                                            <td>${p.codigo}</td>
                                            <td>${p.nombre}</td>
                                            <td><span class="badge ${p.stock == 0 ? 'badge-danger' : 'badge-warning'}">${p.stock} u.</span></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="detail-box">
                            <h4><span class="status-dot blue">•</span> Últimas Operaciones</h4>
                            <div class="table-responsive">
                                <table class="mini-table">
                                    <thead>
                                        <tr>
                                            <th>Tipo</th>
                                            <th>Producto</th>
                                            <th>Cant.</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="m" items="${sessionScope.listaMovs}">
                                            <tr>
                                                <td>
                                                    <%-- Aquí el badge cambia de color automáticamente según si es ENTRADA o SALIDA --%>
                                                    <span class="badge ${m.tipo == 'ENTRADA' ? 'badge-success' : 'badge-danger'}">
                                                        ${m.tipo}
                                                    </span>
                                                </td>
                                                <td>${m.producto}</td>
                                                <td>${m.cantidad}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
                </section>

                <section id="inventario" class="content-section">
                    <h3>Gestión de Inventario</h3>
                    <p>Aquí irá la tabla general de tu inventario.</p>
                </section>

                <section id="productos" class="content-section">
                    <h3>Catálogo de Productos</h3>
                    <p>Aquí podrás agregar, editar o eliminar productos.</p>
                </section>

                <section id="movimientos" class="content-section">
                    <h3>Entradas y Salidas</h3>
                    <p>Registro de movimientos del inventario.</p>
                </section>

            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="dashboard.js"></script>

</body>
</html>