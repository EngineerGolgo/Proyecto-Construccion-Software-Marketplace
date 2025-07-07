<%-- 
    Document   : logout
    Created on : 5 jun 2025, 11:32:02 p. m.
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
    // Inicio del bloque de scriptlet Java para manejar el cierre de sesión

    // Obtiene la sesión actual del usuario.
    // El parámetro 'false' evita que se cree una nueva sesión si no hay una existente,
    // lo cual es importante para solo invalidar una sesión activa.
    HttpSession sesion = request.getSession(false);
    
    // Verifica si existe una sesión activa.
    if (sesion != null) {
        // Si la sesión existe, la invalida. Esto destruye la sesión y elimina todos
        // los atributos asociados a ella, cerrando efectivamente la sesión del usuario.
        sesion.invalidate();
    }
    
    // Redirige al usuario a la página de inicio (home.jsp) después de cerrar la sesión.
    // Esto asegura que el usuario vea una página pública o de inicio de sesión.
    response.sendRedirect("home.jsp");
%>
</html>