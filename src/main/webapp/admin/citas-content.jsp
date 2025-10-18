<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Gestión de Citas Médicas</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Citas</li>
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

        <!-- Card de filtros -->
        <div class="card card-secondary collapsed-card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-filter mr-2"></i> Filtros de Búsqueda
                </h3>
                <div class="card-tools">
                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>

            <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/CitaServlet" id="filtroForm">
                    <input type="hidden" name="accion" value="filtrar">

                    <div class="row">
                        <!-- Tipo de filtro -->
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Filtrar por:</label>
                                <select class="form-control" id="tipoFiltro" name="tipoFiltro" required>
                                    <option value="">Seleccione...</option>
                                    <option value="estado">Estado</option>
                                    <option value="fecha">Fecha</option>
                                    <option value="rango">Rango de Fechas</option>
                                </select>
                            </div>
                        </div>

                        <!-- Filtro por Estado -->
                        <div class="col-md-3 filtro-option" id="filtroEstado" style="display:none;">
                            <div class="form-group">
                                <label>Estado:</label>
                                <select class="form-control" name="estado">
                                    <option value="PENDIENTE">Pendiente</option>
                                    <option value="CONFIRMADA">Confirmada</option>
                                    <option value="COMPLETADA">Completada</option>
                                    <option value="CANCELADA">Cancelada</option>
                                </select>
                            </div>
                        </div>

                        <!-- Filtro por Fecha -->
                        <div class="col-md-3 filtro-option" id="filtroFecha" style="display:none;">
                            <div class="form-group">
                                <label>Fecha:</label>
                                <input type="date" class="form-control" name="fecha">
                            </div>
                        </div>

                        <!-- Filtro por Rango -->
                        <div class="col-md-6 filtro-option" id="filtroRango" style="display:none;">
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Fecha Inicio:</label>
                                    <input type="date" class="form-control" name="fechaInicio">
                                </div>
                                <div class="col-md-6">
                                    <label>Fecha Fin:</label>
                                    <input type="date" class="form-control" name="fechaFin">
                                </div>
                            </div>
                        </div>

                        <!-- Botón -->
                        <div class="col-md-3">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                </form>

                <div class="text-center mt-2">
                    <a href="${pageContext.request.contextPath}/CitaServlet" class="btn btn-secondary btn-sm">
                        <i class="fas fa-redo"></i> Limpiar Filtros
                    </a>
                </div>
            </div>
        </div>

        <!-- Tabla de citas -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-alt mr-2"></i> Lista de Citas
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/CitaServlet?accion=nuevo" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nueva Cita
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="citasTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Paciente</th>
                                <th>Profesional</th>
                                <th>Especialidad</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Motivo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty citas}">
                                <c:forEach var="cita" items="${citas}">
                                    <tr>
                                        <td>${cita.idCita}</td>
                                        <td>
                                            <i class="fas fa-user-injured mr-1"></i>
                                            <strong>${cita.nombrePaciente}</strong><br>
                                            <small class="text-muted">DNI: ${cita.dniPaciente}</small>
                                        </td>
                                        <td>
                                            <i class="fas fa-user-md mr-1"></i>${cita.nombreProfesional}
                                        </td>
                                        <td>
                                            <span class="badge badge-info">${cita.nombreEspecialidad}</span>
                                        </td>
                                        <td><i class="far fa-calendar mr-1"></i>${cita.fechaCita}</td>
                                        <td><i class="far fa-clock mr-1"></i>${cita.horaCita}</td>
                                        <td>
                                    <c:choose>
                                        <c:when test="${not empty cita.motivoConsulta}">
                                            <small>${cita.motivoConsulta}</small>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                    </td>
                                    <td>
                                    <c:choose>
                                        <c:when test="${cita.estado == 'PENDIENTE'}">
                                            <span class="badge badge-warning"><i class="fas fa-clock mr-1"></i>Pendiente</span>
                                        </c:when>
                                        <c:when test="${cita.estado == 'CONFIRMADA'}">
                                            <span class="badge badge-info"><i class="fas fa-check mr-1"></i>Confirmada</span>
                                        </c:when>
                                        <c:when test="${cita.estado == 'COMPLETADA'}">
                                            <span class="badge badge-success"><i class="fas fa-check-double mr-1"></i>Completada</span>
                                        </c:when>
                                        <c:when test="${cita.estado == 'CANCELADA'}">
                                            <span class="badge badge-danger"><i class="fas fa-times mr-1"></i>Cancelada</span>
                                        </c:when>
                                    </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group-vertical btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/CitaServlet?accion=editar&id=${cita.idCita}" 
                                               class="btn btn-warning btn-xs"><i class="fas fa-edit"></i> Editar</a>

                                            <c:if test="${cita.estado == 'PENDIENTE'}">
                                                <a href="${pageContext.request.contextPath}/CitaServlet?accion=confirmar&id=${cita.idCita}" 
                                                   class="btn btn-info btn-xs"
                                                   onclick="return confirm('¿Confirmar esta cita?')">
                                                    <i class="fas fa-check"></i> Confirmar
                                                </a>
                                            </c:if>

                                            <c:if test="${cita.estado == 'CONFIRMADA'}">
                                                <a href="${pageContext.request.contextPath}/CitaServlet?accion=completar&id=${cita.idCita}" 
                                                   class="btn btn-success btn-xs"
                                                   onclick="return confirm('¿Marcar como completada?')">
                                                    <i class="fas fa-check-double"></i> Completar
                                                </a>
                                            </c:if>

                                            <c:if test="${cita.estado != 'CANCELADA' && cita.estado != 'COMPLETADA'}">
                                                <a href="${pageContext.request.contextPath}/CitaServlet?accion=cancelar&id=${cita.idCita}" 
                                                   class="btn btn-secondary btn-xs"
                                                   onclick="return confirm('¿Cancelar esta cita?')">
                                                    <i class="fas fa-ban"></i> Cancelar
                                                </a>
                                            </c:if>

                                            <button type="button" class="btn btn-danger btn-xs"
                                                    onclick="confirmarEliminacion(${cita.idCita}, '${cita.nombrePaciente}', '${cita.fechaCita}')">
                                                <i class="fas fa-trash"></i> Eliminar
                                            </button>
                                        </div>
                                    </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        <i class="fas fa-info-circle fa-2x mb-3 text-muted"></i>
                                        <p class="text-muted">No hay citas registradas en el sistema</p>
                                        <a href="${pageContext.request.contextPath}/CitaServlet?accion=nuevo" 
                                           class="btn btn-primary btn-sm mt-2">
                                            <i class="fas fa-plus mr-1"></i> Agendar Primera Cita
                                        </a>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card-footer">
                <small class="text-muted">
                    <i class="fas fa-info-circle mr-1"></i>
                    Total de citas: <strong><c:out value="${citas != null ? citas.size() : 0}"/></strong>
                </small>
            </div>
        </div>
    </div>
</section>

<!-- Script para confirmar eliminación -->
<script>
    function confirmarEliminacion(id, paciente, fecha) {
        if (confirm('¿Estás seguro de eliminar la cita de "' + paciente + '" para el día ' + fecha + '?\n\nEsta acción no se puede deshacer.')) {
            window.location.href = '${pageContext.request.contextPath}/CitaServlet?accion=eliminar&id=' + id;
        }
    }
</script>

<!-- Filtros dinámicos -->
<script>
    $(document).ready(function () {
        $('#tipoFiltro').change(function () {
            $('.filtro-option').hide();
            const tipoFiltro = $(this).val();
            if (tipoFiltro === 'estado')
                $('#filtroEstado').show();
            else if (tipoFiltro === 'fecha')
                $('#filtroFecha').show();
            else if (tipoFiltro === 'rango')
                $('#filtroRango').show();
        });
    });
</script>

<!-- DataTables -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<script>
    $(document).ready(function() {
    <c:if test="${not empty citas}">
                    $('#citasTable').DataTable({
            language: { url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json" },
            order: [[4, "desc"], [5, "desc"]],
            pageLength: 10,
            responsive: true,
            columnDefs: [{ orderable: false, targets: 8 }]
                });
                </c:if>
    });
</script>
