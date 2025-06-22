import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;
@WebServlet("/AgregarAlCarritoServlet")
public class AgregarAlCarritoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int productoId = Integer.parseInt(request.getParameter("productoId"));

        HttpSession session = request.getSession();
        List<Integer> carrito = (List<Integer>) session.getAttribute("carrito");

        if (carrito == null) {
            carrito = new java.util.ArrayList<>();
        }

        carrito.add(productoId);
        session.setAttribute("carrito", carrito);

        response.sendRedirect("dashboard.jsp");
    }
}