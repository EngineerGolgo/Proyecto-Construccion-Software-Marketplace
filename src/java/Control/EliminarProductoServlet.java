package Control;

import DAO.ProductoDAO;     
import DAO.ComentarioDAO;  
import DAO.PedidoDAO;       
import DAO.DAOException;    

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


/**
 * Servlet para eliminar un producto del sistema.
 * Este servlet maneja la eliminación de un producto junto con sus comentarios asociados
 * y los detalles de pedidos que lo referencian, manteniendo la integridad referencial.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-06-22
 */
@WebServlet("/EliminarProductoServlet")
public class EliminarProductoServlet extends HttpServlet {
    
     /**
     * Procesa la solicitud GET para eliminar un producto.
     * Elimina los comentarios y detalles de pedidos asociados al producto antes de eliminar el producto en sí,
     * para mantener la integridad de la base de datos.
     *
     * @param request El objeto HttpServletRequest que contiene la solicitud del cliente.
     * @param response El objeto HttpServletResponse que contiene la respuesta que el servlet envía al cliente.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de entrada o salida al procesar la solicitud.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idProducto;
        try {
            idProducto = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=id_producto_invalido");
            return;
        }

        ComentarioDAO comentarioDAO = new ComentarioDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();
        ProductoDAO productoDAO = new ProductoDAO();

        try {
            comentarioDAO.eliminarComentariosPorProductoId(idProducto);

            pedidoDAO.eliminarDetallesPorProductoId(idProducto);

            boolean eliminado = productoDAO.eliminarProducto(idProducto);

            if (eliminado) {
                response.sendRedirect("dashboard.jsp?eliminado=exito");
            } else {
                response.sendRedirect("dashboard.jsp?error=producto_no_encontrado_eliminar");
            }

        } catch (DAOException e) {
            System.err.println("Error de DB al eliminar producto: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_db_eliminar");
        } catch (Exception e) {
            System.err.println("Error inesperado en EliminarProductoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=inesperado_eliminar");
        }
    }
}
