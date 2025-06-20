import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/AgregarAlCarritoServlet")
public class AgregarAlCarritoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String producto = request.getParameter("producto");
        HttpSession session = request.getSession();

        List<String> carrito = (List<String>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }
        carrito.add(producto);
        session.setAttribute("carrito", carrito);

        response.sendRedirect("dashboard.jsp");
    }
}