package DAO; 

import Datos.ConexionDB;     
import Modelo.Comentario;    
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement; 
import java.sql.ResultSet; 

import DAO.DAOException; 

public class ComentarioDAO {

    /**
     * Elimina todos los comentarios asociados a un producto específico.
     * @param productoId El ID del producto cuyos comentarios se eliminarán.
     * @throws DAOException si ocurre un error de acceso a la base de datos.
     */
    public void eliminarComentariosPorProductoId(int productoId) {
        String sql = "DELETE FROM comentarios WHERE producto_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productoId);
            stmt.executeUpdate(); 

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar comentarios del producto con ID: " + productoId, e);
        }
    }

    /**
     * Agrega un nuevo comentario a la base de datos.
     * @param comentario El objeto Comentario con los datos que se agregarán.
     * @return verdadero si la inserción fue exitosa, falso en caso contrario.
     * @throws DAOException si ocurre un error de acceso a la base de datos.
     */
    public boolean agregarComentario(Comentario comentario) {
        String sql = "INSERT INTO comentarios (producto_id, usuario_id, comentario, puntuacion, fecha) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, comentario.getProductoId());
            stmt.setInt(2, comentario.getUsuarioId());
            stmt.setString(3, comentario.getComentarioTexto());
            stmt.setInt(4, comentario.getPuntuacion());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        comentario.setId(generatedKeys.getInt(1)); 
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            throw new DAOException("Error al agregar el comentario para el producto ID: " + comentario.getProductoId() + " y usuario ID: " + comentario.getUsuarioId(), e);
        }
    }
}
