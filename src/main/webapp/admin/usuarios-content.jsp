<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Gestión de Usuarios</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Usuarios</li>
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

        <!-- Card con tabla de usuarios -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-users mr-2"></i>
                    Lista de Usuarios
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=nuevo" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nuevo Usuario
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="usuariosTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Nombre Completo</th>
                                <th>Email</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Fecha Registro</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty usuarios}">
                                    <c:forEach var="usuario" items="${usuarios}">
                                        <tr>
                                            <!-- CÓDIGO DEL USUARIO -->
                                            <td>
                                                <strong class="badge badge-light" style="font-size: 0.9rem;">
                                                    ${usuario.codigoUsuario}
                                                </strong>
                                            </td>

                                            <!-- NOMBRE COMPLETO -->
                                            <td>
                                                <i class="fas fa-user mr-2"></i>
                                                ${usuario.nombreCompleto}
                                            </td>

                                            <!-- EMAIL -->
                                            <td>
                                                <i class="fas fa-envelope mr-2"></i>
                                                ${usuario.email}
                                            </td>

                                            <!-- ROL -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${usuario.idRol == 1}">
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-user-shield mr-1"></i>
                                                            ${usuario.nombreRol}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${usuario.idRol == 2}">
                                                        <span class="badge badge-primary">
                                                            <i class="fas fa-user-md mr-1"></i>
                                                            ${usuario.nombreRol}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${usuario.idRol == 3}">
                                                        <span class="badge badge-info">
                                                            <i class="fas fa-user-nurse mr-1"></i>
                                                            ${usuario.nombreRol}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">${usuario.nombreRol}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- ESTADO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${usuario.activo}">
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

                                            <!-- FECHA REGISTRO -->
                                            <td>
                                                <i class="far fa-calendar mr-1"></i>
                                                ${usuario.fechaRegistro}
                                            </td>

                                            <!-- ACCIONES -->
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=${usuario.idUsuario}" 
                                                       class="btn btn-warning btn-sm"
                                                       title="Editar"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <c:choose>
                                                        <c:when test="${sessionScope.usuario.idUsuario == usuario.idUsuario}">
                                                            <button type="button" 
                                                                    class="btn btn-danger btn-sm disabled"
                                                                    title="No puedes eliminar tu propia cuenta"
                                                                    data-toggle="tooltip"
                                                                    disabled>
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" 
                                                                    class="btn btn-danger btn-sm"
                                                                    onclick="eliminarUsuario(${usuario.idUsuario}, '${usuario.nombreCompleto}')"
                                                                    title="Eliminar"
                                                                    data-toggle="tooltip">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4">
                                            <i class="fas fa-info-circle fa-2x mb-3 text-muted"></i>
                                            <p class="text-muted">No hay usuarios registrados en el sistema</p>
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
                    Total de usuarios: <strong>${usuarios.size()}</strong>
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

<!-- ✅ Script con SweetAlert2 -->
<script>
                                                                        const contextPath = '${pageContext.request.contextPath}';

                                                                        $(document).ready(function () {
                                                                            // Inicializar tooltips
                                                                            $('[data-toggle="tooltip"]').tooltip();

                                                                            // Inicializar DataTable
    <c:if test="${not empty usuarios}">
                                                                            if (typeof $.fn.DataTable !== 'undefined') {
                                                                                $('#usuariosTable').DataTable({
                                                                                    "language": {
                                                                                        "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                                                                                    },
                                                                                    "order": [[0, "asc"]], // Ordenar por código
                                                                                    "pageLength": 10,
                                                                                    "responsive": true,
                                                                                    "columnDefs": [
                                                                                        {"orderable": false, "targets": 6} // Deshabilitar ordenamiento en columna Acciones
                                                                                    ]
                                                                                });
                                                                            } else {
                                                                                console.warn('DataTables no se cargó correctamente');
                                                                            }
    </c:if>
                                                                        });

                                                                        /**
                                                                         * ✅ Eliminar usuario con SweetAlert2
                                                                         */
                                                                        function eliminarUsuario(idUsuario, nombreUsuario) {
                                                                            Swal.fire({
                                                                                title: '¿Eliminar usuario?',
                                                                                html: '¿Estás seguro de eliminar al usuario <strong>"' + nombreUsuario + '"</strong>?<br><small class="text-muted">Esta acción no se puede deshacer y eliminará todos los datos relacionados</small>',
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
                                                                                        html: 'Eliminando usuario del sistema',
                                                                                        allowOutsideClick: false,
                                                                                        allowEscapeKey: false,
                                                                                        didOpen: () => {
                                                                                            Swal.showLoading();
                                                                                        }
                                                                                    });

                                                                                    // Redirigir al servlet para eliminar
                                                                                    window.location.href = contextPath + '/UsuarioServlet?accion=eliminar&id=' + idUsuario;
                                                                                }
                                                                            });
                                                                        }
</script>
