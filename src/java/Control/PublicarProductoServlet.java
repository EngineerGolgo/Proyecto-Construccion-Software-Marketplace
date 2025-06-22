package Control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.*;
import java.sql.*;
import Datos.ConexionDB;

@MultipartConfig(fileSizeThreshold=1024*1024, 
                 maxFileSize=1024*1024*5,     
                 maxRequestSize=1024*1024*10) 
public class PublicarProductoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        double precio = Double.parseDouble(request.getParameter("precio"));

        Part imagenPart = request.getPart("imagen");
        String nombreArchivo = imagenPart.getSubmittedFileName();

        String rutaGuardado = getServletContext().getRealPath("") + File.separator + "imagenes";
        File directorio = new File(rutaGuardado);
        if (!directorio.exists()) {
            directorio.mkdir();
        }

        String rutaImagen = "imagenes" + File.separator + nombreArchivo;
        imagenPart.write(rutaGuardado + File.separator + nombreArchivo);

        HttpSession session = request.getSession();
        String usuarioNombre = (String) session.getAttribute("nombreUsuario");

        try (Connection conn = ConexionDB.obtenerConexion()) {
            PreparedStatement buscarId = conn.prepareStatement("SELECT id FROM usuarios WHERE nombre = ?");
            buscarId.setString(1, usuarioNombre);
            ResultSet rs = buscarId.executeQuery();

            if (rs.next()) {
                int usuarioId = rs.getInt("id");

                String sql = "INSERT INTO productos1 (nombre, descripcion, categoria, precio, imagen, usuario_id) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nombre);
                stmt.setString(2, descripcion);
                stmt.setString(3, categoria);
                stmt.setDouble(4, precio);
                stmt.setString(5, rutaImagen);
                stmt.setInt(6, usuarioId);
                stmt.executeUpdate();

                response.sendRedirect("dashboard.jsp?publicado=1");
            } else {
                response.sendRedirect("dashboard.jsp?error=usuario_no_encontrado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=1");
        }
    }
}