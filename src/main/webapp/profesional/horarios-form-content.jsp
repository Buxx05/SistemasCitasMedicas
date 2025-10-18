<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas ${empty horario ? 'fa-plus' : 'fa-edit'} mr-2"></i>
                    ${empty horario ? 'Nuevo Horario' : 'Editar Horario'}
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet">Horarios</a>
                    </li>
                    <li class="breadcrumb-item active">
                        ${empty horario ? 'Nuevo' : 'Editar'}
                    </li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<section class="content">
    <div class="container-fluid">

        <div class="row">
            <div class="col-md-8 offset-md-2">

                <!-- Formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-clock mr-2"></i>
                            Configuración de Horario
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                          method="POST" 
                          id="horarioForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="${empty horario ? 'crear' : 'actualizar'}"/>
                        <c:if test="${not empty horario}">
                            <input type="hidden" name="idHorario" value="${horario.idHorario}"/>
                        </c:if>

                        <div class="card-body">

                            <!-- Día de la Semana -->
                            <div class="form-group">
                                <label for="diaSemana">
                                    <i class="far fa-calendar mr-1"></i>
                                    Día de la Semana <span class="text-danger">*</span>
                                </label>
                                <select class="form-control form-control-lg" 
                                        id="diaSemana" 
                                        name="diaSemana" 
                                        required>
                                    <option value="">-- Seleccione un día --</option>
                                    <option value="LUNES" ${not empty horario && horario.diaSemana == 'LUNES' ? 'selected' : ''}>Lunes</option>
                                    <option value="MARTES" ${not empty horario && horario.diaSemana == 'MARTES' ? 'selected' : ''}>Martes</option>
                                    <option value="MIERCOLES" ${not empty horario && horario.diaSemana == 'MIERCOLES' ? 'selected' : ''}>Miércoles</option>
                                    <option value="JUEVES" ${not empty horario && horario.diaSemana == 'JUEVES' ? 'selected' : ''}>Jueves</option>
                                    <option value="VIERNES" ${not empty horario && horario.diaSemana == 'VIERNES' ? 'selected' : ''}>Viernes</option>
                                    <option value="SABADO" ${not empty horario && horario.diaSemana == 'SABADO' ? 'selected' : ''}>Sábado</option>
                                    <option value="DOMINGO" ${not empty horario && horario.diaSemana == 'DOMINGO' ? 'selected' : ''}>Domingo</option>
                                </select>
                            </div>

                            <!-- Rango de Horas -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="horaInicio">
                                            <i class="fas fa-clock mr-1"></i>
                                            Hora de Inicio <span class="text-danger">*</span>
                                        </label>
                                        <input type="time" 
                                               class="form-control form-control-lg" 
                                               id="horaInicio" 
                                               name="horaInicio" 
                                               value="${not empty horario ? horario.horaInicio.substring(0, 5) : ''}"
                                               required/>
                                        <small class="form-text text-muted">
                                            Hora en que inicia la atención
                                        </small>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="horaFin">
                                            <i class="fas fa-clock mr-1"></i>
                                            Hora de Fin <span class="text-danger">*</span>
                                        </label>
                                        <input type="time" 
                                               class="form-control form-control-lg" 
                                               id="horaFin" 
                                               name="horaFin" 
                                               value="${not empty horario ? horario.horaFin.substring(0, 5) : ''}"
                                               required/>
                                        <small class="form-text text-muted">
                                            Hora en que termina la atención
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Duración de Consulta -->
                            <div class="form-group">
                                <label for="duracionConsulta">
                                    <i class="fas fa-hourglass-half mr-1"></i>
                                    Duración por Consulta (minutos) <span class="text-danger">*</span>
                                </label>
                                <select class="form-control form-control-lg" 
                                        id="duracionConsulta" 
                                        name="duracionConsulta" 
                                        required>
                                    <option value="">-- Seleccione duración --</option>
                                    <option value="15" ${not empty horario && horario.duracionConsulta == 15 ? 'selected' : ''}>15 minutos</option>
                                    <option value="20" ${not empty horario && horario.duracionConsulta == 20 ? 'selected' : ''}>20 minutos</option>
                                    <option value="30" ${not empty horario && horario.duracionConsulta == 30 ? 'selected' : ''}>30 minutos</option>
                                    <option value="45" ${not empty horario && horario.duracionConsulta == 45 ? 'selected' : ''}>45 minutos</option>
                                    <option value="60" ${not empty horario && horario.duracionConsulta == 60 ? 'selected' : ''}>60 minutos (1 hora)</option>
                                </select>
                                <small class="form-text text-muted">
                                    Tiempo estimado por cada consulta (se usará para generar bloques de citas)
                                </small>
                            </div>

                            <!-- Estado Activo -->
                            <div class="form-group">
                                <div class="custom-control custom-switch custom-switch-lg">
                                    <input type="checkbox" 
                                           class="custom-control-input" 
                                           id="activo" 
                                           name="activo"
                                           ${empty horario || horario.activo ? 'checked' : ''}>
                                    <label class="custom-control-label" for="activo">
                                        <strong>Horario Activo</strong>
                                    </label>
                                </div>
                                <small class="form-text text-muted">
                                    Solo los horarios activos estarán disponibles para agendar citas
                                </small>
                            </div>

                            <!-- Información adicional -->
                            <div class="alert alert-info">
                                <h5><i class="icon fas fa-info-circle"></i> Información:</h5>
                                <ul class="mb-0">
                                    <li>Los bloques horarios se generarán automáticamente según la duración de consulta</li>
                                    <li>Los horarios no pueden solaparse en el mismo día</li>
                                    <li>Puedes configurar múltiples bloques para el mismo día</li>
                                </ul>
                            </div>

                        </div>

                        <!-- Card Footer -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${empty horario ? 'Crear Horario' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
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

<!-- Script -->
<script>
    (function () {
        if (typeof jQuery === 'undefined') {
            console.error('jQuery no está cargado');
            return;
        }

        $(document).ready(function () {
            // Validar formulario
            $('#horarioForm').on('submit', function (e) {
                var horaInicio = $('#horaInicio').val();
                var horaFin = $('#horaFin').val();

                if (horaFin <= horaInicio) {
                    e.preventDefault();
                    alert('⚠️ La hora de fin debe ser mayor que la hora de inicio');
                    $('#horaFin').focus();
                    return false;
                }
            });
        });
    })();
</script>
