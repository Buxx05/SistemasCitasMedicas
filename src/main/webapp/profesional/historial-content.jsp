<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- CSS personalizado -->
<style>
    .badge-lg {
        font-size: 0.9rem;
        padding: 0.4rem 0.6rem;
    }

    .timeline-item {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border-radius: 4px;
    }

    .timeline-body {
        padding: 15px;
    }

    .entrada-historial {
        background: #f8f9fa;
        border-left: 4px solid #007bff;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 4px;
    }
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-file-medical-alt mr-2"></i>
                    Historial Clínico
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/PacienteProfesionalServlet">Mis Pacientes</a></li>
                    <li class="breadcrumb-item active">Historial Clínico</li>
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

        <!-- Información del Paciente -->
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-user-circle mr-2"></i>
                    Paciente: ${paciente.nombreCompleto}
                </h3>
                <div class="card-tools">
                    <span class="badge badge-secondary badge-lg mr-2">
                        <i class="fas fa-id-badge mr-1"></i>
                        ${paciente.codigoPaciente}
                    </span>
                    <span class="badge badge-info badge-lg">
                        <i class="fas fa-id-card mr-1"></i>
                        DNI: ${paciente.dni}
                    </span>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <strong><i class="fas fa-birthday-cake mr-1 text-info"></i> Fecha Nacimiento:</strong>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${not empty paciente.fechaNacimiento}">
                                    <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNacParseada"/>
                                    <fmt:formatDate value="${fechaNacParseada}" pattern="dd/MM/yyyy"/>
                                    <br>
                                    <small>
                                        <c:if test="${paciente.edad > 0}">
                                            (${paciente.edad} años)
                                        </c:if>
                                    </small>
                                </c:when>
                                <c:otherwise>No registrada</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-venus-mars mr-1 text-purple"></i> Género:</strong>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${paciente.genero == 'M'}">
                                    <span class="badge badge-info">
                                        <i class="fas fa-mars mr-1"></i> Masculino
                                    </span>
                                </c:when>
                                <c:when test="${paciente.genero == 'F'}">
                                    <span class="badge" style="background-color: #e83e8c; color: white;">
                                        <i class="fas fa-venus mr-1"></i> Femenino
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">Otro</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-phone mr-1 text-success"></i> Teléfono:</strong>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${not empty paciente.telefono}">
                                    <a href="tel:${paciente.telefono}">${paciente.telefono}</a>
                                </c:when>
                                <c:otherwise>No registrado</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-envelope mr-1 text-primary"></i> Email:</strong>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${not empty paciente.email}">
                                    <a href="mailto:${paciente.email}">${paciente.email}</a>
                                </c:when>
                                <c:otherwise>No registrado</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Historial Clínico -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-history mr-2"></i>
                    Entradas del Historial Clínico
                </h3>
                <div class="card-tools">
                    <span class="badge badge-primary badge-lg mr-2">
                        <i class="fas fa-file-medical mr-1"></i>
                        ${totalEntradas} entrada(s)
                    </span>
                    <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=nuevoHistorial&idPaciente=${paciente.idPaciente}" 
                       class="btn btn-success btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nueva Entrada
                    </a>
                </div>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty historiales}">
                        <!-- Timeline de Entradas -->
                        <div class="timeline">
                            <c:forEach var="historial" items="${historiales}" varStatus="status">

                                <!-- Marcador de tiempo -->
                                <div class="time-label">
                                    <span class="bg-primary">
                                        <i class="far fa-calendar-alt mr-1"></i>
                                        <c:choose>
                                            <c:when test="${not empty historial.fechaRegistro}">
                                                <fmt:parseDate value="${historial.fechaRegistro}" pattern="yyyy-MM-dd" var="fechaRegParseada"/>
                                                <fmt:formatDate value="${fechaRegParseada}" pattern="dd 'de' MMMM 'de' yyyy"/>
                                            </c:when>
                                            <c:otherwise>Sin fecha</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <!-- Timeline Item -->
                                <div>
                                    <i class="fas fa-notes-medical bg-info"></i>
                                    <div class="timeline-item">
                                        <span class="time">
                                            <i class="fas fa-clock mr-1"></i>
                                            <c:choose>
                                                <c:when test="${not empty historial.fechaHoraRegistro}">
                                                    <fmt:parseDate value="${historial.fechaHoraRegistro}" pattern="yyyy-MM-dd HH:mm:ss" var="fechaHoraParseada"/>
                                                    <fmt:formatDate value="${fechaHoraParseada}" pattern="HH:mm"/>
                                                </c:when>
                                                <c:otherwise>--:--</c:otherwise>
                                            </c:choose>
                                        </span>

                                        <h3 class="timeline-header">
                                            <i class="fas fa-user-md mr-2 text-primary"></i>
                                            <strong>${historial.nombreProfesional}</strong>
                                            <span class="text-muted"> - ${historial.nombreEspecialidad}</span>
                                            <c:if test="${not empty historial.idCita}">
                                                <span class="badge badge-success ml-2">
                                                    <i class="fas fa-link mr-1"></i>
                                                    Cita ${historial.codigoCita}
                                                </span>
                                            </c:if>
                                        </h3>

                                        <div class="timeline-body">

                                            <!-- Síntomas -->
                                            <c:if test="${not empty historial.sintomas}">
                                                <div class="entrada-historial" style="border-left-color: #17a2b8;">
                                                    <strong class="text-info">
                                                        <i class="fas fa-thermometer-half mr-2"></i>
                                                        Síntomas:
                                                    </strong>
                                                    <p class="mb-0 mt-2">${historial.sintomas}</p>
                                                </div>
                                            </c:if>

                                            <!-- Diagnóstico -->
                                            <c:if test="${not empty historial.diagnostico}">
                                                <div class="entrada-historial" style="border-left-color: #28a745;">
                                                    <strong class="text-success">
                                                        <i class="fas fa-stethoscope mr-2"></i>
                                                        Diagnóstico:
                                                    </strong>
                                                    <p class="mb-0 mt-2">${historial.diagnostico}</p>
                                                </div>
                                            </c:if>

                                            <!-- Tratamiento -->
                                            <c:if test="${not empty historial.tratamiento}">
                                                <div class="entrada-historial" style="border-left-color: #ffc107;">
                                                    <strong class="text-warning">
                                                        <i class="fas fa-pills mr-2"></i>
                                                        Tratamiento:
                                                    </strong>
                                                    <p class="mb-0 mt-2">${historial.tratamiento}</p>
                                                </div>
                                            </c:if>

                                            <!-- Observaciones -->
                                            <c:if test="${not empty historial.observaciones}">
                                                <div class="entrada-historial" style="border-left-color: #6c757d;">
                                                    <strong class="text-secondary">
                                                        <i class="fas fa-sticky-note mr-2"></i>
                                                        Observaciones:
                                                    </strong>
                                                    <p class="mb-0 mt-2">${historial.observaciones}</p>
                                                </div>
                                            </c:if>

                                            <!-- Info de la cita vinculada -->
                                            <c:if test="${not empty historial.fechaCita}">
                                                <div class="alert alert-light border mt-3 mb-0">
                                                    <i class="fas fa-info-circle text-primary mr-2"></i>
                                                    <strong>Cita vinculada:</strong>
                                                    <span class="badge badge-secondary">${historial.codigoCita}</span>
                                                    -
                                                    <fmt:parseDate value="${historial.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                                    <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                                    <c:if test="${not empty historial.horaCita && historial.horaCita.length() >= 5}">
                                                        a las <strong>${historial.horaCita.substring(0, 5)}</strong>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="timeline-footer">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=editarHistorial&id=${historial.idHistorial}" 
                                                   class="btn btn-primary btn-sm"
                                                   title="Editar entrada">
                                                    <i class="fas fa-edit mr-1"></i> Editar
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-danger btn-sm"
                                                        onclick="eliminarHistorial(${historial.idHistorial}, ${paciente.idPaciente})"
                                                        title="Eliminar entrada">
                                                    <i class="fas fa-trash mr-1"></i> Eliminar
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>

                            <!-- Fin de la línea de tiempo -->
                            <div>
                                <i class="fas fa-flag-checkered bg-gray"></i>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- Sin historial -->
                        <div class="text-center py-5">
                            <i class="fas fa-file-medical fa-4x text-muted mb-3 d-block"></i>
                            <h5 class="text-muted">No hay entradas en el historial clínico</h5>
                            <p class="text-muted">Aún no has registrado información médica para este paciente.</p>
                            <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=nuevoHistorial&idPaciente=${paciente.idPaciente}" 
                               class="btn btn-success btn-lg mt-3">
                                <i class="fas fa-plus mr-2"></i>
                                Crear Primera Entrada
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-footer">
                <div class="btn-group" role="group">
                    <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=ver&id=${paciente.idPaciente}" 
                       class="btn btn-info">
                        <i class="fas fa-user mr-2"></i>
                        Ver Detalle del Paciente
                    </a>
                    <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                       class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Volver a la Lista
                    </a>
                </div>
            </div>
        </div>

        <!-- Card Informativa -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Información del Historial Clínico
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <h5><i class="fas fa-thermometer-half text-info mr-2"></i>Síntomas</h5>
                        <p class="small">Manifestaciones clínicas reportadas por el paciente.</p>
                    </div>
                    <div class="col-md-3">
                        <h5><i class="fas fa-stethoscope text-success mr-2"></i>Diagnóstico</h5>
                        <p class="small">Evaluación médica y determinación de la condición.</p>
                    </div>
                    <div class="col-md-3">
                        <h5><i class="fas fa-pills text-warning mr-2"></i>Tratamiento</h5>
                        <p class="small">Plan terapéutico prescrito para el paciente.</p>
                    </div>
                    <div class="col-md-3">
                        <h5><i class="fas fa-sticky-note text-secondary mr-2"></i>Observaciones</h5>
                        <p class="small">Notas adicionales sobre la evolución del paciente.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>

