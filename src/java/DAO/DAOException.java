/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO; 

/**
 * Excepción personalizada para la capa de Acceso a Datos (DAO).
 * Permite encapsular y manejar errores de SQL de forma más limpia
 * sin exponer directamente las excepciones de JDBC en capas superiores.
 */
public class DAOException extends RuntimeException {

    // Constructor que acepta solo un mensaje
    public DAOException(String message) {
        super(message);
    }

    // Constructor que acepta un mensaje y la causa original (Throwable)
    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }

    // Constructor que acepta solo la causa original
    public DAOException(Throwable cause) {
        super(cause);
    }
}

