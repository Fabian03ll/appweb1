$(document).ready(function () {
    cargarMovimientos("TODOS", "", "");
});

function cargarMovimientos(tipo, fecha, producto) {
    $.get(
        "TablaMovimientosServlet",
        {
            tipo: tipo,
            fecha: fecha,
            producto: producto
        },
        function (datos) {
            let filas = "";
            let movimientos = datos.split("\n");
            movimientos.forEach(function (m) {
                m = m.trim();
                if (m !== "") {
                    let dato = m.split("|");
                    filas += "<tr>";
                    filas += "<td>" + dato[0] + "</td>";
                    filas += "<td>" + dato[1] + "</td>";
                    filas += "<td>" + dato[2] + "</td>";
                    filas += "<td>" + dato[3] + "</td>";
                    filas += "</tr>";
                }
            });
            $("#tablaMovimientos").html(filas);
        }
    );
}

// Filtrar por tipo
$(document).off("change","input[name='tipo']");
$(document).on("change","input[name='tipo']",function(){
    let tipo = $("input[name='tipo']:checked").val();
    let fecha = $("#fecha").val();
    let producto = $("#txtProducto").val();
    cargarMovimientos(tipo, fecha, producto);
});

// Buscar por fecha
$(document).off("click","#btnBuscarFecha");
$(document).on("click","#btnBuscarFecha",function(){
    let tipo = $("input[name='tipo']:checked").val();
    let fecha = $("#fecha").val();
    let producto = $("#txtProducto").val();
    cargarMovimientos(tipo, fecha, producto);
});

// Mostrar todo
$(document).off("click","#btnTodo");
$(document).on("click","#btnTodo",function(){
    $("#fecha").val("");
    $("input[value='TODOS']").prop("checked",true);
    $("#txtProducto").val("");
    cargarMovimientos("TODOS","","");
});

$(document).off("keyup", "#txtProducto");

$(document).on("keyup", "#txtProducto", function () {

    let tipo = $("input[name='tipo']:checked").val();
    let fecha = $("#fecha").val();
    let producto = $("#txtProducto").val();

    cargarMovimientos(tipo, fecha, producto);

});
