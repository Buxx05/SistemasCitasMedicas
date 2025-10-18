<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas ${empty historial ? 'fa-plus' : 'fa-edit'} mr-2"></i>
                    ${empty historial ? 'Nueva Entrada' : 'Editar Entrada'} - Historial Clínico
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/PacienteProfesionalServlet">Mis Pacientes</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=verHistorial&idPaciente=${paciente.idPaciente}">Historial</a></li>
                    <li class="breadcrumb-item active">${empty historial ? 'Nueva' : 'Editar'}</li>
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

                <!-- Info del Paciente -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-circle mr-2"></i>
                            Información del Paciente
                        </h3>
                    </div>
                    <div class="card-body">
                        <dl class="row mb-0">
                            <dt class="col-sm-3">Nombre Completo:</dt>
                            <dd class="col-sm-9">${paciente.nombreCompleto}</dd>

                            <dt class="col-sm-3">DNI:</dt>
                            <dd class="col-sm-9">${paciente.dni}</dd>

                            <dt class="col-sm-3">Género:</dt>
                            <dd class="col-sm-9">
                            <c:choose>
                                <c:when test="${paciente.genero == 'M'}">Masculino</c:when>
                                <c:when test="${paciente.genero == 'F'}">Femenino</c:when>
                                <c:otherwise>Otro</c:otherwise>
                            </c:choose>
                            </dd>

                            <dt class="col-sm-3">Fecha Nacimiento:</dt>
                            <dd class="col-sm-9">
                            <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNacParseada"/>
                            <fmt:formatDate value="${fechaNacParseada}" pattern="dd/MM/yyyy"/>
                            </dd>
                        </dl>
                    </div>
                </div>

                <!-- Formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-file-medical-alt mr-2"></i>
                            Datos de la Entrada Clínica
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                          method="post" 
                          id="historialForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="${empty historial ? 'crearHistorial' : 'actualizarHistorial'}">
                        <input type="hidden" name="idPaciente" value="${paciente.idPaciente}">
                        <c:if test="${not empty historial}">
                            <input type="hidden" name="idHistorial" value="${historial.idHistorial}">
                        </c:if>

                        <div class="card-body">

                            <!-- Síntomas -->
                            <div class="form-group">
                                <label for="sintomas">
                                    <i class="fas fa-thermometer-half mr-1"></i>
                                    Síntomas
                                </label>
                                <textarea class="form-control" 
                                          id="sintomas" 
                                          name="sintomas" 
                                          rows="3" 
                                          placeholder="Descripción de los síntomas reportados por el paciente...">${not empty historial ? historial.sintomas : ''}</textarea>
                                <small class="form-text text-muted">
                                    Describe los síntomas que presenta el paciente
                                </small>
                            </div>

                            <!-- Diagnóstico -->
                            <div class="form-group">
                                <label for="diagnostico">
                                    <i class="fas fa-stethoscope mr-1"></i>
                                    Diagnóstico <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="diagnostico" 
                                          name="diagnostico" 
                                          rows="3" 
                                          placeholder="Diagnóstico médico..."
                                          required>${not empty historial ? historial.diagnostico : ''}</textarea>
                                <small class="form-text text-muted">
                                    Diagnóstico clínico basado en la evaluación
                                </small>
                            </div>

                            <!-- Tratamiento -->
                            <div class="form-group">
                                <label for="tratamiento">
                                    <i class="fas fa-pills mr-1"></i>
                                    Tratamiento <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="tratamiento" 
                                          name="tratamiento" 
                                          rows="4" 
                                          placeholder="Tratamiento prescrito: medicamentos, terapias, recomendaciones..."
                                          required>${not empty historial ? historial.tratamiento : ''}</textarea>
                                <small class="form-text text-muted">
                                    Incluye medicamentos, dosis, frecuencia y recomendaciones
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
                                          rows="3" 
                                          placeholder="Notas adicionales, evolución esperada, indicaciones especiales...">${not empty historial ? historial.observaciones : ''}</textarea>
                                <small class="form-text text-muted">
                                    Información adicional relevante sobre el caso
                                </small>
                            </div>

                            <!-- Vincular con Cita (solo al crear) -->
                            <c:if test="${empty historial}">
                                <div class="form-group">
                                    <label for="idCita">
                                        <i class="fas fa-link mr-1"></i>
                                        Vincular con Cita (Opcional)
                                    </label>
                                    <select class="form-control" id="idCita" name="idCita">
                                        <option value="0">-- No vincular con ninguna cita --</option>
                                        <c:forEach var="cita" items="${citasCompletadas}">
                                            <option value="${cita.idCita}">
                                            <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                            <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                            - ${cita.horaCita.substring(0, 5)} - ${cita.motivoConsulta}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">
                                        Puedes vincular esta entrada con una cita completada
                                    </small>
                                </div>
                            </c:if>

                            <c:if test="${not empty historial && not empty historial.idCita}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle mr-2"></i>
                                    <strong>Vinculado a cita:</strong>
                                    <fmt:parseDate value="${historial.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaVinculada"/>
                                    <fmt:formatDate value="${fechaCitaVinculada}" pattern="dd/MM/yyyy"/>
                                    a las ${historial.horaCita.substring(0, 5)}
                                </div>
                            </c:if>

                        </div>

                        <!-- Botones -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${empty historial ? 'Crear Entrada' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=verHistorial&idPaciente=${paciente.idPaciente}" 
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

<!-- Validación del formulario -->
<script>
    $(document).ready(function () {
        $('#historialForm').submit(function (e) {
            var diagnostico = $('#diagnostico').val().trim();
            var tratamiento = $('#tratamiento').val().trim();

            if (diagnostico === '' || tratamiento === '') {
                e.preventDefault();
                alert('⚠️ El diagnóstico y el tratamiento son obligatorios');
                return false;
            }
        });
    });
</script>
