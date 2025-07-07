package Control;

import Modelo.Comentario;
import Modelo.Usuario;
import DAO.ComentarioDAO;
import DAO.UsuarioDAO;
import DAO.DAOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet para permitir a los usuarios logueados añadir comentarios y puntuaciones a productos.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-07-03
 */
@WebServlet("/AgregarComentarioServlet")
public class AgregarComentarioServlet extends HttpServlet {

    /**
     * Procesa la solicitud POST para agregar un comentario.
     * Valida la sesión, obtiene datos del comentario y usuario,
     * y persiste el comentario en la base de datos.
     *
     * @param request El objeto HttpServletRequest.
     * @param response El objeto HttpServletResponse.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de E/S.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("nombreUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

        int productoId;
        int puntuacion;
        try {
            productoId = Integer.parseInt(request.getParameter("productoId"));
            puntuacion = Integer.parseInt(request.getParameter("puntuacion"));
        } catch (NumberFormatException e) {
            System.err.println("Error: ID de producto o puntuación inválidos en AgregarComentarioServlet. " + e.getMessage());
            response.sendRedirect("verProducto.jsp?id=" + request.getParameter("productoId") + "&error=datos_invalidos");
            return;
        }

        String comentarioTexto = request.getParameter("comentario");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        ComentarioDAO comentarioDAO = new ComentarioDAO();

        try {
            Usuario usuario = usuarioDAO.obtenerPorNombre(nombreUsuario);
            if (usuario == null) {
                response.sendRedirect("login.jsp?error=usuario_no_encontrado_comentario");
                return;
            }
            int usuarioId = usuario.getId();

            Comentario nuevoComentario = new Comentario(productoId, usuarioId, comentarioTexto, puntuacion);

            boolean agregado = comentarioDAO.agregarComentario(nuevoComentario);

            if (agregado) {
                response.sendRedirect("verProducto.jsp?id=" + productoId + "&comentario=exito");
            } else {
                response.sendRedirect("verProducto.jsp?id=" + productoId + "&error=no_se_pudo_agregar_comentario");
            }

        } catch (DAOException e) {
            System.err.println("Error de base de datos en AgregarComentarioServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("verProducto.jsp?id=" + productoId + "&error=error_db_comentario");
        } catch (Exception e) {
            System.err.println("Error inesperado en AgregarComentarioServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("verProducto.jsp?id=" + productoId + "&error=inesperado_comentario");
        }
    }
}