/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO; 

import Datos.ConexionDB; 
import Modelo.Usuario;   
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;



public class UsuarioDAO {

    /**
     * Registra un nuevo usuario en la base de datos.
     * @param usuario El objeto Usuario con los datos a registrar. El ID no es necesario si es auto-generado.
     * @return true si el registro fue exitoso, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public boolean registrarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, correo, contraseña) VALUES (?, ?, ?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getCorreo());
            stmt.setString(3, usuario.getContrasena()); 

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new  DAOException("Error al registrar el usuario: " + usuario.getCorreo(), e);
        }
    }
    
    public class DAOException extends RuntimeException {
    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }
}

    /**
     * Busca un usuario por su correo y contraseña.
     * @param correo El correo del usuario.
     * @param contrasena La contraseña del usuario.
     * @return Un objeto Usuario si se encuentra, o null si no se encuentra o las credenciales son incorrectas.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public Usuario obtenerPorCredenciales(String correo, String contrasena) {
        String sql = "SELECT id, nombre, correo, contraseña FROM usuarios WHERE correo = ? AND contraseña = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, correo);
            stmt.setString(2, contrasena);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Usuario(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("correo"),
                    rs.getString("contraseña")
                );
            }
            return null; 

        } catch (SQLException e) {
            throw new DAOException("Error al obtener usuario por credenciales: " + correo, e);
        }
    }

    /**
     * Busca un usuario por su nombre de usuario.
     * @param nombre El nombre de usuario.
     * @return Un objeto Usuario si se encuentra, o null si no se encuentra.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public Usuario obtenerPorNombre(String nombre) {
        String sql = "SELECT id, nombre, correo, contraseña FROM usuarios WHERE nombre = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nombre);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Usuario(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("correo"),
                    rs.getString("contraseña")
                );
            }
            return null; 

        } catch (SQLException e) {
            throw new DAOException("Error al obtener usuario por nombre: " + nombre, e);
        }
    }

    // Aquí se podrían añadir más métodos para la entidad Usuario,
    // como actualizarUsuario(Usuario usuario), eliminarUsuario(int id), etc.
}
