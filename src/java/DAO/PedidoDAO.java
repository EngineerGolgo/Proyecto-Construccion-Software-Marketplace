package DAO;

import Datos.ConexionDB;
import Modelo.Pedido;
import Modelo.DetallePedido;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList; // Importar ArrayList
import java.util.List;

import DAO.DAOException;

public class PedidoDAO {

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

    public void guardarDetallesPedido(List<DetallePedido> detalles) {
        String sql = "INSERT INTO detalle_pedido (pedido_id, producto_id) VALUES (?, ?)";

        Connection conn = null; // Declarar conn fuera del try-with-resources para el rollback
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false); // Inicia la transacción

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                for (DetallePedido detalle : detalles) {
                    stmt.setInt(1, detalle.getPedidoId());
                    stmt.setInt(2, detalle.getProductoId());
                    stmt.addBatch();
                }
                stmt.executeBatch();
                conn.commit();
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Error al hacer rollback: " + rollbackEx.getMessage());
                }
            }
            throw new DAOException("Error al guardar los detalles del pedido.", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restaura el auto-commit
                    conn.close(); // Cierra la conexión si fue obtenida aquí
                } catch (SQLException autoCommitEx) {
                    System.err.println("Error al restaurar auto-commit o cerrar conexión: " + autoCommitEx.getMessage());
                }
            }
        }
    }

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

    /**
     * Obtiene una lista de IDs de pedidos realizados por un usuario específico.
     * @param usuarioId El ID del usuario.
     * @return Una lista de IDs de pedidos.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public List<Integer> obtenerIdsPedidosPorUsuario(int usuarioId) {
        List<Integer> pedidoIds = new ArrayList<>();
        String sql = "SELECT id FROM pedidos WHERE usuario_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                pedidoIds.add(rs.getInt("id"));
            }
            return pedidoIds;

        } catch (SQLException e) {
            throw new DAOException("Error al obtener IDs de pedidos para el usuario ID: " + usuarioId, e);
        }
    }

    /**
     * Elimina todos los detalles de un pedido específico.
     * @param pedidoId El ID del pedido cuyos detalles se desean eliminar.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public void eliminarDetallesPorPedidoId(int pedidoId) {
        String sql = "DELETE FROM detalle_pedido WHERE pedido_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, pedidoId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar detalles del pedido con ID: " + pedidoId, e);
        }
    }

    /**
     * Elimina todos los pedidos realizados por un usuario específico.
     * @param usuarioId El ID del usuario cuyos pedidos se desean eliminar.
     * @return true si la eliminación fue exitosa, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public boolean eliminarPedidosPorUsuarioId(int usuarioId) {
        String sql = "DELETE FROM pedidos WHERE usuario_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, usuarioId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar pedidos del usuario ID: " + usuarioId, e);
        }
    }
}