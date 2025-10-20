<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas ${empty receta ? 'fa-plus' : 'fa-edit'} mr-2"></i>
                    ${empty receta ? 'Nueva Receta Médica' : 'Editar Receta Médica'}
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/RecetaMedicaServlet">Recetas</a>
                    </li>
                    <li class="breadcrumb-item active">
                        ${empty receta ? 'Nueva' : 'Editar'}
                    </li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<section class="content">
    <div class="container-fluid">

        <!-- Alertas -->
        <jsp:include page="/componentes/alert.jsp"/>

        <!-- Información de receta en edición -->
        <c:if test="${not empty receta}">
            <div class="alert alert-info alert-dismissible fade show">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <h5>
                    <i class="icon fas fa-file-prescription"></i> 
                    Editando Receta: <span class="badge badge-light">${receta.codigoReceta}</span>
                </h5>
                <strong>Paciente:</strong> ${receta.nombrePaciente} (${receta.codigoPaciente})<br/>
                <strong>Fecha Emisión:</strong> 
                <fmt:parseDate value="${receta.fechaEmision}" pattern="yyyy-MM-dd" var="fechaEmi"/>
                <fmt:formatDate value="${fechaEmi}" pattern="dd/MM/yyyy"/>
            </div>
        </c:if>

        <!-- Información de cita seleccionada -->
        <c:if test="${not empty citaSeleccionada}">
            <div class="alert alert-success alert-dismissible fade show">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <h5>
                    <i class="icon fas fa-calendar-check"></i> 
                    Receta para Cita: <span class="badge badge-light">${citaSeleccionada.codigoCita}</span>
                </h5>
                <div class="row">
                    <div class="col-md-6">
                        <strong>Paciente:</strong> ${citaSeleccionada.nombrePaciente}<br/>
                        <strong>DNI:</strong> ${citaSeleccionada.dniPaciente}
                    </div>
                    <div class="col-md-6">
                        <c:if test="${not empty citaSeleccionada.fechaCita}">
                            <strong>Fecha:</strong>
                            <fmt:parseDate value="${citaSeleccionada.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaPar"/>
                            <fmt:formatDate value="${fechaCitaPar}" pattern="dd/MM/yyyy"/>
                            <c:if test="${not empty citaSeleccionada.horaCita && citaSeleccionada.horaCita.length() >= 5}">
                                a las ${citaSeleccionada.horaCita.substring(0, 5)}
                            </c:if>
                            <br/>
                        </c:if>
                        <c:if test="${not empty citaSeleccionada.motivoConsulta}">
                            <strong>Motivo:</strong> ${citaSeleccionada.motivoConsulta}
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Información del paciente seleccionado -->
        <c:if test="${not empty pacienteSeleccionado && empty citaSeleccionada}">
            <div class="alert alert-info alert-dismissible fade show">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <h5>
                    <i class="icon fas fa-user-circle"></i> 
                    Paciente Seleccionado: <span class="badge badge-light">${pacienteSeleccionado.codigoPaciente}</span>
                </h5>
                <div class="row">
                    <div class="col-md-4">
                        <strong>Nombre:</strong> ${pacienteSeleccionado.nombreCompleto}
                    </div>
                    <div class="col-md-4">
                        <strong>DNI:</strong> ${pacienteSeleccionado.dni}
                    </div>
                    <div class="col-md-4">
                        <strong>Edad:</strong> ${pacienteSeleccionado.edad} años
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Formulario -->
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-prescription mr-2"></i>
                            Datos de la Receta Médica
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                          method="POST" 
                          id="recetaForm"
                          novalidate>

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="${empty receta ? 'crear' : 'actualizar'}"/>
                        <c:if test="${not empty receta}">
                            <input type="hidden" name="idReceta" value="${receta.idReceta}"/>
                            <input type="hidden" name="idCita" value="${receta.idCita}"/>
                            <input type="hidden" name="idPaciente" value="${receta.idPaciente}"/>
                        </c:if>

                        <div class="card-body">

                            <!-- SECCIÓN: Selección de Paciente y Cita (solo en nueva receta) -->
                            <c:if test="${empty receta}">

                                <h5 class="mb-3">
                                    <i class="fas fa-user-md text-primary mr-2"></i>
                                    Selección de Paciente y Cita
                                </h5>

                                <div class="form-group">
                                    <label for="idPaciente">
                                        <i class="fas fa-user-circle mr-1"></i> 
                                        Paciente <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-control select2" 
                                            id="idPaciente" 
                                            name="idPaciente" 
                                            onchange="cargarCitasPaciente(this.value)"
                                            required>
                                        <option value="">-- Seleccione un paciente --</option>
                                        <c:forEach var="pac" items="${pacientes}">
                                            <option value="${pac.idPaciente}"
                                                    data-codigo="${pac.codigoPaciente}"
                                                    <c:if test="${(not empty pacienteSeleccionado && pacienteSeleccionado.idPaciente == pac.idPaciente) || (not empty citaSeleccionada && citaSeleccionada.idPaciente == pac.idPaciente)}">selected</c:if>>
                                                [${pac.codigoPaciente}] ${pac.nombreCompleto} - DNI: ${pac.dni}
                                                <c:if test="${pac.edad > 0}"> - ${pac.edad} años</c:if>
                                                </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-info-circle"></i>
                                        Selecciona el paciente para ver sus citas completadas
                                    </small>
                                </div>

                                <div class="form-group">
                                    <label for="idCita">
                                        <i class="fas fa-calendar-check mr-1"></i> 
                                        Cita Vinculada <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-control" 
                                            id="idCita" 
                                            name="idCita" 
                                            required>
                                        <option value="">-- Seleccione una cita completada --</option>
                                        <c:choose>
                                            <c:when test="${not empty citasPaciente}">
                                                <c:forEach var="cita" items="${citasPaciente}">
                                                    <option value="${cita.idCita}"
                                                            <c:if test="${not empty citaSeleccionada && citaSeleccionada.idCita == cita.idCita}">selected</c:if>>
                                                        [${cita.codigoCita}] 
                                                        <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaCit"/>
                                                        <fmt:formatDate value="${fechaCit}" pattern="dd/MM/yyyy"/>
                                                        - ${not empty cita.horaCita && cita.horaCita.length() >= 5 ? cita.horaCita.substring(0, 5) : 'N/A'}
                                                        - ${not empty cita.motivoConsulta ? cita.motivoConsulta : 'Sin motivo'}
                                                    </option>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <option disabled>Seleccione primero un paciente</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </select>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-check-circle"></i>
                                        Solo se muestran citas completadas del paciente seleccionado
                                    </small>
                                </div>

                                <hr class="my-4">

                            </c:if>

                            <!-- SECCIÓN: Información del Paciente (solo en edición) -->
                            <c:if test="${not empty receta}">
                                <div class="alert alert-light border">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <strong><i class="fas fa-user-circle text-primary mr-2"></i>Paciente:</strong> 
                                            ${receta.nombrePaciente}
                                        </div>
                                        <div class="col-md-3">
                                            <strong><i class="fas fa-id-badge text-info mr-2"></i>Código:</strong> 
                                            ${receta.codigoPaciente}
                                        </div>
                                        <div class="col-md-3">
                                            <strong><i class="fas fa-id-card text-secondary mr-2"></i>DNI:</strong> 
                                            ${receta.dniPaciente}
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- SECCIÓN: Prescripción Médica -->
                            <h5 class="mb-3">
                                <i class="fas fa-pills text-success mr-2"></i>
                                Prescripción Médica
                            </h5>

                            <!-- Medicamentos -->
                            <div class="form-group">
                                <label for="medicamentos">
                                    <i class="fas fa-pills mr-1"></i> 
                                    Medicamentos Prescritos <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="medicamentos" 
                                          name="medicamentos" 
                                          rows="3" 
                                          placeholder="Ejemplo: Losartán 50mg, Paracetamol 500mg, Omeprazol 20mg"
                                          required><c:if test="${not empty receta}">${receta.medicamentos}</c:if></textarea>
                                          <small class="form-text text-muted">
                                              Ingrese los medicamentos con su concentración
                                          </small>
                                </div>

                                <div class="row">
                                    <!-- Dosis -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="dosis">
                                                <i class="fas fa-prescription-bottle mr-1"></i> 
                                                Dosis <span class="text-danger">*</span>
                                            </label>
                                            <textarea class="form-control" 
                                                      id="dosis" 
                                                      name="dosis" 
                                                      rows="2" 
                                                      placeholder="Ejemplo: 1 tableta, 1 cápsula, 5ml"
                                                      required><c:if test="${not empty receta}">${receta.dosis}</c:if></textarea>
                                        </div>
                                    </div>

                                    <!-- Frecuencia -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="frecuencia">
                                                <i class="fas fa-clock mr-1"></i> 
                                                Frecuencia <span class="text-danger">*</span>
                                            </label>
                                            <textarea class="form-control" 
                                                      id="frecuencia" 
                                                      name="frecuencia" 
                                                      rows="2" 
                                                      placeholder="Ejemplo: 1 vez al día (mañana), Cada 8 horas, 3 veces al día"
                                                      required><c:if test="${not empty receta}">${receta.frecuencia}</c:if></textarea>
                                        </div>
                                    </div>
                                </div>

                                <!-- Duración y Vigencia -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="duracion">
                                                <i class="fas fa-calendar-alt mr-1"></i> 
                                                Duración del Tratamiento
                                            </label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="duracion" 
                                                   name="duracion" 
                                                   placeholder="Ejemplo: 7 días, 2 semanas, 1 mes"
                                                   value="${not empty receta ? receta.duracion : ''}"/>
                                        <small class="form-text text-muted">
                                            Tiempo de duración del tratamiento
                                        </small>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="fechaVigencia">
                                            <i class="fas fa-calendar-check mr-1"></i> 
                                            Vigencia de la Receta <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" 
                                               class="form-control" 
                                               id="fechaVigencia" 
                                               name="fechaVigencia" 
                                               value="${not empty receta ? receta.fechaVigencia : ''}"
                                               required/>
                                        <small class="form-text text-muted">
                                            Fecha hasta la cual la receta es válida
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- SECCIÓN: Indicaciones -->
                            <h5 class="mb-3">
                                <i class="fas fa-exclamation-triangle text-warning mr-2"></i>
                                Indicaciones y Observaciones
                            </h5>

                            <!-- Indicaciones -->
                            <div class="form-group">
                                <label for="indicaciones">
                                    <i class="fas fa-exclamation-triangle mr-1"></i> 
                                    Indicaciones Generales <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="indicaciones" 
                                          name="indicaciones" 
                                          rows="3" 
                                          placeholder="Instrucciones de uso, precauciones, interacciones, etc."
                                          required><c:if test="${not empty receta}">${receta.indicaciones}</c:if></textarea>
                                          <small class="form-text text-muted">
                                              Instrucciones importantes para el paciente
                                          </small>
                                </div>

                                <!-- Observaciones -->
                                <div class="form-group">
                                    <label for="observaciones">
                                        <i class="fas fa-sticky-note mr-1"></i> 
                                        Observaciones Adicionales
                                    </label>
                                    <textarea class="form-control" 
                                              id="observaciones" 
                                              name="observaciones" 
                                              rows="2" 
                                              placeholder="Notas adicionales, recomendaciones especiales..."><c:if test="${not empty receta}">${receta.observaciones}</c:if></textarea>
                                    <small class="form-text text-muted">
                                        Información complementaria (opcional)
                                    </small>
                                </div>

                            </div>

                            <!-- Card Footer -->
                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-save mr-2"></i> 
                                ${empty receta ? 'Emitir Receta' : 'Guardar Cambios'}
                            </button>
                            <button type="button" class="btn btn-secondary btn-lg" onclick="confirmarCancelar()">
                                <i class="fas fa-times mr-2"></i> 
                                Cancelar
                            </button>
                            <small class="text-muted float-right mt-2">
                                <i class="fas fa-info-circle"></i>
                                Los campos con <span class="text-danger">*</span> son obligatorios
                            </small>
                        </div>

                    </form>
                </div>
            </div>
        </div>

    </div>
