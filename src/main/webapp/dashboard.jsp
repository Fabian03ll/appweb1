<%-- 
    Document   : dashboard
    Created on : 26 jun 2026, 9:11:13 p.m.
    Author     : smite
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
                <span><%= session.getAttribute("usuario") %></span>
                <a href="Login.html" style="color:#aab; font-size:13px; margin-left:12px;">Cerrar sesión</a>
            </div>
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
                    <h3>Panel Principal</h3>
                    <p>Bienvenido, <%= session.getAttribute("usuario") %>. Selecciona una opción en el menú.</p>
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