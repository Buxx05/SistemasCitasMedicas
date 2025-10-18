<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Sistema de Citas Médicas</title>

        <!-- Google Font -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <!-- Bootstrap 4 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                font-family: 'Source Sans Pro', sans-serif;
            }

            .login-container {
                width: 100%;
                max-width: 400px;
            }

            .card {
                border-radius: 0.5rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                border: none;
            }

            .card-body {
                padding: 2rem;
            }

            .brand-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .brand-header i {
                font-size: 3rem;
                color: #667eea;
                margin-bottom: 0.5rem;
            }

            .brand-header h2 {
                color: #333;
                font-weight: 600;
                margin-bottom: 0.25rem;
            }

            .brand-header p {
                color: #999;
                font-size: 0.9rem;
                margin: 0;
            }

            .form-control {
                border-radius: 0.25rem;
                border: 1px solid #ddd;
                height: 2.5rem;
                font-size: 0.95rem;
            }

            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            .btn-login {
                background-color: #667eea;
                border-color: #667eea;
                height: 2.5rem;
                font-weight: 600;
                border-radius: 0.25rem;
                transition: all 0.3s ease;
            }

            .btn-login:hover {
                background-color: #764ba2;
                border-color: #764ba2;
                transform: translateY(-2px);
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }

            .alert {
                border-radius: 0.25rem;
                border: none;
                margin-bottom: 1.5rem;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="card">
                <div class="card-body">
                    <!-- Header -->
                    <div class="brand-header">
                        <i class="fas fa-hospital"></i>
                        <h2>Sistema de Citas</h2>
                        <p>Médicas</p>
                    </div>

                    <!-- Alertas de error -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                            <strong>Error:</strong> ${error}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorSession}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                            <strong>Error:</strong> ${errorSession}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <c:set var="temp" value="${sessionScope.remove('error')}" />
                    </c:if>

                    <!-- Formulario -->
                    <form action="LoginServlet" method="POST" novalidate>
                        <div class="form-group">
                            <label for="email" class="form-label font-weight-bold">Correo Electrónico</label>
                            <input 
                                type="email" 
                                class="form-control" 
                                id="email" 
                                name="email" 
                                placeholder="tu@correo.com"
                                required 
                                autofocus>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label font-weight-bold">Contraseña</label>
                            <input 
                                type="password" 
                                class="form-control" 
                                id="password" 
                                name="password" 
                                placeholder="••••••••"
                                required>
                        </div>

                        <button type="submit" class="btn btn-login btn-block text-white mt-4">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Iniciar Sesión
                        </button>
                    </form>

                    <!-- Footer -->
                    <hr class="my-3">
                    <p class="text-center text-muted small mb-0">
                        Sistema de Gestión de Citas Médicas &copy; 2025
                    </p>
                </div>
            </div>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- Bootstrap 4 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Auto-cerrar alertas después de 5 segundos
            document.addEventListener('DOMContentLoaded', function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
    </body>
</html>