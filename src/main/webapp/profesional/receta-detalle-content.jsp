<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Validar que la receta existe -->
<c:if test="${empty receta}">
    <section class="content">
        <div class="container-fluid">
            <div class="alert alert-warning mt-3">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                La receta no existe o ha sido eliminada.
                <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" class="alert-link">
                    Volver al listado
                </a>
            </div>
        </div>
    </section>
</c:if>

<!-- Mostrar detalle si receta existe -->
<c:if test="${not empty receta}">

    <!-- Content Header -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">
                        <i class="fas fa-prescription mr-2"></i>
                        Receta Médica #${receta.idReceta}
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
                        <li class="breadcrumb-item active">Detalle</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <section class="content">
        <div class="container-fluid">

            <div class="row">
                <div class="col-md-10 offset-md-1">

                    <!-- Card Principal de la Receta -->
                    <div class="card card-outline ${not empty vigente && vigente ? 'card-success' : 'card-danger'}">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-file-prescription mr-2"></i>
                                Receta Médica N° ${receta.idReceta}
                            </h3>
                            <div class="card-tools">
                                <c:choose>
                                    <c:when test="${not empty vigente && vigente}">
                                        <span class="badge badge-success badge-lg">
                                            <i class="fas fa-check-circle mr-1"></i>
                                            VIGENTE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger badge-lg">
                                            <i class="fas fa-times-circle mr-1"></i>
                                            VENCIDA
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card-body">

                            <!-- Información del Paciente -->
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
                                        <dd class="col-sm-9">
                                            <strong>${not empty receta.nombrePaciente ? receta.nombrePaciente : 'No especificado'}</strong>
                                        </dd>

                                        <dt class="col-sm-3">DNI:</dt>
                                        <dd class="col-sm-9">
                                            ${not empty receta.dniPaciente ? receta.dniPaciente : 'No especificado'}
                                        </dd>
                                    </dl>
                                </div>
                            </div>

                            <!-- Información del Profesional -->
                            <div class="card card-primary">
                                <div class="card-header">
                                    <h3 class="card-title">
                                        <i class="fas fa-user-md mr-2"></i>
                                        Profesional que Emite
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <dl class="row mb-0">
                                        <dt class="col-sm-3">Nombre:</dt>
                                        <dd class="col-sm-9">
                                            <strong>${not empty receta.nombreProfesional ? receta.nombreProfesional : 'No especificado'}</strong>
                                        </dd>

                                        <dt class="col-sm-3">Especialidad:</dt>
                                        <dd class="col-sm-9">
                                            ${not empty receta.nombreEspecialidad ? receta.nombreEspecialidad : 'No especificada'}
                                        </dd>
                                    </dl>
                                </div>
                            </div>

                            <!-- Prescripción Médica -->
                            <div class="card card-warning">
                                <div class="card-header">
                                    <h3 class="card-title">
                                        <i class="fas fa-pills mr-2"></i>
                                        Prescripción Médica
                                    </h3>
                                </div>
                                <div class="card-body">

                                    <!-- Medicamentos -->
                                    <div class="mb-3">
                                        <strong class="text-primary">
                                            <i class="fas fa-capsules mr-1"></i>
                                            Medicamentos Prescritos:
                                        </strong>
                                        <c:if test="${not empty receta.medicamentos}">
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.medicamentos}
                                            </p>
                                        </c:if>
                                        <c:if test="${empty receta.medicamentos}">
                                            <p class="mb-0 mt-2 text-muted">No especificado</p>
                                        </c:if>
                                    </div>

                                    <!-- Dosis -->
                                    <div class="mb-3">
                                        <strong class="text-success">
                                            <i class="fas fa-prescription-bottle mr-1"></i>
                                            Dosis:
                                        </strong>
                                        <c:if test="${not empty receta.dosis}">
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.dosis}
                                            </p>
                                        </c:if>
                                        <c:if test="${empty receta.dosis}">
                                            <p class="mb-0 mt-2 text-muted">No especificada</p>
                                        </c:if>
                                    </div>

                                    <!-- Frecuencia -->
                                    <div class="mb-3">
                                        <strong class="text-warning">
                                            <i class="fas fa-clock mr-1"></i>
                                            Frecuencia:
                                        </strong>
                                        <c:if test="${not empty receta.frecuencia}">
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.frecuencia}
                                            </p>
                                        </c:if>
                                        <c:if test="${empty receta.frecuencia}">
                                            <p class="mb-0 mt-2 text-muted">No especificada</p>
                                        </c:if>
                                    </div>

                                    <!-- Duración -->
                                    <c:if test="${not empty receta.duracion}">
                                        <div class="mb-3">
                                            <strong class="text-info">
                                                <i class="fas fa-calendar-alt mr-1"></i>
                                                Duración del Tratamiento:
                                            </strong>
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.duracion}
                                            </p>
                                        </div>
                                    </c:if>

                                    <!-- Indicaciones -->
                                    <div class="mb-3">
                                        <strong class="text-danger">
                                            <i class="fas fa-exclamation-triangle mr-1"></i>
                                            Indicaciones Generales:
                                        </strong>
                                        <c:if test="${not empty receta.indicaciones}">
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.indicaciones}
                                            </p>
                                        </c:if>
                                        <c:if test="${empty receta.indicaciones}">
                                            <p class="mb-0 mt-2 text-muted">No especificadas</p>
                                        </c:if>
                                    </div>

                                    <!-- Observaciones -->
                                    <c:if test="${not empty receta.observaciones}">
                                        <div class="mb-0">
                                            <strong class="text-secondary">
                                                <i class="fas fa-sticky-note mr-1"></i>
                                                Observaciones Adicionales:
                                            </strong>
                                            <p class="mb-0 mt-2 p-3 bg-light border rounded">
                                                ${receta.observaciones}
                                            </p>
                                        </div>
                                    </c:if>

                                </div>
                            </div>

                            <!-- Información de Fechas -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-box bg-gradient-info">
                                        <span class="info-box-icon"><i class="far fa-calendar"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Fecha de Emisión</span>
                                            <span class="info-box-number">
                                                <c:if test="${not empty receta.fechaEmision}">
                                                    <fmt:parseDate value="${receta.fechaEmision}" pattern="yyyy-MM-dd" var="fechaEmisionParseada"/>
                                                    <fmt:formatDate value="${fechaEmisionParseada}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                                <c:if test="${empty receta.fechaEmision}">
                                                    <span class="text-muted">No especificada</span>
                                                </c:if>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-box ${not empty vigente && vigente ? 'bg-gradient-success' : 'bg-gradient-danger'}">
                                        <span class="info-box-icon"><i class="far fa-calendar-check"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Vigente Hasta</span>
                                            <span class="info-box-number">
                                                <c:if test="${not empty receta.fechaVigencia}">
                                                    <fmt:parseDate value="${receta.fechaVigencia}" pattern="yyyy-MM-dd" var="fechaVigParseada"/>
                                                    <fmt:formatDate value="${fechaVigParseada}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                                <c:if test="${empty receta.fechaVigencia}">
                                                    <span class="text-muted">No especificada</span>
                                                </c:if>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Información de la Cita Vinculada -->
                            <c:if test="${not empty receta.fechaCita}">
                                <div class="alert alert-light border">
                                    <i class="fas fa-link mr-2"></i>
                                    <strong>Cita Vinculada:</strong>
                                    <fmt:parseDate value="${receta.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                    <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                    <c:if test="${not empty receta.horaCita && fn:length(receta.horaCita) >= 5}">
                                        a las ${fn:substring(receta.horaCita, 0, 5)}
                                    </c:if>
                                    <c:if test="${not empty receta.motivoConsulta}">
                                        - ${receta.motivoConsulta}
                                    </c:if>
                                </div>
                            </c:if>

                        </div>

                        <!-- Botones de Acción -->
                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=editar&id=${receta.idReceta}" 
                               class="btn btn-primary">
                                <i class="fas fa-edit mr-2"></i>
                                Editar Receta
                            </a>
                            <button type="button" 
                                    class="btn btn-danger"
                                    onclick="eliminarReceta(${receta.idReceta})">
                                <i class="fas fa-trash mr-2"></i>
                                Eliminar Receta
                            </button>
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left mr-2"></i>
                                Volver al Listado
                            </a>
                        </div>

                    </div>

                </div>
            </div>

        </div>
    </section>

</c:if>

<!-- Script -->
<script>
    /**
     * Elimina una receta médica después de pedir confirmación
     */
    function eliminarReceta(idReceta) {
        if (confirm('¿Estás seguro de eliminar esta receta médica?\n\nEsta acción no se puede deshacer.')) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/RecetaMedicaServlet';

            var inputAccion = document.createElement('input');
            inputAccion.type = 'hidden';
            inputAccion.name = 'accion';
            inputAccion.value = 'eliminar';
            form.appendChild(inputAccion);

            var inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'id';
            inputId.value = idReceta;
            form.appendChild(inputId);

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>