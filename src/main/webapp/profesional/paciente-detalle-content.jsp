<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- CSS personalizado -->
<style>
    .avatar-grande {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 3rem;
        font-weight: bold;
        color: white;
        margin-bottom: 20px;
    }

    .avatar-masculino-grande {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .avatar-femenino-grande {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }

    .avatar-otro-grande {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }
</style>

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
                            <!-- Avatar grande con iniciales -->
                            <c:set var="iniciales" value="${paciente.nombreCompleto.substring(0, 1)}"/>
                            <c:choose>
                                <c:when test="${paciente.genero == 'M'}">
                                    <div class="avatar-grande avatar-masculino-grande">${iniciales}</div>
                                </c:when>
                                <c:when test="${paciente.genero == 'F'}">
                                    <div class="avatar-grande avatar-femenino-grande">${iniciales}</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-grande avatar-otro-grande">${iniciales}</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h3 class="profile-username text-center">${paciente.nombreCompleto}</h3>

                        <p class="text-muted text-center">
                            <i class="fas fa-id-card mr-1"></i>
                            DNI: ${paciente.dni}
                        </p>

                        <ul class="list-group list-group-unbordered mb-3">
                            <!-- Fecha de Nacimiento y Edad -->
                            <li class="list-group-item">
                                <b><i class="fas fa-birthday-cake mr-2 text-info"></i>Fecha Nacimiento</b>
                                <span class="float-right">
                                    <c:choose>
                                        <c:when test="${not empty paciente.fechaNacimiento}">
                                            <fmt:parseDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fechaNacParseada"/>
                                            <fmt:formatDate value="${fechaNacParseada}" pattern="dd/MM/yyyy"/>
                                            <br>
                                            <small class="text-muted">
                                                <c:if test="${paciente.edad > 0}">
                                                    (${paciente.edad} años)
                                                </c:if>
                                            </small>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">No registrada</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>

                            <!-- Género -->
                            <li class="list-group-item">
                                <b><i class="fas fa-venus-mars mr-2 text-purple"></i>Género</b>
                                <span class="float-right">
                                    <c:choose>
                                        <c:when test="${paciente.genero == 'M'}">
                                            <span class="badge badge-info">
                                                <i class="fas fa-mars mr-1"></i>
                                                Masculino
                                            </span>
                                        </c:when>
                                        <c:when test="${paciente.genero == 'F'}">
                                            <span class="badge" style="background-color: #e83e8c; color: white;">
                                                <i class="fas fa-venus mr-1"></i>
                                                Femenino
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">Otro</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>

                            <!-- Teléfono -->
                            <li class="list-group-item">
                                <b><i class="fas fa-phone mr-2 text-success"></i>Teléfono</b>
                                <span class="float-right">
                                    <c:choose>
                                        <c:when test="${not empty paciente.telefono}">
                                            <a href="tel:${paciente.telefono}" class="text-primary">
                                                ${paciente.telefono}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">No registrado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>

                            <!-- Email -->
                            <li class="list-group-item">
                                <b><i class="fas fa-envelope mr-2 text-primary"></i>Email</b>
                                <span class="float-right text-truncate" 
                                      style="max-width: 150px; display: inline-block;" 
                                      title="${paciente.email}">
                                    <c:choose>
                                        <c:when test="${not empty paciente.email}">
                                            <a href="mailto:${paciente.email}" class="text-info">
                                                ${paciente.email}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">No registrado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>

                            <!-- Dirección -->
                            <li class="list-group-item">
                                <b><i class="fas fa-map-marker-alt mr-2 text-danger"></i>Dirección</b>
                                <span class="float-right text-truncate" 
                                      style="max-width: 180px; display: inline-block;" 
                                      title="${paciente.direccion}">
                                    ${not empty paciente.direccion ? paciente.direccion : 'No registrada'}
                                </span>
                            </li>

                            <!-- Fecha de Registro -->
                            <li class="list-group-item">
                                <b><i class="fas fa-calendar-plus mr-2 text-warning"></i>Registrado</b>
                                <span class="float-right">
                                    <c:if test="${not empty paciente.fechaRegistro}">
                                        <fmt:parseDate value="${paciente.fechaRegistro}" pattern="yyyy-MM-dd HH:mm:ss" var="fechaReg"/>
                                        <fmt:formatDate value="${fechaReg}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </span>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Card de estadísticas -->
                <div class="card card-success">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-bar mr-2"></i>
                            Estadísticas de Atención
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-4 text-center">
                                <div class="info-box-content">
                                    <span class="info-box-text">Total</span>
                                    <span class="info-box-number text-primary">
                                        <h3>${totalCitas}</h3>
                                    </span>
                                    <small class="text-muted">citas</small>
                                </div>
                            </div>
                            <div class="col-4 text-center border-left border-right">
                                <div class="info-box-content">
                                    <span class="info-box-text">Completadas</span>
                                    <span class="info-box-number text-success">
                                        <h3>${citasCompletadas}</h3>
                                    </span>
                                    <small class="text-muted">atendidas</small>
                                </div>
                            </div>
                            <div class="col-4 text-center">
                                <div class="info-box-content">
                                    <span class="info-box-text">Canceladas</span>
                                    <span class="info-box-number text-danger">
                                        <h3>${citasCanceladas}</h3>
                                    </span>
                                    <small class="text-muted">no asistió</small>
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
                            <span class="badge badge-primary badge-lg">
                                ${historialCitas != null ? historialCitas.size() : 0} cita(s)
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>Código</th>
                                        <th>Fecha</th>
                                        <th>Hora</th>
                                        <th>Motivo</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty historialCitas}">
                                            <c:forEach var="cita" items="${historialCitas}">
                                                <tr>
                                                    <!-- Código de Cita -->
                                                    <td>
                                                        <span class="badge badge-secondary">${cita.codigoCita}</span>
                                                    </td>

                                                    <!-- Fecha -->
                                                    <td>
                                                        <i class="far fa-calendar mr-1"></i>
                                                        <fmt:parseDate value="${cita.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                                        <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                                    </td>

                                                    <!-- Hora -->
                                                    <td>
                                                        <i class="far fa-clock mr-1"></i>
                                                        ${not empty cita.horaCita && cita.horaCita.length() >= 5 ? cita.horaCita.substring(0, 5) : 'N/A'}
                                                    </td>

                                                    <!-- Motivo -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cita.motivoConsulta}">
                                                                <c:choose>
                                                                    <c:when test="${cita.motivoConsulta.length() > 40}">
                                                                        <span data-toggle="tooltip" title="${cita.motivoConsulta}">
                                                                            ${cita.motivoConsulta.substring(0, 40)}...
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${cita.motivoConsulta}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Sin especificar</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- Estado con colores correctos -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${cita.estado == 'PENDIENTE'}">
                                                                <span class="badge badge-warning">
                                                                    <i class="fas fa-clock mr-1"></i>
                                                                    Pendiente
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'COMPLETADA'}">
                                                                <span class="badge badge-success">
                                                                    <i class="fas fa-check-circle mr-1"></i>
                                                                    Completada
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'CANCELADA'}">
                                                                <span class="badge badge-danger">
                                                                    <i class="fas fa-times-circle mr-1"></i>
                                                                    Cancelada
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-secondary">${cita.estado}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <i class="fas fa-calendar-times fa-4x text-muted mb-3 d-block"></i>
                                                    <h5 class="text-muted">No hay citas registradas</h5>
                                                    <p class="text-muted">Este paciente aún no tiene citas contigo</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card-footer">
                        <div class="btn-group" role="group">
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

    </div>
</section>

<!-- ✅ Script con SweetAlert2 preparado (si se necesitan confirmaciones futuras) -->
<script>
    const contextPath = '${pageContext.request.contextPath}';

    $(document).ready(function () {
        // Inicializar tooltips
        $('[data-toggle="tooltip"]').tooltip();
    });

// Función de ejemplo para futuras confirmaciones (si se agregan botones de acción)
    function confirmarAccion(titulo, mensaje, callback) {
        Swal.fire({
            title: titulo,
            html: mensaje,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#007bff',
            cancelButtonColor: '#6c757d',
            confirmButtonText: '<i class="fas fa-check"></i> Confirmar',
            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                callback();
            }
        });
    }
</script>
