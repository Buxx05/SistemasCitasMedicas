<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Login - Sistema de Citas Médicas</title>

        <!-- Favicon -->
        <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🏥</text></svg>">

        <!-- Google Font -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <!-- Bootstrap 4 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

        <!-- SweetAlert2 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

        <style>
            :root {
                --primary-color: #0d6efd;
                --primary-dark: #0a58ca;
                --secondary-color: #17a2b8;
                --success-color: #28a745;
                --gradient-start: #0d6efd;
                --gradient-end: #17a2b8;
            }

            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
                font-family: 'Source Sans Pro', sans-serif;
                padding: 20px;
                position: relative;
                overflow: hidden;
            }

            /* Efecto de fondo médico */
            body::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background:
                    radial-gradient(circle at 20% 30%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 70%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
                animation: float 20s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% {
                    transform: translate(0, 0) rotate(0deg);
                }
                50% {
                    transform: translate(50px, 50px) rotate(180deg);
                }
            }

            .login-container {
                width: 100%;
                max-width: 440px;
                position: relative;
                z-index: 1;
                animation: fadeInUp 0.6s ease;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .card {
                border-radius: 1rem;
                box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.2);
                border: none;
                overflow: hidden;
                backdrop-filter: blur(10px);
                background: rgba(255, 255, 255, 0.98);
            }

            .card-body {
                padding: 2.5rem;
            }

            .brand-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .brand-header .icon-wrapper {
                display: flex; /* ✅ Cambiar de inline-block a flex */
                width: 90px;
                height: 90px;
                background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
                border-radius: 50%;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem auto; /* ✅ Agregar margin: 0 auto */
                box-shadow: 0 0.5rem 1.5rem rgba(13, 110, 253, 0.4);
                animation: pulse 2s ease-in-out infinite;
            }


            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
            }

            .brand-header i {
                font-size: 2.75rem;
                color: #ffffff;
            }

            .brand-header h2 {
                color: #212529;
                font-weight: 700;
                margin-bottom: 0.25rem;
                font-size: 1.85rem;
            }

            .brand-header p {
                color: #6c757d;
                font-size: 0.95rem;
                margin: 0;
                font-weight: 500;
            }

            .form-label {
                color: #495057;
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
                font-weight: 600;
            }

            .form-label i {
                color: var(--primary-color);
                margin-right: 0.25rem;
            }

            .input-group {
                position: relative;
                margin-bottom: 1.25rem;
            }

            .input-icon {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--primary-color);
                z-index: 10;
                pointer-events: none;
            }

            .form-control {
                border-radius: 0.5rem;
                border: 2px solid #e9ecef;
                height: 3.25rem;
                font-size: 0.95rem;
                padding-left: 2.75rem;
                padding-right: 1rem;
                transition: all 0.3s ease;
                background-color: #f8f9fa;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
                background-color: #ffffff;
            }

            .form-control::placeholder {
                color: #adb5bd;
            }

            .input-group-append {
                position: absolute;
                right: 0;
                top: 0;
                height: 100%;
                z-index: 10;
            }

            .toggle-password {
                background: transparent;
                border: none;
                color: #6c757d;
                padding: 0 1rem;
                height: 100%;
                cursor: pointer;
                transition: color 0.3s ease;
            }

            .toggle-password:hover {
                color: var(--primary-color);
            }

            .toggle-password:focus {
                outline: none;
            }

            .btn-login {
                background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
                border: none;
                height: 3.25rem;
                font-weight: 600;
                font-size: 1rem;
                border-radius: 0.5rem;
                transition: all 0.3s ease;
                box-shadow: 0 0.5rem 1rem rgba(13, 110, 253, 0.3);
                position: relative;
                overflow: hidden;
            }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.2);
                transition: left 0.5s ease;
            }

            .btn-login:hover::before {
                left: 100%;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 0.75rem 1.5rem rgba(13, 110, 253, 0.4);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .btn-login:disabled {
                opacity: 0.7;
                cursor: not-allowed;
                transform: none !important;
            }

            .alert {
                border-radius: 0.5rem;
                border: none;
                margin-bottom: 1.5rem;
                animation: slideDown 0.3s ease;
                border-left: 4px solid;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border-left-color: #dc3545;
            }

            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border-left-color: #28a745;
            }

            .alert i {
                margin-right: 0.5rem;
            }

            .forgot-password {
                text-align: center;
                margin-top: 1rem;
            }

            .forgot-password a {
                color: #6c757d;
                text-decoration: none;
                font-size: 0.9rem;
                transition: color 0.3s ease;
            }

            .forgot-password a:hover {
                color: var(--primary-color);
            }

            .footer-text {
                text-align: center;
                color: rgba(255, 255, 255, 0.9);
                font-size: 0.875rem;
                margin-top: 1.5rem;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
            }

            .security-badge {
                text-align: center;
                padding: 1rem;
                background-color: #f8f9fa;
                border-radius: 0.5rem;
                margin-top: 1rem;
            }

            .security-badge i {
                color: var(--success-color);
                margin-right: 0.5rem;
            }

            .security-badge small {
                color: #6c757d;
                font-weight: 500;
            }

            /* Responsive */
            @media (max-width: 480px) {
                .card-body {
                    padding: 1.75rem;
                }

                .brand-header h2 {
                    font-size: 1.5rem;
                }

                .brand-header .icon-wrapper {
                    width: 75px;
                    height: 75px;
                }

                .brand-header i {
                    font-size: 2.25rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="card">
                <div class="card-body">
                    <!-- Header -->
                    <div class="brand-header">
                        <div class="icon-wrapper">
                            <i class="fas fa-hospital"></i>
                        </div>
                        <h2>Sistema de Citas</h2>
                        <p>Gestión Médica Profesional</p>
                    </div>

                    <!-- Alerta de Error (request) -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i>
                            <strong>Error:</strong> ${error}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <!-- Alerta de Mensaje (session) -->
                    <c:if test="${not empty sessionScope.mensaje}">
                        <c:set var="tipoAlerta" value="${sessionScope.tipoMensaje != null ? sessionScope.tipoMensaje : 'info'}" />
                        <div class="alert alert-${tipoAlerta} alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i>
                            ${sessionScope.mensaje}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <c:remove var="mensaje" scope="session" />
                        <c:remove var="tipoMensaje" scope="session" />
                    </c:if>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" id="loginForm">

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email" class="form-label">
                                <i class="fas fa-envelope"></i>
                                Correo Electrónico
                            </label>
                            <div class="input-group">
                                <i class="fas fa-user input-icon"></i>
                                <input 
                                    type="email" 
                                    class="form-control" 
                                    id="email" 
                                    name="email" 
                                    placeholder="usuario@ejemplo.com"
                                    required 
                                    autofocus
                                    autocomplete="email">
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock"></i>
                                Contraseña
                            </label>
                            <div class="input-group">
                                <i class="fas fa-key input-icon"></i>
                                <input 
                                    type="password" 
                                    class="form-control" 
                                    id="password" 
                                    name="password" 
                                    placeholder="••••••••"
                                    required
                                    autocomplete="current-password">
                                <div class="input-group-append">
                                    <button class="toggle-password" type="button" id="togglePassword" tabindex="-1">
                                        <i class="fas fa-eye" id="toggleIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Botón Submit -->
                        <button type="submit" class="btn btn-login btn-block text-white mt-4" id="btnLogin">
                            <span id="btnText">
                                <i class="fas fa-sign-in-alt mr-2"></i>
                                Iniciar Sesión
                            </span>
                        </button>
                    </form>

                    <!-- Olvidaste tu contraseña -->
                    <div class="forgot-password">
                        <a href="#" id="forgotPasswordLink">
                            <i class="fas fa-question-circle"></i>
                            ¿Olvidaste tu contraseña?
                        </a>
                    </div>

                    <!-- Divider -->
                    <hr class="my-4">

                    <!-- Security Badge -->
                    <div class="security-badge">
                        <i class="fas fa-shield-alt"></i>
                        <small>Acceso seguro y protegido</small>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <p class="footer-text">
                <i class="fas fa-hospital mr-1"></i>
                Sistema de Gestión de Citas Médicas &copy; 2025
            </p>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- Bootstrap 4 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            $(document).ready(function () {

                // Auto-cerrar alertas después de 5 segundos
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);

                // Toggle mostrar/ocultar contraseña
                $('#togglePassword').on('click', function () {
                    const passwordInput = $('#password');
                    const toggleIcon = $('#toggleIcon');

                    if (passwordInput.attr('type') === 'password') {
                        passwordInput.attr('type', 'text');
                        toggleIcon.removeClass('fa-eye').addClass('fa-eye-slash');
                    } else {
                        passwordInput.attr('type', 'password');
                        toggleIcon.removeClass('fa-eye-slash').addClass('fa-eye');
                    }
                });

                // Validación del formulario
                $('#loginForm').on('submit', function (e) {
                    const email = $('#email').val().trim();
                    const password = $('#password').val().trim();

                    // Validar campos vacíos
                    if (!email || !password) {
                        e.preventDefault();
                        Swal.fire({
                            icon: 'warning',
                            title: 'Campos Incompletos',
                            text: 'Por favor, completa todos los campos',
                            confirmButtonColor: '#0d6efd',
                            confirmButtonText: 'Entendido'
                        });
                        return false;
                    }

                    // Validar formato de email
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(email)) {
                        e.preventDefault();
                        Swal.fire({
                            icon: 'warning',
                            title: 'Email Inválido',
                            text: 'Por favor, ingresa un correo electrónico válido',
                            confirmButtonColor: '#0d6efd',
                            confirmButtonText: 'Entendido'
                        });
                        $('#email').focus();
                        return false;
                    }

                    // Validar longitud mínima de contraseña
                    if (password.length < 4) {
                        e.preventDefault();
                        Swal.fire({
                            icon: 'warning',
                            title: 'Contraseña Muy Corta',
                            text: 'La contraseña debe tener al menos 4 caracteres',
                            confirmButtonColor: '#0d6efd',
                            confirmButtonText: 'Entendido'
                        });
                        $('#password').focus();
                        return false;
                    }

                    // Mostrar loading
                    $('#btnLogin').prop('disabled', true);
                    $('#btnText').html('<i class="fas fa-spinner fa-spin mr-2"></i>Ingresando...');
                });

                // Enter en cualquier campo envía el formulario
                $('#email, #password').on('keypress', function (e) {
                    if (e.which === 13) {
                        $('#loginForm').submit();
                    }
                });

                // Olvidaste tu contraseña
                $('#forgotPasswordLink').on('click', function (e) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'info',
                        title: 'Recuperar Contraseña',
                        html: '<p>Por favor, contacta al administrador del sistema para restablecer tu contraseña.</p>' +
                                '<p class="mb-0"><i class="fas fa-envelope mr-2"></i><strong>admin@sistema.com</strong></p>',
                        confirmButtonColor: '#0d6efd',
                        confirmButtonText: 'Entendido'
                    });
                });
            });
        </script>
    </body>
</html>
