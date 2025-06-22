package Control;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import Datos.ConexionDB;

@WebServlet("/FinalizarPedidoServlet")
public class FinalizarPedidoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nombreUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nombreUsuario = (String) session.getAttribute("nombreUsuario");

        try (Connection conn = ConexionDB.obtenerConexion()) {

            // Obtener ID del usuario
            PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM usuarios WHERE nombre = ?");
            userStmt.setString(1, nombreUsuario);
            ResultSet rsUser = userStmt.executeQuery();

            if (!rsUser.next()) {
                response.sendRedirect("dashboard.jsp?error=usuario");
                return;
            }
            int usuarioId = rsUser.getInt("id");

            List<Integer> carrito = (List<Integer>) session.getAttribute("carrito");
            if (carrito != null && !carrito.isEmpty()) {
                // 1. Calcular total del pedido
                double total = 0;
                PreparedStatement precioStmt = conn.prepareStatement("SELECT precio FROM productos1 WHERE id = ?");
                for (int productoId : carrito) {
                    precioStmt.setInt(1, productoId);
                    ResultSet rs = precioStmt.executeQuery();
                    if (rs.next()) {
                        total += rs.getDouble("precio");
                    }
                }

                // 2. Insertar pedido con total
                PreparedStatement pedidoStmt = conn.prepareStatement(
                    "INSERT INTO pedidos (usuario_id, fecha, total) VALUES (?, NOW(), ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
                pedidoStmt.setInt(1, usuarioId);
                pedidoStmt.setDouble(2, total);
                pedidoStmt.executeUpdate();

                ResultSet generatedKeys = pedidoStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int pedidoId = generatedKeys.getInt(1);

                    // 3. Insertar detalles del pedido
                    PreparedStatement detalleStmt = conn.prepareStatement(
                        "INSERT INTO detalle_pedido (pedido_id, producto_id) VALUES (?, ?)"
                    );

                    for (int productoId : carrito) {
                        detalleStmt.setInt(1, pedidoId);
                        detalleStmt.setInt(2, productoId);
                        detalleStmt.addBatch();
                    }
                    detalleStmt.executeBatch();

                    // 4. Limpiar carrito
                    session.removeAttribute("carrito");

                    response.sendRedirect("dashboard.jsp?pedido=exito");
                    return;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=pedido");
        }
    }
}
