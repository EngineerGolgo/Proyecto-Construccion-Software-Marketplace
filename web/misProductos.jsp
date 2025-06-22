<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.sql.*,Datos.ConexionDB" %>
<%
    HttpSession sesion = request.getSession(false);
    String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Productos</title>
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="css/estiloDashboard.css">
</head>
<body>

<header class="header">
    <div class="logo">Marketplace</div>
    <nav class="navbar">
        <a href="dashboard.jsp">Inicio</a>
        <a href="perfil.jsp">Perfil</a>
        <a href="foro.jsp">Publicar Mensaje</a>
        <a href="mensajes.jsp">Mensajes</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<main class="content">
    <h1>Mis Productos</h1>

    <div class="productos-grid">
        <%
            try (Connection conn = ConexionDB.obtenerConexion()) {
                PreparedStatement buscarId = conn.prepareStatement("SELECT id FROM usuarios WHERE nombre = ?");
                buscarId.setString(1, nombreUsuario);
                ResultSet rsUsuario = buscarId.executeQuery();

                if (rsUsuario.next()) {
                    int idUsuario = rsUsuario.getInt("id");

                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos1 WHERE usuario_id = ?");
                    stmt.setInt(1, idUsuario);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int idProducto = rs.getInt("id");
                        String nombreProducto = rs.getString("nombre");
                        String categoria = rs.getString("categoria");
                        double precio = rs.getDouble("precio");
                        String imagen = rs.getString("imagen");
        %>
        <div class="producto-card">
            <img src="<%= imagen %>" alt="Imagen del producto">
            <h3><%= nombreProducto %></h3>
            <p><strong>Categoría:</strong> <%= categoria %></p>
            <p><strong>Precio:</strong> $<%= precio %></p>
            <div class="acciones">
                <a href="editarProducto.jsp?id=<%= idProducto %>">Editar</a>
                <a href="EliminarProductoServlet?id=<%= idProducto %>" onclick="return confirm('¿Estás seguro de eliminar este producto?');">Eliminar</a>
            </div>
        </div>
        <%
                    }
                } else {
                    out.println("<p>Usuario no encontrado.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error al cargar tus productos.</p>");
                e.printStackTrace();
            }
        %>
    </div>
</main>

<footer class="footer">
    &copy; 2025 Lopez Ochoa. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>
