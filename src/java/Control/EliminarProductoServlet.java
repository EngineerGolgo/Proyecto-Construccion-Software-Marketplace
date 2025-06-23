package Control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import Datos.ConexionDB;

public class EliminarProductoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = ConexionDB.obtenerConexion()) {

            // 1. Eliminar comentarios relacionados (si tienes tabla comentarios con FK a producto_id)
            PreparedStatement borrarComentarios = conn.prepareStatement("DELETE FROM comentarios WHERE producto_id = ?");
            borrarComentarios.setInt(1, id);
            borrarComentarios.executeUpdate();

            // 2. Eliminar detalle_pedido relacionados
            PreparedStatement borrarDetalles = conn.prepareStatement("DELETE FROM detalle_pedido WHERE producto_id = ?");
            borrarDetalles.setInt(1, id);
            borrarDetalles.executeUpdate();

            // 3. Eliminar el producto
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM productos1 WHERE id = ?");
            stmt.setInt(1, id);
            stmt.executeUpdate();

            response.sendRedirect("dashboard.jsp?eliminado=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=1");
        }
    }
}
