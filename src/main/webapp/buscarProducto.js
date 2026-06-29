$(document).ready(function () {
    // No hacemos nada aquí.
    // La función cargarProductos(categoria) se llama desde movimientos.js
});

function cargarProductos(categoria, filtro = "") {
    let estado = $("input[name='filtro']:checked").val();
    $.get(
        "ProductoServletD",
        {
            categoria: categoria,
            filtro: filtro,
            estado: estado
        },
        function(datos){
            let filas = "";
            let productos = datos.split("\n");
            productos.forEach(function(p){
                p = p.trim();
                if(p !== ""){
                    let datosProducto = p.split("|");
                    filas += "<tr>";
                    filas += "<td>"+datosProducto[0]+"</td>";
                    filas += "<td>"+datosProducto[1]+"</td>";
                    let stock = parseInt(datosProducto[2]);
                    let claseStock = "";
                    if(stock == 0){
                        claseStock = "stockSin";
                    }else if(stock <= 30){
                        claseStock = "stockBajo";
                    }else{
                        claseStock = "stockNormal";
                    }
                    filas += "<td><span class='" + claseStock + "'>" + stock + "</span></td>";
                    filas += "<td>";
                    filas += "<button class='seleccionar'";
                    filas += " data-producto='" + datosProducto[1] + "'";
                    filas += " data-stock='" + datosProducto[2] + "'>";
                    filas += "Seleccionar";
                    filas += "</button>";
                    filas += "</td>";
                    filas += "</tr>";
                }
            });
            $("#listaProductos").html(filas);
        }
    );
}

$(document).on("keyup", "#txtBuscar", function () {
    let categoria = $("#categoria").val();
    let filtro = $(this).val();
    cargarProductos(categoria, filtro);
});

$(document).on("change", "input[name='filtro']", function () {
    let categoria = $("#categoria").val();
    let filtro = $("#txtBuscar").val();
    cargarProductos(categoria, filtro);
});

// Cuando el usuario haga clic en "Seleccionar"
$(document).off("click", ".seleccionar");

$(document).on("click", ".seleccionar", function () {
    let producto = $(this).data("producto");
    let stock = $(this).data("stock");
    $("#producto").val(producto);
    $("#stock").val(stock);
    $("#modalProducto").hide();
});