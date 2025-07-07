package Control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List; 


/**
 * Servlet para eliminar un producto del carrito de compras basado en su índice.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-06-27
 */
@WebServlet("/EliminarDelCarritoServlet")
public class EliminarDelCarritoServlet extends HttpServlet {

    
    /**
     * Procesa la solicitud POST para eliminar un producto del carrito.
     * Valida la sesión del usuario y el índice del producto a eliminar de la lista del carrito almacenada en la sesión.
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

        List<Integer> carritoIds = (List<Integer>) session.getAttribute("carrito");

        if (carritoIds != null) {
            try {
                int indexToRemove = Integer.parseInt(request.getParameter("index"));
                
                if (indexToRemove >= 0 && indexToRemove < carritoIds.size()) {
                    carritoIds.remove(indexToRemove); 
                } else {
                    System.out.println("Advertencia: Índice inválido (" + indexToRemove + ") para eliminar del carrito.");

                }
            } catch (NumberFormatException e) {
                System.err.println("Error: 'index' no es un número válido en EliminarDelCarritoServlet. " + e.getMessage());
                e.printStackTrace();
            } catch (Exception e) {
                System.err.println("Error inesperado en EliminarDelCarritoServlet: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("dashboard.jsp");
    }
}