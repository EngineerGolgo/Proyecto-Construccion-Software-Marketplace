package DAO; 

import Datos.ConexionDB;    
import Modelo.Pedido;      
import Modelo.DetallePedido; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import DAO.DAOException; 

public class PedidoDAO {

    /**
     * Guarda un nuevo pedido en la base de datos y recupera el ID generado.
     * @param pedido El objeto Pedido a guardar (sin ID si es auto-generado).
     * @return El ID generado del pedido si la inserción fue exitosa.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public int guardarPedido(Pedido pedido) {
        String sql = "INSERT INTO pedidos (usuario_id, fecha, total) VALUES (?, NOW(), ?)";
        int pedidoId = -1; 

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, pedido.getUsuarioId());
            stmt.setDouble(2, pedido.getTotal());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        pedidoId = generatedKeys.getInt(1); 
                        pedido.setId(pedidoId); 
                    }
                }
            }
            return pedidoId;

        } catch (SQLException e) {
            throw new DAOException("Error al guardar el pedido para el usuario ID: " + pedido.getUsuarioId(), e);
        }
    }

    /**
     * Guarda una lista de detalles de pedido en la base de datos utilizando batch.
     * @param detalles Una lista de objetos DetallePedido a guardar.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public void guardarDetallesPedido(List<DetallePedido> detalles) {
        String sql = "INSERT INTO detalle_pedido (pedido_id, producto_id) VALUES (?, ?)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false); 

            for (DetallePedido detalle : detalles) {
                stmt.setInt(1, detalle.getPedidoId());
                stmt.setInt(2, detalle.getProductoId());
                stmt.addBatch(); 
            }

            stmt.executeBatch(); 
            conn.commit(); 

        } catch (SQLException e) {
            try (Connection rollbackConn = ConexionDB.obtenerConexion()) { 
                if (rollbackConn != null) {
                     rollbackConn.rollback(); 
                }
            } catch (SQLException rollbackEx) {
                System.err.println("Error al hacer rollback: " + rollbackEx.getMessage());
            }
            throw new DAOException("Error al guardar los detalles del pedido.", e);
        } finally {
            try (Connection finalConn = ConexionDB.obtenerConexion()) { 
                if (finalConn != null) {
                    finalConn.setAutoCommit(true); 
                }
            } catch (SQLException autoCommitEx) {
                System.err.println("Error al restaurar auto-commit: " + autoCommitEx.getMessage());
            }
        }
    }

    /**
     * Elimina los detalles de pedido asociados a un producto específico.
     * @param productoId El ID del producto cuyos detalles de pedido se desean eliminar.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public void eliminarDetallesPorProductoId(int productoId) {
        String sql = "DELETE FROM detalle_pedido WHERE producto_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productoId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar detalles de pedido del producto con ID: " + productoId, e);
        }
    }
}
