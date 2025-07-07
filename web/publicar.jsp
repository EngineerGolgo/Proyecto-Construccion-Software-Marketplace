<%--
    Document   : publicar
    Created on : 10 jun 2025, 11:32:02 p. m.
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Inicio del bloque de scriptlet Java para la verificación de sesión.

    // Obtiene la sesión HTTP actual del usuario.
    // El parámetro 'false' asegura que no se cree una nueva sesión si no existe.
    HttpSession sesion = request.getSession(false);

    // Verifica si la sesión es nula o si el atributo "nombreUsuario" no está presente en la sesión.
    // Esto significa que el usuario no ha iniciado sesión o su sesión ha expirado.
    if (sesion == null || sesion.getAttribute("nombreUsuario") == null) {
        // Si no hay sesión válida, redirige al usuario a la página de inicio de sesión.
        response.sendRedirect("login.jsp");
        // Detiene el procesamiento posterior de este JSP para evitar que se muestre contenido no autorizado.
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Publicar Producto</title>
    <link rel="stylesheet" href="css/estiloDashboard.css" />
    <style>
        /* Estilos CSS específicos para el formulario de publicación de productos */
        .form-container {
            max-width: 600px;
            margin: 120px auto; /* Centra el contenedor y le da margen superior */
            padding: 30px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Sombra suave para un efecto elevado */
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-container form {
            display: flex;
            flex-direction: column;
        }

        .form-container label {
            margin: 10px 0 5px; /* Espacio entre etiquetas y campos */
            font-weight: 600;
        }

        .form-container input[type="text"],
        .form-container input[type="number"],
        .form-container textarea,
        .form-container select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px; /* Bordes más redondeados */
            font-size: 14px;
        }

        .form-container textarea {
            resize: vertical; /* Permite redimensionar verticalmente */
        }

        .form-container input[type="file"] {
            margin-top: 10px;
        }

        .form-container input[type="submit"] {
            margin-top: 25px;
            padding: 12px;
            background-color: #3AB397; /* Color verde azulado */
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease; /* Transición suave al pasar el mouse */
        }

        .form-container input[type="submit"]:hover {
            background-color: #339d84; /* Tono más oscuro al pasar el mouse */
        }

        body {
            padding-top: 60px; /* Para evitar que el contenido se superponga con el header */
            margin: 0;
        }

        .volver {
            margin-top: 20px;
            text-align: center;
        }

        .volver a {
            text-decoration: none;
            color: #3AB397;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .volver a:hover {
            color: #339d84;
            text-decoration: underline;
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

<div class="form-container">
    <h2>Publicar Producto</h2>
    <%-- Formulario para enviar los datos del nuevo producto al servlet PublicarProductoServlet.
         'method="post"' es para enviar datos de forma segura.
         'enctype="multipart/form-data"' es necesario para subir archivos (en este caso, la imagen). --%>
    <form action="PublicarProductoServlet" method="post" enctype="multipart/form-data">
        <label for="nombre">Nombre del producto</label>
        <input type="text" name="nombre" id="nombre" required>

        <label for="descripcion">Descripción</label>
        <textarea name="descripcion" id="descripcion" rows="4" required></textarea>

        <label for="categoria">Categoría</label>
        <select name="categoria" id="categoria">
            <option value="Tecnología">Tecnología</option>
            <option value="Hogar">Hogar</option>
            <option value="Moda">Moda</option>
            <option value="Otros">Otros</option>
        </select>

        <label for="precio">Precio ($)</label>
        <%-- 'step="0.01"' permite números decimales para el precio. --%>
        <input type="number" step="0.01" name="precio" id="precio" required>

        <label for="imagen">Imagen del producto</label>
        <%-- 'accept="image/*"' restringe la selección de archivos a solo imágenes. --%>
        <input type="file" name="imagen" id="imagen" accept="image/*" required>

        <input type="submit" value="Publicar Producto">
    </form>

    <div class="volver">
        <a href="dashboard.jsp">&larr; Volver al inicio</a>
    </div>
</div>

<footer class="footer">
    &copy; 2025 Lopez Ochoa. Todos los derechos reservados a Anthony Lopez.
</footer>

</body>
</html>