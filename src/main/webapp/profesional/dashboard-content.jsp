<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-tachometer-alt mr-2"></i>
                    Dashboard Profesional
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
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

        <!-- ========== ESTADÍSTICAS (INFO BOXES) ========== -->
        <div class="row">

            <!-- Total Citas del Mes -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-info">
                    <div class="inner">
                        <h3>${totalCitasMes}</h3>
                        <p>Citas Este Mes</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" class="small-box-footer">
                        Ver todas <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Citas Completadas -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-success">
                    <div class="inner">
                        <h3>${citasCompletadas}</h3>
                        <p>Citas Completadas</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=COMPLETADA" class="small-box-footer">
                        Ver detalles <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Citas Pendientes -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-warning">
                    <div class="inner">
                        <h3>${citasPendientes}</h3>
                        <p>Citas Pendientes</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=CONFIRMADA" class="small-box-footer">
                        Ver pendientes <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Pacientes Únicos -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-danger">
                    <div class="inner">
                        <h3>${totalPacientesUnicos}</h3>
                        <p>Pacientes Atendidos</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" class="small-box-footer">
                        Ver pacientes <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

        </div>

        <div class="row">

            <!-- ========== AGENDA DEL DÍA (TIMELINE) ========== -->
            <div class="col-md-7">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-day mr-2"></i>
                            Mi Agenda de Hoy - <fmt:formatDate value="<%= new java.util.Date()%>" pattern="dd/MM/yyyy"/>
                        </h3>
                        <div class="card-tools">
                            <span class="badge badge-primary">
                                ${citasHoy != null ? citasHoy.size() : 0} cita(s)
                            </span>
                        </div>
                    </div>

                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty citasHoy}">
                                <!-- Timeline -->
                                <div class="timeline">
                                    <c:forEach var="cita" items="${citasHoy}">

                                        <!-- Timeline Item -->
                                        <div>
                                            <i class="fas fa-clock bg-${cita.estado == 'CONFIRMADA' ? 'warning' : (cita.estado == 'COMPLETADA' ? 'success' : 'secondary')}"></i>
                                            <div class="timeline-item">
                                                <span class="time">
                                                    <i class="fas fa-clock"></i> ${not empty cita.horaCita ? cita.horaCita.substring(0, 5) : 'N/A'}
                                                </span>

                                                <h3 class="timeline-header">
                                                    <a href="#">${cita.nombrePaciente}</a>
                                                    <c:choose>
                                                        <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                            <span class="badge badge-warning">Pendiente</span>
                                                        </c:when>
                                                        <c:when test="${cita.estado == 'COMPLETADA'}">
                                                            <span class="badge badge-success">Completada</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">${cita.estado}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                                <div class="timeline-body">
                                                    <p><strong>DNI:</strong> ${cita.dniPaciente}</p>
                                                    <c:if test="${not empty cita.motivoConsulta}">
                                                        <p><strong>Motivo:</strong> ${cita.motivoConsulta}</p>
                                                    </c:if>
                                                    <c:if test="${not empty cita.observaciones}">
                                                        <p><strong>Observaciones:</strong> ${cita.observaciones}</p>
                                                    </c:if>
                                                </div>
                                                <div class="timeline-footer">
                                                    <c:if test="${cita.estado == 'CONFIRMADA'}">
                                                        <button type="button" 
                                                                class="btn btn-success btn-sm"
                                                                onclick="completarCita(${cita.idCita})"
                                                                title="Marcar como completada">
                                                            <i class="fas fa-check"></i> Completar
                                                        </button>
                                                        <button type="button" 
                                                                class="btn btn-info btn-sm"
                                                                onclick="crearRecita(${cita.idCita}, ${cita.idPaciente})"
                                                                title="Crear cita de seguimiento">
                                                            <i class="fas fa-redo"></i> Re-citar
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${cita.estado != 'CANCELADA'}">
                                                        <button type="button" 
                                                                class="btn btn-danger btn-sm"
                                                                onclick="cancelarCita(${cita.idCita})"
                                                                title="Cancelar cita">
                                                            <i class="fas fa-times"></i> Cancelar
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                    </c:forEach>

                                    <!-- End Timeline -->
                                    <div>
                                        <i class="fas fa-check bg-gray"></i>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Sin citas hoy -->
                                <div class="text-center py-5">
                                    <i class="fas fa-calendar-check fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted">No tienes citas programadas para hoy</h5>
                                    <p class="text-muted">Disfruta de tu día libre 😊</p>
                                    <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                                       class="btn btn-primary mt-3">
                                        <i class="fas fa-clock"></i> Ver Mis Horarios
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty citasHoy}">
                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                               class="btn btn-primary btn-block">
                                <i class="fas fa-calendar-alt"></i> Ver Todas Mis Citas
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- ========== GRÁFICOS ========== -->
            <div class="col-md-5">

                <!-- Gráfico: Citas por Estado -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-pie mr-2"></i>
                            Citas por Estado
                        </h3>
                    </div>
                    <div class="card-body">
                        <canvas id="graficoEstados" style="height: 250px;"></canvas>
                    </div>
                </div>

                <!-- Gráfico: Productividad (Últimos 6 Meses) -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line mr-2"></i>
                            Productividad (Últimos 6 Meses)
                        </h3>
                    </div>
                    <div class="card-body">
                        <canvas id="graficoMeses" style="height: 250px;"></canvas>
                    </div>
                </div>

            </div>

        </div>

        <!-- ========== ACCESOS RÁPIDOS ========== -->
        <div class="row">
            <div class="col-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-bolt mr-2"></i>
                            Accesos Rápidos
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-6">
                                <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                                   class="btn btn-app btn-block bg-primary">
                                    <i class="fas fa-calendar-alt"></i>
                                    Mis Citas
                                </a>
                            </div>
                            <div class="col-md-3 col-6">
                                <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                                   class="btn btn-app btn-block bg-success">
                                    <i class="fas fa-users"></i>
                                    Mis Pacientes
                                </a>
                            </div>
                            <div class="col-md-3 col-6">
                                <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                                   class="btn btn-app btn-block bg-warning">
                                    <i class="fas fa-clock"></i>
                                    Mis Horarios
                                </a>
                            </div>
                            <!-- RECETAS PARA AMBOS ROLES -->
                            <div class="col-md-3 col-6">
                                <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                                   class="btn btn-app btn-block bg-info">
                                    <i class="fas fa-prescription"></i>
                                    Recetas
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<!-- Scripts personalizados -->
<script>
// ✅ Definir contexto una sola vez
                                                                    const contextPath = '${pageContext.request.contextPath}';

