package Control;

import Datos.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/verCarrito")
public class VerCarritoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Integer> carrito = (List<Integer>) session.getAttribute("carrito");
        if (carrito == null) carrito = new ArrayList<>();

        List<Map<String, Object>> productos = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion()) {
            for (Integer id : carrito) {
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM productos1 WHERE id = ?");
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    Map<String, Object> prod = new HashMap<>();
                    prod.put("nombre", rs.getString("nombre"));
                    prod.put("precio", rs.getDouble("precio"));
                    prod.put("imagen", rs.getString("imagen"));
                    productos.add(prod);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("productosCarrito", productos);
        request.getRequestDispatcher("carritoPanel.jsp").forward(request, response);
    }
}