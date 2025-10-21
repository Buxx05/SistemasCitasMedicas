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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/ProfesionalServlet">Profesionales</a></li>
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
            <div class="col-md-10 offset-md-1">

                <!-- Card del formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-md mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/ProfesionalServlet" 
                          method="post" 
                          id="profesionalForm">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idProfesional" value="${profesional.idProfesional}">
                        </c:if>

                        <div class="card-body">

                            <!-- ========== SECCIÓN: DATOS DE USUARIO (Solo al crear) ========== -->
                            <c:if test="${accion == 'crear'}">
                                <h5 class="mb-3">
                                    <i class="fas fa-user mr-2"></i>
                                    Datos de Usuario
                                </h5>

                                <div class="row">
                                    <!-- Nombre Completo -->
                                    <div class="col-md-6">
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
                                                       value="${accion == 'crear' ? '' : param.nombreCompleto}" 
                                                       placeholder="Ingrese el nombre completo"
                                                       required>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Email -->
                                    <div class="col-md-6">
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
                                                       value="${accion == 'crear' ? '' : param.email}" 
                                                       placeholder="correo@ejemplo.com"
                                                       required>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Contraseña -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="password">
                                                Contraseña <span class="text-danger">*</span>
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
                                                       required>
                                                <div class="input-group-append">
                                                    <button class="btn btn-outline-secondary" 
                                                            type="button" 
                                                            id="togglePassword">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <small class="form-text text-muted">
                                                Mínimo 6 caracteres
                                            </small>
                                        </div>
                                    </div>

                                    <!-- Rol -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="idRol">
                                                Tipo de Profesional <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">
                                                        <i class="fas fa-user-tag"></i>
                                                    </span>
                                                </div>
                                                <select class="form-control" id="idRol" name="idRol" required>
                                                    <option value="">Seleccione el tipo</option>
                                                    <option value="2" ${accion != 'crear' && param.idRol == '2' ? 'selected' : ''}>
                                                        Especialista Médico
                                                    </option>
                                                    <option value="3" ${accion != 'crear' && param.idRol == '3' ? 'selected' : ''}>
                                                        Especialista No Médico
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">
                            </c:if>

                            <!-- ========== SECCIÓN: INFO USUARIO (Solo al editar) ========== -->
                            <c:if test="${accion == 'actualizar'}">
                                <div class="alert alert-info">
                                    <h5 class="alert-heading">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        Usuario Vinculado
                                    </h5>
                                    <p class="mb-0">
                                        <strong>Nombre:</strong> ${profesional.nombreUsuario}<br>
                                        <strong>Email:</strong> ${profesional.emailUsuario}<br>
                                        <strong>Rol:</strong> ${profesional.nombreRol}
                                    </p>
                                    <hr>
                                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=${profesional.idUsuario}" 
                                       class="btn btn-sm btn-info">
                                        <i class="fas fa-user-edit mr-1"></i>
                                        Editar Datos de Usuario
                                    </a>
                                </div>

                                <hr class="my-4">
                            </c:if>

                            <!-- ========== SECCIÓN: DATOS PROFESIONALES ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-stethoscope mr-2"></i>
                                Datos Profesionales
                            </h5>

                            <div class="row">
                                <!-- Especialidad -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="idEspecialidad">
                                            Especialidad <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-briefcase-medical"></i>
                                                </span>
                                            </div>
                                            <select class="form-control" id="idEspecialidad" name="idEspecialidad" required>
                                                <option value="">Seleccione una especialidad</option>
                                                <c:forEach var="esp" items="${especialidades}">
                                                    <option value="${esp.idEspecialidad}" 
                                                            ${(accion == 'actualizar' && profesional != null && profesional.idEspecialidad == esp.idEspecialidad) || (accion == 'crear' && param.idEspecialidad == esp.idEspecialidad) ? 'selected' : ''}>
                                                        ${esp.nombre}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Número de Licencia -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="numeroLicencia">
                                            Número de Licencia <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-id-card"></i>
                                                </span>
                                            </div>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="numeroLicencia" 
                                                   name="numeroLicencia" 
                                                   value="${accion == 'actualizar' && profesional != null ? profesional.numeroLicencia : (accion == 'crear' && param.numeroLicencia != null ? param.numeroLicencia : '')}" 
                                                   placeholder="Ej: LIC-12345"
                                                   required>
                                        </div>
                                        <small class="form-text text-muted">
                                            Número único de registro profesional
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- DNI -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="dni">
                                            DNI <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-id-card-alt"></i>
                                                </span>
                                            </div>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="dni" 
                                                   name="dni" 
                                                   value="${accion == 'actualizar' && profesional != null ? profesional.dni : (accion == 'crear' && param.dni != null ? param.dni : '')}" 
                                                   placeholder="Ej: 12345678"
                                                   maxlength="8"
                                                   pattern="[0-9]{8}"
                                                   required>
                                        </div>
                                        <small class="form-text text-muted">
                                            Documento Nacional de Identidad (8 dígitos)
                                        </small>
                                    </div>
                                </div>

                                <!-- Teléfono -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="telefono">
                                            Teléfono
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone"></i>
                                                </span>
                                            </div>
                                            <input type="tel" 
                                                   class="form-control" 
                                                   id="telefono" 
                                                   name="telefono" 
                                                   value="${accion == 'actualizar' && profesional != null ? profesional.telefono : (accion == 'crear' && param.telefono != null ? param.telefono : '')}" 
                                                   placeholder="Ej: +51 999 888 777">
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Crear Profesional' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/ProfesionalServlet" 
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

        // Validación del formulario
        $('#profesionalForm').submit(function (e) {
            const accion = $('input[name="accion"]').val();

            // Solo validar contraseña al crear
            if (accion === 'crear') {
                const password = $('#password').val();
                if (password.length < 6) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 6 caracteres');
                    $('#password').focus();
                    return false;
                }
            }

            // ✅ VALIDAR DNI (8 dígitos numéricos)
            const dni = $('#dni').val().trim();
            if (!/^\d{8}$/.test(dni)) {
                e.preventDefault();
                alert('El DNI debe contener exactamente 8 dígitos numéricos');
                $('#dni').focus();
                return false;
            }

            // Validar número de licencia
            const licencia = $('#numeroLicencia').val().trim();
            if (licencia.length < 3) {
                e.preventDefault();
                alert('El número de licencia debe tener al menos 3 caracteres');
                $('#numeroLicencia').focus();
                return false;
            }
        });
    });
</script>
