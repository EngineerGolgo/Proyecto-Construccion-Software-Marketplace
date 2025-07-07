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
    git clone [https://github.com/EngineerGolgo/Proyecto](https://github.com/EngineerGolgo/Proyecto-Construccion-Software-Marketplace)
    cd LocalMarket
    ```

2.  **Configura la base de datos MySQL:**
    * Crea una nueva base de datos llamada `marketplace` (este es el nombre utilizado en el script SQL).
    * Ejecuta el script SQL `marketplace.sql` (ubicado en la raíz de tu repositorio o en una carpeta `database/` si la creaste) para crear las tablas y datos iniciales.

    ```sql
    -- Ejemplo de creación de base de datos y usuario (ajusta según tus necesidades)
    CREATE DATABASE IF NOT EXISTS marketplace CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER 'tu_usuario_db'@'localhost' IDENTIFIED BY 'tu_contraseña_db';
    GRANT ALL PRIVILEGES ON marketplace.* TO 'tu_usuario_db'@'localhost';
    FLUSH PRIVILEGES;
    USE marketplace;

    -- Aquí deberías ejecutar el contenido de tu archivo marketplace.sql
    -- Por ejemplo, importándolo directamente con MySQL Workbench o la línea de comandos.
    ```

3.  **Configura el servidor Apache Tomcat:**
    * Abre NetBeans IDE.
    * Importa el proyecto `LocalMarket` como un proyecto web existente.
    * Asegúrate de que Apache Tomcat 9.x esté configurado como el servidor en tu IDE.
    * Verifica la configuración de la conexión a la base de datos en el código Java (probablemente en `Datos/ConexionDB.java`) para que coincida con tus credenciales de MySQL.

    ```java
    // Ejemplo de configuración de conexión en Java (ajusta según tu código)
    // En Datos/ConexionDB.java o similar
    private static final String URL = "jdbc:mysql://localhost:3306/marketplace?useSSL=false&serverTimezone=UTC";
    private static final String USER = "tu_usuario_db";
    private static final String PASSWORD = "tu_contraseña_db";
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
* Sistema de autenticación y gestión de usuarios (registro e inicio de sesión, visualización básica de perfil, edición de perfil y eliminación de cuenta).
* Catálogo de productos con filtros dinámicos (imágenes, descripciones, precio).
* Carrito de compras funcional (añadir/eliminar productos, visualización del total).
* Publicación de productos por vendedores (formulario simple, edición y eliminación).
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

La arquitectura del sistema se basa en un patrón clásico de tres capas, que ha sido refactorizado a un patrón **Modelo-Vista-Controlador (MVC)** para una mejor separación de responsabilidades:

* **Capa de Presentación (Vista)**: Interfaz del sistema (HTML, CSS, JSP). Responsable de mostrar la información al usuario.
* **Capa de Lógica de Negocio (Controlador)**: Procesamiento de información y reglas de negocio (Servlets Java). Actúa como intermediario entre la Vista y el Modelo, recibiendo las peticiones del usuario y delegando las operaciones.
* **Capa de Datos (Modelo)**: Gestión de comunicación con la base de datos MySQL (JDBC, con implementación de DAOs - Data Access Objects). Contiene las clases de entidad (POJOs) que representan los datos y las clases DAO que interactúan directamente con la base de datos.

### 🗄️ Base de Datos

La aplicación utiliza una base de datos relacional (`marketplace`) para almacenar y gestionar toda la información de usuarios, productos, pedidos y comentarios. El diseño sigue un esquema que permite modelar las relaciones clave de un sistema de marketplace.

#### 📊 Esquema de la Base de Datos

A continuación, se detalla la estructura de las tablas principales y sus relaciones:

#### 1. `usuarios`
Representa a los usuarios registrados en el sistema. Un usuario puede actuar tanto como vendedor (publicando productos) como comprador (realizando pedidos).

| Columna | Tipo | Descripción |
| :---- | :---- | :---------- |
| `id` | `INT` | Clave primaria, auto-incrementable. |
| `nombre` | `VARCHAR(100)` | Nombre de usuario. |
| `correo` | `VARCHAR(100)` | Correo electrónico (único). |
| `contraseña` | `VARCHAR(100)` | Contraseña del usuario (se recomienda hashing para producción). |

#### 2. `productos1`
Almacena la información de los productos disponibles en el marketplace, publicados por los usuarios.

| Columna | Tipo | Descripción |
| :---- | :---- | :---------- |
| `id` | `INT` | Clave primaria, auto-incrementable. |
| `nombre` | `VARCHAR(100)` | Nombre del producto. |
| `descripcion` | `TEXT` | Descripción detallada del producto. |
| `categoria` | `VARCHAR(50)` | Categoría a la que pertenece el producto. |
| `precio` | `DECIMAL(10,2)` | Precio del producto. |
| `imagen` | `VARCHAR(255)` | Ruta de la imagen del producto en el servidor. |
| `usuario_id` | `INT` | **Clave foránea** a `usuarios.id`. Indica qué usuario publicó el producto. |

#### 3. `comentarios`
Guarda los comentarios y puntuaciones que los usuarios hacen sobre los productos.

| Columna | Tipo | Descripción |
| :---- | :---- | :---------- |
| `id` | `INT` | Clave primaria, auto-incrementable. |
| `producto_id` | `INT` | **Clave foránea** a `productos1.id`. Producto al que pertenece el comentario. |
| `usuario_id` | `INT` | **Clave foránea** a `usuarios.id`. Usuario que realizó el comentario. |
| `comentario` | `TEXT` | Contenido del comentario. |
| `puntuacion` | `INT` | Puntuación numérica (ej., 1-5 estrellas). |
| `fecha` | `TIMESTAMP` | Fecha y hora del comentario (con `DEFAULT CURRENT_TIMESTAMP`). |

#### 4. `pedidos`
Registra los pedidos realizados por los usuarios compradores.

| Columna | Tipo | Descripción |
| :---- | :---- | :---------- |
| `id` | `INT` | Clave primaria, auto-incrementable. |
| `usuario_id` | `INT` | **Clave foránea** a `usuarios.id`. Usuario que realizó el pedido. |
| `fecha` | `DATETIME` | Fecha y hora de creación del pedido. |
| `total` | `DECIMAL(10,2)` | Precio total del pedido. |

#### 5. `detalle_pedido`
Esta es una tabla de unión que resuelve la relación de "Muchos a Muchos" entre `pedidos` y `productos1`. Cada fila representa un producto específico incluido en un pedido.

| Columna | Tipo | Descripción |
| :---- | :---- | :---------- |
| `id` | `INT` | Clave primaria, auto-incrementable (o clave compuesta `(pedido_id, producto_id)`). |
| `pedido_id` | `INT` | **Clave foránea** a `pedidos.id`. Pedido al que pertenece el detalle. |
| `producto_id` | `INT` | **Clave foránea** a `productos1.id`. Producto incluido en el pedido. |

#### 🔑 Relaciones Clave

* **`usuarios` ➡️ `productos1`**: Un usuario puede publicar muchos productos (relación 1:N a través de `productos1.usuario_id`).

* **`usuarios` ➡️ `pedidos`**: Un usuario puede realizar muchos pedidos (relación 1:N a través de `pedidos.usuario_id`).

* **`productos1` ⬅️ `comentarios`**: Un producto puede tener muchos comentarios (relación N:1 a través de `comentarios.producto_id`).

* **`usuarios` ⬅️ `comentarios`**: Un usuario puede realizar muchos comentarios (relación N:1 a través de `comentarios.usuario_id`).

* **`pedidos` ↔️ `productos1` (vía `detalle_pedido`)**: Una relación de Muchos a Muchos. Un pedido puede contener múltiples productos, y un producto puede estar en múltiples pedidos. `detalle_pedido` vincula estas dos entidades.

Este esquema de base de datos soporta las funcionalidades principales de un marketplace, permitiendo el registro de usuarios, la publicación y búsqueda de productos, la gestión de carritos y la finalización de pedidos, así como la interacción mediante comentarios.

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

| Sprint | Inicio | Fin | Duración |
| :---------------------------------- | :----------- | :----------- | :-------- |
| Sprint 1: Diseño del sistema | Jun 9, 2025 | Jun 14, 2025 | 6 días |
| Sprint 2: Registro y funcionalidades básicas | Jun 15, 2025 | Jun 22, 2025 | 8 días |
| Sprint 3: Funcionalidades avanzadas | Jun 23, 2025 | Jul 3, 2025 | 10 días |
| Sprint 4: Documentación y entrega final | Jul 4, 2025 | Jul 8, 2025 | 5 días |

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

| Rol | Nombre |
| :---------- | :--------------- |
| Product Owner | Jeremy Mero Araujo |
| Scrum Máster | Anthony Lopez Ochoa |
| Desarrollador | Anthony Lopez Ochoa |
| Desarrollador | Jeremy Mero Araujo |
| Documentador | Jeremy Mero Araujo, Anthony Lopez Ochoa |

## 💰 Presupuesto Estimado

| Concepto | Total Estimado |
| :-------------------- | :------------- |
| Costos Operativos | $128 |
| Ganancia | $512 |
| **Costo Total del Equipo** | **$3,968** |
| **Total General** | **$4,608** |


## 🔗 Fuentes Consultadas

* Narea, W. (2020, June 20). Encuesta revela que luego de la pandemia, los consumidores seguirán comprando por internet. *El Universo*.
