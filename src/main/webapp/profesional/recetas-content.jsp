<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-prescription mr-2"></i>
                    Mis Recetas Médicas
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Recetas Médicas</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<section class="content">
    <div class="container-fluid">

        <!-- Info Boxes -->
        <div class="row">
            <div class="col-md-6">
                <div class="info-box bg-gradient-info">
                    <span class="info-box-icon"><i class="fas fa-prescription-bottle-alt"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Total de Recetas Emitidas</span>
                        <span class="info-box-number">${not empty totalRecetas ? totalRecetas : 0}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-box bg-gradient-success">
                    <span class="info-box-icon"><i class="fas fa-check-circle"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Recetas Vigentes</span>
                        <span class="info-box-number">${not empty recetasVigentes ? recetasVigentes : 0}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recetas Card -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Listado de Recetas Emitidas
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva" 
                       class="btn btn-success btn-sm">
                        <i class="fas fa-plus mr-1"></i> Nueva Receta
                    </a>
                </div>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty recetas}">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>N° Receta</th>
                                        <th>Fecha Emisión</th>
                                        <th>Paciente</th>
                                        <th>DNI</th>
                                        <th>Medicamentos</th>
                                        <th style="width: 120px;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="receta" items="${recetas}">
                                        <tr>
                                            <!-- ID Receta -->
                                            <td class="text-center">
                                                <strong>#${receta.idReceta}</strong>
                                            </td>

                                            <!-- Fecha Emisión -->
                                            <td>
                                                <i class="far fa-calendar mr-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty receta.fechaEmision}">
                                                        <fmt:parseDate value="${receta.fechaEmision}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                        <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificada</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Paciente -->
                                            <td>
                                                <strong>
                                                    ${not empty receta.nombrePaciente ? receta.nombrePaciente : 'No especificado'}
                                                </strong>
                                            </td>

                                            <!-- DNI -->
                                            <td>
                                                ${not empty receta.dniPaciente ? receta.dniPaciente : '-'}
                                            </td>

                                            <!-- Medicamentos (truncado) -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty receta.medicamentos}">
                                                        <c:set var="medicamentos" value="${receta.medicamentos}"/>
                                                        <c:if test="${fn:length(medicamentos) > 50}">
                                                            <span title="${medicamentos}">
                                                                ${fn:substring(medicamentos, 0, 50)}...
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${fn:length(medicamentos) <= 50}">
                                                            ${medicamentos}
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Acciones -->
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <!-- Ver -->
                                                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=ver&id=${receta.idReceta}" 
                                                       class="btn btn-info" 
                                                       title="Ver detalle"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-eye"></i>
                                                    </a>

                                                    <!-- Editar -->
                                                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=editar&id=${receta.idReceta}" 
                                                       class="btn btn-primary" 
                                                       title="Editar"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <!-- Eliminar -->
                                                    <button type="button" 
                                                            class="btn btn-danger" 
                                                            onclick="eliminarReceta(${receta.idReceta})"
                                                            title="Eliminar"
                                                            data-toggle="tooltip">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Mensaje vacío -->
                        <div class="text-center py-5">
                            <i class="fas fa-prescription-bottle fa-4x mb-3 text-muted"></i>
                            <h5 class="text-muted">No has emitido recetas médicas aún</h5>
                            <p class="text-muted mb-3">Las recetas que emitas aparecerán aquí</p>
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva" 
                               class="btn btn-success">
                                <i class="fas fa-plus mr-1"></i> Crear Primera Receta
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Card Footer -->
            <div class="card-footer">
                <small class="text-muted">
                    <i class="fas fa-info-circle mr-1"></i>
                    Las recetas médicas tienen una vigencia predeterminada de 30 días
                </small>
            </div>
        </div>

    </div>
</section>

<!-- Scripts -->
<script>
    /**
     * Función para eliminar una receta médica
     * Pide confirmación y envía un formulario POST
     * @param {number} idReceta - ID de la receta a eliminar
     */
    function eliminarReceta(idReceta) {
        if (confirm('¿Estás seguro de eliminar esta receta médica?\n\nEsta acción no se puede deshacer.')) {
            // Crear formulario dinámico
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/RecetaMedicaServlet';

            // Input para acción
            var inputAccion = document.createElement('input');
            inputAccion.type = 'hidden';
            inputAccion.name = 'accion';
            inputAccion.value = 'eliminar';
            form.appendChild(inputAccion);

            // Input para ID
            var inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'id';
            inputId.value = idReceta;
            form.appendChild(inputId);

            // Agregar al DOM y enviar
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Activar tooltips de Bootstrap
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof jQuery !== 'undefined') {
            $('[data-toggle="tooltip"]').tooltip();
        }
    });
</script>