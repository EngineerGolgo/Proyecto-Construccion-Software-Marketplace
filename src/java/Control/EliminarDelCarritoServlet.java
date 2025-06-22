package Control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/EliminarDelCarritoServlet")
public class EliminarDelCarritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<String> carrito = (List<String>) session.getAttribute("carrito");

        if (carrito != null) {
            try {
                int index = Integer.parseInt(request.getParameter("index"));
                if (index >= 0 && index < carrito.size()) {
                    carrito.remove(index);
                }
            } catch (NumberFormatException e) {
                System.out.println("Índice inválido para eliminar del carrito.");
            }
        }

        response.sendRedirect("dashboard.jsp");
    }
}