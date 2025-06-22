package Control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.sql.*;
import Marketplace.ConexionDB;

@WebServlet("/AgregarComentarioServlet")
public class AgregarComentarioServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        String nombreUsuario = (String) sesion.getAttribute("nombreUsuario");

        if (nombreUsuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int productoId = Integer.parseInt(request.getParameter("productoId"));
        String comentario = request.getParameter("comentario");
        int puntuacion = Integer.parseInt(request.getParameter("puntuacion"));

        try (Connection conn = ConexionDB.obtenerConexion()) {
            PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM usuarios WHERE nombre = ?");
            userStmt.setString(1, nombreUsuario);
            ResultSet rsUser = userStmt.executeQuery();

            if (rsUser.next()) {
                int usuarioId = rsUser.getInt("id");

                PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO comentarios (producto_id, usuario_id, comentario, puntuacion, fecha) VALUES (?, ?, ?, ?, NOW())"
                );
                stmt.setInt(1, productoId);
                stmt.setInt(2, usuarioId);
                stmt.setString(3, comentario);
                stmt.setInt(4, puntuacion);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("verProducto.jsp?id=" + productoId);
    }
}