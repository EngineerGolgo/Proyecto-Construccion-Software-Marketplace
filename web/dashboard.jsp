<%@page import="java.util.List"%>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.io.*, java.sql.*, Marketplace.ConexionDB" %>
<%
    HttpSession sesion = request.getSession(false);
    String nombreUsuario = null;
    if (sesion != null) {
        nombreUsuario = (String) sesion.getAttribute("nombreUsuario");
    }

    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/estilos.css" />
    <link rel="stylesheet" href="css/estiloDashboard.css" />
    
    <script>
        function toggleCarrito() {
            const panel = document.getElementById('carrito-panel');
            panel.classList.toggle('mostrar');
        }
    </script>
</head>
<body>
    
    <!-- Botón de carrito -->
<button id="toggleCarrito" onclick="toggleCarrito()">? Ver Carrito</button>

<!-- Panel del carrito -->
<div id="carrito-panel">
    <h2>Mi Carrito</h2>
    <ul>
        <%
            List<String> carrito = (List<String>) sesion.getAttribute("carrito");
            if (carrito != null && !carrito.isEmpty()) {
                for (int i = 0; i < carrito.size(); i++) {
                    String item = carrito.get(i);
        %>
            <li>
                <%= item %>
                <form action="EliminarDelCarritoServlet" method="post" style="display:inline;">
                    <input type="hidden" name="index" value="<%= i %>">
                    <button type="submit">Eliminar</button>
                </form>
            </li>
        <%
                }
            } else {
        %>
            <li>El carrito está vacío.</li>
        <%
            }
        %>
    </ul>
</div>
    

<header class="header">
    <div class="logo">
        Marketplace <span class="saludo">¡Hola, <%= nombreUsuario %>!</span>
    </div>
    <nav class="navbar">
        <a href="dashboard.jsp">Inicio</a>
        <a href="misProductos.jsp">Mis Productos</a>
        <a href="perfil.jsp">Perfil</a>
        <a href="foro.jsp">Publicar Mensaje</a>
        <a href="mensajes.jsp">Mensajes</a>
        <a href="logout.jsp">Cerrar Sesión</a>
</nav>
</header>

<div class="container">
    <aside class="sidebar">
        <a href="publicar.jsp" class="btn-publicar-sidebar">+ Publicar Producto</a>
        <h2>Categorías</h2>
        <a href="dashboard.jsp" class="categoria-item <%= (request.getParameter("categoria") == null || request.getParameter("categoria").isEmpty()) ? "active" : "" %>">Todas</a>
        <a href="dashboard.jsp?categoria=Tecnología" class="categoria-item <%= "Tecnología".equals(request.getParameter("categoria")) ? "active" : "" %>">Tecnología</a>
        <a href="dashboard.jsp?categoria=Hogar" class="categoria-item <%= "Hogar".equals(request.getParameter("categoria")) ? "active" : "" %>">Hogar</a>
        <a href="dashboard.jsp?categoria=Moda" class="categoria-item <%= "Moda".equals(request.getParameter("categoria")) ? "active" : "" %>">Moda</a>
        <a href="dashboard.jsp?categoria=Otros" class="categoria-item <%= "Otros".equals(request.getParameter("categoria")) ? "active" : "" %>">Otros</a>
    </aside>

    <main class="content">
        <h1>Productos</h1>

        <div class="productos-grid">
            <%
                try (Connection conn = ConexionDB.obtenerConexion()) {
                    String categoriaSeleccionada = request.getParameter("categoria");
                    PreparedStatement stmt;
                    if (categoriaSeleccionada != null && !categoriaSeleccionada.isEmpty()) {
                        stmt = conn.prepareStatement("SELECT p.*, u.nombre as nombre_usuario FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id WHERE p.categoria = ?");
                        stmt.setString(1, categoriaSeleccionada);
                    } else {
                        stmt = conn.prepareStatement("SELECT p.*, u.nombre as nombre_usuario FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id");
                    }

                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        int idProducto = rs.getInt("id");
                        String nombreProducto = rs.getString("nombre");
                        String descripcion = rs.getString("descripcion");
                        String categoria = rs.getString("categoria");
                        double precio = rs.getDouble("precio");
                        String imagen = rs.getString("imagen");
                        String usuarioProducto = rs.getString("nombre_usuario");
            %>
            <div class="producto-card" title="<%= descripcion %>" onclick="location.href='verProducto.jsp?id=<%= idProducto %>'">
                <img src="<%= imagen %>" alt="Imagen del producto" />
                <h3><%= nombreProducto %></h3>
                <p><strong>Categoría:</strong> <%= categoria %></p>
                <p><strong>Precio:</strong> $<%= precio %></p>
                <p><strong>Publicado por:</strong> <%= usuarioProducto %></p>

                <form action="AgregarAlCarritoServlet" method="post" onClick="event.stopPropagation();" style="margin-top:10px;">
    <input type="hidden" name="producto" value="<%= nombreProducto %>" />
    <button type="submit" style="background-color:#28a745; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;">Agregar al carrito</button>
</form>

          

            
            
            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error al cargar productos.</p>");
                    e.printStackTrace();
                }
            %>
        </div>
    </main>
</div>

<footer class="footer">
    &copy; 2025 Free Fire. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>
