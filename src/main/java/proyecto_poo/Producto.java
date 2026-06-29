package proyecto_poo;

public class Producto {
    private String codigo;
    private String nombre;
    private int stock;

    public Producto() {}

    // ESTO ES LO QUE FALTA: Los métodos Getter
    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }
}