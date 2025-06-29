package DAO;

import Datos.ConexionDB;
import Modelo.Producto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;

import DAO.DAOException;

public class ProductoDAO {

    public Producto obtenerPorId(int id) {
        String sql = "SELECT id, nombre, descripcion, categoria, precio, imagen, usuario_id FROM productos1 WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Producto(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("descripcion"),
                    rs.getString("categoria"),
                    rs.getDouble("precio"),
                    rs.getString("imagen"),
                    rs.getInt("usuario_id")
                );
            }
            return null;

        } catch (SQLException e) {
            throw new DAOException("Error al obtener producto por ID: " + id, e);
        }
    }

    public List<Producto> obtenerTodosProductos() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion, categoria, precio, imagen, usuario_id FROM productos1";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                productos.add(new Producto(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("descripcion"),
                    rs.getString("categoria"),
                    rs.getDouble("precio"),
                    rs.getString("imagen"),
                    rs.getInt("usuario_id")
                ));
            }
            return productos;

        } catch (SQLException e) {
            throw new DAOException("Error al obtener todos los productos.", e);
        }
    }

    public boolean guardarProducto(Producto producto) {
        String sql = "INSERT INTO productos1 (nombre, descripcion, categoria, precio, imagen, usuario_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, producto.getNombre());
            stmt.setString(2, producto.getDescripcion());
            stmt.setString(3, producto.getCategoria());
            stmt.setDouble(4, producto.getPrecio());
            stmt.setString(5, producto.getImagen());
            stmt.setInt(6, producto.getUsuarioId());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        producto.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            throw new DAOException("Error al guardar el producto: " + producto.getNombre(), e);
        }
    }

    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM productos1 WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar el producto con ID: " + id, e);
        }
    }

    public boolean actualizarProducto(Producto producto) {
        String sql;
        int paramIndex = 1;

        if (producto.getImagen() != null && !producto.getImagen().isEmpty()) {
            sql = "UPDATE productos1 SET nombre = ?, descripcion = ?, categoria = ?, precio = ?, imagen = ? WHERE id = ?";
        } else {
            sql = "UPDATE productos1 SET nombre = ?, descripcion = ?, categoria = ?, precio = ? WHERE id = ?";
        }

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(paramIndex++, producto.getNombre());
            stmt.setString(paramIndex++, producto.getDescripcion());
            stmt.setString(paramIndex++, producto.getCategoria());
            stmt.setDouble(paramIndex++, producto.getPrecio());

            if (producto.getImagen() != null && !producto.getImagen().isEmpty()) {
                stmt.setString(paramIndex++, producto.getImagen());
            }

            stmt.setInt(paramIndex, producto.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new DAOException("Error al actualizar el producto con ID: " + producto.getId(), e);
        }
    }

    /**
     * Obtiene una lista de IDs de productos publicados por un usuario específico.
     * @param usuarioId El ID del usuario.
     * @return Una lista de IDs de productos.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public List<Integer> obtenerIdsProductosPorUsuario(int usuarioId) {
        List<Integer> productoIds = new ArrayList<>();
        String sql = "SELECT id FROM productos1 WHERE usuario_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                productoIds.add(rs.getInt("id"));
            }
            return productoIds;

        } catch (SQLException e) {
            throw new DAOException("Error al obtener IDs de productos para el usuario ID: " + usuarioId, e);
        }
    }

    /**
     * Elimina todos los productos publicados por un usuario específico.
     * @param usuarioId El ID del usuario cuyos productos se desean eliminar.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
    public void eliminarProductosPorUsuarioId(int usuarioId) {
        String sql = "DELETE FROM productos1 WHERE usuario_id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, usuarioId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new DAOException("Error al eliminar productos del usuario ID: " + usuarioId, e);
        }
    }
}
