<%-- 
    Document   : home
    Created on : 19 jun 2025, 6:43:10 p. m.
    Author     : User
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login y Registro</title>
    <link rel="stylesheet" href="css/styles.css">

    <!-- Ionicons para íconos -->
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

    <!-- Script para toggle -->
    <script src="js/script.js" defer></script>
</head>
<body>
    <div class="container">

        <!-- Formulario de Inicio de Sesión -->
        <div class="container-form">
            <form class="sign-in" action="/MarketplaceServicios/LoginServlet" method="post">
                <h2>Iniciar Sesión</h2>
                <div class="social-network">
                    <ion-icon name="logo-facebook"></ion-icon>
                    <ion-icon name="logo-instagram"></ion-icon>
                </div>
                <span>Use su correo y contraseña</span>
                <div class="container-input">
                    <ion-icon name="mail-outline"></ion-icon>
                    <input type="text" name="correo" placeholder="Correo Electrónico" required>
                </div>
                <div class="container-input">
                    <ion-icon name="lock-closed-outline"></ion-icon>
                    <input type="password" name="contrasena" placeholder="Contraseña" required>
                </div>
                <a href="#">¿Olvidaste tu contraseña?</a>
                <button class="buttom" type="submit">Iniciar Sesión</button>
            </form>
        </div>

        <!-- Formulario de Registro -->
        <div class="container-form">
            <form class="sign-up" action="/MarketplaceServicios/RegistroServlet" method="post">
                <h2>Registrarse</h2>
                <div class="social-network">
                    <ion-icon name="logo-facebook"></ion-icon>
                    <ion-icon name="logo-instagram"></ion-icon>
                </div>
                <span>Use su correo electrónico para registrarse</span>
                <div class="container-input">
                    <ion-icon name="person-outline"></ion-icon>
                    <input type="text" name="nombre" placeholder="Nombre completo" required>
                </div>
                <div class="container-input">
                    <ion-icon name="mail-outline"></ion-icon>
                    <input type="email" name="correo" placeholder="Correo Electrónico" required>
                </div>
                <div class="container-input">
                    <ion-icon name="lock-closed-outline"></ion-icon>
                    <input type="password" name="contrasena" placeholder="Contraseña" required>
                </div>
                <button class="buttom" type="submit">Registrarse</button>
            </form>
        </div>

        <!-- Panel de Bienvenida -->
        <div class="container-welcome">
            <div class="welcome-sign-up welcome">
                <h3>¡Bienvenido!</h3>
                <p>Ingrese sus datos personales para usar todas las funciones de este sitio</p>
                <button class="buttom" id="btn-sign-up">Registrarse</button>
            </div>
            <div class="welcome-sign-in welcome">
                <h3>Hola!</h3>
                <p>¿Ya tienes una cuenta? Inicia sesión con tus datos</p>
                <button class="buttom" id="btn-sign-in">Iniciar Sesión</button>
            </div>
        </div>
    </div>
</body>
</html>
