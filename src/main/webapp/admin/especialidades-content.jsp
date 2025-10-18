<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Gestión de Especialidades</h1>
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

        <!-- Card con tabla de especialidades -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-briefcase-medical mr-2"></i>
                    Lista de Especialidades
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=nuevo" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nueva Especialidad
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="row">
                    <c:choose>
                        <c:when test="${not empty especialidades}">
                            <c:forEach var="esp" items="${especialidades}">
                                <div class="col-md-4 col-sm-6">
                                    <div class="card card-outline card-info">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-stethoscope mr-2"></i>
                                                ${esp.nombre}
                                            </h3>
                                            <div class="card-tools">
                                                <span class="badge badge-info">ID: ${esp.idEspecialidad}</span>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty esp.descripcion}">
                                                    ${esp.descripcion}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Sin descripción</em>
                                                </c:otherwise>
                                            </c:choose>
                                            </p>
                                        </div>
                                        <div class="card-footer">
                                            <div class="row">
                                                <div class="col-6">
                                                    <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=editar&id=${esp.idEspecialidad}" 
                                                       class="btn btn-warning btn-sm btn-block">
                                                        <i class="fas fa-edit"></i> Editar
                                                    </a>
                                                </div>
                                                <div class="col-6">
                                                    <button type="button" 
                                                            class="btn btn-danger btn-sm btn-block"
                                                            onclick="confirmarEliminacion(${esp.idEspecialidad}, '${esp.nombre}')">
                                                        <i class="fas fa-trash"></i> Eliminar
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="alert alert-info text-center py-5">
                                    <i class="fas fa-info-circle fa-3x mb-3"></i>
                                    <h5>No hay especialidades registradas</h5>
                                    <p class="text-muted">Comienza agregando la primera especialidad al sistema</p>
                                    <a href="${pageContext.request.contextPath}/EspecialidadServlet?accion=nuevo" 
                                       class="btn btn-primary mt-2">
                                        <i class="fas fa-plus mr-1"></i> Crear Primera Especialidad
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card-footer">
                <small class="text-muted">
                    <i class="fas fa-info-circle mr-1"></i>
                    Total de especialidades: <strong><c:out value="${especialidades != null ? especialidades.size() : 0}"/></strong>
                </small>
            </div>
        </div>

        <!-- Card informativa -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-lightbulb mr-2"></i>
                    Información
                </h3>
            </div>
            <div class="card-body">
                <ul class="mb-0">
                    <li>Las especialidades son asignadas a los profesionales médicos y no médicos</li>
                    <li>No se puede eliminar una especialidad que tenga profesionales asignados</li>
                    <li>Los nombres de especialidades deben ser únicos en el sistema</li>
                </ul>
            </div>
        </div>

    </div>
</section>

<!-- Script para confirmar eliminación -->
<script>
    function confirmarEliminacion(id, nombre) {
        if (confirm('¿Estás seguro de eliminar la especialidad "' + nombre + '"?\n\n' +
                'Nota: No podrás eliminarla si tiene profesionales asignados.')) {
            window.location.href = '${pageContext.request.contextPath}/EspecialidadServlet?accion=eliminar&id=' + id;
        }
    }
</script>
