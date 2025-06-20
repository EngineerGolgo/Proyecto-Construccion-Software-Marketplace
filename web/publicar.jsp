<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("nombreUsuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Publicar Producto</title>
    <link rel="stylesheet" href="css/estilos.css">
    <style>
        body {
            background: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }

        .form-wrapper {
            max-width: 600px;
            margin: 60px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .form-wrapper h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group input[type="file"] {
            padding: 6px;
        }

        .form-group input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            font-size: 16px;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .form-group input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .volver {
            display: block;
            margin-top: 20px;
            text-align: center;
        }

        .volver a {
            text-decoration: none;
            color: #007bff;
        }

        .volver a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="form-wrapper">
        <h2>Publicar Producto</h2>
        <form action="PublicarProductoServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="nombre">Nombre del producto</label>
                <input type="text" name="nombre" id="nombre" required>
            </div>

            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea name="descripcion" id="descripcion" required></textarea>
            </div>

            <div class="form-group">
                <label for="categoria">Categoría</label>
                <select name="categoria" id="categoria">
                    <option value="Tecnología">Tecnología</option>
                    <option value="Hogar">Hogar</option>
                    <option value="Moda">Moda</option>
                    <option value="Otros">Otros</option>
                </select>
            </div>

            <div class="form-group">
                <label for="precio">Precio ($)</label>
                <input type="number" step="0.01" name="precio" id="precio" required>
            </div>

            <div class="form-group">
                <label for="imagen">Imagen del producto</label>
                <input type="file" name="imagen" id="imagen" accept="image/*" required>
            </div>

            <div class="form-group">
                <input type="submit" value="Publicar Producto">
            </div>
        </form>

        <div class="volver">
            <a href="dashboard.jsp">&larr; Volver al inicio</a>
        </div>
    </div>

</body>
</html>
