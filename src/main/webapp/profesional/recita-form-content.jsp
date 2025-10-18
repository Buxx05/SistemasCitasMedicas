<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-redo mr-2"></i>
                    Crear Cita de Seguimiento
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/CitaProfesionalServlet">Mis Citas</a></li>
                    <li class="breadcrumb-item active">Crear Re-cita</li>
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

                <!-- Información de la cita original -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-info-circle mr-2"></i>
                            Cita Original
                        </h3>
                    </div>
                    <div class="card-body">
                        <dl class="row">
                            <dt class="col-sm-4">Paciente:</dt>
                            <dd class="col-sm-8">${paciente.nombreCompleto}</dd>

                            <dt class="col-sm-4">DNI:</dt>
                            <dd class="col-sm-8">${paciente.dni}</dd>

                            <dt class="col-sm-4">Fecha Cita Original:</dt>
                            <dd class="col-sm-8">${citaOriginal.fechaCita}</dd>

                            <dt class="col-sm-4">Motivo Original:</dt>
                            <dd class="col-sm-8">${citaOriginal.motivoConsulta}</dd>
                        </dl>
                    </div>
                </div>

                <!-- Formulario de re-cita -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-plus mr-2"></i>
                            Nueva Cita de Seguimiento
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                          method="post" 
                          id="recitaForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="crearRecita">
                        <input type="hidden" name="idCitaOriginal" value="${citaOriginal.idCita}">
                        <input type="hidden" name="idPaciente" value="${paciente.idPaciente}">

                        <div class="card-body">

                            <div class="row">
                                <!-- Fecha -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="fechaCita">
                                            Fecha <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="far fa-calendar"></i>
                                                </span>
                                            </div>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaCita" 
                                                   name="fechaCita" 
                                                   required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hora -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="horaCita">
                                            Hora <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="far fa-clock"></i>
                                                </span>
                                            </div>
                                            <input type="time" 
                                                   class="form-control" 
                                                   id="horaCita" 
                                                   name="horaCita" 
                                                   required>
                                        </div>
                                        <small class="form-text text-muted">
                                            Asegúrate de que sea dentro de tus horarios de atención
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Motivo -->
                            <div class="form-group">
                                <label for="motivoConsulta">
                                    Motivo de la Cita de Seguimiento
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-notes-medical"></i>
                                        </span>
                                    </div>
                                    <textarea class="form-control" 
                                              id="motivoConsulta" 
                                              name="motivoConsulta" 
                                              rows="3" 
                                              placeholder="Ejemplo: Evaluación de resultados de exámenes, control post-tratamiento..."></textarea>
                                </div>
                            </div>

                            <!-- Observaciones -->
                            <div class="form-group">
                                <label for="observaciones">
                                    Observaciones Adicionales
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-sticky-note"></i>
                                        </span>
                                    </div>
                                    <textarea class="form-control" 
                                              id="observaciones" 
                                              name="observaciones" 
                                              rows="2" 
                                              placeholder="Notas internas o instrucciones especiales..."></textarea>
                                </div>
                            </div>

                        </div>

                        <!-- Botones -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                Crear Re-cita
                            </button>
                            <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet" 
                               class="btn btn-secondary btn-lg">
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

<!-- Validación -->
<script>
    $(document).ready(function () {
        // Establecer fecha mínima (hoy)
        const today = new Date().toISOString().split('T')[0];
        $('#fechaCita').attr('min', today);

        // Validación del formulario
        $('#recitaForm').submit(function (e) {
            const fecha = $('#fechaCita').val();
            const hora = $('#horaCita').val();

            if (fecha < today) {
                e.preventDefault();
                alert('⚠️ No se pueden agendar citas en fechas pasadas');
                $('#fechaCita').focus();
                return false;
            }

            if (!hora) {
                e.preventDefault();
                alert('⚠️ Debe seleccionar una hora');
                $('#horaCita').focus();
                return false;
            }
        });
    });
</script>
