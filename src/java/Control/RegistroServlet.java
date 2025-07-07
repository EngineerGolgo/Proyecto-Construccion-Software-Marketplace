package Control;

import Modelo.Usuario;   
import DAO.UsuarioDAO;     
import DAO.UsuarioDAO.DAOException;   

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet para manejar el registro de nuevos usuarios en el sistema.
 * Procesa los datos del formulario de registro y persiste la información del usuario en la base de datos.
 *
 * @author Anthony Lopez
 * @version 1.0
 * @since 2025-07-06
 */
@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    /**
     * Procesa la solicitud POST para registrar un nuevo usuario.
     * Recibe el nombre, correo y contraseña del formulario, crea un objeto Usuario,
     * y utiliza UsuarioDAO para intentar registrarlo en la base de datos.
     * Redirige a 'home.jsp' con un mensaje de éxito o error.
     *
     * @param request El objeto HttpServletRequest que contiene la solicitud del cliente.
     * @param response El objeto HttpServletResponse que contiene la respuesta que el servlet envía al cliente.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de entrada o salida al procesar la solicitud.
     */
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
