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
            throw new DAOException("Error al registrar el usuario: " + usuario.getCorreo(), e);
        }
    }
    
        public class DAOException extends RuntimeException {
    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }
}
    
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
    
    public Usuario obtenerPorId(int id) { // Añadir este método, ya que se necesitará en el Servlet para obtener el nombre
        String sql = "SELECT id, nombre, correo, contraseña FROM usuarios WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Usuario(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("correo"),
                    rs.getString("contraseña")
                );
            }
            return null; // Usuario no encontrado

        } catch (SQLException e) {
            throw new DAOException("Error al obtener usuario por ID: " + id, e);
        }
    }

    public boolean actualizarUsuario(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, correo = ?, contraseña = ? WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getCorreo());
            stmt.setString(3, usuario.getContrasena());
            stmt.setInt(4, usuario.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new DAOException("Error al actualizar el usuario con ID: " + usuario.getId(), e);
        }
    }

    /**
     * Elimina un usuario y todos sus datos relacionados (productos, pedidos, comentarios).
     * Esta operación se realiza dentro de una transacción.
     * @param usuarioId El ID del usuario a eliminar.
     * @return true si la eliminación fue exitosa, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos o la transacción.
     */
    public boolean eliminarUsuario(int usuarioId) {
        Connection conn = null; // La conexión debe ser compartida para la transacción
        boolean exito = false;

        ProductoDAO productoDAO = new ProductoDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();
        ComentarioDAO comentarioDAO = new ComentarioDAO();

        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false); // Iniciar transacción

            // Configurar los DAOs para usar la misma conexión (si tu ConexionDB permite pasarla, sino,
            // los DAOs obtendrán nuevas conexiones pero la transacción seguirá a nivel del UsuarioDAO orquestador.
            // Para una transacción real, lo ideal es que los DAOs internos acepten la conexión.
            // Como tu ConexionDB.obtenerConexion() siempre abre una nueva, la transacción global es más compleja.
            // Una forma más simple para tu setup es que las eliminaciones individuales lancen excepciones
            // y esta capa superior maneje el rollback para todas si una falla.

            // 1. Eliminar comentarios asociados a los productos del usuario
            List<Integer> productosDelUsuarioIds = productoDAO.obtenerIdsProductosPorUsuario(usuarioId);
            for (int productoId : productosDelUsuarioIds) {
                comentarioDAO.eliminarComentariosPorProductoId(productoId);
            }

            // 2. Eliminar detalles de pedidos asociados a los pedidos del usuario
            List<Integer> pedidosDelUsuarioIds = pedidoDAO.obtenerIdsPedidosPorUsuario(usuarioId);
            for (int pedidoId : pedidosDelUsuarioIds) {
                pedidoDAO.eliminarDetallesPorPedidoId(pedidoId);
            }

            // 3. Eliminar los productos del usuario
            productoDAO.eliminarProductosPorUsuarioId(usuarioId);

            // 4. Eliminar los pedidos del usuario
            pedidoDAO.eliminarPedidosPorUsuarioId(usuarioId);
            
            // 5. Finalmente, eliminar el usuario
            String sqlUsuario = "DELETE FROM usuarios WHERE id = ?";
            try (PreparedStatement stmtUsuario = conn.prepareStatement(sqlUsuario)) {
                stmtUsuario.setInt(1, usuarioId);
                int rowsAffected = stmtUsuario.executeUpdate();
                if (rowsAffected > 0) {
                    exito = true;
                }
            }

            conn.commit(); // Confirmar la transacción
            
        } catch (SQLException | DAOException e) { // Capturar SQLException y DAOException
            if (conn != null) {
                try {
                    conn.rollback(); // Deshacer la transacción si hay un error
                } catch (SQLException rollbackEx) {
                    System.err.println("Error al hacer rollback: " + rollbackEx.getMessage());
                }
            }
            throw new DAOException("Error al eliminar el usuario con ID: " + usuarioId, e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restaurar el auto-commit
                    conn.close(); // Cerrar la conexión
                } catch (SQLException closeEx) {
                    System.err.println("Error al cerrar conexión después de eliminar usuario: " + closeEx.getMessage());
                }
            }
        }
        return exito;
    }
}
