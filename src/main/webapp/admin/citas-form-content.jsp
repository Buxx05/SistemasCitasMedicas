<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS para las horas -->
<style>
    .hora-slot {
        display: inline-block;
        width: 90px;
        padding: 10px;
        margin: 5px;
        border: 2px solid #ddd;
        border-radius: 5px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: bold;
    }

    .hora-slot.disponible {
        background-color: #d4edda;
        border-color: #28a745;
        color: #155724;
    }

    .hora-slot.disponible:hover {
        background-color: #28a745;
        color: white;
        transform: scale(1.05);
    }

    .hora-slot.ocupada {
        background-color: #f8d7da;
        border-color: #dc3545;
        color: #721c24;
        cursor: not-allowed;
        opacity: 0.6;
    }

    .hora-slot.seleccionada {
        background-color: #007bff;
        border-color: #0056b3;
        color: white;
        transform: scale(1.1);
    }

    #horasContainer {
        min-height: 100px;
        padding: 15px;
        border: 1px dashed #ddd;
        border-radius: 5px;
        text-align: center;
        background-color: #f8f9fa;
    }
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-calendar-plus mr-2"></i>
                    ${tituloFormulario}
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
                    </li>
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

                <!-- Formulario de cita -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-plus mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/CitaServlet" 
                          method="post" 
                          id="citaForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="${accion}">
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idCita" value="${cita.idCita}">
                        </c:if>
                        <!-- Campo oculto para la hora seleccionada -->
                        <input type="hidden" name="horaCita" id="horaCitaInput" required>

                        <div class="card-body">

                            <!-- ========== SECCIÓN 1: PACIENTE Y PROFESIONAL ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-users mr-2"></i>
                                Paciente y Profesional
                            </h5>

                            <div class="row">
                                <!-- Paciente -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="idPaciente">
                                            <i class="fas fa-user-injured mr-1"></i>
                                            Paciente <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-control select2" id="idPaciente" name="idPaciente" required>
                                            <option value="">Seleccione un paciente</option>
                                            <c:forEach var="pac" items="${pacientes}">
                                                <option value="${pac.idPaciente}" 
                                                        ${(accion == 'actualizar' && cita.idPaciente == pac.idPaciente) ? 'selected' : ''}>
                                                    ${pac.nombreCompleto} - DNI: ${pac.dni}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <!-- Profesional -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="idProfesional">
                                            <i class="fas fa-user-md mr-1"></i>
                                            Profesional <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-control select2" id="idProfesional" name="idProfesional" required>
                                            <option value="">Seleccione un profesional</option>
                                            <c:forEach var="prof" items="${profesionales}">
                                                <option value="${prof.idProfesional}" 
                                                        ${(accion == 'actualizar' && cita.idProfesional == prof.idProfesional) ? 'selected' : ''}>
                                                    ${prof.nombreUsuario} - ${prof.nombreEspecialidad}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- ========== SECCIÓN 2: FECHA Y HORA ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-calendar-day mr-2"></i>
                                Fecha y Hora de la Cita
                            </h5>

                            <!-- Fecha -->
                            <div class="form-group">
                                <label for="fechaCita">
                                    <i class="far fa-calendar mr-1"></i>
                                    Fecha <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fas fa-calendar-alt"></i>
                                        </span>
                                    </div>
                                    <input type="date" 
                                           class="form-control form-control-lg" 
                                           id="fechaCita" 
                                           name="fechaCita" 
                                           value="${accion == 'actualizar' ? cita.fechaCita : ''}"
                                           onkeydown="return false"
                                           onclick="this.showPicker ? this.showPicker() : null"
                                           style="cursor: pointer;"
                                           required>
                                </div>
                                <small class="form-text text-muted">
                                    <i class="fas fa-mouse-pointer mr-1"></i>
                                    Haz clic para abrir el calendario
                                </small>
                            </div>


                            <!-- Selector de Horas Disponibles -->
                            <div class="form-group">
                                <label>
                                    <i class="far fa-clock mr-1"></i>
                                    Hora Disponible <span class="text-danger">*</span>
                                </label>
                                <div id="horasContainer">
                                    <p class="text-muted">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        Selecciona un profesional y una fecha para ver las horas disponibles
                                    </p>
                                </div>
                                <small class="form-text text-muted">
                                    <span class="badge badge-success">Verde</span> = Disponible &nbsp;
                                    <span class="badge badge-danger">Rojo</span> = Ocupado &nbsp;
                                    <span class="badge badge-primary">Azul</span> = Seleccionado
                                </small>
                            </div>

                            <hr class="my-4">

                            <!-- ========== SECCIÓN 3: DETALLES ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-file-medical mr-2"></i>
                                Detalles de la Cita
                            </h5>

                            <!-- Motivo -->
                            <div class="form-group">
                                <label for="motivoConsulta">
                                    <i class="fas fa-notes-medical mr-1"></i>
                                    Motivo de Consulta
                                </label>
                                <textarea class="form-control" 
                                          id="motivoConsulta" 
                                          name="motivoConsulta" 
                                          rows="3" 
                                          placeholder="Describa brevemente el motivo de la consulta...">${accion == 'actualizar' ? cita.motivoConsulta : ''}</textarea>
                            </div>

                            <!-- Estado (solo en modo editar, readonly) -->
                            <c:if test="${accion == 'actualizar'}">
                                <div class="form-group">
                                    <label for="estadoDisplay">
                                        <i class="fas fa-info-circle mr-1"></i>
                                        Estado (Solo lectura)
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="estadoDisplay"
                                           value="${cita.estado}" 
                                           readonly>
                                    <input type="hidden" name="estado" value="${cita.estado}">
                                    <small class="form-text text-muted">
                                        El estado es modificado por el profesional médico
                                    </small>
                                </div>
                            </c:if>

                            <!-- Observaciones -->
                            <div class="form-group">
                                <label for="observaciones">
                                    <i class="fas fa-sticky-note mr-1"></i>
                                    Observaciones Administrativas
                                </label>
                                <textarea class="form-control" 
                                          id="observaciones" 
                                          name="observaciones" 
                                          rows="2" 
                                          placeholder="Notas internas o instrucciones especiales...">${accion == 'actualizar' ? cita.observaciones : ''}</textarea>
                            </div>

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle mr-2"></i>
                                <strong>Nota:</strong> La cita se creará con estado PENDIENTE. El profesional médico podrá completarla o cancelarla.
                            </div>

                        </div>

                        <!-- Botones -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg" id="btnSubmit">
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

