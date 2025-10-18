<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error - Sistema de Citas Médicas</title>

        <!-- Google Font -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <!-- Bootstrap 4 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

        <!-- AdminLTE 3 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .error-container {
                width: 100%;
                max-width: 600px;
                padding: 1rem;
            }

            .error-card {
                background: white;
                border-radius: 0.5rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                border: none;
                overflow: hidden;
            }

            .error-header {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
                padding: 2rem;
                text-align: center;
            }

            .error-header i {
                font-size: 3rem;
                margin-bottom: 1rem;
                display: block;
            }

            .error-header h2 {
                margin: 0;
                font-weight: 600;
            }

            .error-body {
                padding: 2rem;
            }

            .error-code {
                font-size: 4rem;
                font-weight: 700;
                color: #dc3545;
                text-align: center;
                margin-bottom: 1rem;
                opacity: 0.3;
            }

            .error-message {
                background: #f8f9fa;
                border-left: 4px solid #dc3545;
                padding: 1rem;
                margin-bottom: 1.5rem;
                border-radius: 0.25rem;
                color: #333;
            }

            .error-actions {
                display: flex;
                gap: 1rem;
                justify-content: center;
                flex-wrap: wrap;
            }

            .error-actions a {
                flex: 1;
                min-width: 150px;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-card">

                <!-- Header de Error -->
                <div class="error-header">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h2>¡Ha Ocurrido un Error!</h2>
                </div>

                <!-- Cuerpo del Error -->
                <div class="error-body">

                    <!-- Código de Error (Opcional) -->
                    <c:if test="${not empty error_code}">
                        <div class="error-code">${error_code}</div>
                    </c:if>

                    <!-- Mensaje de Error -->
                    <div class="error-message">
                        <strong>Descripción del Error:</strong><br>
                        <c:choose>
                            <c:when test="${not empty mensajeError}">
                                ${mensajeError}
                            </c:when>
                            <c:when test="${not empty error}">
                                ${error}
                            </c:when>
                            <c:otherwise>
                                Ocurrió un error inesperado en el servidor. Por favor, contacte al administrador si el problema persiste.
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Acciones -->
                    <div class="error-actions">
                        <a href="login.jsp" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Iniciar Sesión
                        </a>
                        <a href="javascript:history.back()" class="btn btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Volver Atrás
                        </a>
                        <c:if test="${not empty sessionScope.usuario}">
                            <a href="DashboardAdminServlet" class="btn btn-info">
                                <i class="fas fa-home mr-2"></i>
                                Ir al Inicio
                            </a>
                        </c:if>
                    </div>

                    <!-- Footer -->
                    <hr class="my-3">
                    <p class="text-center text-muted small mb-0">
                        Si cree que esto es un error, contacte al 
                        <strong>administrador@hospital.com</strong>
                    </p>
                </div>

            </div>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- Bootstrap 4 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- AdminLTE 3 -->
        <script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
    </body>
</html>