// ========== FUNCIONES PARA GESTIÓN DE CITAS ==========

                                                                    function completarCita(idCita) {
                                                                        if (confirm('¿Marcar esta cita como completada?')) {
                                                                            window.location.href = contextPath + '/CitaProfesionalServlet?accion=completar&id=' + idCita;
                                                                        }
                                                                    }

                                                                    function cancelarCita(idCita) {
                                                                        if (confirm('¿Estás seguro de cancelar esta cita?\n\nEsta acción notificará al paciente.')) {
                                                                            window.location.href = contextPath + '/CitaProfesionalServlet?accion=cancelar&id=' + idCita;
                                                                        }
                                                                    }

                                                                    function crearRecita(idCita, idPaciente) {
                                                                        window.location.href = contextPath + '/CitaProfesionalServlet?accion=nuevaRecita&idCita=' + idCita + '&idPaciente=' + idPaciente;
                                                                    }

// ========== GRÁFICOS ==========

// Datos de citas por estado
                                                                    const citasPorEstadoData = ${citasPorEstadoJson};
                                                                    console.log('Citas por estado:', citasPorEstadoData);

// Datos de citas por mes
                                                                    const citasPorMesData = ${citasPorMesJson};
                                                                    console.log('Citas por mes:', citasPorMesData);

// ========== GRÁFICO DE DONUT (ESTADOS) ==========
                                                                    const ctxEstados = document.getElementById('graficoEstados').getContext('2d');
                                                                    const graficoEstados = new Chart(ctxEstados, {
                                                                        type: 'doughnut',
                                                                        data: {
                                                                            labels: Object.keys(citasPorEstadoData),
                                                                            datasets: [{
                                                                                    data: Object.values(citasPorEstadoData),
                                                                                    backgroundColor: [
                                                                                        'rgba(255, 193, 7, 0.8)', // CONFIRMADA (amarillo)
                                                                                        'rgba(40, 167, 69, 0.8)', // COMPLETADA (verde)
                                                                                        'rgba(220, 53, 69, 0.8)'    // CANCELADA (rojo)
                                                                                    ],
                                                                                    borderColor: [
                                                                                        'rgba(255, 193, 7, 1)',
                                                                                        'rgba(40, 167, 69, 1)',
                                                                                        'rgba(220, 53, 69, 1)'
                                                                                    ],
                                                                                    borderWidth: 2
                                                                                }]
                                                                        },
                                                                        options: {
                                                                            responsive: true,
                                                                            maintainAspectRatio: false,
                                                                            plugins: {
                                                                                legend: {
                                                                                    position: 'bottom'
                                                                                }
                                                                            }
                                                                        }
                                                                    });

// ========== GRÁFICO DE LÍNEA (MESES) ==========
                                                                    const ctxMeses = document.getElementById('graficoMeses').getContext('2d');
                                                                    const graficoMeses = new Chart(ctxMeses, {
                                                                        type: 'line',
                                                                        data: {
                                                                            labels: Object.keys(citasPorMesData),
                                                                            datasets: [{
                                                                                    label: 'Citas Atendidas',
                                                                                    data: Object.values(citasPorMesData),
                                                                                    backgroundColor: 'rgba(0, 123, 255, 0.2)',
                                                                                    borderColor: 'rgba(0, 123, 255, 1)',
                                                                                    borderWidth: 3,
                                                                                    fill: true,
                                                                                    tension: 0.4
                                                                                }]
                                                                        },
                                                                        options: {
                                                                            responsive: true,
                                                                            maintainAspectRatio: false,
                                                                            plugins: {
                                                                                legend: {
                                                                                    display: false
                                                                                }
                                                                            },
                                                                            scales: {
                                                                                y: {
                                                                                    beginAtZero: true,
                                                                                    ticks: {
                                                                                        stepSize: 1
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    });
</script>
