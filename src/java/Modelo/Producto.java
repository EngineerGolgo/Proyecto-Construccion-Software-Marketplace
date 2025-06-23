/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo; 

public class Producto {
    private int id;
    private String nombre;
    private String descripcion;
    private String categoria;
    private double precio;
    private String imagen;
    private int usuarioId; 

    // Constructor vacío
    public Producto() {
    }


    public Producto(int id, String nombre, String descripcion, String categoria, double precio, String imagen, int usuarioId) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.usuarioId = usuarioId;
    }


    public Producto(String nombre, String descripcion, String categoria, double precio, String imagen, int usuarioId) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.usuarioId = usuarioId;
    }

    // Getters y Setters para todos los atributos
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    @Override
    public String toString() {
        return "Producto{" +
               "id=" + id +
               ", nombre='" + nombre + '\'' +
               ", precio=" + precio +
               ", categoria='" + categoria + '\'' +
               '}';
    }
}