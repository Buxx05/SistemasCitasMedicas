<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-user-circle mr-2"></i>
                    Detalle del Paciente
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/PacienteProfesionalServlet">Mis Pacientes</a></li>
                    <li class="breadcrumb-item active">Detalle</li>
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

        <div class="row">

            <!-- ========== INFORMACIÓN DEL PACIENTE ========== -->
            <div class="col-md-4">

                <!-- Card de información personal -->
                <div class="card card-primary card-outline">
                    <div class="card-body box-profile">
                        <div class="text-center">
                            <i class="fas fa-user-circle fa-5x text-primary mb-3"></i>
                        </div>
                        <h3 class="profile-username text-center">${paciente.nombreCompleto}</h3>
                        <p class="text-muted text-center">
                            <i class="fas fa-id-card mr-1"></i>
                            DNI: ${paciente.dni}
                        </p>

                        <ul class="list-group list-group-unbordered mb-3">
                            <li class="list-group-item">
                                <b><i class="fas fa-birthday-cake mr-2"></i>Fecha Nacimiento</b>
                                <span class="float-right">
                                    <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNacParseada"/>
                                    <fmt:formatDate value="${fechaNacParseada}" pattern="dd/MM/yyyy"/>
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-venus-mars mr-2"></i>Género</b>
                                <span class="float-right">
                                    <c:choose>
                                        <c:when test="${paciente.genero == 'M'}">Masculino</c:when>
                                        <c:when test="${paciente.genero == 'F'}">Femenino</c:when>
                                        <c:otherwise>Otro</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-phone mr-2"></i>Teléfono</b>
                                <span class="float-right">${not empty paciente.telefono ? paciente.telefono : 'No registrado'}</span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-envelope mr-2"></i>Email</b>
                                <span class="float-right text-truncate" style="max-width: 150px;" title="${paciente.email}">
                                    ${not empty paciente.email ? paciente.email : 'No registrado'}
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-map-marker-alt mr-2"></i>Dirección</b>
                                <span class="float-right">${not empty paciente.direccion ? paciente.direccion : 'No registrada'}</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Card de estadísticas -->
                <div class="card card-success">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-bar mr-2"></i>
                            Estadísticas
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-4 text-center">
                                <div class="info-box-content">
                                    <span class="info-box-text">Total</span>
                                    <span class="info-box-number text-primary">${totalCitas}</span>
                                </div>
                            </div>
                            <div class="col-4 text-center">
                                <div class="info-box-content">
                                    <span class="info-box-text">Completadas</span>
                                    <span class="info-box-number text-success">${citasCompletadas}</span>
                                </div>
                            </div>
                            <div class="col-4 text-center">
                                <div class="info-box-content">
                                    <span class="info-box-text">Canceladas</span>
                                    <span class="info-box-number text-danger">${citasCanceladas}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ========== HISTORIAL DE CITAS ========== -->
            <div class="col-md-8">

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-history mr-2"></i>
                            Historial de Citas Conmigo
                        </h3>
                        <div class="card-tools">
                            <span class="badge badge-primary">
                                ${historialCitas.size()} cita(s)
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Hora</th>
                                        <th>Motivo</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cita" items="${historialCitas}">
                                        <tr>
                                            <td>
                                                <i class="far fa-calendar mr-1"></i>
                                                <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                                <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <i class="far fa-clock mr-1"></i>
                                                ${cita.horaCita.substring(0, 5)}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cita.motivoConsulta}">
                                                        ${cita.motivoConsulta.length() > 40 ? cita.motivoConsulta.substring(0, 40).concat('...') : cita.motivoConsulta}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Sin especificar</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                        <span class="badge badge-warning">Pendiente</span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'COMPLETADA'}">
                                                        <span class="badge badge-success">Completada</span>
                                                    </c:when>
                                                    <c:when test="${cita.estado == 'CANCELADA'}">
                                                        <span class="badge badge-danger">Cancelada</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card-footer">
                        <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet?accion=verHistorial&idPaciente=${paciente.idPaciente}" 
                           class="btn btn-primary">
                            <i class="fas fa-file-medical-alt mr-2"></i>
                            Ver Historial Clínico
                        </a>
                        <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                           class="btn btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Volver a la Lista
                        </a>
                    </div>

                </div>

            </div>

        </div>

    </div>
</section>
