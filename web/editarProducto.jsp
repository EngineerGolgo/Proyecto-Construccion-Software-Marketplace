<%-- 
    Document   : editarProducto
    Created on : 13 jun 2025, 7:47:41 p. m.
    Author     : User
--%>

<%@ page import="java.sql.*, Datos.ConexionDB" %>
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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Producto</title>
    <link rel="stylesheet" href="css/estiloDashboard.css" />
    <style>
        .form-container {
            max-width: 600px;
            margin: 120px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-container form {
            display: flex;
            flex-direction: column;
        }

        .form-container label {
            margin: 10px 0 5px;
            font-weight: 600;
        }

        .form-container input[type="text"],
        .form-container input[type="number"],
        .form-container textarea,
        .form-container select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-container textarea {
            resize: vertical;
        }

        .form-container input[type="file"] {
            margin-top: 10px;
        }

        .form-container input[type="submit"] {
            margin-top: 25px;
            padding: 12px;
            background-color: #3AB397;
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-container input[type="submit"]:hover {
            background-color: #339d84;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="logo">Marketplace</div>
    <nav class="navbar">
        <a href="dashboard.jsp">Inicio</a>
        <a href="misProductos.jsp">Mis Productos</a>
        <a href="perfil.jsp">Perfil</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<div class="form-container">
    <h2>Editar Producto</h2>
    <form action="EditarProductoServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= productoId %>">

        <label for="nombre">Nombre:</label>
        <input type="text" name="nombre" id="nombre" value="<%= nombre %>" required>

        <label for="descripcion">Descripción:</label>
        <textarea name="descripcion" id="descripcion" rows="4" required><%= descripcion %></textarea>

        <label for="categoria">Categoría:</label>
        <select name="categoria" id="categoria">
            <option value="Tecnología" <%= categoria.equals("Tecnología") ? "selected" : "" %>>Tecnología</option>
            <option value="Hogar" <%= categoria.equals("Hogar") ? "selected" : "" %>>Hogar</option>
            <option value="Moda" <%= categoria.equals("Moda") ? "selected" : "" %>>Moda</option>
            <option value="Otros" <%= categoria.equals("Otros") ? "selected" : "" %>>Otros</option>
        </select>

        <label for="precio">Precio:</label>
        <input type="number" step="0.01" name="precio" id="precio" value="<%= precio %>" required>

        <label for="imagen">Imagen del producto (opcional):</label>
        <input type="file" name="imagen" id="imagen" accept="image/*">

        <input type="submit" value="Actualizar">
    </form>
</div>

<footer class="footer">
    &copy; 2025 LocalMarket. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>