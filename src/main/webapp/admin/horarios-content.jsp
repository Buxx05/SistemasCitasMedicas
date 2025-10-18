<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Mis Horarios de Atención</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Mis Horarios</li>
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

        <!-- Card informativo -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Información sobre Horarios
                </h3>
            </div>
            <div class="card-body">
                <ul class="mb-0">
                    <li>Define los días y horas en que atenderás a tus pacientes.</li>
                    <li>La <strong>duración de consulta</strong> se usa para generar bloques de tiempo (ejemplo: 30 minutos).</li>
                    <li>Los administradores solo podrán agendar citas dentro de los horarios definidos aquí.</li>
                    <li>Puedes desactivar temporalmente un horario sin eliminarlo.</li>
                </ul>
            </div>
        </div>

        <!-- Card con tabla de horarios -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-week mr-2"></i> Mis Horarios Configurados
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=nuevo"
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Nuevo Horario
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="horariosTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Día</th>
                                <th>Hora Inicio</th>
                                <th>Hora Fin</th>
                                <th>Duración Consulta</th>
                                <th>Bloques Generados</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty horarios}">
                                <c:forEach var="h" items="${horarios}">
                                    <tr>
                                        <td>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${h.diaSemana == 'LUNES'}"><i class="fas fa-calendar-day text-primary mr-1"></i> Lunes</c:when>
                                                    <c:when test="${h.diaSemana == 'MARTES'}"><i class="fas fa-calendar-day text-success mr-1"></i> Martes</c:when>
                                                    <c:when test="${h.diaSemana == 'MIERCOLES'}"><i class="fas fa-calendar-day text-info mr-1"></i> Miércoles</c:when>
                                                    <c:when test="${h.diaSemana == 'JUEVES'}"><i class="fas fa-calendar-day text-warning mr-1"></i> Jueves</c:when>
                                                    <c:when test="${h.diaSemana == 'VIERNES'}"><i class="fas fa-calendar-day text-danger mr-1"></i> Viernes</c:when>
                                                    <c:when test="${h.diaSemana == 'SABADO'}"><i class="fas fa-calendar-day text-secondary mr-1"></i> Sábado</c:when>
                                                    <c:when test="${h.diaSemana == 'DOMINGO'}"><i class="fas fa-calendar-day text-dark mr-1"></i> Domingo</c:when>
                                                </c:choose>
                                            </strong>
                                        </td>
                                        <td><i class="far fa-clock mr-1"></i>${h.horaInicio}</td>
                                        <td><i class="far fa-clock mr-1"></i>${h.horaFin}</td>
                                        <td>
                                            <span class="badge badge-info">
                                                <i class="fas fa-hourglass-half mr-1"></i>${h.duracionConsulta} min
                                            </span>
                                        </td>
                                        <td>
                                    <c:set var="inicio" value="${h.horaInicio.substring(0,2)}"/>
                                    <c:set var="fin" value="${h.horaFin.substring(0,2)}"/>
                                    <c:set var="horas" value="${fin - inicio}"/>
                                    <c:set var="bloques" value="${(horas * 60) / h.duracionConsulta}"/>

                                    <span class="badge badge-secondary">
                                        <i class="fas fa-th mr-1"></i>${bloques} bloques
                                    </span>
                                    <br>
                                    <small class="text-muted">(${horas} horas disponibles)</small>
                                    </td>
                                    <td>
                                    <c:choose>
                                        <c:when test="${h.activo}">
                                            <span class="badge badge-success">
                                                <i class="fas fa-check-circle mr-1"></i> Activo
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">
                                                <i class="fas fa-times-circle mr-1"></i> Inactivo
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=editar&id=${h.idHorario}"
                                               class="btn btn-warning btn-sm" title="Editar">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" class="btn btn-danger btn-sm"
                                                    onclick="confirmarEliminacion(${h.idHorario}, '${h.diaSemana}')"
                                                    title="Eliminar">
                                                <i class="fas fa-trash"></i>
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
                                        <h5>No has configurado horarios de atención</h5>
                                        <p class="text-muted">
                                            Configura tus horarios para que los administradores puedan agendar citas.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=nuevo"
                                           class="btn btn-primary mt-2">
                                            <i class="fas fa-plus mr-1"></i> Configurar Mi Primer Horario
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
                    Total de horarios configurados:
                    <strong><c:out value="${horarios != null ? horarios.size() : 0}"/></strong>
                </small>
            </div>
        </div>
    </div>
</section>

<!-- Script para confirmar eliminación -->
<script>
    function confirmarEliminacion(id, dia) {
    if (confirm('¿Estás seguro de eliminar el horario del ' + dia + '?\n\nEsta acción no se puede deshacer.')) {
    window.location.href = '${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=eliminar&id=' + id;
    }
    }
</script>

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<!-- Inicializar DataTable -->
<script>
    $(document).ready(function() {
    <c:if test="${not empty horarios}">
                        $('#horariosTable').DataTable({
            "language": {
            "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
            },
            "order": [[0, "asc"]],
            "pageLength": 10,
            "responsive": true,
            "columnDefs": [
            {"orderable": false, "targets": 6}
            ]
        });
        </c:if>
    });
</script>
