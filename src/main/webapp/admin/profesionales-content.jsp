<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Gestión de Profesionales</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Profesionales</li>
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

        <!-- Card con tabla de profesionales -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-user-md mr-2"></i>
                    Lista de Profesionales
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/ProfesionalServlet?accion=nuevo" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nuevo Profesional
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="profesionalesTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Nombre Completo</th>
                                <th>Email</th>
                                <th>Especialidad</th>
                                <th>Licencia</th>
                                <th>Teléfono</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty profesionales}">
                                    <c:forEach var="prof" items="${profesionales}">
                                        <tr>
                                            <!-- CÓDIGO DEL PROFESIONAL -->
                                            <td>
                                                <strong class="badge badge-light" style="font-size: 0.9rem;">
                                                    ${prof.codigoProfesional}
                                                </strong>
                                            </td>

                                            <!-- NOMBRE COMPLETO -->
                                            <td>
                                                <i class="fas fa-user-md mr-2"></i>
                                                ${prof.nombreUsuario}
                                            </td>

                                            <!-- EMAIL -->
                                            <td>
                                                <i class="fas fa-envelope mr-2"></i>
                                                ${prof.emailUsuario}
                                            </td>

                                            <!-- ESPECIALIDAD -->
                                            <td>
                                                <span class="badge badge-info">
                                                    <i class="fas fa-stethoscope mr-1"></i>
                                                    ${prof.nombreEspecialidad}
                                                </span>
                                            </td>

                                            <!-- LICENCIA -->
                                            <td>
                                                <i class="fas fa-id-card mr-1"></i>
                                                ${prof.numeroLicencia}
                                            </td>

                                            <!-- TELÉFONO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty prof.telefono}">
                                                        <i class="fas fa-phone mr-1"></i>
                                                        ${prof.telefono}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-minus"></i>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- ROL -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${prof.nombreRol == 'Especialista Médico'}">
                                                        <span class="badge badge-primary">
                                                            <i class="fas fa-user-md mr-1"></i>
                                                            Médico
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${prof.nombreRol == 'Especialista No Médico'}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-user-nurse mr-1"></i>
                                                            No Médico
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">${prof.nombreRol}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- ESTADO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${prof.activo}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check-circle mr-1"></i>
                                                            Activo
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">
                                                            <i class="fas fa-times-circle mr-1"></i>
                                                            Inactivo
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- ACCIONES -->
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/ProfesionalServlet?accion=editar&id=${prof.idProfesional}" 
                                                       class="btn btn-warning btn-sm"
                                                       title="Editar"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=${prof.idUsuario}" 
                                                       class="btn btn-info btn-sm"
                                                       title="Editar Usuario"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-user-edit"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-danger btn-sm"
                                                            onclick="eliminarProfesional(${prof.idProfesional}, '${prof.nombreUsuario}')"
                                                            title="Eliminar"
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
                                            <p class="text-muted">No hay profesionales registrados en el sistema</p>
                                            <a href="${pageContext.request.contextPath}/ProfesionalServlet?accion=nuevo" 
                                               class="btn btn-primary btn-sm mt-2">
                                                <i class="fas fa-plus mr-1"></i> Crear Primer Profesional
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
                <div class="row">
                    <div class="col-sm-6">
                        <small class="text-muted">
                            <i class="fas fa-info-circle mr-1"></i>
                            Total de profesionales: <strong><c:out value="${profesionales != null ? profesionales.size() : 0}"/></strong>
                        </small>
                    </div>
                    <div class="col-sm-6 text-right">
                        <small class="text-muted">
                            <i class="fas fa-lightbulb mr-1"></i>
                            Usa el botón <i class="fas fa-user-edit"></i> para editar los datos del usuario
                        </small>
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

<!-- ✅ Script con SweetAlert2 -->
<script>
                                                                const contextPath = '${pageContext.request.contextPath}';

                                                                $(document).ready(function () {
                                                                    // Inicializar tooltips
                                                                    $('[data-toggle="tooltip"]').tooltip();

                                                                    // Inicializar DataTable solo si hay profesionales
    <c:if test="${not empty profesionales}">
                                                                    if (typeof $.fn.DataTable !== 'undefined') {
                                                                        $('#profesionalesTable').DataTable({
                                                                            "language": {
                                                                                "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                                                                            },
                                                                            "order": [[0, "asc"]], // Ordenar por código ascendente
                                                                            "pageLength": 10,
                                                                            "responsive": true,
                                                                            "columnDefs": [
                                                                                {"orderable": false, "targets": 8} // Deshabilitar ordenamiento en columna Acciones
                                                                            ]
                                                                        });
                                                                    } else {
                                                                        console.warn('DataTables no se cargó correctamente');
                                                                    }
    </c:if>
                                                                });

                                                                /**
                                                                 * ✅ Eliminar profesional con SweetAlert2
                                                                 */
                                                                function eliminarProfesional(idProfesional, nombreProfesional) {
                                                                    Swal.fire({
                                                                        title: '¿Eliminar profesional?',
                                                                        html: '¿Estás seguro de eliminar al profesional <strong>"' + nombreProfesional + '"</strong>?<br><br>' +
                                                                                '<small class="text-muted"><i class="fas fa-info-circle mr-1"></i>Nota: Esto solo eliminará el registro profesional.<br>' +
                                                                                'El usuario permanecerá en el sistema.</small>',
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
                                                                                html: 'Eliminando registro profesional',
                                                                                allowOutsideClick: false,
                                                                                allowEscapeKey: false,
                                                                                didOpen: () => {
                                                                                    Swal.showLoading();
                                                                                }
                                                                            });

                                                                            // Redirigir al servlet para eliminar
                                                                            window.location.href = contextPath + '/ProfesionalServlet?accion=eliminar&id=' + idProfesional;
                                                                        }
                                                                    });
                                                                }
</script>
