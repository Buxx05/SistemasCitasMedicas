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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/CitaServlet">Citas</a></li>
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
                            <i class="fas fa-calendar-plus mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/CitaServlet" 
                          method="post" 
                          id="citaForm">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idCita" value="${cita.idCita}">
                        </c:if>

                        <div class="card-body">

                            <!-- ========== SECCIÓN: DATOS DEL PACIENTE Y PROFESIONAL ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-users mr-2"></i>
                                Paciente y Profesional
                            </h5>

                            <div class="row">
                                <!-- Paciente -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="idPaciente">
                                            Paciente <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user-injured"></i>
                                                </span>
                                            </div>
                                            <select class="form-control select2" id="idPaciente" name="idPaciente" required>
                                                <option value="">Seleccione un paciente</option>
                                                <c:forEach var="pac" items="${pacientes}">
                                                    <option value="${pac.idPaciente}" 
                                                            ${(cita != null && cita.idPaciente == pac.idPaciente) || param.idPaciente == pac.idPaciente ? 'selected' : ''}>
                                                        ${pac.nombreCompleto} - DNI: ${pac.dni}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Profesional -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="idProfesional">
                                            Profesional <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user-md"></i>
                                                </span>
                                            </div>
                                            <select class="form-control select2" id="idProfesional" name="idProfesional" required>
                                                <option value="">Seleccione un profesional</option>
                                                <c:forEach var="prof" items="${profesionales}">
                                                    <option value="${prof.idProfesional}" 
                                                            ${(cita != null && cita.idProfesional == prof.idProfesional) || param.idProfesional == prof.idProfesional ? 'selected' : ''}>
                                                        ${prof.nombreUsuario} - ${prof.nombreEspecialidad}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- ========== SECCIÓN: FECHA Y HORA ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-calendar-day mr-2"></i>
                                Fecha y Hora de la Cita
                            </h5>

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
                                                   value="${cita != null ? cita.fechaCita : param.fechaCita}"
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
                                            <select class="form-control" 
                                                    id="horaCita" 
                                                    name="horaCita" 
                                                    required
                                                    disabled>
                                                <option value="">Seleccione profesional y fecha primero</option>
                                            </select>
                                        </div>
                                        <small class="form-text text-muted">
                                            Los horarios se cargan según la disponibilidad del profesional
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- ========== SECCIÓN: DETALLES DE LA CITA ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-file-medical mr-2"></i>
                                Detalles de la Cita
                            </h5>

                            <div class="row">
                                <!-- Motivo -->
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="motivoConsulta">
                                            Motivo de Consulta
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
                                                      placeholder="Describa brevemente el motivo de la consulta...">${cita != null ? cita.motivoConsulta : param.motivoConsulta}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Estado (solo en modo editar) -->
                            <c:if test="${accion == 'actualizar'}">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="estado">
                                                Estado <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">
                                                        <i class="fas fa-info-circle"></i>
                                                    </span>
                                                </div>
                                                <select class="form-control" id="estado" name="estado" required>
                                                    <option value="CONFIRMADA" ${cita.estado == 'CONFIRMADA' ? 'selected' : ''}>Confirmada</option>
                                                    <option value="COMPLETADA" ${cita.estado == 'COMPLETADA' ? 'selected' : ''}>Completada</option>
                                                    <option value="CANCELADA" ${cita.estado == 'CANCELADA' ? 'selected' : ''}>Cancelada</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Observaciones -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="observaciones">
                                            Observaciones
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
                                                      placeholder="Notas adicionales o instrucciones especiales...">${cita != null ? cita.observaciones : param.observaciones}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Agendar Cita' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/CitaServlet" 
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

<!-- Select2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css">

<!-- Select2 JS (se carga después de jQuery del layout) -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- Script personalizado -->
<!-- ========== SCRIPTS (AL FINAL) ========== -->

