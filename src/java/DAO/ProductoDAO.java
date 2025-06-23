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

    /**
     * Obtiene un producto de la base de datos por su ID.
     * @param id El ID del producto a buscar.
     * @return Un objeto Producto si se encuentra, o null si no existe.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
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

    /**
     * Obtiene todos los productos de la base de datos.
     * @return Una lista de objetos Producto. Puede estar vacía si no hay productos.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
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

    /**
     * Guarda un nuevo producto en la base de datos.
     * @param producto El objeto Producto a guardar. El ID puede ser 0 si es auto-generado por la DB.
     * @return true si la inserción fue exitosa, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
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

    /**
     * Elimina un producto de la base de datos por su ID.
     * @param id El ID del producto a eliminar.
     * @return true si la eliminación fue exitosa, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
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

    /**
     * Actualiza un producto existente en la base de datos.
     * Permite actualizar también la imagen si se proporciona una nueva.
     * @param producto El objeto Producto con los datos actualizados. El ID debe ser válido.
     * @return true si la actualización fue exitosa, false en caso contrario.
     * @throws DAOException si ocurre un error durante el acceso a la base de datos.
     */
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
}
