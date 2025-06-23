package Modelo; 

public class DetallePedido {

    private int id; 
    private int pedidoId;
    private int productoId;

    // Constructor vacío
    public DetallePedido() {
    }

    // Constructor para crear un nuevo detalle de pedido (sin ID si es auto-generado)
    public DetallePedido(int pedidoId, int productoId) {
        this.pedidoId = pedidoId;
        this.productoId = productoId;
    }

    // Constructor para recuperar desde la DB (si tiene ID)
    public DetallePedido(int id, int pedidoId, int productoId) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.productoId = productoId;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPedidoId() {
        return pedidoId;
    }

    public void setPedidoId(int pedidoId) {
        this.pedidoId = pedidoId;
    }

    public int getProductoId() {
        return productoId;
    }

    public void setProductoId(int productoId) {
        this.productoId = productoId;
    }

    @Override
    public String toString() {
        return "DetallePedido{" +
               "id=" + id +
               ", pedidoId=" + pedidoId +
               ", productoId=" + productoId +
               '}';
    }
}