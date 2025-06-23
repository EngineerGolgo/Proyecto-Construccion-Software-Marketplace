package Control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AgregarAlCarritoServlet")
public class AgregarAlCarritoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(); 

        int productoId;
        try {
            productoId = Integer.parseInt(request.getParameter("productoId"));
        } catch (NumberFormatException e) {
            System.err.println("Error: ID de producto inválido en AgregarAlCarritoServlet. " + e.getMessage());
            response.sendRedirect("dashboard.jsp?error=id_producto_invalido_agregar");
            return; 
        }

        List<Integer> carrito = (List<Integer>) session.getAttribute("carrito");

        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito); 
        }

        carrito.add(productoId);
        

        response.sendRedirect("dashboard.jsp?agregado=exito");
    }
}
