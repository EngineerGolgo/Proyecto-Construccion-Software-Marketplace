# LocalMarket: Aplicación Web Marketplace

LocalMarket es una aplicación web tipo Marketplace diseñada para conectar vendedores independientes con compradores, facilitando la publicación, búsqueda y adquisición de productos de forma eficiente y segura. La plataforma busca ofrecer visibilidad a pequeños emprendimientos y proporcionar a los usuarios un espacio confiable para sus compras en línea.

## 🚀 Empezando

Estas instrucciones te guiarán para obtener una copia de nuestro proyecto en funcionamiento en tu máquina local para propósitos de desarrollo y prueba.

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

* **Java Development Kit (JDK) 17 o superior**
* **Apache Tomcat 9.x**
* **MySQL Server 8.x**
* **NetBeans IDE** (O cualquier otro IDE de tu preferencia, como IntelliJ IDEA o Eclipse)
* **MySQL Workbench** (O cualquier otro cliente de MySQL)

### Instalación

Sigue estos pasos para configurar el proyecto localmente:

1.  **Clona el repositorio:**

    ```bash
    git clone [https://github.com/EngineerGolgo/Proyecto](https://github.com/EngineerGolgo/Proyecto)
    cd LocalMarket
    ```
    *(Reemplaza `tu-usuario/LocalMarket.git` con la URL real de tu repositorio)*

2.  **Configura la base de datos MySQL:**
    * Crea una nueva base de datos llamada `localmarket_db` (o el nombre que prefieras).
    * Ejecuta el script SQL para crear las tablas y datos iniciales. Este script debería estar en `src/main/resources/database/schema.sql` o una ruta similar dentro del proyecto.

    ```sql
    -- Ejemplo de creación de base de datos y usuario (ajusta según tus necesidades)
    CREATE DATABASE IF NOT EXISTS localmarket_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER 'localmarket_user'@'localhost' IDENTIFIED BY 'your_password';
    GRANT ALL PRIVILEGES ON localmarket_db.* TO 'localmarket_user'@'localhost';
    FLUSH PRIVILEGES;
    USE localmarket_db;

    -- Aquí iría el contenido de tu archivo schema.sql para crear tablas
    -- Por ejemplo:
    -- CREATE TABLE usuarios (
    --     id INT AUTO_INCREMENT PRIMARY KEY,
    --     nombre VARCHAR(255),
    --     email VARCHAR(255) UNIQUE,
    --     password VARCHAR(255)
    -- );
    ```

3.  **Configura el servidor Apache Tomcat:**
    * Abre NetBeans IDE.
    * Importa el proyecto `LocalMarket` como un proyecto web existente.
    * Asegúrate de que Apache Tomcat 9.x esté configurado como el servidor en tu IDE.
    * Verifica la configuración de la conexión a la base de datos en el código Java (probablemente en un archivo `DBConnection.java` o similar) para que coincida con tus credenciales de MySQL.

    ```java
    // Ejemplo de configuración de conexión en Java (ajusta según tu código)
    private static final String URL = "jdbc:mysql://localhost:3306/localmarket_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "localmarket_user";
    private static final String PASSWORD = "your_password";
    ```

4.  **Despliega la aplicación:**
    * Desde NetBeans, limpia y construye el proyecto.
    * Despliega el archivo `.war` generado en tu instancia de Apache Tomcat. Normalmente, NetBeans puede hacer esto automáticamente al "Run" el proyecto.

5.  **Accede a la aplicación:**
    * Abre tu navegador web y navega a la URL de la aplicación (ej. `http://localhost:8080/LocalMarket`).

## 🗺️ Visión del Proyecto

Desarrollar una aplicación web tipo Marketplace que permita a pequeños vendedores ofrecer sus productos y ampliar su alcance de forma simple y segura. El objetivo es crear un espacio accesible donde la compra y venta sean procesos fáciles, cómodos y confiables, mediante una interfaz clara y herramientas como reseñas que fortalezcan la confianza entre usuarios.

## 🎯 Público Objetivo

LocalMarket está dirigido a dos segmentos principales en un contexto local: **vendedores independientes** (pequeños comerciantes, emprendedores locales) y **consumidores** (usuarios locales que buscan variedad y confianza en compras en línea).

## ✨ Características

### En Alcance

* Interfaz web receptiva e intuitiva.
* Navegación por categorías de productos y barra de búsqueda.
* Sistema de autenticación y gestión de usuarios (registro e inicio de sesión, visualización básica de perfil).
* Catálogo de productos con filtros dinámicos (imágenes, descripciones, precio).
* Carrito de compras funcional (añadir/eliminar productos, visualización del total).
* Publicación de productos por vendedores (formulario simple).
* Foro de reseñas (publicación por usuarios registrados, lectura pública).
* Principios de desarrollo seguro y tolerancia a fallos (validaciones en formularios, manejo de excepciones).
* Documentación del sistema (manual técnico, manual de usuario, documentación de diseño, comentarios en el código).

### Fuera de Alcance

* Gestión logística o integración con sistemas de pago reales (solo simulaciones).
* Soporte para múltiples idiomas (orientado a usuarios locales).
* Plataformas que no sean web (exclusivamente aplicación web).
* Funcionalidades avanzadas debido a limitaciones de recursos y cronograma.
* Encriptación avanzada de contraseñas (se implementará en versiones posteriores).

## 🏛️ Arquitectura del Sistema

La arquitectura del sistema se basa en un patrón clásico de tres capas:

* **Capa de Presentación**: Interfaz del sistema (HTML, CSS, JSP).
* **Capa de Lógica de Negocio**: Procesamiento de información y reglas de negocio (Servlets Java).
* **Capa de Datos**: Gestión de comunicación con la base de datos MySQL (JDBC).