<script>
// Esperar a que jQuery del layout.jsp esté disponible
    (function esperarJQuery() {
        if (typeof jQuery === 'undefined') {
            setTimeout(esperarJQuery, 50);
            return;
        }

        console.log('✅ jQuery disponible, cargando Select2...');

        // Cargar CSS de Select2
        var link1 = document.createElement('link');
        link1.rel = 'stylesheet';
        link1.href = 'https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css';
        document.head.appendChild(link1);

        var link2 = document.createElement('link');
        link2.rel = 'stylesheet';
        link2.href = 'https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css';
        document.head.appendChild(link2);

        // Cargar JS de Select2
        var script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js';
        script.onload = function () {
            console.log('✅ Select2 cargado');
            inicializarFormulario();
        };
        document.body.appendChild(script);
    })();

// Función principal del formulario
    function inicializarFormulario() {
        $(document).ready(function () {
            console.log('✅ Inicializando formulario de citas');

            // Inicializar Select2
            $('.select2').select2({
                theme: 'bootstrap4',
                width: '100%'
            });
            console.log('✅ Select2 inicializado');

            // Fecha mínima (hoy)
            const today = new Date().toISOString().split('T')[0];
            $('#fechaCita').attr('min', today);

            // ========== CARGA DINÁMICA DE HORARIOS ==========

            function cargarHorariosDisponibles() {
                const idProfesional = $('#idProfesional').val();
                const fecha = $('#fechaCita').val();

                console.log('=== CARGANDO HORARIOS ===');
                console.log('ID Profesional:', idProfesional);
                console.log('Fecha:', fecha);

                if (!idProfesional || !fecha) {
                    console.log('⚠️ Faltan datos');
                    $('#horaCita').html('<option value="">Seleccione profesional y fecha primero</option>');
                    $('#horaCita').prop('disabled', true);
                    return;
                }

                $('#horaCita').html('<option value="">⏳ Cargando horarios...</option>');
                $('#horaCita').prop('disabled', true);

                const url = '${pageContext.request.contextPath}/CitaServlet?accion=obtenerHorarios&idProfesional=' + idProfesional + '&fecha=' + fecha;
                console.log('🌐 URL AJAX:', url);

                $.ajax({
                    url: url,
                    type: 'GET',
                    dataType: 'json',
                    success: function (horarios) {
                        console.log('✅ Respuesta exitosa');
                        console.log('📋 Horarios:', horarios);
                        console.log('📊 Cantidad:', horarios.length);

                        $('#horaCita').html('');

                        if (horarios.length > 0) {
                            $('#horaCita').append('<option value="">Seleccione un horario</option>');

                            horarios.forEach(function (hora) {
                                $('#horaCita').append('<option value="' + hora + '">' + hora + '</option>');
                            });

                            $('#horaCita').prop('disabled', false);
                            console.log('✅ ' + horarios.length + ' horarios cargados');
                        } else {
                            $('#horaCita').html('<option value="">❌ No hay horarios disponibles</option>');
                            $('#horaCita').prop('disabled', true);
                            console.log('⚠️ No hay horarios para este día');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.log('❌ ERROR AJAX');
                        console.log('Status:', status);
                        console.log('Error:', error);
                        console.log('Response:', xhr.responseText);

                        $('#horaCita').html('<option value="">❌ Error al cargar</option>');
                        $('#horaCita').prop('disabled', true);

                        alert('Error al obtener horarios.\n\nDetalles en consola (F12).');
                    }
                });
            }

            // Eventos
            $('#idProfesional').change(function () {
                console.log('👤 Cambió profesional');
                cargarHorariosDisponibles();
            });

            $('#fechaCita').change(function () {
                console.log('📅 Cambió fecha');
                const fecha = $(this).val();

                if (fecha < today) {
                    alert('⚠️ No se pueden agendar citas en fechas pasadas');
                    $(this).val('');
                    return;
                }

                cargarHorariosDisponibles();
            });

            // Validación
            $('#citaForm').submit(function (e) {
                const fecha = $('#fechaCita').val();
                const hora = $('#horaCita').val();

                if (fecha < today) {
                    e.preventDefault();
                    alert('⚠️ Fecha inválida');
                    $('#fechaCita').focus();
                    return false;
                }

                if (!hora) {
                    e.preventDefault();
                    alert('⚠️ Seleccione un horario');
                    $('#horaCita').focus();
                    return false;
                }

                console.log('✅ Enviando formulario...');
            });
        });
    }
</script>

