# Cuidado Infantil - Aplicación Móvil

Aplicación móvil desarrollada en Flutter para la gestión y monitoreo de centros de cuidado infantil. Permite a los educadores y administradores gestionar información de los infantes, monitorear su desarrollo, salud y asistencia, así como reportar incidencias.

## 🛠 Stack Tecnológico

-   **Framework:** [Flutter](https://flutter.dev/)
-   **Lenguaje:** [Dart](https://dart.dev/)
-   **Gestión de Estado:** [GetX](https://pub.dev/packages/get)
-   **Arquitectura:** Clean Architecture (Capas de Presentación, Dominio y Datos)
-   **Patrón de Diseño:** Repository Pattern para la abstracción de datos.
-   **Diseño UI:** Material Design 3 con soporte completo para Tema Oscuro y Claro.

## ✨ Funcionalidades Principales

### 🔐 Autenticación y Seguridad
-   Inicio de sesión seguro.
-   Recuperación de contraseña.
-   Gestión de sesiones y tokens (JWT).
-   Configuración de servidor backend dinámico.

### 👶 Gestión de Infantes (Child Management)
-   **Expediente Digital:** Registro completo de infantes con datos personales, médicos, sociales y familiares.
-   **Documentación:** Carga y visualización de documentos (Acta de nacimiento, Cartilla de vacunación, etc.).
-   **Listado y Filtrado:** Búsqueda avanzada de infantes por nombre o CURP.
-   **Edición:** Actualización de información en tiempo real.

### 📊 Monitoreo (Monitoring)
Módulo integral para el seguimiento del bienestar del infante:

-   **Nutrición:**
    -   Registro de evaluaciones nutricionales (Peso, Talla, IMC).
    -   Historial de evaluaciones.
    -   Gráficos y estado nutricional.

-   **Desarrollo Infantil:**
    -   Evaluaciones de desarrollo por áreas (Motor, Cognitivo, Lenguaje, Socioemocional).
    -   Cálculo de puntajes y determinación de estado de desarrollo.
    -   Visualización de resultados detallados.

-   **Vacunación:**
    -   Seguimiento del esquema de vacunación.
    -   Registro de dosis aplicadas.
    -   Visualización de progreso por vacuna.

-   **Asistencia:**
    -   Registro diario de asistencia (Entrada/Salida).
    -   Reportes de asistencia por sala o grupo.
    -   Justificación de inasistencias.

### 🚨 Gestión de Incidencias
-   Creación de reportes de incidencias ocurridas en el centro.
-   Clasificación por severidad (Baja, Media, Alta).
-   Adjunto de evidencias (fotos/documentos).
-   Seguimiento de estatus de reportes.

### ⚙️ Configuración y Perfil
-   Perfil del educador.
-   Selección de Centro de Atención Infantil (CAI).
-   Cambio de contraseña.
-   Configuración de tema (Soporte para Modo Oscuro/Claro).

## 🔧 Mejoras Técnicas y Mantenimiento (Refactoring & Clean Code)

Se ha realizado un proceso exhaustivo de limpieza y refactorización del código fuente para asegurar su mantenibilidad, seguridad y escalabilidad:

-   **Clean Code & Refactoring:**
    -   Eliminación total de sentencias de depuración (`print`) y código comentado en el directorio `lib`.
    -   Extracción de lógica de negocio y parseo de datos en funciones auxiliares (`Helpers`) en los módulos de *Monitoring*, *Incident* y *Child*, reduciendo la duplicidad de código.
    -   Centralización de la paleta de colores en `AppColors` y constantes de estilo.
-   **Seguridad:**
    -   Limpieza de validaciones SSL inseguras en `ApiService`, estandarizando el uso de conexiones seguras HTTPS predeterminadas del sistema.
-   **UI/UX & Internacionalización:**
    -   Implementación completa de **Tema Oscuro** y soporte para tema del sistema (`ThemeMode.system`).
    -   Corrección integral de problemas de codificación de caracteres (UTF-8) en textos en español en toda la aplicación.
    -   Mejoras en la responsividad y feedback al usuario (Snackbars, Diálogos unificados).
-   **Estabilidad:**
    -   Corrección de errores en módulos de monitoreo (Gráficos, Listas).
    -   Optimización de controladores GetX para una gestión de memoria más eficiente.

## 📱 Estructura del Proyecto

El proyecto sigue una estructura modular organizada por características (`Auth`, `Child`, `Incident`, `Monitoring`, `User`, `Config`), facilitando la escalabilidad y el mantenimiento.

```
lib/
├── Auth/           # Autenticación (Login, Password)
├── Child/          # Gestión de Infantes
├── Config/         # Configuraciones globales, Widgets compartidos, Servicios base
├── Incident/       # Reportes de Incidencias
├── Intro/          # Onboarding y Splash screen
├── Monitoring/     # Módulos de seguimiento (Salud, Nutrición, Asistencia)
├── User/           # Gestión de perfil de usuario
└── main.dart       # Punto de entrada
```

## 🚀 Instalación y Ejecución

1.  Clonar el repositorio.
2.  Instalar dependencias: `flutter pub get`
3.  Configurar variables de entorno (si aplica).
4.  Ejecutar: `flutter run`
