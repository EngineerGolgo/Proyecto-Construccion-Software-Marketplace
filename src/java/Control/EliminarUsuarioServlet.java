/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Control;

import DAO.UsuarioDAO;
import DAO.DAOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet para permitir a un usuario autenticado eliminar su propia cuenta.
 * Si la eliminación es exitosa, invalida la sesión y redirige al inicio.
 *
 * @author Jeremy Mero
 * @version 2.0.0
 * @since 2025-06-17
 */
@WebServlet("/EliminarUsuarioServlet")
public class EliminarUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nombreUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nombreUsuarioActual = (String) session.getAttribute("nombreUsuario");

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            Modelo.Usuario usuarioParaEliminar = usuarioDAO.obtenerPorNombre(nombreUsuarioActual);

            if (usuarioParaEliminar == null) {
                response.sendRedirect("dashboard.jsp?error=usuario_no_encontrado_eliminar");
                return;
            }

            boolean eliminado = usuarioDAO.eliminarUsuario(usuarioParaEliminar.getId());

            if (eliminado) {
                session.invalidate();
                response.sendRedirect("home.jsp?eliminado=exito"); 
            } else {
                response.sendRedirect("perfil.jsp?error=no_se_pudo_eliminar_usuario");
            }

        } catch (DAOException e) {
            System.err.println("Error de base de datos al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=error_db_eliminar_usuario");
        } catch (Exception e) {
            System.err.println("Error inesperado en EliminarUsuarioServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=inesperado_eliminar_usuario");
        }
    }
}