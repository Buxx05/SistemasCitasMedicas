<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-users mr-2"></i>
                    Mis Pacientes
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Mis Pacientes</li>
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

        <!-- Card de pacientes -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Pacientes que he Atendido
                </h3>
                <div class="card-tools">
                    <span class="badge badge-primary badge-lg">
                        <i class="fas fa-user mr-1"></i>
                        ${pacientes != null ? pacientes.size() : 0} paciente(s)
                    </span>
                </div>
            </div>

            <div class="card-body">

                <!-- Buscador -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                              method="get" 
                              class="form-inline">
                            <input type="hidden" name="accion" value="buscar">
                            <div class="input-group input-group-lg" style="width: 100%;">
                                <input type="text" 
                                       name="busqueda" 
                                       class="form-control" 
                                       placeholder="Buscar por DNI o nombre..."
                                       value="${busqueda}"
                                       autofocus>
                                <div class="input-group-append">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Buscar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-6 text-right">
                        <c:if test="${not empty busqueda}">
                            <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                               class="btn btn-secondary btn-lg">
                                <i class="fas fa-times"></i> Limpiar Búsqueda
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Mensaje de búsqueda -->
                <c:if test="${not empty busqueda}">
                    <div class="alert alert-info alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <i class="fas fa-info-circle mr-2"></i>
                        Mostrando resultados para: <strong>"${busqueda}"</strong>
                    </div>
                </c:if>

                <!-- Tabla de pacientes -->
                <div class="table-responsive">
                    <table id="pacientesTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Paciente</th>
                                <th>DNI</th>
                                <th>Género</th>
                                <th>Teléfono</th>
                                <th>Total Citas</th>
                                <th>Completadas</th>
                                <th>Última Cita</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty pacientes}">
                                    <c:forEach var="paciente" items="${pacientes}">
                                        <c:set var="stats" value="${estadisticasPacientes[paciente.idPaciente]}"/>
                                        <tr>
                                            <td>
                                                <strong>${paciente.nombreCompleto}</strong>
                                                <br>
                                                <small class="text-muted">
                                                    <i class="far fa-envelope mr-1"></i>
                                                    ${not empty paciente.email ? paciente.email : 'Sin email'}
                                                </small>
                                            </td>
                                            <td>${paciente.dni}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${paciente.genero == 'M'}">
                                                        <span class="badge badge-info">
                                                            <i class="fas fa-mars mr-1"></i>
                                                            Masculino
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${paciente.genero == 'F'}">
                                                        <span class="badge badge-pink">
                                                            <i class="fas fa-venus mr-1"></i>
                                                            Femenino
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">Otro</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="fas fa-phone mr-1"></i>
                                                ${not empty paciente.telefono ? paciente.telefono : 'Sin teléfono'}
                                            </td>
                                            <td class="text-center">
                                                <span class="badge badge-primary badge-lg">
                                                    ${stats.totalCitas}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge badge-success badge-lg">
                                                    ${stats.citasCompletadas}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${not empty stats.ultimaCita}">
                                                    <i class="far fa-calendar mr-1"></i>
                                                    <fmt:parseDate value="${stats.ultimaCita}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                    <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=ver&id=${paciente.idPaciente}" 
                                                   class="btn btn-info btn-sm"
                                                   title="Ver detalle completo">
                                                    <i class="fas fa-eye"></i> Ver Detalle
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-user-slash fa-4x mb-3 text-muted"></i>
                                            <h5 class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty busqueda}">
                                                        No se encontraron pacientes con "${busqueda}"
                                                    </c:when>
                                                    <c:otherwise>
                                                        No has atendido pacientes aún
                                                    </c:otherwise>
                                                </c:choose>
                                            </h5>
                                            <p class="text-muted">
                                                Los pacientes que atiendas aparecerán aquí
                                            </p>
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
                    Solo se muestran pacientes con al menos una cita completada
                </small>
            </div>
        </div>

    </div>
</section>

<!-- CSS adicional para badge rosa -->
<style>
    .badge-pink {
        background-color: #e83e8c;
        color: white;
    }
</style>

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<!-- Script personalizado -->
<script>
    $(document).ready(function () {
    <c:if test="${not empty pacientes && pacientes.size() > 0}">
        $('#pacientesTable').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
            }
            ,
            "order": [[6, "desc"]], // Ordenar por última cita (columna 6)
            "pageLength": 10,
            "responsive": true,
            "columnDefs": [
                {"orderable": false, "targets": 7} // Desactivar orden en columna Acciones
            ]
        });
    </c:if>
    });
</script>
