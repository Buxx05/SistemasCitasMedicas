<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .swal-wide {
        width: 600px !important;
    }
</style>
<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-briefcase-medical mr-2"></i>
                    Gestión de Especialidades
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Especialidades</li>
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

        <!-- Botón Nueva Especialidad (destacado arriba) -->
        <div class="row mb-3">
            <div class="col-12">
                <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=nuevo" 
                   class="btn btn-primary btn-lg">
                    <i class="fas fa-plus-circle mr-2"></i> Nueva Especialidad
                </a>
            </div>
        </div>

        <!-- Card con tarjetas de especialidades -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Lista de Especialidades
                </h3>
                <div class="card-tools">
                    <span class="badge badge-primary badge-lg">
                        Total: <c:out value="${especialidades != null ? especialidades.size() : 0}"/>
                    </span>
                </div>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty especialidades}">
                        <div class="row">
                            <c:forEach var="esp" items="${especialidades}">
                                <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                                    <div class="card card-outline card-info h-100">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-stethoscope mr-2"></i>
                                                <strong>${esp.nombre}</strong>
                                            </h3>
                                            <div class="card-tools">
                                                <span class="badge badge-primary">${esp.codigo}</span>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <p class="text-muted mb-0">
                                                <c:choose>
                                                    <c:when test="${not empty esp.descripcion}">
                                                        ${esp.descripcion}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-black-50">Sin descripción disponible</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <div class="btn-group d-flex" role="group">
                                                <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=editar&id=${esp.idEspecialidad}" 
                                                   class="btn btn-warning btn-sm w-50"
                                                   title="Editar especialidad"
                                                   data-toggle="tooltip">
                                                    <i class="fas fa-edit"></i> Editar
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-danger btn-sm w-50"
                                                        onclick="eliminarEspecialidad(${esp.idEspecialidad}, '${esp.nombre}', '${esp.codigo}')"
                                                        title="Eliminar especialidad"
                                                        data-toggle="tooltip">
                                                    <i class="fas fa-trash-alt"></i> Eliminar
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center py-5">
                            <i class="fas fa-info-circle fa-4x mb-3 text-info"></i>
                            <h4>No hay especialidades registradas</h4>
                            <p class="text-muted mb-4">Comienza agregando la primera especialidad al sistema</p>
                            <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=nuevo" 
                               class="btn btn-primary btn-lg">
                                <i class="fas fa-plus-circle mr-2"></i> Crear Primera Especialidad
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Card informativa -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Información Importante
                </h3>
            </div>
            <div class="card-body">
                <ul class="mb-0">
                    <li class="mb-2">
                        <i class="fas fa-hashtag text-primary mr-2"></i>
                        Los códigos se generan automáticamente y no se pueden modificar
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-check-circle text-success mr-2"></i>
                        Las especialidades son asignadas a los profesionales médicos y no médicos
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-exclamation-triangle text-warning mr-2"></i>
                        No se puede eliminar una especialidad que tenga profesionales asignados
                    </li>
                    <li>
                        <i class="fas fa-shield-alt text-info mr-2"></i>
                        Los nombres de especialidades deben ser únicos en el sistema
                    </li>
                </ul>
            </div>
        </div>

    </div>
</section>

<!-- ✅ Script con SweetAlert2 -->
<script>
    const contextPath = '${pageContext.request.contextPath}';

    $(document).ready(function () {
        // Inicializar tooltips
        $('[data-toggle="tooltip"]').tooltip();
    });

    /**
     * ✅ Eliminar especialidad con SweetAlert2
     */
    function eliminarEspecialidad(idEspecialidad, nombreEspecialidad, codigoEspecialidad) {
        Swal.fire({
            title: '¿Eliminar especialidad?',
            html: '<p class="mb-3">¿Estás seguro de eliminar la especialidad?</p>' +
                    '<div style="background: #f8f9fa; padding: 15px; border-radius: 5px; border-left: 4px solid #007bff;">' +
                    '<p class="mb-2"><strong>Código:</strong> <span class="badge badge-primary">' + codigoEspecialidad + '</span></p>' +
                    '<p class="mb-0"><strong>Nombre:</strong> <span style="color: #dc3545; font-weight: bold;">' + nombreEspecialidad + '</span></p>' +
                    '</div>' +
                    '<div style="background: #fff3cd; padding: 10px; border-radius: 5px; margin-top: 15px; border-left: 4px solid #ffc107;">' +
                    '<small><i class="fas fa-info-circle mr-1"></i>No podrás eliminarla si tiene profesionales asignados.</small>' +
                    '</div>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: '<i class="fas fa-trash-alt"></i> Sí, eliminar',
            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
            reverseButtons: true,
            focusCancel: true,
            customClass: {
                popup: 'swal-wide'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                // Mostrar mensaje de carga
                Swal.fire({
                    title: 'Eliminando...',
                    html: 'Eliminando especialidad del sistema',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Redirigir al servlet para eliminar
                window.location.href = contextPath + '/EspecialidadServlet?accion=eliminar&id=' + idEspecialidad;
            }
        });
    }
</script>