<!-- ✅ Script con SweetAlert2 -->
<script>
const contextPath = '${pageContext.request.contextPath}';

/**
 * Eliminar entrada del historial clínico con SweetAlert2
 */
function eliminarHistorial(idHistorial, idPaciente) {
    Swal.fire({
        title: '¿Eliminar entrada del historial?',
        html: '¿Estás seguro de eliminar esta entrada del historial clínico?<br><small class="text-muted">Esta acción no se puede deshacer</small>',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-trash"></i> Sí, eliminar',
        cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
        reverseButtons: true,
        focusCancel: true
    }).then((result) => {
        if (result.isConfirmed) {
            // Mostrar mensaje de carga
            Swal.fire({
                title: 'Eliminando...',
                html: 'Eliminando entrada del historial',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            // Crear y enviar formulario
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = contextPath + '/PacienteProfesionalServlet';

            var inputAccion = document.createElement('input');
            inputAccion.type = 'hidden';
            inputAccion.name = 'accion';
            inputAccion.value = 'eliminarHistorial';
            form.appendChild(inputAccion);

            var inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'id';
            inputId.value = idHistorial;
            form.appendChild(inputId);

            var inputIdPaciente = document.createElement('input');
            inputIdPaciente.type = 'hidden';
            inputIdPaciente.name = 'idPaciente';
            inputIdPaciente.value = idPaciente;
            form.appendChild(inputIdPaciente);

            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
