<%--
    Document   : perfil
    Created on : 5 jun 2025, 10:15:31 p. m.
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
    // Inicio del bloque de scriptlet Java para la verificaci�n de sesi�n y carga de datos del perfil.

    // Obtiene la sesi�n actual del usuario. 'false' indica que no se debe crear una nueva si no existe.
    HttpSession sesion = request.getSession(false);
    // Recupera el nombre de usuario de la sesi�n.
    String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

    // Si el nombre de usuario es nulo, significa que el usuario no ha iniciado sesi�n.
    if (nombreUsuario == null) {
        // Redirige al usuario a la p�gina de inicio de sesi�n y detiene el procesamiento de este JSP.
        response.sendRedirect("login.jsp");
        return;
    }

    // Declara una variable para almacenar el objeto Usuario actual.
    Usuario usuarioActual = null;
    // Instancia el DAO para interactuar con los datos del usuario en la base de datos.
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    try {
        // Intenta obtener los datos completos del usuario desde la base de datos usando su nombre de usuario.
        usuarioActual = usuarioDAO.obtenerPorNombre(nombreUsuario);
        // Si no se encuentra el usuario (lo cual ser�a un estado an�malo para una sesi�n activa),
        // redirige a la p�gina de login con un mensaje de error.
        if (usuarioActual == null) {
            response.sendRedirect("login.jsp?error=perfil_no_encontrado");
            return;
        }
    } catch (DAOException e) {
        // Captura excepciones espec�ficas del DAO (errores de base de datos).
        System.err.println("Error de DB al cargar perfil: " + e.getMessage());
        e.printStackTrace(); // Imprime el stack trace para depuraci�n.
        // Redirige al dashboard con un mensaje de error si la carga del perfil falla por DB.
        response.sendRedirect("dashboard.jsp?error=error_db_perfil_carga");
        return;
    } catch (Exception e) {
        // Captura cualquier otra excepci�n inesperada durante la carga del perfil.
        System.err.println("Error inesperado al cargar perfil: " + e.getMessage());
        e.printStackTrace(); // Imprime el stack trace para depuraci�n.
        // Redirige al dashboard con un mensaje de error general.
        response.sendRedirect("dashboard.jsp?error=inesperado_perfil_carga");
        return;
    }

    // Inicializa searchTerm para mantener la consistencia con la navegaci�n del sidebar, aunque no se usa directamente aqu�.
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
        // Funci�n para mostrar/ocultar el panel del carrito.
        function toggleCarrito() {
            const panel = document.getElementById('carrito-panel');
            panel.classList.toggle('mostrar');
        }

        // Funci�n para alternar entre la vista de informaci�n del perfil y el formulario de edici�n.
        function toggleEditForm() {
            const displayDiv = document.getElementById('display-info');
            const editForm = document.getElementById('edit-form');
            if (displayDiv.style.display === 'none') {
                displayDiv.style.display = 'block'; // Muestra la informaci�n
                editForm.style.display = 'none';    // Oculta el formulario
            } else {
                displayDiv.style.display = 'none';    // Oculta la informaci�n
                editForm.style.display = 'block';     // Muestra el formulario
            }
        }

        // Funci�n para pedir confirmaci�n antes de eliminar la cuenta del usuario.
        function confirmarEliminarUsuario() {
            return confirm("�Est�s seguro de que deseas eliminar tu cuenta? Esta acci�n es irreversible y borrar� todos tus productos, pedidos y comentarios.");
        }
    </script>

    <style>
        /* Estilos CSS espec�ficos para la p�gina de perfil */
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

        .profile-actions a, .profile-actions button, .profile-actions form button { /* A�adido form button */
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

        .profile-actions form.delete-form button {
            background-color: #dc3545;
        }
        .profile-actions form.delete-form button:hover {
            background-color: #c82333;
        }

        #edit-form {
            display: none; /* Oculto por defecto */
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

        #edit-form button[type="button"] { /* Bot�n de Cancelar */
            background-color: #dc3545;
        }

        #edit-form button[type="button"]:hover {
            background-color: #c82333;
        }

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
                // Inicio del scriptlet para mostrar los elementos del carrito (similar al dashboard.jsp)
                // Recupera la lista de IDs de productos del atributo 'carrito' de la sesi�n.
                List<Integer> carritoIds = (List<Integer>) sesion.getAttribute("carrito");
                // Inicializa una lista para almacenar los objetos Producto.
                List<Modelo.Producto> productosEnCarrito = new java.util.ArrayList<>();
                // Crea una instancia de ProductoDAO para obtener los detalles de los productos.
                DAO.ProductoDAO productoDAO = new DAO.ProductoDAO();

                // Si hay IDs en el carrito, intenta recuperar los detalles de cada producto.
                if (carritoIds != null && !carritoIds.isEmpty()) {
                    try {
                        for (Integer id : carritoIds) {
                            // Obtiene el objeto Producto por su ID.
                            Modelo.Producto producto = productoDAO.obtenerPorId(id);
                            if (producto != null) {
                                productosEnCarrito.add(producto);
                            }
                        }
                    } catch (DAOException e) {
                        // Manejo de errores si falla la carga de productos del carrito.
                        System.err.println("Error al cargar productos del carrito en el perfil: " + e.getMessage());
                        out.println("<li>Error al cargar productos del carrito.</li>");
                    }
                }

                // Si hay productos en el carrito, los muestra.
                if (productosEnCarrito != null && !productosEnCarrito.isEmpty()) {
                    for (int i = 0; i < productosEnCarrito.size(); i++) {
                        Modelo.Producto prod = productosEnCarrito.get(i);
            %>
                <li>
                    <strong><%= prod.getNombre() %></strong> - $<%= prod.getPrecio() %>
                    <%-- Formulario para eliminar un producto del carrito, pasando el �ndice para identificarlo en la lista. --%>
                    <form action="EliminarDelCarritoServlet" method="post" style="display:inline;">
                        <input type="hidden" name="index" value="<%= i %>">
                        <button type="submit">Eliminar</button>
                    </form>
                </li>
            <%
                    }
                } else {
            %>
                <li>El carrito est� vac�o.</li>
            <%
                }
            %>
        </ul>
        <%-- Muestra el bot�n para finalizar pedido solo si el carrito no est� vac�o. --%>
        <% if (carritoIds != null && !carritoIds.isEmpty()) { %>
            <form action="FinalizarPedidoServlet" method="post">
                <button type="submit" class="btn btn-success">Finalizar Pedido</button>
            </form>
        <% } %>
    </div>

    <%-- Muestra un mensaje de �xito si el pedido fue realizado (recibido por par�metro 'pedido'). --%>
    <% if (request.getParameter("pedido") != null) { %>
        <p style="color: green; font-weight: bold;">�Pedido realizado con �xito!</p>
    <% } %>

    <header class="header">
        <div class="logo">
            Marketplace <span class="saludo">�Hola, <%= usuarioActual.getNombre() %>!</span>
        </div>
        <nav class="navbar">
            <a href="dashboard.jsp">Inicio</a>
            <a href="misProductos.jsp">Mis Productos</a>
            <a href="perfil.jsp">Perfil</a>
            <a href="logout.jsp">Cerrar Sesi�n</a>
        </nav>
    </header>

    <div class="container">
        <aside class="sidebar">
            <a href="publicar.jsp" class="btn-publicar-sidebar">+ Publicar Producto</a>
            <h2>Categor�as</h2>
            <%-- Enlaces a categor�as para la navegaci�n lateral (mantiene el searchTerm para la b�squeda). --%>
            <a href="dashboard.jsp?search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Todas</a>
            <a href="dashboard.jsp?categoria=Tecnolog�a&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Tecnolog�a</a>
            <a href="dashboard.jsp?categoria=Hogar&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Hogar</a>
            <a href="dashboard.jsp?categoria=Moda&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Moda</a>
            <a href="dashboard.jsp?categoria=Otros&search=<%= URLEncoder.encode(searchTerm, "UTF-8") %>" class="categoria-item">Otros</a>
        </aside>

        <main class="content">
            <h1>Perfil del Usuario</h1>

            <%
                // Inicio del scriptlet para mostrar mensajes de �xito o error.
                String exito = request.getParameter("exito");
                String error = request.getParameter("error");
                // Muestra mensaje si el perfil se actualiz� correctamente.
                if ("perfil_actualizado".equals(exito)) {
                    out.println("<p class='message success'>�Perfil actualizado con �xito!</p>");
                }
                // Muestra mensaje si la cuenta fue eliminada con �xito (redirigido desde EliminarUsuarioServlet).
                else if ("eliminado_exito".equals(request.getParameter("eliminado"))) {
                    out.println("<p class='message success'>�Tu cuenta ha sido eliminada con �xito!</p>");
                }
                // Muestra mensaje de error gen�rico si hay un par�metro de error.
                else if (error != null) {
                    out.println("<p class='message error'>Error: " + error.replace("_", " ") + "</p>");
                }
            %>

            <%-- Div para mostrar la informaci�n del usuario (visible por defecto). --%>
            <div id="display-info">
                <p><strong>Nombre:</strong> <%= usuarioActual.getNombre() %></p>
                <p><strong>Correo:</strong> <%= usuarioActual.getCorreo() %></p>
            </div>

            <%-- Formulario para editar el perfil (oculto por defecto, se muestra con JavaScript). --%>
            <div id="edit-form" style="display:none;">
                <h2>Editar Perfil</h2>
                <form action="EditarPerfilServlet" method="post">
                    <label for="nombre">Nombre de Usuario:</label>
                    <input type="text" id="nombre" name="nombre" value="<%= usuarioActual.getNombre() %>" required><br>

                    <label for="correo">Correo Electr�nico:</label>
                    <input type="email" id="correo" name="correo" value="<%= usuarioActual.getCorreo() %>" required><br>

                    <label for="contrasena">Nueva Contrase�a (dejar en blanco para no cambiar):</label>
                    <%-- El campo de contrase�a no debe mostrar la contrase�a actual por seguridad, pero el valor est� ah�. --%>
                    <input type="password" id="contrasena" name="contrasena" placeholder="********" value=""><br>

                    <button type="submit">Guardar Cambios</button>
                    <button type="button" onclick="toggleEditForm()">Cancelar</button>
                </form>
            </div>

            <%-- Secciones de acciones del perfil. --%>
            <div class="profile-actions">
                <button type="button" onclick="toggleEditForm()">Editar Perfil</button>
                <a href="dashboard.jsp">Volver al Dashboard</a>

                <%-- Formulario para eliminar la cuenta. El 'onsubmit' llama a la funci�n de confirmaci�n JS. --%>
                <form action="EliminarUsuarioServlet" method="post" style="display:inline;" onsubmit="return confirmarEliminarUsuario();" class="delete-form">
                    <button type="submit">Eliminar Cuenta</button>
                </form>
            </div>
        </main>
    </div>

    <footer class="footer">
        &copy; 2025 LocalMarket. Todos los derechos reservados a Anthony Lopez.
    </footer>

</body>
</html>