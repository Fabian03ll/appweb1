<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestión de Inventario</title>
    <link rel="stylesheet" href="dashboard.css">
    <link rel="stylesheet" href="movimientos.css">
</head>
<body>

    <div class="dashboard-wrapper">

        <div class="top-banner">
            <img src="resources/banner.jpg" alt="Banner">
        </div>

        <header class="top-header">
            <div class="logo-container">
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
                <div style="margin-top:auto; padding:20px; text-align:center;">
                      <img src="resources/montapuercos.gif" alt="Decoración" style="width:100%; border-radius:8px;">
                </div>
            </aside>

            <main class="content-area">
    
                <section id="inicio" class="content-section active-section">
                    <div class="welcome-row">
                        <div class="welcome-header">
                            <h3>Panel Principal</h3>
                            <p>Bienvenid@, <%= session.getAttribute("usuario") %>. Selecciona una opción en el menú.</p>
                            <p>Resumen logístico del estado de los productos en almacén.</p>
                        </div>
                        <div class="welcome-gif">
                            <img src="resources/cajas.gif" alt="Animación">
                        </div>
                    </div>

                    <div class="kpi-container">
                        <div class="kpi-card">
                            <div class="kpi-icon blue">📦</div>
                            <div class="kpi-data">
                                <h4>Ítems Registrados</h4>
                                <p class="kpi-value" id="kpiItems">${not empty sessionScope.totalItems ? sessionScope.totalItems : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-icon green">📥</div>
                            <div class="kpi-data">
                                <h4>Stock Total</h4>
                                <p class="kpi-value" id="kpiStock">${not empty sessionScope.stockTotal ? sessionScope.stockTotal : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card alert">
                            <div class="kpi-icon red">⚠️</div>
                            <div class="kpi-data">
                                <h4>Stock Crítico / Cero</h4>
                                <p class="kpi-value" id="kpiCritico">${not empty sessionScope.stockCritico ? sessionScope.stockCritico : 0}</p>
                            </div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-icon purple">🔄</div>
                            <div class="kpi-data">
                                <h4>Movimientos (Hoy)</h4>
                                <p class="kpi-value" id="kpiMovHoy">${not empty sessionScope.movimientosHoy ? sessionScope.movimientosHoy : 0}</p>
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
                                    <tbody id="tablaAgotarse">
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
                                    <tbody id="tablaMovs">
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
                     <iframe src="InventarioServlet" 
                                style="width:100%; height:85vh; border:none;"
                                id="frameInventario">
                     </iframe>
                </section>

                <section id="productos" class="content-section">
                    <iframe src="ProductoServlet" 
                            style="width:100%; height:80vh; border:none;"
                            id="frameProductos">
                    </iframe>
                </section>

                 <section id="movimientos" class="content-section">
                    <!--
                    <h3>Entradas y Salidas</h3>
                    <p>Registro de movimientos del inventario.</p>
                    <p>Bienvenido al sistema. Selecciona una opción en el menú de la izquierda.</p>
                    -->
                    
                    <div id="menuMovimientos">
                        <h2>Módulo de Movimientos</h2>
                        <p>Seleccione una opción.</p>
                        <!--aqui cambie-->
                        <div class="movimientos-opciones">
                            <div class="opcion-movimiento"
                                 id="btnRegistrar"
                                 onclick="abrirMovimientos()">
                                <div class="icono-opcion">
                                    📦
                                </div>
                                <h3>Registrar Movimiento</h3>
                                <p>
                                    Registrar entradas y salidas
                                    del inventario.
                                </p>
                                <button class="btn-opcion">
                                    Comenzar →
                                </button>
                            </div>
                            <div class="opcion-movimiento"
                                 id="btnMostrar"
                                 onclick="abrirVerMovimientos()">
                                <div class="icono-opcion">
                                    📋
                                </div>
                                <h3>Ver Movimientos</h3>
                                <p>
                                    Consultar el historial de
                                    movimientos registrados.
                                </p>
                                <button class="btn-opcion">
                                    Consultar →
                                </button>
                            </div>
                        </div>
                        <!--hasta aca creo-->
                    </div>

                    <!-- Aquí cargaremos registrar o ver movimientos -->
                    <div id="contenidoMovimientos"></div>

                </section>

            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="dashboard.js"></script>

</body>
</html>