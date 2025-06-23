<%-- 
    Document   : dashboard
    Created on : 5 jun 2025, 11:33:02?p. m.
    Author     : User
--%>


<%@page import="java.util.List"%>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.io.*, java.sql.*, Datos.ConexionDB" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="Modelo.Producto" %> 
<%@ page import="DAO.ProductoDAO" %> 
<%@ page import="DAO.DAOException" %> 


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

    String searchTerm = request.getParameter("search");
    if (searchTerm == null) {
        searchTerm = ""; 
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/estilos.css" />
    <link rel="stylesheet" href="css/estiloDashboard.css" />
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <script>
        function toggleCarrito() {
            const panel = document.getElementById('carrito-panel');
            panel.classList.toggle('mostrar');
        }
    </script>

    <style>
        
        .search-bar {
            margin: 30px auto; 
            display: flex;
            align-items: center;
            background-color: #ffffff; 
            border-radius: 50px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1); 
            max-width: 600px; 
            padding: 8px 10px; 
            border: 1px solid #e0e0e0; 
        }

        .search-bar form {
            display: flex; 
            width: 100%;
            align-items: center;
        }

        .search-bar input[type="text"] {
            flex-grow: 1; 
            padding: 8px 15px;
            border: none; 
            background-color: transparent; 
            font-size: 1.1em;
            color: #333;
            outline: none; 
            order: 2; 
        }

        .search-bar input[type="text"]::placeholder {
            color: #888; 
        }

        .search-bar button[type="submit"] {
            background-color: #007bff; 
            color: white;
            border: none;
            border-radius: 50%; 
            width: 40px; 
            height: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-size: 1.2em; 
            transition: background-color 0.3s ease, transform 0.2s ease;
            flex-shrink: 0; 
            margin-right: 10px; 
            order: 1; 
        }

        .search-bar button[type="submit"]:hover {
            background-color: #0056b3; 
            transform: scale(1.05); 
        }
        
        main.content h1 {
            margin-bottom: 20px; 
        }
        
        .search-bar {
            margin-bottom: 40px; 
        }

    </style>
</head>
<body>
    
    <button id="toggleCarrito" onclick="toggleCarrito()">? Ver Carrito</button>

<div id="carrito-panel">
    <h2>Mi Carrito</h2>
    <ul>
<%
    List<Integer> carritoIds = (List<Integer>) session.getAttribute("carrito"); 
    List<Producto> productosEnCarrito = new java.util.ArrayList<>(); 
    ProductoDAO productoDAO = new ProductoDAO(); 

    if (carritoIds != null && !carritoIds.isEmpty()) {
        try {
            for (Integer id : carritoIds) {
                Producto producto = productoDAO.obtenerPorId(id); 
                if (producto != null) {
                    productosEnCarrito.add(producto);
                }
            }
        } catch (DAOException e) {
            System.err.println("Error al cargar productos del carrito en el dashboard: " + e.getMessage());
            e.printStackTrace();
            out.println("<li>Error al cargar productos del carrito.</li>");
        }
    }

    if (productosEnCarrito != null && !productosEnCarrito.isEmpty()) {
        for (int i = 0; i < productosEnCarrito.size(); i++) {
            Producto prod = productosEnCarrito.get(i);
%>
    <li>
        <strong><%= prod.getNombre() %></strong> - $<%= prod.getPrecio() %>
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
<% if (carritoIds != null && !carritoIds.isEmpty()) { %> 
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
        <a href="dashboard.jsp?search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item <%= (request.getParameter("categoria") == null || request.getParameter("categoria").isEmpty()) ? "active" : "" %>">Todas</a>
        <a href="dashboard.jsp?categoria=Tecnología&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item <%= "Tecnología".equals(request.getParameter("categoria")) ? "active" : "" %>">Tecnología</a>
        <a href="dashboard.jsp?categoria=Hogar&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item <%= "Hogar".equals(request.getParameter("categoria")) ? "active" : "" %>">Hogar</a>
        <a href="dashboard.jsp?categoria=Moda&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item <%= "Moda".equals(request.getParameter("categoria")) ? "active" : "" %>">Moda</a>
        <a href="dashboard.jsp?categoria=Otros&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item <%= "Otros".equals(request.getParameter("categoria")) ? "active" : "" %>">Otros</a>
    </aside>

    <main class="content">
        <h1>Productos</h1>

        <div class="search-bar">
            <form action="dashboard.jsp" method="get">
                <button type="submit"><i class="fas fa-search"></i></button> 
                <input type="text" name="search" placeholder="Buscar productos..." value="<%= searchTerm %>" />
                <input type="hidden" name="categoria" value="<%= request.getParameter("categoria") != null ? URLEncoder.encode(request.getParameter("categoria"), "UTF-8") : "" %>">
            </form>
        </div>
        
        <div class="productos-grid">
            <%
                try (Connection conn = ConexionDB.obtenerConexion()) {
                    String categoriaSeleccionada = request.getParameter("categoria");
                    
                    StringBuilder sql = new StringBuilder("SELECT p.*, u.nombre as nombre_usuario FROM productos1 p JOIN usuarios u ON p.usuario_id = u.id WHERE 1=1");
                    List<String> params = new java.util.ArrayList<>();

                    if (categoriaSeleccionada != null && !categoriaSeleccionada.isEmpty()) {
                        sql.append(" AND p.categoria = ?");
                        params.add(categoriaSeleccionada);
                    }

                    if (!searchTerm.isEmpty()) {
                        sql.append(" AND (p.nombre LIKE ? OR p.descripcion LIKE ?)");
                        params.add("%" + searchTerm + "%");
                        params.add("%" + searchTerm + "%");
                    }
                    
                    PreparedStatement stmt = conn.prepareStatement(sql.toString());

                    for (int i = 0; i < params.size(); i++) {
                        stmt.setString(i + 1, params.get(i));
                    }
                    
                    ResultSet rs = stmt.executeQuery();
                    
                    boolean productsFound = false;
                    while (rs.next()) {
                        productsFound = true;
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
                    <input type="hidden" name="productoId" value="<%= idProducto %>" />
                    <button type="submit" style="background-color:#28a745; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;">Agregar al carrito</button>
                </form>
            </div>
            <%
                    }
                    if (!productsFound) {
                        out.println("<p>No se encontraron productos que coincidan con su búsqueda.</p>");
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
