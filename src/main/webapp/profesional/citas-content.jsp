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

        <!-- Alertas con SweetAlert2 -->
        <jsp:include page="/componentes/alert.jsp"/>

        <!-- Card de citas -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Listado de Citas
                </h3>
                <div class="card-tools">
                    <!-- Filtros rápidos con estados correctos -->
                    <div class="btn-group" role="group">
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                           class="btn btn-sm ${empty estadoFiltro ? 'btn-primary' : 'btn-outline-primary'}">
                            <i class="fas fa-list"></i> Todas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=PENDIENTE" 
                           class="btn btn-sm ${estadoFiltro == 'PENDIENTE' ? 'btn-warning' : 'btn-outline-warning'}">
                            <i class="fas fa-clock"></i> Pendientes
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=COMPLETADA" 
                           class="btn btn-sm ${estadoFiltro == 'COMPLETADA' ? 'btn-success' : 'btn-outline-success'}">
                            <i class="fas fa-check-circle"></i> Completadas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=CANCELADA" 
                           class="btn btn-sm ${estadoFiltro == 'CANCELADA' ? 'btn-danger' : 'btn-outline-danger'}">
                            <i class="fas fa-times-circle"></i> Canceladas
                        </a>
                    </div>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="citasTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Paciente</th>
                                <th>DNI</th>
                                <th>Motivo</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty citas}">
                                    <c:forEach var="cita" items="${citas}">
                                        <tr>
                                            <!-- Código de cita -->
                                            <td>
                                                <span class="badge badge-secondary">${cita.codigoCita}</span>
                                            </td>

                                            <!-- Fecha -->
                                            <td>
                                                <i class="far fa-calendar mr-1"></i>
                                                <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                            </td>

                                            <!-- Hora -->
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

                                            <!-- Paciente -->
                                            <td>
                                                <strong>${cita.nombrePaciente}</strong>
                                            </td>

                                            <!-- DNI -->
                                            <td>${cita.dniPaciente}</td>

                                            <!-- Motivo -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cita.motivoConsulta}">
                                                        <c:choose>
                                                            <c:when test="${cita.motivoConsulta.length() > 50}">
                                                                <span data-toggle="tooltip" title="${cita.motivoConsulta}">
                                                                    ${cita.motivoConsulta.substring(0, 50)}...
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${cita.motivoConsulta}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Sin especificar</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Estado con colores correctos -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cita.estado == 'PENDIENTE'}">
                                                        <span class="badge badge-warning badge-pill">
                                                            <i class="fas fa-clock mr-1"></i>
                                                            Pendiente
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'COMPLETADA'}">
                                                        <span class="badge badge-success badge-pill">
                                                            <i class="fas fa-check-circle mr-1"></i>
                                                            Completada
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'CANCELADA'}">
                                                        <span class="badge badge-danger badge-pill">
                                                            <i class="fas fa-times-circle mr-1"></i>
                                                            Cancelada
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary badge-pill">
                                                            ${cita.estado}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Acciones según estado -->
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm" role="group">

                                                    <!-- PENDIENTE: Completar o Cancelar -->
                                                    <c:if test="${cita.estado == 'PENDIENTE'}">
                                                        <button type="button" class="btn btn-success"
                                                                onclick="completarCita(${cita.idCita})"
                                                                title="Completar cita">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-danger"
                                                                onclick="cancelarCita(${cita.idCita})"
                                                                title="Cancelar cita">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </c:if>

                                                    <!-- COMPLETADA: Crear Re-cita -->
                                                    <c:if test="${cita.estado == 'COMPLETADA'}">
                                                        <button type="button" class="btn btn-info"
                                                                onclick="crearRecita(${cita.idCita}, ${cita.idPaciente})"
                                                                title="Crear cita de seguimiento">
                                                            <i class="fas fa-redo"></i> Re-cita
                                                        </button>
                                                    </c:if>

                                                    <!-- CANCELADA: Sin acciones -->
                                                    <c:if test="${cita.estado == 'CANCELADA'}">
                                                        <span class="text-muted small">
                                                            <i class="fas fa-ban mr-1"></i>
                                                            Sin acciones
                                                        </span>
                                                    </c:if>

                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-calendar-times fa-4x mb-3 text-muted d-block"></i>
                                            <h5 class="text-muted">No tienes citas registradas</h5>
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
                <div class="row">
                    <div class="col-md-6">
                        <small class="text-muted">
                            <i class="fas fa-info-circle mr-1"></i>
                            Total de citas: <strong><c:out value="${citas != null ? citas.size() : 0}"/></strong>
                        </small>
                    </div>
                    <div class="col-md-6 text-right">
                        <c:if test="${not empty estadoFiltro}">
                            <small class="text-muted">
                                <i class="fas fa-filter mr-1"></i>
                                Filtrado por: <strong>${estadoFiltro}</strong>
                            </small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card informativa -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Leyenda de Estados
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <span class="badge badge-warning badge-lg mr-2">
                            <i class="fas fa-clock"></i> PENDIENTE
                        </span>
                        <p class="small mt-2">Cita agendada, esperando ser atendida. Puedes completarla o cancelarla.</p>
                    </div>
                    <div class="col-md-4">
                        <span class="badge badge-success badge-lg mr-2">
                            <i class="fas fa-check-circle"></i> COMPLETADA
                        </span>
                        <p class="small mt-2">Paciente fue atendido. Puedes agendar re-cita de seguimiento.</p>
                    </div>
                    <div class="col-md-4">
                        <span class="badge badge-danger badge-lg mr-2">
                            <i class="fas fa-times-circle"></i> CANCELADA
                        </span>
                        <p class="small mt-2">Cita cancelada. No hay acciones disponibles.</p>
                    </div>
                </div>
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
                                                                    const contextPath = '${pageContext.request.contextPath}';

                                                                    $(document).ready(function () {
                                                                        // Inicializar tooltips
                                                                        $('[data-toggle="tooltip"]').tooltip();

    <c:if test="${not empty citas}">
                                                                        // Inicializar DataTables
                                                                        if (typeof $.fn.DataTable !== 'undefined') {
                                                                            $('#citasTable').DataTable({
                                                                                "language": {
                                                                                    "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                                                                                },
                                                                                "order": [[1, "desc"], [2, "desc"]], // Ordenar por fecha y hora descendente
                                                                                "pageLength": 25,
                                                                                "responsive": true,
                                                                                "columnDefs": [
                                                                                    {"orderable": false, "targets": 7} // Deshabilitar orden en columna de Acciones
                                                                                ]
                                                                            });
                                                                        } else {
                                                                            console.warn('DataTables no se cargó correctamente');
                                                                        }
    </c:if>
                                                                    });

// ============================================
// FUNCIONES CON SWEETALERT2
// ============================================

                                                                    /**
                                                                     * Completa una cita con confirmación
                                                                     */
                                                                    function completarCita(idCita) {
                                                                        Swal.fire({
                                                                            title: '¿Completar cita?',
                                                                            html: 'Se marcará esta cita como <strong>completada</strong><br><small class="text-muted">Esto indica que el paciente fue atendido exitosamente</small>',
                                                                            icon: 'question',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#28a745',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-check-circle"></i> Sí, completar',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Completando la cita',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=completar&id=' + idCita + '&origen=citas';
                                                                            }
                                                                        });
                                                                    }

                                                                    /**
                                                                     * Cancela una cita con motivo opcional
                                                                     */
                                                                    function cancelarCita(idCita) {
                                                                        Swal.fire({
                                                                            title: '¿Cancelar cita?',
                                                                            html: '¿Deseas indicar el motivo de la cancelación?',
                                                                            icon: 'warning',
                                                                            input: 'textarea',
                                                                            inputPlaceholder: 'Motivo de la cancelación (opcional)...',
                                                                            inputAttributes: {
                                                                                'aria-label': 'Motivo de la cancelación',
                                                                                'maxlength': 200
                                                                            },
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#dc3545',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-ban"></i> Sí, cancelar cita',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> No',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                const motivo = result.value || '';

                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Cancelando la cita',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=cancelar&id=' + idCita + '&origen=citas&motivo=' + encodeURIComponent(motivo);
                                                                            }
                                                                        });
                                                                    }

                                                                    /**
                                                                     * Crea una re-cita de seguimiento
                                                                     */
                                                                    function crearRecita(idCita, idPaciente) {
                                                                        Swal.fire({
                                                                            title: '¿Crear re-cita de seguimiento?',
                                                                            html: 'Se agendará una nueva cita de <strong>seguimiento</strong> para este paciente<br><small class="text-muted">El administrador deberá confirmar la fecha y hora</small>',
                                                                            icon: 'question',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#17a2b8',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-redo"></i> Sí, crear re-cita',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Creando re-cita de seguimiento',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=nuevaRecita&idCita=' + idCita + '&idPaciente=' + idPaciente + '&origen=citas';
                                                                            }
                                                                        });
                                                                    }
</script>
