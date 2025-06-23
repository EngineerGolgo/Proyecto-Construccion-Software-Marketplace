package Control;

import Modelo.Usuario;   
import DAO.UsuarioDAO;     
import DAO.DAOException;   

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            Usuario usuario = usuarioDAO.obtenerPorCredenciales(correo, contrasena);

            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("nombreUsuario", usuario.getNombre()); 
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=credenciales_invalidas");
            }

        } catch (DAOException e) {
            System.err.println("Error de base de datos en LoginServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=error_db");
        } catch (Exception e) {
            System.err.println("Error inesperado en LoginServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=inesperado");
        }
    }
}
