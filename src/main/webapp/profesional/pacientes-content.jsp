<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- CSS personalizado -->
<style>
    .badge-pink {
        background-color: #e83e8c;
        color: white;
    }

    .badge-lg {
        font-size: 0.9rem;
        padding: 0.4rem 0.6rem;
    }

    .paciente-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
        margin-right: 10px;
    }

    .avatar-masculino {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .avatar-femenino {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }

    .avatar-otro {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }
</style>

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

                <!-- Tabla de pacientes -->
                <div class="table-responsive">
                    <table id="pacientesTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Paciente</th>
                                <th>DNI</th>
                                <th>Género</th>
                                <th>Edad</th>
                                <th>Contacto</th>
                                <th class="text-center">Total Citas</th>
                                <th class="text-center">Completadas</th>
                                <th>Última Cita</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty pacientes}">
                                    <c:forEach var="paciente" items="${pacientes}">
                                        <c:set var="stats" value="${estadisticasPacientes[paciente.idPaciente]}"/>
                                        <tr>
                                            <!-- Código del Paciente -->
                                            <td>
                                                <span class="badge badge-secondary">${paciente.codigoPaciente}</span>
                                            </td>

                                            <!-- Paciente con Avatar -->
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <!-- Avatar con iniciales -->
                                                    <c:set var="iniciales" value="${paciente.nombreCompleto.substring(0, 1)}"/>
                                                    <c:choose>
                                                        <c:when test="${paciente.genero == 'M'}">
                                                            <div class="paciente-avatar avatar-masculino">${iniciales}</div>
                                                        </c:when>
                                                        <c:when test="${paciente.genero == 'F'}">
                                                            <div class="paciente-avatar avatar-femenino">${iniciales}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="paciente-avatar avatar-otro">${iniciales}</div>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <div>
                                                        <strong>${paciente.nombreCompleto}</strong>
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="far fa-calendar-alt mr-1"></i>
                                                            <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNac"/>
                                                            <fmt:formatDate value="${fechaNac}" pattern="dd/MM/yyyy"/>
                                                        </small>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- DNI -->
                                            <td>
                                                <i class="fas fa-id-card mr-1 text-muted"></i>
                                                ${paciente.dni}
                                            </td>

                                            <!-- Género con iconos -->
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
                                                        <span class="badge badge-secondary">
                                                            <i class="fas fa-genderless mr-1"></i>
                                                            Otro
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Edad calculada -->
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${paciente.edad > 0}">
                                                        <strong>${paciente.edad}</strong> años
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Contacto -->
                                            <td>
                                                <c:if test="${not empty paciente.telefono}">
                                                    <div>
                                                        <i class="fas fa-phone mr-1 text-primary"></i>
                                                        ${paciente.telefono}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty paciente.email}">
                                                    <div>
                                                        <i class="far fa-envelope mr-1 text-info"></i>
                                                        <small>${paciente.email}</small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${empty paciente.telefono && empty paciente.email}">
                                                    <span class="text-muted">Sin contacto</span>
                                                </c:if>
                                            </td>

                                            <!-- Total Citas -->
                                            <td class="text-center">
                                                <span class="badge badge-primary badge-lg">
                                                    <i class="fas fa-calendar-alt mr-1"></i>
                                                    ${stats.totalCitas}
                                                </span>
                                            </td>

                                            <!-- Completadas -->
                                            <td class="text-center">
                                                <span class="badge badge-success badge-lg">
                                                    <i class="fas fa-check-circle mr-1"></i>
                                                    ${stats.citasCompletadas}
                                                </span>
                                            </td>

                                            <!-- Última Cita -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty stats.ultimaCita}">
                                                        <i class="far fa-calendar mr-1 text-success"></i>
                                                        <fmt:parseDate value="${stats.ultimaCita}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                        <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">
                                                            <i class="fas fa-ban mr-1"></i>
                                                            Sin citas
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Acciones -->
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=ver&id=${paciente.idPaciente}" 
                                                       class="btn btn-info"
                                                       title="Ver historial completo">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center py-5">
                                            <i class="fas fa-user-slash fa-4x mb-3 text-muted d-block"></i>
                                            <h5 class="text-muted">No has atendido pacientes aún</h5>
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
                <div class="row">
                    <div class="col-md-6">
                        <small class="text-muted">
                            <i class="fas fa-info-circle mr-1"></i>
                            Solo se muestran pacientes con al menos una cita completada
                        </small>
                    </div>
                    <div class="col-md-6 text-right">
                        <c:if test="${not empty pacientes}">
                            <small class="text-muted">
                                <i class="fas fa-chart-line mr-1"></i>
                                Mostrando <strong>${pacientes.size()}</strong> paciente(s)
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
                    Información
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <h5><i class="fas fa-calendar-check text-success mr-2"></i>Citas Completadas</h5>
                        <p class="small">Número de consultas finalizadas con éxito.</p>
                    </div>
                    <div class="col-md-4">
                        <h5><i class="fas fa-history text-primary mr-2"></i>Última Cita</h5>
                        <p class="small">Fecha de la consulta más reciente del paciente.</p>
                    </div>
                    <div class="col-md-4">
                        <h5><i class="fas fa-file-medical text-info mr-2"></i>Historial</h5>
                        <p class="small">Accede al historial clínico completo del paciente.</p>
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

<!-- Script personalizado -->
<script>
    $(document).ready(function () {
    <c:if test="${not empty pacientes && pacientes.size() > 0}">
        if (typeof $.fn.DataTable !== 'undefined') {
            $('#pacientesTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                },
                "order": [[8, "desc"]], // Ordenar por última cita (columna 8)
                "pageLength": 10,
                "responsive": true,
                "columnDefs": [
                    {"orderable": false, "targets": [9]}, // Desactivar orden en Acciones
                    {"type": "date", "targets": 8} // Especificar tipo fecha
                ]
            });
        } else {
            console.warn('DataTables no se cargó correctamente');
        }
    </c:if>
    });
</script>
