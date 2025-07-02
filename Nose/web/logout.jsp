<%-- 
    Document   : logout
    Created on : 5 jun 2025, 11:32:02 p. m.
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion != null) {
        sesion.invalidate();
    }
    response.sendRedirect("login.jsp");
%>
</html>
