<%-- 
    Document   : publicar
    Created on : 10 jun 2025, 11:32:02 p. m.
    Author     : User
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("nombreUsuario") == null) {
        response.sendRedirect("login.jsp");
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
        .form-container {
            max-width: 600px;
            margin: 120px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
            margin: 10px 0 5px;
            font-weight: 600;
        }

        .form-container input[type="text"],
        .form-container input[type="number"],
        .form-container textarea,
        .form-container select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-container textarea {
            resize: vertical;
        }

        .form-container input[type="file"] {
            margin-top: 10px;
        }

        .form-container input[type="submit"] {
            margin-top: 25px;
            padding: 12px;
            background-color: #3AB397;
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-container input[type="submit"]:hover {
            background-color: #339d84;
        }

        body {
            padding-top: 60px; 
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
        <input type="number" step="0.01" name="precio" id="precio" required>

        <label for="imagen">Imagen del producto</label>
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