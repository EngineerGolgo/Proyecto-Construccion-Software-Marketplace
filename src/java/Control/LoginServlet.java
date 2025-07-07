package Control;

import Modelo.Usuario;   
import DAO.UsuarioDAO;     
import DAO.DAOException;   

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet para manejar el inicio de sesión de usuarios.
 * Procesa las credenciales enviadas, autentica al usuario y, si son válidas,
 * establece la sesión y redirige al dashboard.
 *
 * @author Anthony Lopez
 * @version 1.0
 * @since 2025-07-06
 */
public class LoginServlet extends HttpServlet {
    /**
     * Procesa la solicitud POST para autenticar a un usuario.
     * Recibe el correo y la contraseña, los valida contra la base de datos
     * y gestiona la sesión del usuario.
     *
     * @param request El objeto HttpServletRequest.
     * @param response El objeto HttpServletResponse.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de E/S.
     */
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
                response.sendRedirect("dashboard.jsp?showWelcomeAnimation=true"); 
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