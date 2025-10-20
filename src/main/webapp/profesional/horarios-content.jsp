<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS personalizado -->
<style>
    .badge-lg {
        font-size: 0.9rem;
        padding: 0.4rem 0.6rem;
    }
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-clock mr-2"></i>
                    Mis Horarios de Atención
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Horarios</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<section class="content">
    <div class="container-fluid">

        <!-- Alertas -->
        <jsp:include page="/componentes/alert.jsp"/>

        <!-- Info Box -->
        <div class="row">
            <div class="col-md-12">
                <div class="info-box bg-gradient-info">
                    <span class="info-box-icon"><i class="fas fa-calendar-week"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Total de Bloques Horarios Configurados</span>
                        <span class="info-box-number">${horarios != null ? horarios.size() : 0}</span>
                        <div class="progress">
                            <div class="progress-bar" style="width: 100%"></div>
                        </div>
                        <span class="progress-description">
                            Define tus horarios de atención para recibir citas
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card de Horarios -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Horarios Configurados
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=nuevo" 
                       class="btn btn-success btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nuevo Horario
                    </a>
                </div>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty horarios}">

                        <!-- Vista de Calendario Semanal -->
                        <div class="row">
                            <c:set var="diasSemana" value="LUNES,MARTES,MIERCOLES,JUEVES,VIERNES,SABADO,DOMINGO"/>
                            <c:set var="diasArray" value="${diasSemana.split(',')}"/>

                            <c:forEach var="dia" items="${diasArray}">
                                <div class="col-md-12 mb-3">
                                    <div class="card card-outline card-primary">
                                        <div class="card-header">
                                            <h4 class="card-title">
                                                <i class="far fa-calendar mr-2"></i>
                                                <strong>${dia}</strong>
                                            </h4>
                                        </div>
                                        <div class="card-body p-2">
                                            <c:set var="tieneHorarios" value="false"/>

                                            <c:forEach var="h" items="${horarios}">
                                                <c:if test="${h.diaSemana == dia}">
                                                    <c:set var="tieneHorarios" value="true"/>
                                                    <div class="row mb-2 align-items-center">
                                                        <div class="col-md-3">
                                                            <span class="badge badge-info badge-lg">
                                                                <i class="far fa-clock mr-1"></i>
                                                                <!-- ✅ Validar horas -->
                                                                ${not empty h.horaInicio && h.horaInicio.length() >= 5 ? h.horaInicio.substring(0, 5) : 'N/A'}
                                                                - 
                                                                ${not empty h.horaFin && h.horaFin.length() >= 5 ? h.horaFin.substring(0, 5) : 'N/A'}
                                                            </span>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <small class="text-muted">
                                                                <i class="fas fa-hourglass-half mr-1"></i>
                                                                Consulta: ${h.duracionConsulta} min
                                                            </small>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <c:choose>
                                                                <c:when test="${h.activo}">
                                                                    <span class="badge badge-success">
                                                                        <i class="fas fa-check-circle mr-1"></i>
                                                                        Activo
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-danger">
                                                                        <i class="fas fa-times-circle mr-1"></i>
                                                                        Inactivo
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="col-md-3 text-right">
                                                            <div class="btn-group btn-group-sm">
                                                                <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=editar&id=${h.idHorario}" 
                                                                   class="btn btn-primary"
                                                                   title="Editar"
                                                                   data-toggle="tooltip">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-danger"
                                                                        onclick="eliminarHorario(${h.idHorario})"
                                                                        title="Eliminar"
                                                                        data-toggle="tooltip">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <hr class="my-2"/>
                                                </c:if>
                                            </c:forEach>

                                            <c:if test="${!tieneHorarios}">
                                                <div class="text-center text-muted py-3">
                                                    <i class="fas fa-times-circle fa-2x mb-2"></i>
                                                    <p class="mb-0">Sin horarios configurados</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <!-- Sin horarios -->
                        <div class="text-center py-5">
                            <i class="fas fa-clock fa-4x mb-3 text-muted" style="display: block;"></i>
                            <h5 class="text-muted">No has configurado horarios de atención</h5>
                            <p class="text-muted">Define tus horarios para que los pacientes puedan agendar citas</p>
                            <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet?accion=nuevo" 
                               class="btn btn-success btn-lg mt-3">
                                <i class="fas fa-plus mr-2"></i>
                                Configurar Primer Horario
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty horarios}">
                <div class="card-footer">
                    <small class="text-muted">
                        <i class="fas fa-info-circle mr-1"></i>
                        Los horarios configurados determinan la disponibilidad para agendar citas
                    </small>
                </div>
            </c:if>
        </div>

    </div>
</section>

<!-- ✅ Script con SweetAlert2 -->
<script>
// Definir contexto una vez
    const contextPath = '${pageContext.request.contextPath}';

    /**
     * Elimina un horario con confirmación de SweetAlert2
     */
    function eliminarHorario(idHorario) {
        Swal.fire({
            title: '¿Eliminar horario?',
            html: '¿Estás seguro de eliminar este bloque horario?<br><small class="text-muted">Los pacientes no podrán agendar citas en este horario</small>',
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
                    html: 'Eliminando bloque horario',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Crear y enviar formulario
                var form = document.createElement('form');
                form.method = 'GET';
                form.action = contextPath + '/HorarioProfesionalServlet';

                var inputAccion = document.createElement('input');
                inputAccion.type = 'hidden';
                inputAccion.name = 'accion';
                inputAccion.value = 'eliminar';
                form.appendChild(inputAccion);

                var inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'id';
                inputId.value = idHorario;
                form.appendChild(inputId);

                document.body.appendChild(form);
                form.submit();
            }
        });
    }

// Inicializar tooltips
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof jQuery !== 'undefined') {
            $('[data-toggle="tooltip"]').tooltip();
        }
    });
</script>
