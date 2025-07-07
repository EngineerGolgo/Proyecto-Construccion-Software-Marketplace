package Control;

import Modelo.Producto;
import DAO.ProductoDAO;
import DAO.DAOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException; 

/**
 * Servlet para editar la información de un producto existente, incluyendo la subida de una nueva imagen.
 *
 * @author Jeremy Mero
 * @version 2.0.0
 * @since 2025-06-19
 */
@WebServlet("/EditarProductoServlet")
@MultipartConfig(fileSizeThreshold=1024*1024,
                 maxFileSize=1024*1024*5,
                 maxRequestSize=1024*1024*10)
public class EditarProductoServlet extends HttpServlet {

    /**
     * Procesa la solicitud POST para actualizar un producto.
     * Recoge los datos del formulario, maneja la subida de una nueva imagen (si se proporciona),
     * y actualiza el producto en la base de datos.
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

        int idProducto;
        try {
            idProducto = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=id_producto_invalido_editar");
            return;
        }

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        double precio;
        try {
            precio = Double.parseDouble(request.getParameter("precio"));
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=precio_invalido_editar");
            return;
        }

        String nuevaRutaImagen = null;

        try {
            Part imagenPart = request.getPart("imagen");
            if (imagenPart != null && imagenPart.getSize() > 0 && imagenPart.getSubmittedFileName() != null && !imagenPart.getSubmittedFileName().isEmpty()) {
                String nombreArchivoOriginal = imagenPart.getSubmittedFileName();
                String extension = "";
                int i = nombreArchivoOriginal.lastIndexOf('.');
                if (i > 0) {
                    extension = nombreArchivoOriginal.substring(i);
                }
                String nombreUnicoArchivo = System.currentTimeMillis() + "_" + (int)(Math.random() * 1000) + extension;

                String rutaGuardadoAbsoluta = getServletContext().getRealPath("") + File.separator + "imagenes";
                File directorio = new File(rutaGuardadoAbsoluta);
                if (!directorio.exists()) {
                    directorio.mkdirs();
                }

                imagenPart.write(rutaGuardadoAbsoluta + File.separator + nombreUnicoArchivo);
                nuevaRutaImagen = "imagenes" + File.separator + nombreUnicoArchivo;
            }
        } catch (IOException | ServletException e) {
            System.err.println("Error al procesar la subida de la imagen: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_subida_imagen_editar");
            return;
        } catch (Exception e) {
            System.err.println("Error inesperado al subir la imagen: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_inesperado_imagen");
            return;
        }

        Producto productoAActualizar = new Producto();
        productoAActualizar.setId(idProducto);
        productoAActualizar.setNombre(nombre);
        productoAActualizar.setDescripcion(descripcion);
        productoAActualizar.setCategoria(categoria);
        productoAActualizar.setPrecio(precio);
        productoAActualizar.setImagen(nuevaRutaImagen);

        ProductoDAO productoDAO = new ProductoDAO();
        try {
            boolean actualizado = productoDAO.actualizarProducto(productoAActualizar);

            if (actualizado) {
                response.sendRedirect("dashboard.jsp?editado=exito");
            } else {
                response.sendRedirect("dashboard.jsp?error=producto_no_encontrado_actualizar");
            }

        } catch (DAOException e) {
            System.err.println("Error de base de datos al actualizar producto: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=error_db_actualizar");
        } catch (Exception e) {
            System.err.println("Error inesperado en EditarProductoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=inesperado_editar");
        }
    }
}