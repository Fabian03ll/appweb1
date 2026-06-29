package proyecto_poo;

public class Movimiento {
    // Variables privadas para encapsulamiento
    private String tipo;
    private String producto;
    private int cantidad;

    // Constructor vacío obligatorio
    public Movimiento() {}

    // Getters (necesarios para que ${m.tipo} funcione en JSP)
    public String getTipo() {
        return tipo;
    }

    public String getProducto() {
        return producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    // Setters (usados en tu LoginServlet para asignar los valores de la BD)
    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setProducto(String producto) {
        this.producto = producto;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }
}