package Modelo; 

import java.time.LocalDateTime;

public class Comentario {
    private int id; 
    private int productoId;
    private int usuarioId;
    private String comentarioTexto; 
    private int puntuacion;
    private LocalDateTime fecha;

    // Constructor vacío
    public Comentario() {
    }

    // Constructor con todos los campos (para recuperar de la DB)
    public Comentario(int id, int productoId, int usuarioId, String comentarioTexto, int puntuacion, LocalDateTime fecha) {
        this.id = id;
        this.productoId = productoId;
        this.usuarioId = usuarioId;
        this.comentarioTexto = comentarioTexto;
        this.puntuacion = puntuacion;
        this.fecha = fecha;
    }

    // Constructor para crear un nuevo comentario (sin ID ni fecha inicial)
    public Comentario(int productoId, int usuarioId, String comentarioTexto, int puntuacion) {
        this.productoId = productoId;
        this.usuarioId = usuarioId;
        this.comentarioTexto = comentarioTexto;
        this.puntuacion = puntuacion;
        
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductoId() {
        return productoId;
    }

    public void setProductoId(int productoId) {
        this.productoId = productoId;
    }

    public int getUsuarioId() {
        return usuarioId;
    }


    public String getComentarioTexto() {
        return comentarioTexto;
    }

    public void setComentarioTexto(String comentarioTexto) {
        this.comentarioTexto = comentarioTexto;
    }

    public int getPuntuacion() {
        return puntuacion;
    }

    public void setPuntuacion(int puntuacion) {
        this.puntuacion = puntuacion;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    @Override
    public String toString() {
        return "Comentario{" +
               "id=" + id +
               ", productoId=" + productoId +
               ", usuarioId=" + usuarioId +
               ", comentarioTexto='" + comentarioTexto + '\'' +
               ", puntuacion=" + puntuacion +
               ", fecha=" + fecha +
               '}';
    }
}
