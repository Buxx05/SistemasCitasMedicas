<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-tachometer-alt mr-2"></i>
                    Dashboard Administrativo
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item active">Dashboard</li>
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

        <!-- ========== TARJETAS PRINCIPALES ========== -->
        <div class="row">

            <!-- Usuarios -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-info">
                    <div class="inner">
                        <h3>${totalUsuarios}</h3>
                        <p>Usuarios Activos</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/UsuarioServlet" class="small-box-footer">
                        Ver más <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Profesionales -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-success">
                    <div class="inner">
                        <h3>${totalProfesionales}</h3>
                        <p>Profesionales</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/ProfesionalServlet" class="small-box-footer">
                        Ver más <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Pacientes -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-warning">
                    <div class="inner">
                        <h3>${totalPacientes}</h3>
                        <p>Pacientes</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-hospital-user"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/PacienteServlet" class="small-box-footer">
                        Ver más <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Citas Hoy -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-danger">
                    <div class="inner">
                        <h3>${citasHoy}</h3>
                        <p>Citas Hoy</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/CitaServlet" class="small-box-footer">
                        Ver más <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

        </div>

        <!-- ========== FILA DE CONTENIDO ========== -->
        <div class="row">

            <!-- Citas Recientes -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-alt mr-2"></i>
                            Citas Recientes
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                <i class="fas fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Código</th>
                                        <th>Paciente</th>
                                        <th>Profesional</th>
                                        <th>Fecha</th>
                                        <th>Hora</th>
                                        <th>Estado</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty citasRecientes}">
                                            <c:forEach var="cita" items="${citasRecientes}">
                                                <tr>
                                                    <td>
                                                        <span class="badge badge-secondary">${cita.codigoCita}</span>
                                                    </td>
                                                    <td>${cita.nombrePaciente}</td>
                                                    <td>${cita.nombreProfesional}</td>
                                                    <td>
                                                        <i class="far fa-calendar mr-1"></i>
                                                        ${cita.fechaCita}
                                                    </td>
                                                    <td>
                                                        <i class="far fa-clock mr-1"></i>
                                                        ${cita.horaCita}
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                                <span class="badge badge-success">
                                                                    <i class="fas fa-check-circle mr-1"></i>
                                                                    ${cita.estado}
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'PENDIENTE'}">
                                                                <span class="badge badge-warning">
                                                                    <i class="fas fa-clock mr-1"></i>
                                                                    ${cita.estado}
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'CANCELADA'}">
                                                                <span class="badge badge-danger">
                                                                    <i class="fas fa-times-circle mr-1"></i>
                                                                    ${cita.estado}
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'COMPLETADA'}">
                                                                <span class="badge badge-info">
                                                                    <i class="fas fa-check-double mr-1"></i>
                                                                    ${cita.estado}
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <a href="${pageContext.request.contextPath}/CitaServlet?accion=ver&id=${cita.idCita}" 
                                                           class="btn btn-sm btn-info"
                                                           title="Ver detalle">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-4">
                                                    <i class="fas fa-info-circle fa-2x mb-2"></i>
                                                    <p class="mb-0">No hay citas registradas</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/CitaServlet" class="btn btn-sm btn-primary">
                            <i class="fas fa-list mr-1"></i>
                            Ver Todas las Citas
                        </a>
                    </div>
                </div>
            </div>

            <!-- Columna Derecha: Estadísticas -->
            <div class="col-md-4">

                <!-- Card: Estadísticas del Mes -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-pie mr-2"></i>
                            Estadísticas del Mes
                        </h3>
                    </div>
                    <div class="card-body">

                        <div class="info-box bg-gradient-info">
                            <span class="info-box-icon"><i class="fas fa-chart-line"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Total Citas</span>
                                <span class="info-box-number">${citasMes}</span>
                            </div>
                        </div>

                        <div class="info-box bg-gradient-success">
                            <span class="info-box-icon"><i class="fas fa-check-circle"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Completadas</span>
                                <span class="info-box-number">${citasCompletadas}</span>
                            </div>
                        </div>

                        <div class="info-box bg-gradient-danger">
                            <span class="info-box-icon"><i class="fas fa-times-circle"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Canceladas</span>
                                <span class="info-box-number">${citasCanceladas}</span>
                            </div>
                        </div>

                        <div class="info-box bg-gradient-warning">
                            <span class="info-box-icon"><i class="fas fa-clock"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Pendientes</span>
                                <span class="info-box-number">${citasPendientes}</span>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Card: Distribución de Profesionales -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-md mr-2"></i>
                            Profesionales por Tipo
                        </h3>
                    </div>
                    <div class="card-body">

                        <div class="info-box bg-gradient-success">
                            <span class="info-box-icon"><i class="fas fa-user-md"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Médicos</span>
                                <span class="info-box-number">${totalProfesionalesMedicos}</span>
                            </div>
                        </div>

                        <div class="info-box bg-gradient-info">
                            <span class="info-box-icon"><i class="fas fa-user-nurse"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">No Médicos</span>
                                <span class="info-box-number">${totalProfesionalesNoMedicos}</span>
                            </div>
                        </div>

                        <div class="info-box bg-gradient-secondary">
                            <span class="info-box-icon"><i class="fas fa-user-shield"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Administradores</span>
                                <span class="info-box-number">${totalAdmins}</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </div>

    </div>
</section>
