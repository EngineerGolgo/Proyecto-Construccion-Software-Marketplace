package Control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.*;
import java.sql.*;
import Marketplace.ConexionDB;

@MultipartConfig
public class EditarProductoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        double precio = Double.parseDouble(request.getParameter("precio"));
        String nuevaRutaImagen = null;

        Part imagenPart = request.getPart("imagen");
        if (imagenPart != null && imagenPart.getSize() > 0) {
            String nombreArchivo = imagenPart.getSubmittedFileName();
            String rutaGuardado = getServletContext().getRealPath("") + File.separator + "imagenes";
            File directorio = new File(rutaGuardado);
            if (!directorio.exists()) directorio.mkdir();

            imagenPart.write(rutaGuardado + File.separator + nombreArchivo);
            nuevaRutaImagen = "imagenes" + File.separator + nombreArchivo;
        }

        try (Connection conn = ConexionDB.obtenerConexion()) {
            String sql;
            if (nuevaRutaImagen != null) {
                sql = "UPDATE productos1 SET nombre = ?, descripcion = ?, categoria = ?, precio = ?, imagen = ? WHERE id = ?";
            } else {
                sql = "UPDATE productos1 SET nombre = ?, descripcion = ?, categoria = ?, precio = ? WHERE id = ?";
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nombre);
            stmt.setString(2, descripcion);
            stmt.setString(3, categoria);
            stmt.setDouble(4, precio);

            if (nuevaRutaImagen != null) {
                stmt.setString(5, nuevaRutaImagen);
                stmt.setInt(6, id);
            } else {
                stmt.setInt(5, id);
            }

            stmt.executeUpdate();
            response.sendRedirect("dashboard.jsp?editado=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=1");
        }
    }
}