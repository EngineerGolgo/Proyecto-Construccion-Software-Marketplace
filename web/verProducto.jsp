<%-- 
    Document   : verProducto
    Created on : 13 jun 2025, 8:14:58?p. m.
    Author     : User
--%>

<%@ page import="java.sql.*,Datos.ConexionDB,jakarta.servlet.http.*,java.util.*" %>
<%
    String idProducto = request.getParameter("id");
    HttpSession sesion = request.getSession(false);
    String nombreUsuario = (sesion != null) ? (String) sesion.getAttribute("nombreUsuario") : null;

    if (idProducto == null || idProducto.isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle del Producto</title>
    <link rel="stylesheet" href="css/estiloDashboard.css">
    <style>
        .detalle-container {
            max-width: 900px;
            margin: 100px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .detalle-container img { width: 100%; height: 300px; object-fit: cover; border-radius: 8px; }
        .comentario-box { border-bottom: 1px solid #ccc; margin-bottom: 15px; padding-bottom: 10px; }
        .comentario-box p { margin: 6px 0; }
        .formulario-comentario textarea {
            width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px;
        }
        .formulario-comentario select, .formulario-comentario button {
            margin-top: 10px;
        }
        .rating-star {
            color: #FFD700; font-size: 16px;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="logo">Marketplace</div>
    <nav class="navbar">
        <a href="dashboard.jsp">Inicio</a>
        <a href="perfil.jsp">Perfil</a>
        <a href="foro.jsp">Publicar Mensaje</a>
        <a href="misProductos.jsp">Mis Productos</a>
        <a href="mensajes.jsp">Mensajes</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<main class="container">
    <div class="detalle-container">
        <%
            try (Connection conn = ConexionDB.obtenerConexion()) {
                PreparedStatement stmt = conn.prepareStatement("SELECT p.*, u.nombre as vendedor FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id WHERE p.id = ?");
                stmt.setInt(1, Integer.parseInt(idProducto));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
        %>
        <img src="<%= rs.getString("imagen") %>" alt="Imagen del producto">
        <h2><%= rs.getString("nombre") %></h2>
        <p><strong>Descripción:</strong> <%= rs.getString("descripcion") %></p>
        <p><strong>Categoría:</strong> <%= rs.getString("categoria") %></p>
        <p><strong>Precio:</strong> $<%= rs.getDouble("precio") %></p>
        <p><strong>Vendedor:</strong> <%= rs.getString("vendedor") %></p>

        <hr>
        <h3>Comentarios y Reseñas</h3>
        <%
            PreparedStatement comStmt = conn.prepareStatement(
                "SELECT c.comentario, c.fecha, c.puntuacion, u.nombre FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE c.producto_id = ? ORDER BY c.fecha DESC"
            );
            comStmt.setInt(1, Integer.parseInt(idProducto));
            ResultSet rsCom = comStmt.executeQuery();

            while (rsCom.next()) {
                int puntuacion = rsCom.getInt("puntuacion");
        %>
        <div class="comentario-box">
            <p><strong><%= rsCom.getString("nombre") %></strong></p>
            <p><%= rsCom.getString("comentario") %></p>
            <p>Puntuación:
                <% for (int i = 0; i < puntuacion; i++) { %>
                    <span class="rating-star">&#9733;</span>
                <% } %>
            </p>
            <small><%= rsCom.getTimestamp("fecha") %></small>
        </div>
        <% } %>

        <% if (nombreUsuario != null) { %>
        <div class="formulario-comentario">
            <h4>Agregar un comentario</h4>
            <form action="AgregarComentarioServlet" method="post">
                <input type="hidden" name="productoId" value="<%= idProducto %>">
                <label for="comentario">Comentario:</label><br>
                <textarea name="comentario" rows="4" required></textarea><br>

                <label for="puntuacion">Puntuación:</label>
                <select name="puntuacion" required>
                    <option value="">Selecciona</option>
                    <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%= i %>"><%= i %></option>
                    <% } %>
                </select><br>

                <button type="submit">Enviar</button>
            </form>
        </div>
        <% } else { %>
            <p><a href="login.jsp">Inicia sesión</a> para comentar.</p>
        <% } %>

        <%
                } else {
                    out.println("<p>Producto no encontrado.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error al obtener el producto.</p>");
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
