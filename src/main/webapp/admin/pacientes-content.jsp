<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Gestión de Pacientes</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Pacientes</li>
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

        <!-- Card con tabla de pacientes -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-hospital-user mr-2"></i>
                    Lista de Pacientes
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/PacienteServlet?accion=nuevo" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nuevo Paciente
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="pacientesTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Nombre Completo</th>
                                <th>DNI</th>
                                <th>Fecha Nacimiento</th>
                                <th>Género</th>
                                <th>Teléfono</th>
                                <th>Email</th>
                                <th>Fecha Registro</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty pacientes}">
                                    <c:forEach var="pac" items="${pacientes}">
                                        <tr>
                                            <!-- CÓDIGO DEL PACIENTE -->
                                            <td>
                                                <strong class="badge badge-light" style="font-size: 0.9rem;">
                                                    ${pac.codigoPaciente}
                                                </strong>
                                            </td>

                                            <!-- NOMBRE COMPLETO -->
                                            <td>
                                                <i class="fas fa-user mr-2"></i>
                                                ${pac.nombreCompleto}
                                            </td>

                                            <!-- DNI -->
                                            <td>
                                                <i class="fas fa-id-card mr-1"></i>
                                                ${pac.dni}
                                            </td>

                                            <!-- FECHA NACIMIENTO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty pac.fechaNacimiento}">
                                                        <i class="far fa-calendar mr-1"></i>
                                                        ${pac.fechaNacimiento}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-minus"></i>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- GÉNERO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pac.genero == 'M'}">
                                                        <span class="badge badge-primary">
                                                            <i class="fas fa-mars mr-1"></i>
                                                            Masculino
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pac.genero == 'F'}">
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-venus mr-1"></i>
                                                            Femenino
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">
                                                            <i class="fas fa-genderless mr-1"></i>
                                                            Otro
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- TELÉFONO -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty pac.telefono}">
                                                        <i class="fas fa-phone mr-1"></i>
                                                        ${pac.telefono}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-minus"></i>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- EMAIL -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty pac.email}">
                                                        <i class="fas fa-envelope mr-1"></i>
                                                        ${pac.email}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-minus"></i>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- FECHA REGISTRO -->
                                            <td>
                                                <i class="far fa-calendar-check mr-1"></i>
                                                ${pac.fechaRegistro}
                                            </td>

                                            <!-- ACCIONES -->
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/PacienteServlet?accion=editar&id=${pac.idPaciente}" 
                                                       class="btn btn-warning btn-sm"
                                                       title="Editar"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-danger btn-sm"
                                                            onclick="eliminarPaciente(${pac.idPaciente}, '${pac.nombreCompleto}')"
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
                                            <p class="text-muted">No hay pacientes registrados en el sistema</p>
                                            <a href="${pageContext.request.contextPath}/PacienteServlet?accion=nuevo" 
                                               class="btn btn-primary btn-sm mt-2">
                                                <i class="fas fa-plus mr-1"></i> Registrar Primer Paciente
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
                    Total de pacientes: <strong><c:out value="${pacientes != null ? pacientes.size() : 0}"/></strong>
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
    <c:if test="${not empty pacientes}">
                                                                    if (typeof $.fn.DataTable !== 'undefined') {
                                                                        $('#pacientesTable').DataTable({
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
                                                                 * ✅ Eliminar paciente con SweetAlert2
                                                                 */
                                                                function eliminarPaciente(idPaciente, nombrePaciente) {
                                                                    Swal.fire({
                                                                        title: '¿Eliminar paciente?',
                                                                        html: '¿Estás seguro de eliminar al paciente <strong>"' + nombrePaciente + '"</strong>?<br><small class="text-muted">Esta acción no se puede deshacer y eliminará todos los datos relacionados (citas, historial clínico, recetas, etc.)</small>',
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
                                                                                html: 'Eliminando paciente y todos sus datos relacionados',
                                                                                allowOutsideClick: false,
                                                                                allowEscapeKey: false,
                                                                                didOpen: () => {
                                                                                    Swal.showLoading();
                                                                                }
                                                                            });

                                                                            // Redirigir al servlet para eliminar
                                                                            window.location.href = contextPath + '/PacienteServlet?accion=eliminar&id=' + idPaciente;
                                                                        }
                                                                    });
                                                                }
</script>
