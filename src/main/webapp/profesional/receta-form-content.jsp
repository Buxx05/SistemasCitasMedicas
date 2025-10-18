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

        <!-- Información de cita seleccionada -->
        <c:if test="${not empty citaSeleccionada}">
            <div class="alert alert-info alert-dismissible fade show">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <h5><i class="icon fas fa-info-circle"></i> Receta para Cita:</h5>
                <strong>Paciente:</strong> ${citaSeleccionada.nombrePaciente} 
                (DNI: ${citaSeleccionada.dniPaciente})<br/>
                <strong>Fecha:</strong>
                <fmt:parseDate value="${citaSeleccionada.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaPar"/>
                <fmt:formatDate value="${fechaCitaPar}" pattern="dd/MM/yyyy"/>
                a las ${citaSeleccionada.horaCita.substring(0, 5)}<br/>
                <strong>Motivo:</strong> ${citaSeleccionada.motivoConsulta}
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
                                                    <c:if test="${(not empty pacienteSeleccionado && pacienteSeleccionado.idPaciente == pac.idPaciente) || (not empty citaSeleccionada && citaSeleccionada.idPaciente == pac.idPaciente)}">selected</c:if>>
                                                ${pac.nombreCompleto} - DNI: ${pac.dni}
                                            </option>
                                        </c:forEach>
                                    </select>
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
                                        <c:if test="${not empty citasPaciente}">
                                            <c:forEach var="cita" items="${citasPaciente}">
                                                <option value="${cita.idCita}"
                                                        <c:if test="${not empty citaSeleccionada && citaSeleccionada.idCita == cita.idCita}">selected</c:if>>
                                                    <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaCit"/>
                                                    <fmt:formatDate value="${fechaCit}" pattern="dd/MM/yyyy"/>
                                                    - ${cita.horaCita.substring(0, 5)} - ${cita.motivoConsulta}
                                                </option>
                                            </c:forEach>
                                        </c:if>
                                    </select>
                                    <small class="form-text text-muted">
                                        Solo se muestran citas completadas del paciente seleccionado
                                    </small>
                                </div>

                            </c:if>

                            <!-- SECCIÓN: Información del Paciente (solo en edición) -->
                            <c:if test="${not empty receta}">
                                <div class="alert alert-light border">
                                    <strong><i class="fas fa-user-circle mr-2"></i>Paciente:</strong> 
                                    ${receta.nombrePaciente}<br/>
                                    <strong><i class="fas fa-id-card mr-2"></i>DNI:</strong> 
                                    ${receta.dniPaciente}
                                </div>
                            </c:if>

                            <!-- SECCIÓN: Medicamentos -->
                            <div class="form-group">
                                <label for="medicamentos">
                                    <i class="fas fa-pills mr-1"></i> 
                                    Medicamentos Prescritos <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="medicamentos" 
                                          name="medicamentos" 
                                          rows="3" 
                                          placeholder="Ejemplo: Losartán 50mg, Paracetamol 500mg"
                                          required><c:if test="${not empty receta}">${receta.medicamentos}</c:if></textarea>
                                </div>

                                <!-- SECCIÓN: Dosis -->
                                <div class="form-group">
                                    <label for="dosis">
                                        <i class="fas fa-prescription-bottle mr-1"></i> 
                                        Dosis <span class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" 
                                              id="dosis" 
                                              name="dosis" 
                                              rows="2" 
                                              placeholder="Ejemplo: 1 tableta, 1 cápsula"
                                              required><c:if test="${not empty receta}">${receta.dosis}</c:if></textarea>
                                </div>

                                <!-- SECCIÓN: Frecuencia -->
                                <div class="form-group">
                                    <label for="frecuencia">
                                        <i class="fas fa-clock mr-1"></i> 
                                        Frecuencia <span class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" 
                                              id="frecuencia" 
                                              name="frecuencia" 
                                              rows="2" 
                                              placeholder="Ejemplo: 1 vez al día (mañana), Cada 8 horas"
                                              required><c:if test="${not empty receta}">${receta.frecuencia}</c:if></textarea>
                                </div>

                                <!-- SECCIÓN: Duración y Vigencia (en 2 columnas) -->
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
                                                   placeholder="Ejemplo: 7 días, 1 mes"
                                                   value="${not empty receta ? receta.duracion : ''}"/>
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
                                    </div>
                                </div>
                            </div>

                            <!-- SECCIÓN: Indicaciones -->
                            <div class="form-group">
                                <label for="indicaciones">
                                    <i class="fas fa-exclamation-triangle mr-1"></i> 
                                    Indicaciones Generales <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="indicaciones" 
                                          name="indicaciones" 
                                          rows="3" 
                                          placeholder="Instrucciones de uso, precauciones..."
                                          required><c:if test="${not empty receta}">${receta.indicaciones}</c:if></textarea>
                                </div>

                                <!-- SECCIÓN: Observaciones -->
                                <div class="form-group">
                                    <label for="observaciones">
                                        <i class="fas fa-sticky-note mr-1"></i> 
                                        Observaciones Adicionales
                                    </label>
                                    <textarea class="form-control" 
                                              id="observaciones" 
                                              name="observaciones" 
                                              rows="2" 
                                              placeholder="Notas adicionales..."><c:if test="${not empty receta}">${receta.observaciones}</c:if></textarea>
                                </div>

                            </div>

                            <!-- Card Footer -->
                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-save mr-2"></i> 
                                ${empty receta ? 'Emitir Receta' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
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
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css" rel="stylesheet"/>

<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- Script -->
<script>
                                                (function () {
                                                    if (typeof jQuery === 'undefined') {
                                                        console.error('jQuery no está cargado');
                                                        return;
                                                    }

                                                    $(document).ready(function () {
                                                        // Inicializar Select2
                                                        if (typeof $.fn.select2 !== 'undefined') {
                                                            $('.select2').select2({
                                                                theme: 'bootstrap4',
                                                                placeholder: '-- Seleccione un paciente --',
                                                                allowClear: true,
                                                                width: '100%'
                                                            });
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

                                                        // Validar formulario antes de enviar
                                                        $('#recetaForm').on('submit', function (e) {
                                                            if (this.checkValidity() === false) {
                                                                e.preventDefault();
                                                                e.stopPropagation();
                                                            }
                                                            $(this).addClass('was-validated');
                                                        });
                                                    });
                                                })();

                                                /**
                                                 * Carga las citas del paciente seleccionado
                                                 * Realiza un reload de la página con el parámetro del paciente
                                                 */
                                                function cargarCitasPaciente(idPaciente) {
                                                    if (!idPaciente) {
                                                        document.getElementById('idCita').innerHTML = '<option value="">-- Seleccione una cita completada --</option>';
                                                        return;
                                                    }
                                                    window.location.href = '${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva&idPaciente=' + idPaciente;
                                                }
</script>
