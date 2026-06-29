$(document).ready(function() {
    $(".menu-btn").click(function(e) {
        e.preventDefault(); // Evita que la página recargue al hacer clic en el enlace

        // 1. Quitar la clase 'active' de todos los botones y ponérsela al que clickeaste
        $(".menu-btn").removeClass("active");
        $(this).addClass("active");

        // 2. Ocultar todas las secciones de contenido a la derecha
        $(".content-section").removeClass("active-section").hide();

        // 3. Obtener el nombre de la sección desde el atributo 'data-target' del botón
        let targetSection = $(this).attr("data-target");

        // 4. Mostrar solo la sección que coincide con ese nombre (con un pequeño efecto de fundido)
        $("#" + targetSection).addClass("active-section").fadeIn(200);

        // 5. Si entramos a "Inicio", refrescamos los datos con la BD en tiempo real
        //    (antes esto se quedaba "congelado" con los valores del login)
        if (targetSection === "inicio") {
            refrescarInicio();
        }
    });
});

//----------------------------------------------------
// Consulta DashboardServlet y actualiza el panel de Inicio con datos frescos
function refrescarInicio() {
    $.getJSON("DashboardServlet", function (data) {
        $("#kpiItems").text(data.totalItems);
        $("#kpiStock").text(data.stockTotal);
        $("#kpiCritico").text(data.stockCritico);
        $("#kpiMovHoy").text(data.movimientosHoy);

        let filasAgotarse = "";
        data.listaAgotarse.forEach(function (p) {
            let badgeClass = p.stock === 0 ? "badge-danger" : "badge-warning";
            filasAgotarse += "<tr><td>" + p.codigo + "</td><td>" + p.nombre +
                "</td><td><span class='badge " + badgeClass + "'>" + p.stock + " u.</span></td></tr>";
        });
        $("#tablaAgotarse").html(filasAgotarse);

        let filasMovs = "";
        data.listaMovs.forEach(function (m) {
            let badgeClass = m.tipo === "ENTRADA" ? "badge-success" : "badge-danger";
            filasMovs += "<tr><td><span class='badge " + badgeClass + "'>" + m.tipo +
                "</span></td><td>" + m.producto + "</td><td>" + m.cantidad + "</td></tr>";
        });
        $("#tablaMovs").html(filasMovs);
    }).fail(function () {
        console.error("No se pudo refrescar el panel de Inicio (revisa DashboardServlet/BD).");
    });
}

//----------------------------------------------------
function abrirMovimientos() {
    $("#menuMovimientos").hide();
    $("#contenidoMovimientos").load("movimientos.html", function () {
        $.getScript("movimientos.js");
    });
}
//-----------------------------------------------------

//-----------------------------------------------------
function abrirVerMovimientos() {
    $("#menuMovimientos").hide();
    $("#contenidoMovimientos").load("verMovimientos.html", function () {
        $.getScript("verMovimientos.js");
    });
}
//-----------------------------------------------------
//
//-----------------------------------------------------
function volverMenuMovimientos() {
    $("#contenidoMovimientos").empty();
    $("#menuMovimientos").show();
}
//-----------------------------------------------------