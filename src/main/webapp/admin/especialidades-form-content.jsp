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
                            <i class="fas fa-briefcase-medical mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/EspecialidadServlet" 
                          method="post" 
                          id="especialidadForm">

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
                                    Nombre de la Especialidad <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-stethoscope"></i>
                                        </span>
                                    </div>
                                    <input type="text" 
                                           class="form-control form-control-lg" 
                                           id="nombre" 
                                           name="nombre" 
                                           value="${especialidad != null ? especialidad.nombre : param.nombre}" 
                                           placeholder="Ej: Cardiología, Pediatría, Psicología"
                                           required>
                                </div>
                                <small class="form-text text-muted">
                                    El nombre debe ser único en el sistema
                                </small>
                            </div>

                            <!-- Descripción -->
                            <div class="form-group">
                                <label for="descripcion">
                                    Descripción
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-align-left"></i>
                                        </span>
                                    </div>
                                    <textarea class="form-control" 
                                              id="descripcion" 
                                              name="descripcion" 
                                              rows="4" 
                                              placeholder="Describe brevemente esta especialidad...">${especialidad != null ? especialidad.descripcion : param.descripcion}</textarea>
                                </div>
                                <small class="form-text text-muted">
                                    Información adicional sobre la especialidad (opcional)
                                </small>
                            </div>

                            <!-- Información adicional en modo editar -->
                            <c:if test="${accion == 'actualizar'}">
                                <hr class="my-4">
                                <div class="alert alert-info">
                                    <h5 class="alert-heading">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        Información
                                    </h5>
                                    <p class="mb-0">
                                        <strong>ID:</strong> ${especialidad.idEspecialidad}<br>
                                        <strong>Nota:</strong> Si esta especialidad tiene profesionales asignados, 
                                        los cambios se reflejarán en sus perfiles.
                                    </p>
                                </div>
                            </c:if>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Crear Especialidad' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/EspecialidadServlet" 
                               class="btn btn-secondary btn-lg">
                                <i class="fas fa-times mr-2"></i>
                                Cancelar
                            </a>
                        </div>

                    </form>
                </div>

                <!-- Card de ayuda -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-question-circle mr-2"></i>
                            Ejemplos de Especialidades
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-user-md mr-2 text-primary"></i>Médicas:</h6>
                                <ul class="small">
                                    <li>Cardiología</li>
                                    <li>Pediatría</li>
                                    <li>Neurología</li>
                                    <li>Dermatología</li>
                                    <li>Oftalmología</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-user-nurse mr-2 text-success"></i>No Médicas:</h6>
                                <ul class="small">
                                    <li>Psicología</li>
                                    <li>Nutrición</li>
                                    <li>Fisioterapia</li>
                                    <li>Trabajo Social</li>
                                    <li>Enfermería</li>
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
        // Validación del formulario
        $('#especialidadForm').submit(function (e) {
            const nombre = $('#nombre').val().trim();

            // Validar que el nombre tenga al menos 3 caracteres
            if (nombre.length < 3) {
                e.preventDefault();
                alert('El nombre de la especialidad debe tener al menos 3 caracteres');
                $('#nombre').focus();
                return false;
            }

            // Capitalizar primera letra automáticamente
            if (nombre.length > 0) {
                $('#nombre').val(nombre.charAt(0).toUpperCase() + nombre.slice(1));
            }
        });

        // Auto-capitalizar al escribir
        $('#nombre').on('blur', function () {
            const value = $(this).val().trim();
            if (value.length > 0) {
                $(this).val(value.charAt(0).toUpperCase() + value.slice(1));
            }
        });
    });
</script>
