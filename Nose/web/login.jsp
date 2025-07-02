<%-- 
    Document   : login
    Created on : 5 jun 2025, 10:15:14 p. m.
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Iniciar Sesión</title>
</head>
<body>
    <h2>Login</h2>
    <form action="LoginServlet" method="post">
        Correo: <input type="email" name="correo" required><br>
        Contraseña: <input type="password" name="contrasena" required><br>
        <input type="submit" value="Iniciar Sesión">
    </form>

    <% if (request.getParameter("error") != null) { %>
        <p style="color:red;">Credenciales incorrectas.</p>
    <% } %>
</body>
</html>