<%-- 
    Document   : perfil
    Created on : 5 jun 2025, 10:15:31?p. m.
    Author     : User
--%>

<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*,java.sql.*" %>
<%@ page import="Marketplace.ConexionDB" %>
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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Perfil de Usuario</title>
    <link rel="stylesheet" type="text/css" href="css/estilos.css">
</head>
<body>
    <div class="container">
    <h1>Perfil del Usuario</h1>
    <p><strong>Nombre:</strong> <%= nombreUsuario %></p>
    <p><strong>Correo:</strong> <%= correo %></p>

    <a href="dashboard.jsp">Volver al Dashboard</a>
    </div>
</body>
</html>