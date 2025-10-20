<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-briefcase-medical mr-2"></i>
                    ${tituloFormulario}
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/EspecialidadServlet">Especialidades</a></li>
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
                            <i class="fas fa-${accion == 'crear' ? 'plus-circle' : 'edit'} mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/EspecialidadServlet" 
                          method="post" 
                          id="especialidadForm"
                          autocomplete="off">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idEspecialidad" value="${especialidad.idEspecialidad}">
                        </c:if>

                        <div class="card-body">

                            <!-- Nombre de la Especialidad -->
                            <div class="form-group">
                                <label for="nombre">
                                    <i class="fas fa-stethoscope mr-1"></i>
                                    Nombre de la Especialidad <span class="text-danger">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="nombre" 
                                       name="nombre" 
                                       value="${especialidad != null ? especialidad.nombre : param.nombre}" 
                                       placeholder="Ej: Cardiología, Pediatría, Psicología"
                                       maxlength="100"
                                       required>
                                <small class="form-text text-muted">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    El nombre debe ser único en el sistema (mínimo 3 caracteres)
                                </small>
                            </div>

                            <!-- Descripción -->
                            <div class="form-group">
                                <label for="descripcion">
                                    <i class="fas fa-align-left mr-1"></i>
                                    Descripción
                                </label>
                                <textarea class="form-control" 
                                          id="descripcion" 
                                          name="descripcion" 
                                          rows="4" 
                                          maxlength="500"
                                          placeholder="Describe brevemente esta especialidad...">${especialidad != null ? especialidad.descripcion : param.descripcion}</textarea>
                                <small class="form-text text-muted">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Información adicional sobre la especialidad (opcional, máximo 500 caracteres)
                                    <span class="float-right">
                                        <span id="charCount">0</span>/500
                                    </span>
                                </small>
                            </div>

                            <!-- Información adicional en modo editar -->
                            <c:if test="${accion == 'actualizar'}">
                                <div class="alert alert-info">
                                    <h5 class="alert-heading mb-2">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        Información del Registro
                                    </h5>
                                    <p class="mb-0">
                                        <strong>ID:</strong> ${especialidad.idEspecialidad}<br>
                                        <strong>Nota:</strong> Si esta especialidad tiene profesionales asignados, 
                                        los cambios se reflejarán automáticamente en sus perfiles.
                                    </p>
                                </div>
                            </c:if>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer bg-light">
                            <button type="submit" class="btn btn-primary btn-lg" id="btnSubmit">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Crear Especialidad' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/EspecialidadServlet" 
                               class="btn btn-secondary btn-lg">
                                <i class="fas fa-arrow-left mr-2"></i>
                                Volver
                            </a>
                            <button type="reset" class="btn btn-outline-warning btn-lg" id="btnReset">
                                <i class="fas fa-undo mr-2"></i>
                                Restablecer
                            </button>
                        </div>

                    </form>
                </div>

                <!-- Card de ayuda -->
                <div class="card card-info collapsed-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-lightbulb mr-2"></i>
                            Ejemplos de Especialidades
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body" style="display: none;">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-user-md mr-2 text-primary"></i>Especialidades Médicas:</h6>
                                <ul class="list-unstyled ml-3">
                                    <li><i class="fas fa-heartbeat text-danger mr-2"></i>Cardiología</li>
                                    <li><i class="fas fa-baby text-info mr-2"></i>Pediatría</li>
                                    <li><i class="fas fa-brain text-purple mr-2"></i>Neurología</li>
                                    <li><i class="fas fa-hand-holding-medical text-success mr-2"></i>Dermatología</li>
                                    <li><i class="fas fa-eye text-primary mr-2"></i>Oftalmología</li>
                                    <li><i class="fas fa-bone text-warning mr-2"></i>Traumatología</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-user-nurse mr-2 text-success"></i>Especialidades No Médicas:</h6>
                                <ul class="list-unstyled ml-3">
                                    <li><i class="fas fa-head-side-virus text-teal mr-2"></i>Psicología</li>
                                    <li><i class="fas fa-apple-alt text-success mr-2"></i>Nutrición</li>
                                    <li><i class="fas fa-walking text-primary mr-2"></i>Fisioterapia</li>
                                    <li><i class="fas fa-hands-helping text-info mr-2"></i>Trabajo Social</li>
                                    <li><i class="fas fa-syringe text-danger mr-2"></i>Enfermería</li>
                                    <li><i class="fas fa-comments text-purple mr-2"></i>Terapia Ocupacional</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</section>

<!-- Script de validación -->
<script>
    $(document).ready(function () {
        console.log('✅ Formulario de especialidades inicializado');

        // Contador de caracteres para descripción
        const $descripcion = $('#descripcion');
        const $charCount = $('#charCount');

        function actualizarContador() {
            const length = $descripcion.val().length;
            $charCount.text(length);

            if (length > 450) {
                $charCount.addClass('text-warning');
            } else {
                $charCount.removeClass('text-warning');
            }
        }

        // Actualizar contador al cargar
        actualizarContador();

        // Actualizar contador al escribir
        $descripcion.on('input', actualizarContador);

        // Auto-capitalizar nombre al escribir
        $('#nombre').on('blur', function () {
            const value = $(this).val().trim();
            if (value.length > 0) {
                // Capitalizar cada palabra
                const capitalized = value.split(' ')
                        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                        .join(' ');
                $(this).val(capitalized);
            }
        });

        // Validación del formulario
        $('#especialidadForm').submit(function (e) {
            const nombre = $('#nombre').val().trim();
            const descripcion = $('#descripcion').val().trim();

            console.log('🔍 Validando formulario...');

            // Validar nombre vacío
            if (nombre.length === 0) {
                e.preventDefault();
                alert('⚠️ El nombre de la especialidad es obligatorio');
                $('#nombre').focus();
                return false;
            }

            // Validar longitud mínima del nombre
            if (nombre.length < 3) {
                e.preventDefault();
                alert('⚠️ El nombre debe tener al menos 3 caracteres');
                $('#nombre').focus();
                return false;
            }

            // Validar caracteres especiales
            if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(nombre)) {
                e.preventDefault();
                alert('⚠️ El nombre solo puede contener letras y espacios');
                $('#nombre').focus();
                return false;
            }

            // Capitalizar antes de enviar
            $('#nombre').val(nombre.split(' ')
                    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                    .join(' '));

            console.log('✅ Formulario válido, enviando...');

            // Deshabilitar botón para evitar doble envío
            $('#btnSubmit').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>Guardando...');

            return true;
        });

        // Botón reset
        $('#btnReset').on('click', function () {
            setTimeout(function () {
                $('#nombre').focus();
                actualizarContador();
            }, 100);
        });

        // Focus inicial en nombre
        $('#nombre').focus();
    });
</script>
