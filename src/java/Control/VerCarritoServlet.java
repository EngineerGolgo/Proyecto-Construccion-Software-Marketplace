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

@WebServlet("/verCarrito")
public class VerCarritoServlet extends HttpServlet {
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
