package Control;

import Modelo.Usuario;    
import Modelo.Producto;     
import Modelo.Pedido;       
import Modelo.DetallePedido; 
import DAO.UsuarioDAO;      
import DAO.ProductoDAO;     
import DAO.PedidoDAO;       
import DAO.DAOException;    

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


/**
 * Servlet para finalizar el proceso de un pedido, creando un nuevo pedido
 * y sus detalles a partir de los productos en el carrito de la sesión.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-06-24
 */
@WebServlet("/FinalizarPedidoServlet")
public class FinalizarPedidoServlet extends HttpServlet {
    /**
     * Procesa la solicitud POST para completar un pedido.
     * Recupera los productos del carrito de la sesión, calcula el total,
     * guarda el pedido y sus detalles en la base de datos, y vacía el carrito.
     *
     * @param request El objeto HttpServletRequest.
     * @param response El objeto HttpServletResponse.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de E/S.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nombreUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nombreUsuario = (String) session.getAttribute("nombreUsuario");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        ProductoDAO productoDAO = new ProductoDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();

        try {
            Usuario usuario = usuarioDAO.obtenerPorNombre(nombreUsuario);
            if (usuario == null) {
                response.sendRedirect("dashboard.jsp?error=usuario_no_encontrado_pedido");
                return;
            }
            int usuarioId = usuario.getId();

            List<Integer> carritoIds = (List<Integer>) session.getAttribute("carrito");
            if (carritoIds == null || carritoIds.isEmpty()) {
                response.sendRedirect("dashboard.jsp?error=carrito_vacio");
                return;
            }

            double total = 0;
            List<Producto> productosDelCarrito = new ArrayList<>();

            for (int productoId : carritoIds) {
                Producto producto = productoDAO.obtenerPorId(productoId);
                if (producto != null) {
                    total += producto.getPrecio();
                    productosDelCarrito.add(producto); 
                } else {
                    System.err.println("Advertencia: Producto con ID " + productoId + " en el carrito no encontrado en la base de datos.");
                }
            }

            if (total <= 0 || productosDelCarrito.isEmpty()) {
                 response.sendRedirect("dashboard.jsp?error=carrito_invalido");
                 return;
            }

            Pedido nuevoPedido = new Pedido(usuarioId, total);
            int pedidoId = pedidoDAO.guardarPedido(nuevoPedido); 

            if (pedidoId != -1) {
                List<DetallePedido> detallesPedido = new ArrayList<>();
                for (Producto prod : productosDelCarrito) {
                    detallesPedido.add(new DetallePedido(pedidoId, prod.getId()));
                }
                
                pedidoDAO.guardarDetallesPedido(detallesPedido);

                session.removeAttribute("carrito");

                response.sendRedirect("dashboard.jsp?pedido=exito");
                return;

            } else {
                response.sendRedirect("dashboard.jsp?error=no_se_pudo_crear_pedido");
                return;
            }

        } catch (DAOException e) {
            System.err.println("Error de DB en FinalizarPedidoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_db_pedido");
        } catch (Exception e) {
            System.err.println("Error inesperado en FinalizarPedidoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=inesperado");
        }
    }
}
