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
    });

});


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