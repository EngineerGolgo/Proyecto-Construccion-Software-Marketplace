<%-- 
    Document   : registro
    Created on : 5 jun 2025, 10:15:24 p. m.
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Registro de Usuario</title>
</head>
<body>
    <h2>Registro de Usuario</h2>
    <form action="RegistroServlet" method="post">
        Nombre: <input type="text" name="nombre" required><br>
        Correo: <input type="email" name="correo" required><br>
        Contraseña: <input type="password" name="contrasena" required><br>
        <input type="submit" value="Registrarse">
    </form>

    <%
        if(request.getParameter("exito") != null) {
            out.println("<p style='color: green;'>¡Registro exitoso!</p>");
        } else if (request.getParameter("error") != null) {
            out.println("<p style='color: red;'>Error al registrar usuario</p>");
        }
    %>
</body>
</html>