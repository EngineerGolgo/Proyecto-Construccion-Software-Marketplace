package Modelo; 

import java.time.LocalDateTime; 

public class Pedido {
    private int id;
    private int usuarioId;
    private LocalDateTime fecha; 
    private double total;

    // Constructor vacío
    public Pedido() {
    }

    // Constructor para recuperar desde la DB (con ID y fecha)
    public Pedido(int id, int usuarioId, LocalDateTime fecha, double total) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.fecha = fecha;
        this.total = total;
    }

    // Constructor para crear un nuevo pedido (sin ID ni fecha inicial, la DB los genera)
    public Pedido(int usuarioId, double total) {
        this.usuarioId = usuarioId;
        this.total = total;
        // La fecha se establecerá en la DB (NOW())
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "Pedido{" +
               "id=" + id +
               ", usuarioId=" + usuarioId +
               ", fecha=" + fecha +
               ", total=" + total +
               '}';
    }
}