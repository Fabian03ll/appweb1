console.log("movimientos.js cargado");

$(document).ready(function () {
    $.get("CategoriaServlet", function (datos) {
        let combo = $("#categoria");
        combo.empty();
        combo.append("<option value=''>Seleccione...</option>");
        let categorias = datos.split("\n");
        categorias.forEach(function(c){
            c = c.trim();
            if(c !== ""){
                combo.append("<option>"+c+"</option>");
            }
        });
    });
    
    cargarResumen();
    
});

function cargarResumen() {

    $.get("ResumenServlet", function(datos){

        let resumen = datos.split("\n");

        $("#lblTotalProductos").text(resumen[0].trim());
        $("#lblStockTotal").text(resumen[1].trim());
        $("#lblEntradas").text(resumen[2].trim());
        $("#lblSalidas").text(resumen[3].trim());
        $("#lblUltimoMovimiento").text(resumen[4].trim());

    });

}


// Abrir buscador
$(document).off("click","#btnBuscarProducto");

$(document).on("click","#btnBuscarProducto",function(){
    let categoria = $("#categoria").val();
    if (categoria === "") {
        mostrarMensaje("Seleccione una categoría.","error");
        return;
    }
    $("#modalProducto").show();
    /*$("#contenidoModal").load(
        "buscarProducto.html",
        function () {
            cargarProductos(categoria);
        }
    );*/
    $("#contenidoModal").load("buscarProducto.html", function () {
        $.getScript("buscarProducto.js")
            .done(function () {
                cargarProductos(categoria);
            })
            .fail(function () {
                console.error("No se pudo cargar buscarProducto.js");
            });
    });
});

// Cerrar modal
$(document).off("click","#cerrarModal");

$(document).on("click","#cerrarModal",function(){
    $("#modalProducto").hide();
});

// Guardar movimiento
$(document).off("click", "#btnGuardar");

console.log("Registrando evento btnGuardar");

$(document).on("click", "#btnGuardar", function () {
    
    console.log("Guardar ejecutado");
    
    let producto = $("#producto").val();
    let categoria = $("#categoria").val();
    let cantidad = $("#cantidad").val();
    let tipo = $("#tipo").val();
    if (categoria === "") {
        mostrarMensaje("Seleccione una categoría.","error");
        return;
    }
    if (producto === "") {
        mostrarMensaje("Seleccione un producto.","error");
        return;
    }
    if (cantidad === "" || cantidad <= 0) {
        mostrarMensaje("Ingrese una cantidad válida.","error");
        return;
    }
    $.post(
        "MovimientoServlet",
        {
            producto: producto,
            cantidad: cantidad,
            tipo: tipo
        },
        function(respuesta){
            if(respuesta==="OK"){
                mostrarMensaje("Movimiento registrado correctamente.","exito");
                // Limpiar formulario
                $("#categoria").val("");
                $("#producto").val("");
                $("#stock").val("");
                $("#cantidad").val("");
                $("#tipo").val("ENTRADA");
                
                cargarResumen();
            }else if(respuesta==="SIN_STOCK"){
                mostrarMensaje("No hay suficiente stock.","error");
            }else if(respuesta==="NO_EXISTE"){
                mostrarMensaje("Producto no encontrado.","error");
            }else{
                mostrarMensaje("Ocurrió un error.","error");
            }
        }
    );
});

function mostrarMensaje(texto, tipo){
    $("#mensajeMovimiento")
        .removeClass("exito error")
        .addClass(tipo)
        .text(texto)
        .fadeIn();
    setTimeout(function(){
        $("#mensajeMovimiento").fadeOut();
    },3000);
}

