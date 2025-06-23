package Control;

import Modelo.Usuario;   
import DAO.UsuarioDAO;     
import DAO.UsuarioDAO.DAOException;   

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        Usuario nuevoUsuario = new Usuario(nombre, correo, contrasena);

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            boolean registrado = usuarioDAO.registrarUsuario(nuevoUsuario);

            if (registrado) {
                response.sendRedirect("home.jsp"); 
            } else {
                response.sendRedirect("home.jsp?error=registro_fallido"); 
            }
        } catch (DAOException e) {
            System.err.println("Error al registrar el usuario desde el Servlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=1");
        } catch (Exception e) {
            System.err.println("Error inesperado en RegistroServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=inesperado");
        }
    }
}
