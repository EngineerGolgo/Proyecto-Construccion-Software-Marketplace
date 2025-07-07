<%-- 
    Document   : misProductos
    Created on : 15 jun 2025, 10:37:20 p. m.
    Author     : User
--%>

<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.sql.*,Datos.ConexionDB" %>
<%
    // Inicio del bloque de scriptlet Java para la verificaci�n de sesi�n y carga de productos.

    // Obtiene la sesi�n actual del usuario. 'false' significa que no se crea una nueva sesi�n si no existe.
    HttpSession sesion = request.getSession(false);
    // Recupera el nombre de usuario de la sesi�n.
    String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

    // Verifica si el nombre de usuario es nulo. Si lo es, significa que el usuario no ha iniciado sesi�n.
    if (nombreUsuario == null) {
        // Redirige al usuario a la p�gina de inicio de sesi�n y detiene el procesamiento de este JSP.
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
        <a href="misProductos.jsp">Mis Productos</a>
        <a href="perfil.jsp">Perfil</a>
        <a href="logout.jsp">Cerrar Sesi�n</a>
    </nav>
</header>

<main class="content">
    <h1>Mis Productos</h1>

    <div class="productos-grid">
        <%
            // Inicio del bloque de scriptlet Java para la recuperaci�n y visualizaci�n de productos.

            try (Connection conn = ConexionDB.obtenerConexion()) {
                // Prepara la consulta SQL para buscar el ID del usuario actual por su nombre.
                PreparedStatement buscarId = conn.prepareStatement("SELECT id FROM usuarios WHERE nombre = ?");
                // Establece el nombre de usuario como par�metro en la consulta.
                buscarId.setString(1, nombreUsuario);
                // Ejecuta la consulta y obtiene el conjunto de resultados.
                ResultSet rsUsuario = buscarId.executeQuery();

                // Verifica si se encontr� el usuario.
                if (rsUsuario.next()) {
                    // Obtiene el ID del usuario.
                    int idUsuario = rsUsuario.getInt("id");

                    // Prepara la consulta SQL para obtener todos los productos asociados a este ID de usuario.
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos1 WHERE usuario_id = ?");
                    // Establece el ID del usuario como par�metro en la consulta.
                    stmt.setInt(1, idUsuario);
                    // Ejecuta la consulta y obtiene el conjunto de resultados de los productos.
                    ResultSet rs = stmt.executeQuery();

                    // Itera sobre cada producto en el conjunto de resultados.
                    while (rs.next()) {
                        // Recupera los detalles de cada producto.
                        int idProducto = rs.getInt("id");
                        String nombreProducto = rs.getString("nombre");
                        String categoria = rs.getString("categoria");
                        double precio = rs.getDouble("precio");
                        String imagen = rs.getString("imagen");
        %>
        <%-- Estructura HTML para la tarjeta de cada producto del usuario. --%>
        <div class="producto-card">
            <img src="<%= imagen %>" alt="Imagen del producto">
            <h3><%= nombreProducto %></h3>
            <p><strong>Categor�a:</strong> <%= categoria %></p>
            <p><strong>Precio:</strong> $<%= precio %></p>
            <div class="acciones">
                <%-- Enlace para editar el producto, pasando el ID del producto como par�metro. --%>
                <a href="editarProducto.jsp?id=<%= idProducto %>">Editar</a>
                <%-- Enlace para eliminar el producto, con una confirmaci�n JavaScript antes de redirigir al servlet. --%>
                <a href="EliminarProductoServlet?id=<%= idProducto %>" onclick="return confirm('�Est�s seguro de eliminar este producto?');">Eliminar</a>
            </div>
        </div>
        <%
                    }
                } else {
                    // Si el usuario no fue encontrado en la base de datos (lo cual no deber�a ocurrir si la sesi�n es v�lida).
                    out.println("<p>Usuario no encontrado.</p>");
                }
            } catch (Exception e) {
                // Captura cualquier excepci�n que ocurra durante la conexi�n a la base de datos o la ejecuci�n de consultas.
                out.println("<p>Error al cargar tus productos.</p>");
                e.printStackTrace(); // Imprime el seguimiento de la pila para depuraci�n.
            }
        %>
    </div>
</main>

<footer class="footer">
    &copy; 2025 LocalMarket. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>