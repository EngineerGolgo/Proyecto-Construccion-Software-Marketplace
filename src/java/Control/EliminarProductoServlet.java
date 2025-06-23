package Control;

import DAO.ProductoDAO;     
import DAO.ComentarioDAO;  
import DAO.PedidoDAO;       
import DAO.DAOException;    

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EliminarProductoServlet")
public class EliminarProductoServlet extends HttpServlet {
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
