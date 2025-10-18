<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-calendar-alt mr-2"></i>
                    Mis Citas
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Mis Citas</li>
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

        <!-- Card de citas -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Listado de Citas
                </h3>
                <div class="card-tools">
                    <!-- Filtros rápidos -->
                    <div class="btn-group" role="group">
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                           class="btn btn-sm ${empty estadoFiltro ? 'btn-primary' : 'btn-outline-primary'}">
                            <i class="fas fa-list"></i> Todas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=CONFIRMADA" 
                           class="btn btn-sm ${estadoFiltro == 'CONFIRMADA' ? 'btn-warning' : 'btn-outline-warning'}">
                            <i class="fas fa-clock"></i> Pendientes
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=COMPLETADA" 
                           class="btn btn-sm ${estadoFiltro == 'COMPLETADA' ? 'btn-success' : 'btn-outline-success'}">
                            <i class="fas fa-check"></i> Completadas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=CANCELADA" 
                           class="btn btn-sm ${estadoFiltro == 'CANCELADA' ? 'btn-danger' : 'btn-outline-danger'}">
                            <i class="fas fa-times"></i> Canceladas
                        </a>
                    </div>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="citasTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Paciente</th>
                                <th>DNI</th>
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
                                            <td>
                                                <i class="far fa-calendar mr-1"></i>
                                                <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <i class="far fa-clock mr-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty cita.horaCita && cita.horaCita.length() >= 5}">
                                                        ${cita.horaCita.substring(0, 5)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <strong>${cita.nombrePaciente}</strong>
                                            </td>
                                            <td>${cita.dniPaciente}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cita.motivoConsulta}">
                                                        ${cita.motivoConsulta.length() > 50 ? cita.motivoConsulta.substring(0, 50).concat('...') : cita.motivoConsulta}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Sin especificar</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                        <span class="badge badge-warning">
                                                            <i class="fas fa-clock mr-1"></i>
                                                            Pendiente
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'COMPLETADA'}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check-circle mr-1"></i>
                                                            Completada
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'CANCELADA'}">
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-times-circle mr-1"></i>
                                                            Cancelada
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <c:if test="${cita.estado == 'CONFIRMADA'}">
                                                        <button type="button" 
                                                                class="btn btn-success"
                                                                onclick="completarCita(${cita.idCita})"
                                                                title="Marcar como completada">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" 
                                                                class="btn btn-info"
                                                                onclick="crearRecita(${cita.idCita}, ${cita.idPaciente})"
                                                                title="Crear cita de seguimiento">
                                                            <i class="fas fa-redo"></i>
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${cita.estado != 'CANCELADA'}">
                                                        <button type="button" 
                                                                class="btn btn-danger"
                                                                onclick="cancelarCita(${cita.idCita})"
                                                                title="Cancelar cita">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </c:if>
                                                    <button type="button" 
                                                            class="btn btn-secondary"
                                                            onclick="verDetalle(${cita.idCita})"
                                                            title="Ver detalles">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4">
                                            <i class="fas fa-calendar-times fa-3x mb-3 text-muted"></i>
                                            <h5>No tienes citas registradas</h5>
                                            <p class="text-muted">Las citas que agende el administrador aparecerán aquí</p>
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

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<!-- Scripts personalizados -->
<script>
// ✅ Definir contexto una sola vez
                                                                const contextPath = '${pageContext.request.contextPath}';

                                                                $(document).ready(function () {
    <c:if test="${not empty citas}">
                                                                    // ✅ Verificar que DataTables está disponible
                                                                    if (typeof $.fn.DataTable !== 'undefined') {
                                                                        $('#citasTable').DataTable({
                                                                            "language": {
                                                                                "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                                                                            },
                                                                            "order": [[0, "desc"], [1, "desc"]], // Ordenar por fecha y hora descendente
                                                                            "pageLength": 25,
                                                                            "responsive": true
                                                                        });
                                                                    } else {
                                                                        console.warn('DataTables no se cargó correctamente');
                                                                    }
    </c:if>
                                                                });

                                                                function completarCita(idCita) {
                                                                    if (confirm('¿Marcar esta cita como completada?')) {
                                                                        window.location.href = contextPath + '/CitaProfesionalServlet?accion=completar&id=' + idCita;
                                                                    }
                                                                }

                                                                function cancelarCita(idCita) {
                                                                    if (confirm('¿Estás seguro de cancelar esta cita?\n\nEsta acción notificará al paciente.')) {
                                                                        window.location.href = contextPath + '/CitaProfesionalServlet?accion=cancelar&id=' + idCita;
                                                                    }
                                                                }

                                                                function crearRecita(idCita, idPaciente) {
                                                                    window.location.href = contextPath + '/CitaProfesionalServlet?accion=nuevaRecita&idCita=' + idCita + '&idPaciente=' + idPaciente;
                                                                }

                                                                function verDetalle(idCita) {
                                                                    // TODO: Implementar modal o página de detalle
                                                                    alert('Función de ver detalle - Por implementar');
                                                                }
</script>


