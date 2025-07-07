package Control;

import Modelo.Producto;    
import DAO.ProductoDAO;    
import DAO.DAOException;   

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet para visualizar los productos actualmente en el carrito de compras de la sesión.
 * Obtiene los IDs de los productos del carrito y recupera sus detalles completos de la base de datos.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-07-27
 */
@WebServlet("/verCarrito")
public class VerCarritoServlet extends HttpServlet {
    /**
     * Procesa la solicitud GET para mostrar el contenido del carrito.
     * Recupera la lista de IDs de productos del carrito de la sesión, busca los detalles
     * de cada producto en la base de datos y los envía a la página JSP para su visualización.
     *
     * @param request El objeto HttpServletRequest.
     * @param response El objeto HttpServletResponse.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de E/S.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Integer> carritoIds = (List<Integer>) session.getAttribute("carrito");
        if (carritoIds == null) {
            carritoIds = new ArrayList<>(); 
        }

        List<Producto> productosEnCarrito = new ArrayList<>();
        ProductoDAO productoDAO = new ProductoDAO(); 

        try {
            for (Integer id : carritoIds) {
                Producto producto = productoDAO.obtenerPorId(id);
                if (producto != null) {
                    productosEnCarrito.add(producto);
                }
            }
        } catch (DAOException e) {
            System.err.println("Error al cargar productos del carrito desde el DAO: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorCarrito", "Error al cargar los detalles de los productos en el carrito.");
        }

        request.setAttribute("productosCarrito", productosEnCarrito);

        request.getRequestDispatcher("carritoPanel.jsp").forward(request, response);
    }
}