Esta estructura promueve una clara separación de responsabilidades, facilitando el mantenimiento, permitiendo modificar la interfaz sin afectar la lógica interna y mejorando la escalabilidad y seguridad.

## 🛠️ Tecnologías Utilizadas

* **Lenguaje de Programación**: Java
* **Frameworks/Librerías**: Servlet API
* **Base de Datos**: MySQL
* **Servidor Web**: Apache Tomcat
* **Diseño UI**: HTML5, CSS

## 🗓️ Plan de Desarrollo (Scrum)

El proyecto se desarrolla bajo la metodología Scrum, facilitando la entrega iterativa e incremental.

### Roles

* **Product Owner**: Jeremy Mero Araujo
* **Scrum Máster**: Anthony Lopez Ochoa
* **Equipo de Desarrollo**: Anthony Lopez Ochoa, Jeremy Mero Araujo

### Eventos Scrum

* **Sprint Planning**: Definición de qué y cómo se hará el trabajo.
* **Daily Stand-up**: Reunión diaria (15 min) para coordinar y detectar bloqueos.
* **Sprint Review**: Presentación del trabajo realizado al final del sprint y retroalimentación.
* **Sprint Retrospective**: Reunión interna para la mejora continua del equipo.
* **Refinement**: Sesiones para detallar y preparar historias de usuario futuras.

### Artefactos Scrum

* **Product Backlog**: Lista priorizada de requisitos gestionada en Trello.
* **Sprint Backlog**: Subconjunto del Product Backlog para un sprint específico, gestionado en Trello.
* **Incremento**: Suma de funcionalidades completadas y probadas en un sprint, potencialmente entregable.

## ⏱️ Cronograma

| Sprint                              | Inicio       | Fin          | Duración  |
| :---------------------------------- | :----------- | :----------- | :-------- |
| Sprint 1: Diseño del sistema        | Jun 9, 2025  | Jun 14, 2025 | 6 días    |
| Sprint 2: Registro y funcionalidades básicas | Jun 15, 2025 | Jun 22, 2025 | 8 días    |
| Sprint 3: Funcionalidades avanzadas | Jun 23, 2025 | Jul 3, 2025  | 10 días   |
| Sprint 4: Documentación y entrega final | Jul 4, 2025  | Jul 8, 2025  | 5 días    |

## 🚨 Gestión de Riesgos

Se han identificado y planificado mitigaciones para riesgos clave, incluyendo:

* **SEG-001 (Inyecciones SQL)**: Implementar consultas preparadas con JDBC y validar entradas.
* **SEG-002 (Autenticación débil)**: Políticas de contraseñas seguras y bloqueo de cuentas.
* **PRY-003 (Cambios constantes en requisitos)**: Involucrar al cliente y realizar validaciones frecuentes.
* **TEC-002 (Rendimiento insuficiente)**: Pruebas de carga con JMeter y optimización de consultas SQL.

## 🚀 Despliegue y Mantenimiento

### Plan de Despliegue

El despliegue se realizará en un servidor local con Apache Tomcat 9 y MySQL 8.

* **Entorno**: Computadoras personales del equipo (Windows 10, 16GB RAM) con Tomcat 9, MySQL 8, Java, Servlets.
* **Proceso**: Empaquetado de WAR en NetBeans, configuración de Tomcat y MySQL, importación de esquema de BD, despliegue del WAR, pruebas funcionales y monitoreo de logs.
* **Fecha**: Programado para el 07/07/2025.

### Plan de Mantenimiento

Se asegurará la estabilidad con mantenimiento correctivo y preventivo.

* **Mantenimiento Correctivo**: Corrección de errores detectados en pruebas o ejecución.
* **Frecuencia**: Semanal (errores internos), Mensual (fallos menores).
* **Respaldo**: Semanal de BD (mysqldump), código fuente y documentación (copias locales).
* **Monitoreo**: Revisión de logs de Tomcat, consola de NetBeans y pruebas manuales diarias.

## 📄 Documentación

Se generará la siguiente documentación:

* **Manual Técnico**: Guía para desarrolladores y administradores (PDF con arquitectura, instalación, Javadoc).
* **Manual de Usuario**: Guía sencilla y visual para consumidores y vendedores (PDF de 1 página con capturas).
* **Herramientas**: Javadoc, Microsoft Word, Draw.io.

## 🧑‍💻 Equipo del Proyecto

| Rol           | Nombre           |
| :------------ | :--------------- |
| Product Owner | Jeremy Mero Araujo |
| Scrum Máster  | Anthony Lopez Ochoa |
| Desarrollador | Anthony Lopez Ochoa |
| Desarrollador | Jeremy Mero Araujo |
| Documentador  | Jeremy Mero Araujo, Anthony Lopez Ochoa |

## 💰 Presupuesto Estimado

| Concepto              | Total Estimado |
| :-------------------- | :------------- |
| Costos Operativos     | $128           |
| Ganancia              | $512           |
| **Costo Total del Equipo** | **$3,968** |
| **Total General** | **$4,608** | ## 📚 Glosario

Consulta el [Glosario](GLOSSARY.md) para conocer las definiciones de los términos técnicos utilizados en este proyecto. *(Opcional: puedes crear un archivo GLOSSARY.md aparte o dejar el glosario completo aquí)*

## 🔗 Fuentes Consultadas

* Narea, W. (2020, June 20). Encuesta revela que luego de la pandemia, los consumidores seguirán comprando por internet. *El Universo*.

---

¡Gracias por revisar nuestro proyecto LocalMarket! Si tienes alguna pregunta o sugerencia, no dudes en abrir un *issue*.
