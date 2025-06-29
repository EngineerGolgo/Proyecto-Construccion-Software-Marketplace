/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Control;

import Modelo.Usuario;
import DAO.UsuarioDAO;    
import DAO.DAOException; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EditarPerfilServlet")
public class EditarPerfilServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); 

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nombreUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nombreUsuarioActual = (String) session.getAttribute("nombreUsuario");

        String nuevoNombre = request.getParameter("nombre");
        String nuevoCorreo = request.getParameter("correo");
        String nuevaContrasena = request.getParameter("contrasena"); 

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            Usuario usuarioExistente = usuarioDAO.obtenerPorNombre(nombreUsuarioActual);

            if (usuarioExistente == null) {
                response.sendRedirect("perfil.jsp?error=usuario_no_encontrado");
                return;
            }

            Usuario usuarioAActualizar = new Usuario(
                usuarioExistente.getId(),
                nuevoNombre,
                nuevoCorreo,
                nuevaContrasena 
            );

            boolean actualizado = usuarioDAO.actualizarUsuario(usuarioAActualizar);

            if (actualizado) {
                if (!nombreUsuarioActual.equals(nuevoNombre)) {
                    session.setAttribute("nombreUsuario", nuevoNombre);
                }
                response.sendRedirect("perfil.jsp?exito=perfil_actualizado");
            } else {
                response.sendRedirect("perfil.jsp?error=no_se_pudo_actualizar");
            }

        } catch (DAOException e) {
            System.err.println("Error de base de datos al actualizar perfil: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=error_db_perfil");
        } catch (Exception e) {
            System.err.println("Error inesperado en EditarPerfilServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=inesperado");
        }
    }
}