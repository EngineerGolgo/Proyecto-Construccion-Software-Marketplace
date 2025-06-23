<%-- 
    Document   : perfil
    Created on : 5 jun 2025, 10:15:31?p. m.
    Author     : User
--%>

<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.sql.*" %>
<%@ page import="Datos.ConexionDB" %>
<%@ page import="java.net.URLEncoder" %> 
<%@ page import="java.util.List" %> 

<%
    HttpSession sesion = request.getSession(false);
    String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String correo = "";
    try (Connection conn = ConexionDB.obtenerConexion()) {
        String sql = "SELECT correo FROM usuarios WHERE nombre = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, nombreUsuario);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            correo = rs.getString("correo");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String searchTerm = ""; 
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil de Usuario</title>
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="css/estiloDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <script>
        function toggleCarrito() {
            const panel = document.getElementById('carrito-panel');
            panel.classList.toggle('mostrar');
        }
    </script>

    <style>
        main.content {
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto; 
        }

        main.content h1 {
            color: #333;
            margin-bottom: 25px;
            font-size: 2em;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            display: inline-block; 
        }

        main.content p {
            font-size: 1.1em;
            margin-bottom: 15px;
            color: #555;
        }

        main.content p strong {
            color: #000;
            margin-right: 5px;
        }

        main.content .profile-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        main.content .profile-actions a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        main.content .profile-actions a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    
    <button id="toggleCarrito" onclick="toggleCarrito()">? Ver Carrito</button>

    <div id="carrito-panel">
        <h2>Mi Carrito</h2>
        <ul>
            <%
                List<Integer> carrito = (List<Integer>) session.getAttribute("carrito");
                if (carrito != null && !carrito.isEmpty()) {
                    try (Connection conn = ConexionDB.obtenerConexion()) {
                        for (int i = 0; i < carrito.size(); i++) {
                            int idProducto = carrito.get(i);
                            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos1 WHERE id = ?");
                            stmt.setInt(1, idProducto);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next()) {
            %>
                <li>
                    <strong><%= rs.getString("nombre") %></strong> - $<%= rs.getDouble("precio") %>
                    <form action="EliminarDelCarritoServlet" method="post" style="display:inline;">
                        <input type="hidden" name="index" value="<%= i %>">
                        <button type="submit">Eliminar</button>
                    </form>
                </li>
            <%
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<li>Error al cargar productos del carrito.</li>");
                    }
                } else {
            %>
                <li>El carrito está vacío.</li>
            <%
                }
            %>
        </ul>
        <% if (carrito != null && !carrito.isEmpty()) { %>
            <form action="FinalizarPedidoServlet" method="post">
                <button type="submit" class="btn btn-success">Finalizar Pedido</button>
            </form>
        <% } %>
    </div>
    
    <% if (request.getParameter("pedido") != null) { %>
        <p style="color: green; font-weight: bold;">¡Pedido realizado con éxito!</p>
    <% } %>
    
    <header class="header">
        <div class="logo">
            Marketplace <span class="saludo">¡Hola, <%= nombreUsuario %>!</span>
        </div>
        <nav class="navbar">
            <a href="dashboard.jsp">Inicio</a>
            <a href="misProductos.jsp">Mis Productos</a>
            <a href="perfil.jsp">Perfil</a>
            <a href="logout.jsp">Cerrar Sesión</a>
        </nav>
    </header>

    <div class="container">
        <aside class="sidebar">
            <a href="publicar.jsp" class="btn-publicar-sidebar">+ Publicar Producto</a>
            <h2>Categorías</h2>
            <a href="dashboard.jsp?search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Todas</a>
            <a href="dashboard.jsp?categoria=Tecnología&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Tecnología</a>
            <a href="dashboard.jsp?categoria=Hogar&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Hogar</a>
            <a href="dashboard.jsp?categoria=Moda&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Moda</a>
            <a href="dashboard.jsp?categoria=Otros&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Otros</a>
        </aside>

        <main class="content">
            <h1>Perfil del Usuario</h1>
            <p><strong>Nombre:</strong> <%= nombreUsuario %></p>
            <p><strong>Correo:</strong> <%= correo %></p>

            <div class="profile-actions">
                <a href="dashboard.jsp">Volver al Dashboard</a>
                </div>
        </main>
    </div>

    <footer class="footer">
        &copy; 2025 Free Fire. Todos los derechos reservados a Anthony Lopez.
    </footer>

</body>
</html>