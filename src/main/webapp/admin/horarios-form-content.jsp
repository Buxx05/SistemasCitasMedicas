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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/HorarioProfesionalServlet">Mis Horarios</a></li>
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
                            <i class="fas fa-calendar-week mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                          method="post" 
                          id="horarioForm">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idHorario" value="${horario.idHorario}">
                        </c:if>

                        <div class="card-body">

                            <!-- ========== CONFIGURACIÓN DEL HORARIO ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-cog mr-2"></i>
                                Configuración del Horario
                            </h5>

                            <div class="row">
                                <!-- Día de la Semana -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="diaSemana">
                                            Día de la Semana <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-calendar-day"></i>
                                                </span>
                                            </div>
                                            <select class="form-control" id="diaSemana" name="diaSemana" required>
                                                <option value="">Seleccione un día</option>
                                                <option value="LUNES" ${(horario != null && horario.diaSemana == 'LUNES') ? 'selected' : ''}>Lunes</option>
                                                <option value="MARTES" ${(horario != null && horario.diaSemana == 'MARTES') ? 'selected' : ''}>Martes</option>
                                                <option value="MIERCOLES" ${(horario != null && horario.diaSemana == 'MIERCOLES') ? 'selected' : ''}>Miércoles</option>
                                                <option value="JUEVES" ${(horario != null && horario.diaSemana == 'JUEVES') ? 'selected' : ''}>Jueves</option>
                                                <option value="VIERNES" ${(horario != null && horario.diaSemana == 'VIERNES') ? 'selected' : ''}>Viernes</option>
                                                <option value="SABADO" ${(horario != null && horario.diaSemana == 'SABADO') ? 'selected' : ''}>Sábado</option>
                                                <option value="DOMINGO" ${(horario != null && horario.diaSemana == 'DOMINGO') ? 'selected' : ''}>Domingo</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Duración de Consulta -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="duracionConsulta">
                                            Duración de Consulta <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-hourglass-half"></i>
                                                </span>
                                            </div>
                                            <select class="form-control" id="duracionConsulta" name="duracionConsulta" required>
                                                <option value="15" ${(horario != null && horario.duracionConsulta == 15) ? 'selected' : ''}>15 minutos</option>
                                                <option value="20" ${(horario != null && horario.duracionConsulta == 20) ? 'selected' : ''}>20 minutos</option>
                                                <option value="30" ${(horario != null && horario.duracionConsulta == 30) || horario == null ? 'selected' : ''}>30 minutos (recomendado)</option>
                                                <option value="45" ${(horario != null && horario.duracionConsulta == 45) ? 'selected' : ''}>45 minutos</option>
                                                <option value="60" ${(horario != null && horario.duracionConsulta == 60) ? 'selected' : ''}>60 minutos</option>
                                            </select>
                                        </div>
                                        <small class="form-text text-muted">
                                            Tiempo asignado para cada consulta
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Hora Inicio -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="horaInicio">
                                            Hora de Inicio <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="far fa-clock"></i>
                                                </span>
                                            </div>
                                            <input type="time" 
                                                   class="form-control" 
                                                   id="horaInicio" 
                                                   name="horaInicio" 
                                                   value="${horario != null ? horario.horaInicio : '08:00'}"
                                                   required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hora Fin -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="horaFin">
                                            Hora de Fin <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="far fa-clock"></i>
                                                </span>
                                            </div>
                                            <input type="time" 
                                                   class="form-control" 
                                                   id="horaFin" 
                                                   name="horaFin" 
                                                   value="${horario != null ? horario.horaFin : '12:00'}"
                                                   required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Estado -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <div class="custom-control custom-switch custom-switch-lg">
                                            <input type="checkbox" 
                                                   class="custom-control-input" 
                                                   id="activo" 
                                                   name="activo"
                                                   ${(horario == null || horario.activo) ? 'checked' : ''}>
                                            <label class="custom-control-label" for="activo">
                                                <strong>Horario Activo</strong>
                                                <br>
                                                <small class="text-muted">
                                                    Si está desactivado, no se podrán agendar citas en este horario
                                                </small>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Vista previa de bloques -->
                            <div class="alert alert-info" id="vistaPrevia" style="display:none;">
                                <h5 class="alert-heading">
                                    <i class="fas fa-info-circle mr-2"></i>
                                    Vista Previa de Bloques
                                </h5>
                                <p id="textoBloques"></p>
                            </div>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Crear Horario' : 'Guardar Cambios'}
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

<!-- Script de validación y vista previa -->
<script>
    $(document).ready(function () {
        // Función para calcular y mostrar vista previa
        function calcularBloques() {
            const horaInicio = $('#horaInicio').val();
            const horaFin = $('#horaFin').val();
            const duracion = parseInt($('#duracionConsulta').val());

            if (horaInicio && horaFin && duracion) {
                const [horaIni, minIni] = horaInicio.split(':').map(Number);
                const [horaFin2, minFin] = horaFin.split(':').map(Number);

                const minutosInicio = horaIni * 60 + minIni;
                const minutosFin = horaFin2 * 60 + minFin;
                const totalMinutos = minutosFin - minutosInicio;

                if (totalMinutos > 0) {
                    const bloques = Math.floor(totalMinutos / duracion);
                    const horas = Math.floor(totalMinutos / 60);

                    $('#textoBloques').html(
                            '<strong>Se generarán ' + bloques + ' bloques de ' + duracion + ' minutos</strong><br>' +
                            'Total de tiempo disponible: ' + horas + ' horas (' + totalMinutos + ' minutos)'
                            );
                    $('#vistaPrevia').fadeIn();
                } else {
                    $('#vistaPrevia').fadeOut();
                }
            }
        }

        // Calcular bloques al cambiar valores
        $('#horaInicio, #horaFin, #duracionConsulta').change(calcularBloques);

        // Calcular al cargar (modo editar)
        calcularBloques();

        // Validación del formulario
        $('#horarioForm').submit(function (e) {
            const horaInicio = $('#horaInicio').val();
            const horaFin = $('#horaFin').val();

            if (horaFin <= horaInicio) {
                e.preventDefault();
                alert('La hora de fin debe ser mayor que la hora de inicio');
                $('#horaFin').focus();
                return false;
            }
        });
    });
</script>