<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- Script AJAX -->
<!-- Script AJAX -->
<script>
                                               const contextPath = '${pageContext.request.contextPath}';
                                               let horaSeleccionada = null;

                                               $(document).ready(function () {
                                                   console.log('✅ Inicializando formulario de citas (Admin)');

                                                   // Inicializar Select2
                                                   $('.select2').select2({
                                                       theme: 'bootstrap4',
                                                       width: '100%',
                                                       placeholder: 'Seleccione una opción'
                                                   });

                                                   // Establecer fecha mínima (hoy)
                                                   const today = new Date().toISOString().split('T')[0];
                                                   $('#fechaCita').attr('min', today);
                                                   console.log('📅 Fecha mínima:', today);

                                                   // ========== EVENTOS ==========

                                                   // Cuando cambia el profesional
                                                   $('#idProfesional').on('change', function () {
                                                       const idProf = $(this).val();
                                                       console.log('👤 Cambió profesional:', idProf);
                                                       resetearHorarios();
                                                       const fecha = $('#fechaCita').val();
                                                       if (fecha && fecha.length === 10 && idProf) {
                                                           cargarHorasDisponibles();
                                                       }
                                                   });

                                                   // Cuando cambia la fecha (SOLO desde calendario)
                                                   $('#fechaCita').on('change', function () {
                                                       const fecha = $(this).val();

                                                       if (!fecha || fecha.length !== 10) {
                                                           console.log('⚠️ Fecha vacía o incompleta');
                                                           return;
                                                       }

                                                       console.log('📅 Fecha del calendario:', fecha);

                                                       const fechaObj = new Date(fecha + 'T00:00:00');
                                                       const hoy = new Date(today + 'T00:00:00');

                                                       if (isNaN(fechaObj.getTime())) {
                                                           alert('⚠️ Fecha inválida');
                                                           $(this).val('');
                                                           resetearHorarios();
                                                           return;
                                                       }

                                                       if (fechaObj < hoy) {
                                                           alert('⚠️ No se pueden agendar citas en fechas pasadas');
                                                           $(this).val('');
                                                           resetearHorarios();
                                                           return;
                                                       }

                                                       cargarHorasDisponibles();
                                                   });

                                                   // Validación del formulario
                                                   $('#citaForm').submit(function (e) {
                                                       const idPaciente = $('#idPaciente').val();
                                                       const idProfesional = $('#idProfesional').val();
                                                       const fecha = $('#fechaCita').val();
                                                       const hora = $('#horaCitaInput').val();

                                                       console.log('🚀 Validando formulario...');
                                                       console.log('Paciente:', idPaciente);
                                                       console.log('Profesional:', idProfesional);
                                                       console.log('Fecha:', fecha);
                                                       console.log('Hora:', hora);

                                                       if (!idPaciente) {
                                                           e.preventDefault();
                                                           alert('⚠️ Debe seleccionar un paciente');
                                                           $('#idPaciente').focus();
                                                           return false;
                                                       }

                                                       if (!idProfesional) {
                                                           e.preventDefault();
                                                           alert('⚠️ Debe seleccionar un profesional');
                                                           $('#idProfesional').focus();
                                                           return false;
                                                       }

                                                       if (!fecha) {
                                                           e.preventDefault();
                                                           alert('⚠️ Debe seleccionar una fecha');
                                                           $('#fechaCita').focus();
                                                           return false;
                                                       }

                                                       if (!hora) {
                                                           e.preventDefault();
                                                           alert('⚠️ Debe seleccionar una hora disponible');
                                                           return false;
                                                       }

                                                       console.log('✅ Formulario válido, enviando...');
                                                       return true;
                                                   });

                                                   // Si estamos editando, cargar hora actual
    <c:if test="${accion == 'actualizar'}">
                                                   console.log('📝 Modo edición, cargando datos...');
                                                   horaSeleccionada = '${cita.horaCita}';
                                                   if (horaSeleccionada.length > 5) {
                                                       horaSeleccionada = horaSeleccionada.substring(0, 5);
                                                   }
                                                   $('#horaCitaInput').val('${cita.horaCita}');
                                                   console.log('⏰ Hora precargada:', horaSeleccionada);

                                                   setTimeout(function () {
                                                       cargarHorasDisponibles();
                                                   }, 500);
    </c:if>
                                               });

                                               /**
                                                * Carga las horas disponibles mediante AJAX
                                                */
                                               function cargarHorasDisponibles() {
                                                   const idProfesional = $('#idProfesional').val();
                                                   const fecha = $('#fechaCita').val();
                                                   const container = $('#horasContainer');

                                                   console.log('=== CARGANDO HORARIOS ===');
                                                   console.log('ID Profesional:', idProfesional);
                                                   console.log('Fecha:', fecha);

                                                   if (!idProfesional) {
                                                       console.log('⚠️ Falta profesional');
                                                       container.html('<p class="text-muted"><i class="fas fa-info-circle mr-2"></i>Selecciona un profesional primero</p>');
                                                       return;
                                                   }

                                                   if (!fecha || fecha.length !== 10) {
                                                       console.log('⚠️ Falta fecha o fecha incompleta');
                                                       container.html('<p class="text-muted"><i class="fas fa-info-circle mr-2"></i>Selecciona una fecha completa</p>');
                                                       return;
                                                   }

                                                   container.html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x text-primary"></i><p class="mt-2">Cargando horas disponibles...</p></div>');

                                                   $.ajax({
                                                       url: contextPath + '/ObtenerHorasDisponiblesServlet',
                                                       method: 'GET',
                                                       data: {
                                                           idProfesional: idProfesional,
                                                           fecha: fecha
                                                       },
                                                       dataType: 'json',
                                                       success: function (response) {
                                                           console.log('✅ Respuesta AJAX recibida');
                                                           console.log('Response:', response);

                                                           if (response.success) {
                                                               console.log('📊 Horas:', response.horas);
                                                               mostrarHorasDisponibles(response.horas);
                                                           } else {
                                                               console.log('⚠️', response.message);
                                                               container.html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle mr-2"></i>' + response.message + '</div>');
                                                           }
                                                       },
                                                       error: function (xhr, status, error) {
                                                           console.log('❌ ERROR AJAX');
                                                           console.log('Status:', status);
                                                           console.log('Error:', error);
                                                           console.log('Response:', xhr.responseText);
                                                           container.html('<div class="alert alert-danger"><i class="fas fa-times-circle mr-2"></i>Error al cargar las horas. Revisa la consola (F12).</div>');
                                                       }
                                                   });
                                               }

                                               /**
                                                * Muestra las horas disponibles como botones
                                                */
                                               function mostrarHorasDisponibles(horas) {
                                                   const container = $('#horasContainer');
                                                   container.empty();

                                                   console.log('🎨 Mostrando horarios...');

                                                   if (!horas || horas.length === 0) {
                                                       container.html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle mr-2"></i>No hay horas disponibles para esta fecha</div>');
                                                       console.log('⚠️ Sin horarios disponibles');
                                                       return;
                                                   }

                                                   let contadorDisponibles = 0;

                                                   horas.forEach(function (slot) {
                                                       const claseDisponible = slot.disponible ? 'disponible' : 'ocupada';

                                                       const boton = $('<div>')
                                                               .addClass('hora-slot ' + claseDisponible)
                                                               .text(slot.hora)
                                                               .data('hora', slot.hora);

                                                       if (slot.disponible) {
                                                           contadorDisponibles++;
                                                           boton.on('click', function () {
                                                               seleccionarHora($(this));
                                                           });
                                                       }

                                                       if (slot.hora === horaSeleccionada) {
                                                           boton.addClass('seleccionada');
                                                           console.log('✅ Hora precargada seleccionada:', slot.hora);
                                                       }

                                                       container.append(boton);
                                                   });

                                                   console.log('✅ Mostrados', horas.length, 'horarios (' + contadorDisponibles + ' disponibles)');
                                               }

                                               /**
                                                * Selecciona una hora
                                                */
                                               function seleccionarHora(boton) {
                                                   $('.hora-slot').removeClass('seleccionada');
                                                   boton.addClass('seleccionada');
                                                   horaSeleccionada = boton.data('hora');
                                                   $('#horaCitaInput').val(horaSeleccionada + ':00');
                                                   console.log('⏰ Hora seleccionada:', horaSeleccionada);
                                               }

                                               /**
                                                * Resetea los horarios
                                                */
                                               function resetearHorarios() {
                                                   horaSeleccionada = null;
                                                   $('#horaCitaInput').val('');
                                                   $('#horasContainer').html('<p class="text-muted"><i class="fas fa-info-circle mr-2"></i>Selecciona un profesional y una fecha para ver las horas disponibles</p>');
                                                   console.log('🔄 Horarios reseteados');
                                               }
</script>

