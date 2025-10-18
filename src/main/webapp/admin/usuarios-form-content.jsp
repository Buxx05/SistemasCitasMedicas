<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">${tituloFormulario}</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/UsuarioServlet">Usuarios</a></li>
                    <li class="breadcrumb-item active">${tituloFormulario}</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main content -->
<section class="content">
    <div class="container-fluid">

        <!-- Alertas -->
        <jsp:include page="/componentes/alert.jsp"/>

        <div class="row">
            <div class="col-md-8 offset-md-2">

                <!-- Card del formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-edit mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/UsuarioServlet" 
                          method="post" 
                          id="usuarioForm">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
                        </c:if>

                        <div class="card-body">

                            <!-- Nombre Completo -->
                            <div class="form-group">
                                <label for="nombreCompleto">
                                    Nombre Completo <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-user"></i>
                                        </span>
                                    </div>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombreCompleto" 
                                           name="nombreCompleto" 
                                           value="${usuario != null ? usuario.nombreCompleto : param.nombreCompleto}" 
                                           placeholder="Ingrese el nombre completo"
                                           required>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label for="email">
                                    Email <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope"></i>
                                        </span>
                                    </div>
                                    <input type="email" 
                                           class="form-control" 
                                           id="email" 
                                           name="email" 
                                           value="${usuario != null ? usuario.email : param.email}" 
                                           placeholder="correo@ejemplo.com"
                                           required>
                                </div>
                            </div>

                            <!-- Contraseña -->
                            <div class="form-group">
                                <label for="password">
                                    Contraseña 
                                    <c:choose>
                                        <c:when test="${accion == 'crear'}">
                                            <span class="text-danger">*</span>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-muted">(Dejar en blanco para no cambiar)</small>
                                        </c:otherwise>
                                    </c:choose>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                    </div>
                                    <input type="password" 
                                           class="form-control" 
                                           id="password" 
                                           name="password" 
                                           placeholder="Ingrese la contraseña"
                                           ${accion == 'crear' ? 'required' : ''}>
                                    <div class="input-group-append">
                                        <button class="btn btn-outline-secondary" 
                                                type="button" 
                                                id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <small class="form-text text-muted">
                                    <i class="fas fa-info-circle"></i>
                                    La contraseña debe tener al menos 6 caracteres
                                </small>
                            </div>

                            <!-- Rol -->
                            <div class="form-group">
                                <label for="idRol">
                                    Rol <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-user-tag"></i>
                                        </span>
                                    </div>
                                    <select class="form-control" id="idRol" name="idRol" required>
                                        <option value="">Seleccione un rol</option>
                                        <option value="1" ${(usuario != null && usuario.idRol == 1) || param.idRol == '1' ? 'selected' : ''}>
                                            Administrador
                                        </option>
                                        <option value="2" ${(usuario != null && usuario.idRol == 2) || param.idRol == '2' ? 'selected' : ''}>
                                            Especialista Médico
                                        </option>
                                        <option value="3" ${(usuario != null && usuario.idRol == 3) || param.idRol == '3' ? 'selected' : ''}>
                                            Especialista No Médico
                                        </option>
                                    </select>
                                </div>
                            </div>

                            <!-- Estado (solo en modo editar) -->
                            <c:if test="${accion == 'actualizar'}">
                                <div class="form-group">
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" 
                                               class="custom-control-input" 
                                               id="activo" 
                                               name="activo" 
                                               ${usuario.activo ? 'checked' : ''}>
                                        <label class="custom-control-label" for="activo">
                                            <i class="fas fa-toggle-on mr-1"></i>
                                            Usuario Activo
                                        </label>
                                    </div>
                                    <small class="form-text text-muted">
                                        Los usuarios inactivos no podrán iniciar sesión
                                    </small>
                                </div>
                            </c:if>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Crear Usuario' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/UsuarioServlet" 
                               class="btn btn-secondary">
                                <i class="fas fa-times mr-2"></i>
                                Cancelar
                            </a>
                        </div>

                    </form>
                </div>

            </div>
        </div>

    </div>
</section>

<!-- Script para mostrar/ocultar contraseña -->
<script>
    $(document).ready(function () {
        // Toggle password visibility
        $('#togglePassword').click(function () {
            const passwordField = $('#password');
            const icon = $(this).find('i');

            if (passwordField.attr('type') === 'password') {
                passwordField.attr('type', 'text');
                icon.removeClass('fa-eye').addClass('fa-eye-slash');
            } else {
                passwordField.attr('type', 'password');
                icon.removeClass('fa-eye-slash').addClass('fa-eye');
            }
        });

        // Validación de contraseña (mínimo 6 caracteres)
        $('#usuarioForm').submit(function (e) {
            const password = $('#password').val();
            const accion = $('input[name="accion"]').val();

            // Solo validar si es crear o si se está cambiando la contraseña
            if (accion === 'crear' || (accion === 'actualizar' && password.length > 0)) {
                if (password.length < 6) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 6 caracteres');
                    $('#password').focus();
                    return false;
                }
            }
        });
    });
</script>