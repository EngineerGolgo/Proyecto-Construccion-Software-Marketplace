<%-- 
    Document   : editarProducto
    Created on : 13 jun 2025, 7:47:41 p. m.
    Author     : User
--%>

<%@ page import="java.sql.*, Marketplace.ConexionDB" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int productoId = Integer.parseInt(request.getParameter("id"));
    String nombre = "", descripcion = "", categoria = "";
    double precio = 0.0;

    try (Connection conn = ConexionDB.obtenerConexion()) {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos1 WHERE id = ?");
        stmt.setInt(1, productoId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            nombre = rs.getString("nombre");
            descripcion = rs.getString("descripcion");
            categoria = rs.getString("categoria");
            precio = rs.getDouble("precio");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Editar Producto</title>
</head>
<body>
    <h2>Editar Producto</h2>
    <form action="EditarProductoServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= productoId %>">
        Nombre: <input type="text" name="nombre" value="<%= nombre %>" required><br>
        Descripción: <textarea name="descripcion" required><%= descripcion %></textarea><br>
        Categoría: 
        <select name="categoria">
            <option value="Tecnología" <%= categoria.equals("Tecnología") ? "selected" : "" %>>Tecnología</option>
            <option value="Hogar" <%= categoria.equals("Hogar") ? "selected" : "" %>>Hogar</option>
            <option value="Moda" <%= categoria.equals("Moda") ? "selected" : "" %>>Moda</option>
            <option value="Otros" <%= categoria.equals("Otros") ? "selected" : "" %>>Otros</option>
        </select><br>
        Precio: <input type="number" step="0.01" name="precio" value="<%= precio %>" required><br>
        Imagen del producto (opcional): <input type="file" name="imagen" accept="image/*"><br>
        <input type="submit" value="Actualizar">
    </form>
</body>
</html>