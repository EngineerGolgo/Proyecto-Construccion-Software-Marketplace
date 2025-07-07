<%--
    Document   : verProducto
    Created on : 13 jun 2025, 8:14:58 p. m.
    Author     : User
--%>

<%@ page import="java.sql.*,Datos.ConexionDB,jakarta.servlet.http.*,java.util.*" %>
<%
    // Inicio del bloque de scriptlet Java para la inicialización y validación.

    // Obtiene el ID del producto de los parámetros de la solicitud.
    String idProducto = request.getParameter("id");
    // Obtiene la sesión actual del usuario (sin crear una nueva si no existe).
    HttpSession sesion = request.getSession(false);
    // Obtiene el nombre de usuario de la sesión, si existe.
    String nombreUsuario = (sesion != null) ? (String) sesion.getAttribute("nombreUsuario") : null;

    // Si el ID del producto es nulo o está vacío, redirige al usuario al dashboard.
    // Esto previene errores si se intenta acceder a la página sin un ID válido.
    if (idProducto == null || idProducto.isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return; // Detiene la ejecución del JSP.
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle del Producto</title>
    <link rel="stylesheet" href="css/estiloDashboard.css">
    <style>
        /* Estilos CSS específicos para la página de detalle del producto y comentarios */
        body {
            background-color: #f0f2f5; /* Fondo más suave */
        }

        .producto-grid {
            display: grid;
            grid-template-columns: 1fr 1fr; /* Dos columnas: una para detalle, otra para comentarios */
            gap: 40px; /* Espacio entre las columnas */
            max-width: 1400px;
            margin: 100px auto; /* Centra el contenido principal */
            padding: 0 30px;
        }

        .detalle-producto {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08); /* Sombra sutil */
        }

        .detalle-producto img {
            width: 100%;
            height: 350px;
            object-fit: cover; /* Asegura que la imagen cubra el área sin distorsionarse */
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
            max-height: 800px; /* Altura máxima para los comentarios */
            overflow-y: auto; /* Permite desplazamiento si hay muchos comentarios */
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
            color: #ffc107; /* Color dorado para las estrellas */
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
        // Inicio del bloque de scriptlet Java para obtener y mostrar los detalles del producto.
        try (Connection conn = ConexionDB.obtenerConexion()) {
            // Prepara la consulta SQL para obtener los detalles del producto y el nombre del vendedor.
            // Se une la tabla productos1 con la tabla usuarios usando usuario_id = u.id.
            PreparedStatement stmt = conn.prepareStatement("SELECT p.*, u.nombre as vendedor FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id WHERE p.id = ?");
            // Establece el ID del producto obtenido de la URL como parámetro de la consulta.
            stmt.setInt(1, Integer.parseInt(idProducto));
            // Ejecuta la consulta y obtiene el resultado.
            ResultSet rs = stmt.executeQuery();

            // Si se encuentra el producto en la base de datos.
            if (rs.next()) {
    %>

    <div class="detalle-producto">
        <img src="<%= rs.getString("imagen") %>" alt="Imagen del producto">
        <h2><%= rs.getString("nombre") %></h2>
        <p><strong>Descripción:</strong> <%= rs.getString("descripcion") %></p>
        <p><strong>Categoría:</strong> <%= rs.getString("categoria") %></p>
        <p><strong>Precio:</strong> $<%= rs.getDouble("precio") %></p>
        <p><strong>Vendedor:</strong> <%= rs.getString("vendedor") %></p>

        <%
            // Verifica si el usuario actual ha iniciado sesión para mostrar el formulario de comentarios.
            if (nombreUsuario != null) {
                // Prepara la consulta para verificar si el usuario ya ha comentado este producto.
                PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE u.nombre = ? AND c.producto_id = ?"
                );
                // Establece el nombre de usuario y el ID del producto como parámetros.
                checkStmt.setString(1, nombreUsuario);
                checkStmt.setInt(2, Integer.parseInt(idProducto));
                // Ejecuta la consulta.
                ResultSet rsCheck = checkStmt.executeQuery();
                rsCheck.next(); // Mueve el cursor al primer (y único) resultado.
                boolean yaComento = rsCheck.getInt(1) > 0; // true si el conteo es mayor que 0.

                // Si el usuario NO ha comentado este producto, muestra el formulario para agregar un comentario.
                if (!yaComento) {
        %>
        <div class="formulario-comentario">
            <h4>Agregar un comentario</h4>
            <%-- Formulario para enviar un nuevo comentario al servlet AgregarComentarioServlet. --%>
            <form action="AgregarComentarioServlet" method="post">
                <%-- Campo oculto para pasar el ID del producto al servlet. --%>
                <input type="hidden" name="productoId" value="<%= idProducto %>">

                <label for="comentario">Comentario:</label>
                <textarea name="comentario" rows="4" required></textarea>

                <label for="puntuacion">Puntuación:</label>
                <select name="puntuacion" required>
                    <option value="">Selecciona</option>
                    <%-- Genera opciones de puntuación del 1 al 5. --%>
                    <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>

                <button type="submit">Enviar</button>
            </form>
        </div>
        <% } else { %>
            <%-- Mensaje si el usuario ya ha comentado el producto. --%>
            <p style="margin-top: 20px; color: gray;"><em>Ya has comentado este producto.</em></p>
        <% } } else { %>
            <%-- Mensaje si el usuario no ha iniciado sesión, invitándolo a hacerlo para comentar. --%>
            <p style="margin-top: 20px;"><a href="login.jsp">Inicia sesión</a> para comentar.</p>
        <% } %>
    </div>

    <div class="comentarios-producto">
        <h3>Comentarios y Reseñas</h3>
        <%
            // Prepara la consulta SQL para obtener todos los comentarios de este producto.
            // Se une con la tabla usuarios para obtener el nombre del comentarista.
            // Se ordenan por fecha descendente (los más recientes primero).
            PreparedStatement comStmt = conn.prepareStatement(
                "SELECT c.comentario, c.fecha, c.puntuacion, u.nombre FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE c.producto_id = ? ORDER BY c.fecha DESC"
            );
            // Establece el ID del producto.
            comStmt.setInt(1, Integer.parseInt(idProducto));
            // Ejecuta la consulta y obtiene los comentarios.
            ResultSet rsCom = comStmt.executeQuery();

            boolean hayComentarios = false; // Bandera para saber si se encontraron comentarios.
            // Itera sobre cada comentario encontrado.
            while (rsCom.next()) {
                hayComentarios = true; // Se encontró al menos un comentario.
                int puntuacion = rsCom.getInt("puntuacion");
        %>
        <div class="comentario-card">
            <p><strong><%= rsCom.getString("nombre") %></strong></p>
            <p><%= rsCom.getString("comentario") %></p>
            <p>
                <%-- Genera estrellas según la puntuación. --%>
                <% for (int i = 0; i < puntuacion; i++) { %>
                    <span class="rating-star">&#9733;</span>
                <% } %>
            </p>
            <small><%= rsCom.getTimestamp("fecha") %></small>
        </div>
        <% } %>

        <% if (!hayComentarios) { %>
            <%-- Mensaje si no hay comentarios para el producto. --%>
            <p style="color: gray;">Este producto aún no tiene comentarios.</p>
        <% } %>
    </div>

    <%
            // Si el producto no fue encontrado (rs.next() fue false).
            } else {
                out.println("<p>Producto no encontrado.</p>");
            }
        } catch (Exception e) {
            // Manejo de errores si hay problemas con la base de datos o la lógica.
            out.println("<p>Error al obtener el producto.</p>");
            e.printStackTrace(); // Imprime el seguimiento de la pila para depuración.
        }
    %>
</main>


<footer class="footer">
    &copy; 2025 LocalMarket. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>