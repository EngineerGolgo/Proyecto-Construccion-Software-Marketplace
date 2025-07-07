package Control;

import Datos.ConexionDB; 
import Modelo.Producto;  
import Modelo.Usuario;   
import DAO.ProductoDAO;  
import DAO.UsuarioDAO;   
import DAO.DAOException; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException; 


/**
 * Servlet para permitir a los usuarios publicar nuevos productos.
 * Maneja la subida de imágenes y el almacenamiento de los datos del producto en la base de datos.
 *
 * @author Anthony Lopez
 * @version 2.0.0
 * @since 2025-06-20
 */
@WebServlet("/PublicarProductoServlet")
@MultipartConfig(fileSizeThreshold=1024*1024,   
                 maxFileSize=1024*1024*5,       
                 maxRequestSize=1024*1024*10)   
public class PublicarProductoServlet extends HttpServlet {

    /**
     * Procesa la solicitud POST para publicar un nuevo producto.
     * Recoge los datos del formulario, guarda la imagen en el servidor
     * y persiste la información del producto en la base de datos.
     *
     * @param request El objeto HttpServletRequest.
     * @param response El objeto HttpServletResponse.
     * @throws ServletException Si ocurre un error específico del servlet.
     * @throws IOException Si ocurre un error de E/S.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); 

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        double precio;
        try {
            precio = Double.parseDouble(request.getParameter("precio"));
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=precio_invalido");
            return;
        }

        String rutaImagen = null;
        try {
            Part imagenPart = request.getPart("imagen"); 
            if (imagenPart != null && imagenPart.getSize() > 0) {
                String nombreArchivo = imagenPart.getSubmittedFileName();
                String extension = "";
                int i = nombreArchivo.lastIndexOf('.');
                if (i > 0) {
                    extension = nombreArchivo.substring(i);
                }
                String nombreUnicoArchivo = System.currentTimeMillis() + "_" + Math.random() * 1000 + extension;

                String rutaGuardadoAbsoluta = getServletContext().getRealPath("") + File.separator + "imagenes";
                File directorio = new File(rutaGuardadoAbsoluta);
                if (!directorio.exists()) {
                    directorio.mkdirs(); 
                }

                imagenPart.write(rutaGuardadoAbsoluta + File.separator + nombreUnicoArchivo);
                rutaImagen = "imagenes" + File.separator + nombreUnicoArchivo; 
            }
        } catch (Exception e) {
            System.err.println("Error al subir la imagen: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_subida_imagen");
            return;
        }

        HttpSession session = request.getSession();
        String usuarioNombre = (String) session.getAttribute("nombreUsuario");
        int usuarioId = -1; 
        
        UsuarioDAO usuarioDAO = new UsuarioDAO(); 
        try {
            Usuario usuario = usuarioDAO.obtenerPorNombre(usuarioNombre);
            if (usuario != null) {
                usuarioId = usuario.getId();
            } else {
                response.sendRedirect("dashboard.jsp?error=usuario_no_encontrado_publicar");
                return;
            }
        } catch (DAOException e) {
            System.err.println("Error al obtener ID de usuario para publicación: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_db_usuario");
            return;
        }

        if (usuarioId != -1 && rutaImagen != null) {
            Producto nuevoProducto = new Producto(nombre, descripcion, categoria, precio, rutaImagen, usuarioId);
            ProductoDAO productoDAO = new ProductoDAO(); 

            try {
                boolean guardado = productoDAO.guardarProducto(nuevoProducto);

                if (guardado) {
                    response.sendRedirect("dashboard.jsp?publicado=exito");
                } else {
                    response.sendRedirect("dashboard.jsp?error=no_se_pudo_publicar");
                }
            } catch (DAOException e) {
                System.err.println("Error al guardar el producto en la DB: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("dashboard.jsp?error=error_db_publicar");
            } catch (Exception e) {
                System.err.println("Error inesperado en PublicarProductoServlet: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("dashboard.jsp?error=inesperado");
            }
        } else {
            response.sendRedirect("dashboard.jsp?error=datos_faltantes_o_imagen");
        }
    }
}