</section>

<!-- Select2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css" rel="stylesheet"/>

<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- ✅ Script con SweetAlert2 -->
<script>
                                const contextPath = '${pageContext.request.contextPath}';

                                $(document).ready(function () {
                                    // Verificar jQuery
                                    if (typeof jQuery === 'undefined') {
                                        console.error('jQuery no está cargado');
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error de carga',
                                            text: 'jQuery no se cargó correctamente. Por favor, recarga la página.',
                                            confirmButtonColor: '#dc3545'
                                        });
                                        return;
                                    }

                                    // Inicializar Select2
                                    if (typeof $.fn.select2 !== 'undefined') {
                                        $('.select2').select2({
                                            theme: 'bootstrap4',
                                            placeholder: '-- Seleccione un paciente --',
                                            allowClear: true,
                                            width: '100%'
                                        });
                                    } else {
                                        console.warn('Select2 no está cargado');
                                    }

                                    // Auto-establecer fecha vigencia (+30 días) si es nueva receta
    <c:if test="${empty receta}">
                                    var hoy = new Date();
                                    var vigencia = new Date(hoy.getTime() + (30 * 24 * 60 * 60 * 1000));
                                    $('#fechaVigencia').val(vigencia.toISOString().split('T')[0]);
    </c:if>

                                    // Establecer fecha mínima = hoy
                                    var hoyISO = new Date().toISOString().split('T')[0];
                                    $('#fechaVigencia').attr('min', hoyISO);

                                    // ✅ Validar formulario con SweetAlert2
                                    $('#recetaForm').on('submit', function (e) {
                                        if (this.checkValidity() === false) {
                                            e.preventDefault();
                                            e.stopPropagation();

                                            // Encontrar el primer campo inválido
                                            var primerInvalido = $(this).find(':invalid').first();
                                            var nombreCampo = primerInvalido.attr('name') || 'campo';

                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'Campos incompletos',
                                                text: 'Por favor, completa todos los campos obligatorios antes de continuar.',
                                                confirmButtonColor: '#ffc107'
                                            });

                                            // Hacer scroll al primer campo inválido
                                            if (primerInvalido.length) {
                                                $('html, body').animate({
                                                    scrollTop: primerInvalido.offset().top - 100
                                                }, 500);
                                                primerInvalido.focus();
                                            }
                                        }
                                        $(this).addClass('was-validated');
                                    });
                                });

                                /**
                                 * ✅ Confirmar cancelación con SweetAlert2
                                 */
                                function confirmarCancelar() {
                                    // Verificar si hay datos en los campos principales
                                    var medicamentos = $('#medicamentos').val().trim();
                                    var dosis = $('#dosis').val().trim();
                                    var frecuencia = $('#frecuencia').val().trim();
                                    var indicaciones = $('#indicaciones').val().trim();

                                    var hayCambios = medicamentos !== '' || dosis !== '' || frecuencia !== '' || indicaciones !== '';

                                    if (hayCambios) {
                                        Swal.fire({
                                            title: '¿Cancelar sin guardar?',
                                            html: 'Tienes cambios sin guardar en la receta.<br>¿Estás seguro de que deseas salir?',
                                            icon: 'question',
                                            showCancelButton: true,
                                            confirmButtonColor: '#6c757d',
                                            cancelButtonColor: '#007bff',
                                            confirmButtonText: '<i class="fas fa-times"></i> Sí, salir',
                                            cancelButtonText: '<i class="fas fa-arrow-left"></i> Continuar editando',
                                            reverseButtons: true
                                        }).then((result) => {
                                            if (result.isConfirmed) {
                                                window.location.href = contextPath + '/RecetaMedicaServlet';
                                            }
                                        });
                                    } else {
                                        // Si no hay cambios, redirigir directamente
                                        window.location.href = contextPath + '/RecetaMedicaServlet';
                                    }
                                }

                                /**
                                 * Carga las citas del paciente seleccionado
                                 */
                                function cargarCitasPaciente(idPaciente) {
                                    if (!idPaciente) {
                                        $('#idCita').html('<option value="">-- Seleccione una cita completada --</option>');
                                        return;
                                    }
                                    window.location.href = contextPath + '/RecetaMedicaServlet?accion=nueva&idPaciente=' + idPaciente;
                                }
</script>
