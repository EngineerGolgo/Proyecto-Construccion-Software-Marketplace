<%-- 
    Document   : perfil
    Created on : 5 jun 2025, 10:15:31 p. m.
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    HttpSession sesion = request.getSession(false);
    String usuario = (String) sesion.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Perfil de Usuario</title>
</head>
<body>
    <h2>Bienvenido, <%= usuario %>!</h2>
    <a href="logout.jsp">Cerrar sesión</a>
</body>
</html>