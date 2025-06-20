<%-- 
    Document   : verProducto
    Created on : 13 jun 2025, 8:14:58?p. m.
    Author     : User
--%>

<%@ page import="java.sql.*,Marketplace.ConexionDB" %>
<%
    String idProducto = request.getParameter("id");

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
    <link rel="stylesheet" type="text/css" href="css/estilos.css">
    <style>
        .detalle-container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .detalle-container img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
        }

        .detalle-container h2 {
            margin-top: 20px;
        }

        .detalle-container p {
            margin: 10px 0;
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
                    String nombre = rs.getString("nombre");
                    String descripcion = rs.getString("descripcion");
                    String categoria = rs.getString("categoria");
                    double precio = rs.getDouble("precio");
                    String imagen = rs.getString("imagen");
                    String vendedor = rs.getString("vendedor");
        %>
        <img src="<%= imagen %>" alt="Imagen del producto">
        <h2><%= nombre %></h2>
        <p><strong>Descripción:</strong> <%= descripcion %></p>
        <p><strong>Categoría:</strong> <%= categoria %></p>
        <p><strong>Precio:</strong> $<%= precio %></p>
        <p><strong>Vendedor:</strong> <%= vendedor %></p>

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