<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                    <span class="badge badge-info badge-lg">
                        <i class="fas fa-id-card mr-1"></i>
                        DNI: ${paciente.dni}
                    </span>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <strong><i class="fas fa-birthday-cake mr-1"></i> Fecha Nacimiento:</strong>
                        <p class="text-muted">
                            <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNacParseada"/>
                            <fmt:formatDate value="${fechaNacParseada}" pattern="dd/MM/yyyy"/>
                        </p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-venus-mars mr-1"></i> Género:</strong>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${paciente.genero == 'M'}">Masculino</c:when>
                                <c:when test="${paciente.genero == 'F'}">Femenino</c:when>
                                <c:otherwise>Otro</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-phone mr-1"></i> Teléfono:</strong>
                        <p class="text-muted">${not empty paciente.telefono ? paciente.telefono : 'No registrado'}</p>
                    </div>
                    <div class="col-md-3">
                        <strong><i class="fas fa-envelope mr-1"></i> Email:</strong>
                        <p class="text-muted">${not empty paciente.email ? paciente.email : 'No registrado'}</p>
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
                            <c:forEach var="historial" items="${historiales}">

                                <!-- Marcador de tiempo -->
                                <div class="time-label">
                                    <span class="bg-primary">
                                        <i class="far fa-calendar-alt mr-1"></i>
                                        <fmt:parseDate value="${historial.fechaRegistro}" pattern="yyyy-MM-dd" var="fechaRegParseada"/>
                                        <fmt:formatDate value="${fechaRegParseada}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>

                                <!-- Timeline Item -->
                                <div>
                                    <i class="fas fa-notes-medical bg-info"></i>
                                    <div class="timeline-item">
                                        <span class="time">
                                            <i class="fas fa-clock mr-1"></i>
                                            <fmt:parseDate value="${historial.fechaHoraRegistro}" pattern="yyyy-MM-dd HH:mm:ss" var="fechaHoraParseada"/>
                                            <fmt:formatDate value="${fechaHoraParseada}" pattern="HH:mm"/>
                                        </span>

                                        <h3 class="timeline-header">
                                            <i class="fas fa-user-md mr-1"></i>
                                            ${historial.nombreProfesional} - ${historial.nombreEspecialidad}
                                            <c:if test="${not empty historial.idCita}">
                                                <span class="badge badge-success ml-2">
                                                    <i class="fas fa-link mr-1"></i>
                                                    Vinculado a cita
                                                </span>
                                            </c:if>
                                        </h3>

                                        <div class="timeline-body">

                                            <!-- Síntomas -->
                                            <c:if test="${not empty historial.sintomas}">
                                                <div class="mb-3">
                                                    <strong class="text-primary">
                                                        <i class="fas fa-thermometer-half mr-1"></i>
                                                        Síntomas:
                                                    </strong>
                                                    <p class="mb-0">${historial.sintomas}</p>
                                                </div>
                                            </c:if>

                                            <!-- Diagnóstico -->
                                            <c:if test="${not empty historial.diagnostico}">
                                                <div class="mb-3">
                                                    <strong class="text-success">
                                                        <i class="fas fa-stethoscope mr-1"></i>
                                                        Diagnóstico:
                                                    </strong>
                                                    <p class="mb-0">${historial.diagnostico}</p>
                                                </div>
                                            </c:if>

                                            <!-- Tratamiento -->
                                            <c:if test="${not empty historial.tratamiento}">
                                                <div class="mb-3">
                                                    <strong class="text-warning">
                                                        <i class="fas fa-pills mr-1"></i>
                                                        Tratamiento:
                                                    </strong>
                                                    <p class="mb-0">${historial.tratamiento}</p>
                                                </div>
                                            </c:if>

                                            <!-- Observaciones -->
                                            <c:if test="${not empty historial.observaciones}">
                                                <div class="mb-0">
                                                    <strong class="text-info">
                                                        <i class="fas fa-sticky-note mr-1"></i>
                                                        Observaciones:
                                                    </strong>
                                                    <p class="mb-0">${historial.observaciones}</p>
                                                </div>
                                            </c:if>

                                            <!-- Info de la cita vinculada -->
                                            <c:if test="${not empty historial.fechaCita}">
                                                <div class="alert alert-light mt-3 mb-0">
                                                    <i class="fas fa-info-circle mr-1"></i>
                                                    <strong>Cita vinculada:</strong>
                                                    <fmt:parseDate value="${historial.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                                    <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                                    a las ${historial.horaCita.substring(0, 5)}
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="timeline-footer">
                                            <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=editarHistorial&id=${historial.idHistorial}" 
                                               class="btn btn-primary btn-sm"
                                               title="Editar entrada">
                                                <i class="fas fa-edit"></i> Editar
                                            </a>
                                            <button type="button" 
                                                    class="btn btn-danger btn-sm"
                                                    onclick="eliminarHistorial(${historial.idHistorial})"
                                                    title="Eliminar entrada">
                                                <i class="fas fa-trash"></i> Eliminar
                                            </button>
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
                            <i class="fas fa-file-medical fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay entradas en el historial clínico</h5>
                            <p class="text-muted">Aún no has registrado información médica para este paciente.</p>
                            <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=nuevoHistorial&idPaciente=${paciente.idPaciente}" 
                               class="btn btn-success mt-3">
                                <i class="fas fa-plus mr-2"></i>
                                Crear Primera Entrada
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=ver&id=${paciente.idPaciente}" 
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Volver al Detalle del Paciente
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Script de confirmación para eliminar -->
<script>
    function eliminarHistorial(idHistorial) {
        if (confirm('¿Estás seguro de eliminar esta entrada del historial?\n\nEsta acción no se puede deshacer.')) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/PacienteProfesionalServlet';

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

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
