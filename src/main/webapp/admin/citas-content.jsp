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

        <!-- Tabla de citas -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-alt mr-2"></i> Lista de Citas
                </h3>

                <div class="card-tools">
                    <!-- Filtros rápidos por estado -->
                    <div class="btn-group mr-2" role="group">
                        <a href="${pageContext.request.contextPath}/CitaServlet" 
                           class="btn btn-sm ${empty param.estado ? 'btn-secondary' : 'btn-outline-secondary'}">
                            <i class="fas fa-list"></i> Todas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaServlet?accion=filtrar&tipoFiltro=estado&estado=PENDIENTE" 
                           class="btn btn-sm ${param.estado == 'PENDIENTE' ? 'btn-warning' : 'btn-outline-warning'}">
                            <i class="fas fa-clock"></i> Pendientes
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaServlet?accion=filtrar&tipoFiltro=estado&estado=COMPLETADA" 
                           class="btn btn-sm ${param.estado == 'COMPLETADA' ? 'btn-success' : 'btn-outline-success'}">
                            <i class="fas fa-check"></i> Completadas
                        </a>
                        <a href="${pageContext.request.contextPath}/CitaServlet?accion=filtrar&tipoFiltro=estado&estado=CANCELADA" 
                           class="btn btn-sm ${param.estado == 'CANCELADA' ? 'btn-danger' : 'btn-outline-danger'}">
                            <i class="fas fa-times"></i> Canceladas
                        </a>
                    </div>

                    <!-- Botón Nueva Cita -->
                    <a href="${pageContext.request.contextPath}/CitaServlet?accion=nuevo" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nueva Cita
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="citasTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
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
                                            <!-- CÓDIGO -->
                                            <td>
                                                <strong class="badge badge-light" style="font-size: 0.9rem;">
                                                    ${cita.codigoCita}
                                                </strong>
                                            </td>

                                            <!-- PACIENTE -->
                                            <td>
                                                <i class="fas fa-user-injured mr-1"></i>
                                                <strong>${cita.nombrePaciente}</strong><br>
                                                <small class="text-muted">DNI: ${cita.dniPaciente}</small>
                                            </td>

                                            <!-- PROFESIONAL -->
                                            <td>
                                                <i class="fas fa-user-md mr-1"></i>${cita.nombreProfesional}
                                            </td>

                                            <!-- ESPECIALIDAD -->
                                            <td>
                                                <span class="badge badge-info">${cita.nombreEspecialidad}</span>
                                            </td>

                                            <!-- FECHA -->
                                            <td><i class="far fa-calendar mr-1"></i>${cita.fechaCita}</td>

                                            <!-- HORA -->
                                            <td><i class="far fa-clock mr-1"></i>${cita.horaCita}</td>

                                            <!-- MOTIVO -->
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

                                            <!-- ESTADO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cita.estado == 'PENDIENTE'}">
                                                        <span class="badge badge-warning">
                                                            <i class="fas fa-clock mr-1"></i>Pendiente
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'COMPLETADA'}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check-double mr-1"></i>Completada
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'CANCELADA'}">
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-times mr-1"></i>Cancelada
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>

                                            <!-- ACCIONES -->
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/CitaServlet?accion=editar&id=${cita.idCita}" 
                                                       class="btn btn-warning"
                                                       title="Editar cita"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <button type="button" 
                                                            class="btn btn-danger"
                                                            onclick="eliminarCita(${cita.idCita}, '${cita.nombrePaciente}', '${cita.fechaCita}', '${cita.estado}')"
                                                            title="Eliminar cita"
                                                            data-toggle="tooltip">
                                                        <i class="fas fa-trash"></i>
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

<!-- DataTables -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<!-- ✅ Script con SweetAlert2 -->
<script>
                                                                const contextPath = '${pageContext.request.contextPath}';

                                                                $(document).ready(function () {
                                                                    // Inicializar tooltips
                                                                    $('[data-toggle="tooltip"]').tooltip();

                                                                    // Inicializar DataTable
    <c:if test="${not empty citas}">
                                                                    if (typeof $.fn.DataTable !== 'undefined') {
                                                                        $('#citasTable').DataTable({
                                                                            language: {url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"},
                                                                            order: [[4, "desc"], [5, "desc"]], // Ordenar por fecha y hora
                                                                            pageLength: 10,
                                                                            responsive: true,
                                                                            columnDefs: [{orderable: false, targets: 8}] // Deshabilitar orden en Acciones
                                                                        });
                                                                    } else {
                                                                        console.warn('DataTables no se cargó correctamente');
                                                                    }
    </c:if>
                                                                });

                                                                /**
                                                                 * ✅ Eliminar cita con SweetAlert2 (doble confirmación para completadas)
                                                                 */
                                                                function eliminarCita(idCita, nombrePaciente, fecha, estado) {
                                                                    // Si la cita está COMPLETADA, requiere doble confirmación
                                                                    if (estado === 'COMPLETADA') {
                                                                        Swal.fire({
                                                                            title: '⚠️ ADVERTENCIA',
                                                                            html: 'Esta cita ya fue <strong class="text-success">COMPLETADA</strong>.<br><br>' +
                                                                                    'Eliminar una cita completada <strong class="text-danger">borrará el registro médico histórico</strong>.<br><br>' +
                                                                                    '¿Estás seguro de eliminar la cita de <strong>"' + nombrePaciente + '"</strong> del <strong>' + fecha + '</strong>?',
                                                                            icon: 'error',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#dc3545',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-exclamation-triangle"></i> Continuar',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Segunda confirmación
                                                                                Swal.fire({
                                                                                    title: 'Confirma nuevamente',
                                                                                    html: '¿Eliminar cita completada?<br><small class="text-muted">Esta acción no se puede deshacer</small>',
                                                                                    icon: 'warning',
                                                                                    showCancelButton: true,
                                                                                    confirmButtonColor: '#dc3545',
                                                                                    cancelButtonColor: '#6c757d',
                                                                                    confirmButtonText: '<i class="fas fa-trash"></i> Sí, eliminar',
                                                                                    cancelButtonText: '<i class="fas fa-times"></i> No',
                                                                                    reverseButtons: true,
                                                                                    focusCancel: true
                                                                                }).then((result2) => {
                                                                                    if (result2.isConfirmed) {
                                                                                        // Mostrar mensaje de carga
                                                                                        Swal.fire({
                                                                                            title: 'Eliminando...',
                                                                                            html: 'Eliminando cita completada',
                                                                                            allowOutsideClick: false,
                                                                                            allowEscapeKey: false,
                                                                                            didOpen: () => {
                                                                                                Swal.showLoading();
                                                                                            }
                                                                                        });

                                                                                        // Eliminar
                                                                                        window.location.href = contextPath + '/CitaServlet?accion=eliminar&id=' + idCita;
                                                                                    }
                                                                                });
                                                                            }
                                                                        });
                                                                    } else {
                                                                        // Cita NO completada (PENDIENTE o CANCELADA)
                                                                        Swal.fire({
                                                                            title: '¿Eliminar cita?',
                                                                            html: '¿Estás seguro de eliminar la cita de <strong>"' + nombrePaciente + '"</strong> para el día <strong>' + fecha + '</strong>?<br><small class="text-muted">Esta acción no se puede deshacer</small>',
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
                                                                                    html: 'Eliminando cita médica',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                // Eliminar
                                                                                window.location.href = contextPath + '/CitaServlet?accion=eliminar&id=' + idCita;
                                                                            }
                                                                        });
                                                                    }
                                                                }
</script>
