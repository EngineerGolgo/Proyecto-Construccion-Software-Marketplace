<%-- 
    Document   : perfil
    Created on : 5 jun 2025, 10:15:31?p. m.
    Author     : User
--%>

<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.io.*, java.sql.*" %>
<%@ page import="Datos.ConexionDB" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Usuario" %>
<%@ page import="DAO.UsuarioDAO" %>
<%@ page import="DAO.ProductoDAO" %> <%-- Necesario para el carrito --%>
<%@ page import="DAO.DAOException" %>

<%
    HttpSession sesion = request.getSession(false);
    String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Usuario usuarioActual = null;
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    try {
        usuarioActual = usuarioDAO.obtenerPorNombre(nombreUsuario);
        if (usuarioActual == null) {
            response.sendRedirect("login.jsp?error=perfil_no_encontrado");
            return;
        }
    } catch (DAOException e) {
        System.err.println("Error de DB al cargar perfil: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp?error=error_db_perfil_carga");
        return;
    } catch (Exception e) {
        System.err.println("Error inesperado al cargar perfil: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp?error=inesperado_perfil_carga");
        return;
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

        function toggleEditForm() {
            const displayDiv = document.getElementById('display-info');
            const editForm = document.getElementById('edit-form');
            if (displayDiv.style.display === 'none') {
                displayDiv.style.display = 'block';
                editForm.style.display = 'none';
            } else {
                displayDiv.style.display = 'none';
                editForm.style.display = 'block';
            }
        }

        function confirmarEliminarUsuario() {
            // Utiliza un modal personalizado si tienes uno, en lugar de confirm()
            return confirm("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción es irreversible y borrará todos tus productos, pedidos y comentarios.");
        }
    </script>

    <style>
        /* Mantén tus estilos existentes */
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

        .profile-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .profile-actions a, .profile-actions button, .profile-actions form button { /* Añadido form button */
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 10px;
        }

        .profile-actions a:hover, .profile-actions button:hover, .profile-actions form button:hover {
            background-color: #0056b3;
        }

        /* Estilo específico para el botón de eliminar */
        .profile-actions form.delete-form button {
            background-color: #dc3545; /* Rojo para eliminar */
        }
        .profile-actions form.delete-form button:hover {
            background-color: #c82333;
        }


        /* Estilos para el formulario de edición */
        #edit-form {
            display: none;
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        #edit-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }

        #edit-form input[type="text"],
        #edit-form input[type="email"],
        #edit-form input[type="password"] {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
        }

        #edit-form button[type="submit"] {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #edit-form button[type="submit"]:hover {
            background-color: #218838;
        }

        #edit-form button[type="button"] {
            background-color: #dc3545;
        }

        #edit-form button[type="button"]:hover {
            background-color: #c82333;
        }

        /* Mensajes de éxito/error */
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            font-weight: bold;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    
    <button id="toggleCarrito" onclick="toggleCarrito()">? Ver Carrito</button>

    <div id="carrito-panel">
        <h2>Mi Carrito</h2>
        <ul>
            <%
                List<Integer> carritoIds = (List<Integer>) sesion.getAttribute("carrito");
                List<Modelo.Producto> productosEnCarrito = new java.util.ArrayList<>();
                DAO.ProductoDAO productoDAO = new DAO.ProductoDAO(); // Instancia aquí

                if (carritoIds != null && !carritoIds.isEmpty()) {
                    try {
                        for (Integer id : carritoIds) {
                            Modelo.Producto producto = productoDAO.obtenerPorId(id);
                            if (producto != null) {
                                productosEnCarrito.add(producto);
                            }
                        }
                    } catch (DAOException e) {
                        System.err.println("Error al cargar productos del carrito en el perfil: " + e.getMessage());
                        out.println("<li>Error al cargar productos del carrito.</li>");
                    }
                }

                if (productosEnCarrito != null && !productosEnCarrito.isEmpty()) {
                    for (int i = 0; i < productosEnCarrito.size(); i++) {
                        Modelo.Producto prod = productosEnCarrito.get(i);
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
            Marketplace <span class="saludo">¡Hola, <%= usuarioActual.getNombre() %>!</span>
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
            <a href="dashboard.jsp?search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Todas</a>
            <a href="dashboard.jsp?categoria=Tecnología&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Tecnología</a>
            <a href="dashboard.jsp?categoria=Hogar&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Hogar</a>
            <a href="dashboard.jsp?categoria=Moda&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Moda</a>
            <a href="dashboard.jsp?categoria=Otros&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Otros</a>
        </aside>

        <main class="content">
            <h1>Perfil del Usuario</h1>

            <%-- Mensajes de éxito/error --%>
            <%
                String exito = request.getParameter("exito");
                String error = request.getParameter("error");
                if ("perfil_actualizado".equals(exito)) {
                    out.println("<p class='message success'>¡Perfil actualizado con éxito!</p>");
                } else if ("eliminado_exito".equals(request.getParameter("eliminado"))) { // Nuevo mensaje de eliminado
                     out.println("<p class='message success'>¡Tu cuenta ha sido eliminada con éxito!</p>");
                } else if (error != null) {
                    out.println("<p class='message error'>Error: " + error.replace("_", " ") + "</p>");
                }
            %>

            <div id="display-info">
                <p><strong>Nombre:</strong> <%= usuarioActual.getNombre() %></p>
                <p><strong>Correo:</strong> <%= usuarioActual.getCorreo() %></p>
            </div>

            <div id="edit-form" style="display:none;">
                <h2>Editar Perfil</h2>
                <form action="EditarPerfilServlet" method="post">
                    <label for="nombre">Nombre de Usuario:</label>
                    <input type="text" id="nombre" name="nombre" value="<%= usuarioActual.getNombre() %>" required><br>

                    <label for="correo">Correo Electrónico:</label>
                    <input type="email" id="correo" name="correo" value="<%= usuarioActual.getCorreo() %>" required><br>

                    <label for="contrasena">Nueva Contraseña (dejar en blanco para no cambiar):</label>
                    <input type="password" id="contrasena" name="contrasena" placeholder="********" value="<%= usuarioActual.getContrasena() %>"><br>
                    
                    <button type="submit">Guardar Cambios</button>
                    <button type="button" onclick="toggleEditForm()">Cancelar</button>
                </form>
            </div>

            <div class="profile-actions">
                <button type="button" onclick="toggleEditForm()">Editar Perfil</button>
                <a href="dashboard.jsp">Volver al Dashboard</a>
                
                <form action="EliminarUsuarioServlet" method="post" style="display:inline;" onsubmit="return confirmarEliminarUsuario();" class="delete-form">
                    <button type="submit">Eliminar Cuenta</button>
                </form>
            </div>
        </main>
    </div>

    <footer class="footer">
        &copy; 2025 Free Fire. Todos los derechos reservados a Anthony Lopez.
    </footer>

</body>
</html>
