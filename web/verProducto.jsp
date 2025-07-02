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
        body {
            background-color: #f0f2f5;
        }

        .producto-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            max-width: 1400px;
            margin: 100px auto;
            padding: 0 30px;
        }

        .detalle-producto {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }

        .detalle-producto img {
            width: 100%;
            height: 350px;
            object-fit: cover;
            border-radius: 10px;
        }

        .detalle-producto h2 {
            font-size: 28px;
            margin: 15px 0 10px;
        }

        .detalle-producto p {
            font-size: 16px;
            margin: 6px 0;
        }

        .comentarios-producto {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            max-height: 800px;
            overflow-y: auto;
        }

        .comentarios-producto h3 {
            margin-top: 0;
            font-size: 22px;
        }

        .comentario-card {
            background: #f9f9f9;
            padding: 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }

        .comentario-card p {
            margin: 6px 0;
        }

        .rating-star {
            color: #ffc107;
            font-size: 18px;
        }

        .formulario-comentario {
            margin-top: 30px;
        }

        .formulario-comentario textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 10px;
        }

        .formulario-comentario select,
        .formulario-comentario button {
            margin-top: 8px;
            padding: 8px;
        }

        .formulario-comentario h4 {
            margin-bottom: 10px;
        }

        .formulario-comentario label {
            display: block;
            margin-bottom: 5px;
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

<main class="producto-grid">
    <%
        try (Connection conn = ConexionDB.obtenerConexion()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT p.*, u.nombre as vendedor FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id WHERE p.id = ?");
            stmt.setInt(1, Integer.parseInt(idProducto));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
    %>

    <div class="detalle-producto">
        <img src="<%= rs.getString("imagen") %>" alt="Imagen del producto">
        <h2><%= rs.getString("nombre") %></h2>
        <p><strong>Descripción:</strong> <%= rs.getString("descripcion") %></p>
        <p><strong>Categoría:</strong> <%= rs.getString("categoria") %></p>
        <p><strong>Precio:</strong> $<%= rs.getDouble("precio") %></p>
        <p><strong>Vendedor:</strong> <%= rs.getString("vendedor") %></p>

        <% if (nombreUsuario != null) {
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE u.nombre = ? AND c.producto_id = ?"
            );
            checkStmt.setString(1, nombreUsuario);
            checkStmt.setInt(2, Integer.parseInt(idProducto));
            ResultSet rsCheck = checkStmt.executeQuery();
            rsCheck.next();
            boolean yaComento = rsCheck.getInt(1) > 0;

            if (!yaComento) {
        %>
        <div class="formulario-comentario">
            <h4>Agregar un comentario</h4>
            <form action="AgregarComentarioServlet" method="post">
                <input type="hidden" name="productoId" value="<%= idProducto %>">

                <label for="comentario">Comentario:</label>
                <textarea name="comentario" rows="4" required></textarea>

                <label for="puntuacion">Puntuación:</label>
                <select name="puntuacion" required>
                    <option value="">Selecciona</option>
                    <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>

                <button type="submit">Enviar</button>
            </form>
        </div>
        <% } else { %>
            <p style="margin-top: 20px; color: gray;"><em>Ya has comentado este producto.</em></p>
        <% } } else { %>
            <p style="margin-top: 20px;"><a href="login.jsp">Inicia sesión</a> para comentar.</p>
        <% } %>
    </div>

    <div class="comentarios-producto">
        <h3>Comentarios y Reseñas</h3>
        <%
            PreparedStatement comStmt = conn.prepareStatement(
                "SELECT c.comentario, c.fecha, c.puntuacion, u.nombre FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE c.producto_id = ? ORDER BY c.fecha DESC"
            );
            comStmt.setInt(1, Integer.parseInt(idProducto));
            ResultSet rsCom = comStmt.executeQuery();

            boolean hayComentarios = false;
            while (rsCom.next()) {
                hayComentarios = true;
                int puntuacion = rsCom.getInt("puntuacion");
        %>
        <div class="comentario-card">
            <p><strong><%= rsCom.getString("nombre") %></strong></p>
            <p><%= rsCom.getString("comentario") %></p>
            <p>
                <% for (int i = 0; i < puntuacion; i++) { %>
                    <span class="rating-star">&#9733;</span>
                <% } %>
            </p>
            <small><%= rsCom.getTimestamp("fecha") %></small>
        </div>
        <% } %>

        <% if (!hayComentarios) { %>
            <p style="color: gray;">Este producto aún no tiene comentarios.</p>
        <% } %>
    </div>

    <%
            } else {
                out.println("<p>Producto no encontrado.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error al obtener el producto.</p>");
            e.printStackTrace();
        }
    %>
</main>


<footer class="footer">
    &copy; 2025 LocalMarket. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>
