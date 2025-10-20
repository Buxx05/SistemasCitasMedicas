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

        <!-- Alertas con SweetAlert2 -->
        <jsp:include page="/componentes/alert.jsp"/>

        <!-- ========== ESTADÍSTICAS (INFO BOXES) ========== -->
        <div class="row">

            <!-- Total Citas del Mes -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-primary">
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
                    <a href="${pageContext.request.contextPath}/CitaProfesionalServlet?estado=PENDIENTE" class="small-box-footer">
                        Ver pendientes <i class="fas fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>

            <!-- Pacientes Únicos -->
            <div class="col-lg-3 col-6">
                <div class="small-box bg-info">
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
                            Mi Agenda de Hoy - <jsp:useBean id="fechaHoy" class="java.util.Date"/>
                            <fmt:formatDate value="${fechaHoy}" pattern="dd/MM/yyyy"/>
                        </h3>
                        <div class="card-tools">
                            <span class="badge badge-primary badge-lg">
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
                                            <!-- Colores según estado PENDIENTE/COMPLETADA/CANCELADA -->
                                            <i class="fas fa-clock bg-${cita.estado == 'PENDIENTE' ? 'warning' : (cita.estado == 'COMPLETADA' ? 'success' : 'danger')}"></i>
                                            <div class="timeline-item">
                                                <span class="time">
                                                    <i class="fas fa-clock mr-1"></i>
                                                    ${not empty cita.horaCita && cita.horaCita.length() >= 5 ? cita.horaCita.substring(0, 5) : 'N/A'}
                                                </span>

                                                <h3 class="timeline-header">
                                                    <!-- Código de cita -->
                                                    <span class="badge badge-secondary mr-2">${cita.codigoCita}</span>
                                                    <a href="#">${cita.nombrePaciente}</a>
                                                    <!-- Estados con colores correctos -->
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
                                                    <!-- Solo PENDIENTE puede completarse o cancelarse -->
                                                    <c:if test="${cita.estado == 'PENDIENTE'}">
                                                        <button type="button" class="btn btn-success btn-sm"
                                                                onclick="completarCita(${cita.idCita})">
                                                            <i class="fas fa-check mr-1"></i> Completar
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm"
                                                                onclick="cancelarCita(${cita.idCita})">
                                                            <i class="fas fa-times mr-1"></i> Cancelar
                                                        </button>
                                                    </c:if>

                                                    <!-- Solo COMPLETADA puede crear receta y re-cita -->
                                                    <c:if test="${cita.estado == 'COMPLETADA'}">
                                                        <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva&idCita=${cita.idCita}&idPaciente=${cita.idPaciente}"
                                                           class="btn btn-primary btn-sm">
                                                            <i class="fas fa-prescription mr-1"></i> Receta
                                                        </a>
                                                        <button type="button" class="btn btn-info btn-sm"
                                                                onclick="crearRecita(${cita.idCita}, ${cita.idPaciente})">
                                                            <i class="fas fa-redo mr-1"></i> Re-cita
                                                        </button>
                                                    </c:if>

                                                    <!-- CANCELADA no tiene acciones -->
                                                    <c:if test="${cita.estado == 'CANCELADA'}">
                                                        <span class="text-muted">
                                                            <i class="fas fa-info-circle mr-1"></i>
                                                            Cita cancelada - Sin acciones disponibles
                                                        </span>
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
                                    <i class="fas fa-calendar-check fa-4x text-muted mb-3 d-block"></i>
                                    <h5 class="text-muted">No tienes citas programadas para hoy</h5>
                                    <p class="text-muted">Disfruta de tu día libre 😊</p>
                                    <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                                       class="btn btn-primary mt-3">
                                        <i class="fas fa-clock mr-1"></i> Ver Mis Horarios
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty citasHoy}">
                        <div class="card-footer text-center">
                            <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                               class="btn btn-primary">
                                <i class="fas fa-calendar-alt mr-1"></i> Ver Todas Mis Citas
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

<script>
                                                                    const contextPath = '${pageContext.request.contextPath}';

// ========== FUNCIONES PARA GESTIÓN DE CITAS CON SWEETALERT2 ==========

                                                                    /**
                                                                     * Completa una cita con confirmación
                                                                     */
                                                                    function completarCita(idCita) {
                                                                        Swal.fire({
                                                                            title: '¿Completar cita?',
                                                                            html: 'Se marcará esta cita como <strong>completada</strong><br><small class="text-muted">Esto indica que el paciente fue atendido exitosamente</small>',
                                                                            icon: 'question',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#28a745',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-check-circle"></i> Sí, completar',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Completando la cita',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=completar&id=' + idCita + '&origen=dashboard';
                                                                            }
                                                                        });
                                                                    }

                                                                    /**
                                                                     * Cancela una cita con motivo opcional
                                                                     */
                                                                    function cancelarCita(idCita) {
                                                                        Swal.fire({
                                                                            title: '¿Cancelar cita?',
                                                                            html: '¿Deseas indicar el motivo de la cancelación?',
                                                                            icon: 'warning',
                                                                            input: 'textarea',
                                                                            inputPlaceholder: 'Motivo de la cancelación (opcional)...',
                                                                            inputAttributes: {
                                                                                'aria-label': 'Motivo de la cancelación',
                                                                                'maxlength': 200
                                                                            },
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#dc3545',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-ban"></i> Sí, cancelar cita',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> No',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                const motivo = result.value || '';

                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Cancelando la cita',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=cancelar&id=' + idCita + '&origen=dashboard&motivo=' + encodeURIComponent(motivo);
                                                                            }
                                                                        });
                                                                    }

                                                                    /**
                                                                     * Crea una re-cita de seguimiento
                                                                     */
                                                                    function crearRecita(idCita, idPaciente) {
                                                                        Swal.fire({
                                                                            title: '¿Crear re-cita de seguimiento?',
                                                                            html: 'Se agendará una nueva cita de <strong>seguimiento</strong> para este paciente<br><small class="text-muted">El administrador deberá confirmar la fecha y hora</small>',
                                                                            icon: 'question',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#17a2b8',
                                                                            cancelButtonColor: '#6c757d',
                                                                            confirmButtonText: '<i class="fas fa-redo"></i> Sí, crear re-cita',
                                                                            cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                                                                            reverseButtons: true,
                                                                            focusCancel: true
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Mostrar mensaje de carga
                                                                                Swal.fire({
                                                                                    title: 'Procesando...',
                                                                                    html: 'Creando re-cita de seguimiento',
                                                                                    allowOutsideClick: false,
                                                                                    allowEscapeKey: false,
                                                                                    didOpen: () => {
                                                                                        Swal.showLoading();
                                                                                    }
                                                                                });

                                                                                window.location.href = contextPath + '/CitaProfesionalServlet?accion=nuevaRecita&idCita=' + idCita + '&idPaciente=' + idPaciente + '&origen=dashboard';
                                                                            }
                                                                        });
                                                                    }

// ========== GRÁFICOS ==========

// Datos de citas por estado
                                                                    const citasPorEstadoData = ${citasPorEstadoJson};
                                                                    console.log('Citas por estado:', citasPorEstadoData);

// Datos de citas por mes
                                                                    const citasPorMesData = ${citasPorMesJson};
                                                                    console.log('Citas por mes:', citasPorMesData);

// Verificar que Chart.js esté cargado
                                                                    if (typeof Chart === 'undefined') {
                                                                        console.error('Chart.js no está cargado');
                                                                        Swal.fire({
                                                                            icon: 'error',
                                                                            title: 'Error al cargar gráficos',
                                                                            text: 'No se pudieron cargar los gráficos. Por favor, recarga la página.',
                                                                            confirmButtonText: 'Recargar',
                                                                            confirmButtonColor: '#dc3545'
                                                                        }).then(() => {
                                                                            window.location.reload();
                                                                        });
                                                                    } else {
                                                                        // ========== GRÁFICO DE DONUT (ESTADOS) ==========
                                                                        const ctxEstados = document.getElementById('graficoEstados');

                                                                        if (ctxEstados) {
                                                                            // Mapear estados a colores específicos
                                                                            const labels = Object.keys(citasPorEstadoData);
                                                                            const data = Object.values(citasPorEstadoData);

                                                                            // Asignar colores según el estado
                                                                            const backgroundColor = labels.map(estado => {
                                                                                if (estado === 'PENDIENTE')
                                                                                    return 'rgba(255, 193, 7, 0.8)';      // Amarillo
                                                                                if (estado === 'COMPLETADA')
                                                                                    return 'rgba(40, 167, 69, 0.8)';     // Verde
                                                                                if (estado === 'CANCELADA')
                                                                                    return 'rgba(220, 53, 69, 0.8)';      // Rojo
                                                                                return 'rgba(108, 117, 125, 0.8)';                                // Gris (por defecto)
                                                                            });

                                                                            const borderColor = labels.map(estado => {
                                                                                if (estado === 'PENDIENTE')
                                                                                    return 'rgba(255, 193, 7, 1)';
                                                                                if (estado === 'COMPLETADA')
                                                                                    return 'rgba(40, 167, 69, 1)';
                                                                                if (estado === 'CANCELADA')
                                                                                    return 'rgba(220, 53, 69, 1)';
                                                                                return 'rgba(108, 117, 125, 1)';
                                                                            });

                                                                            new Chart(ctxEstados.getContext('2d'), {
                                                                                type: 'doughnut',
                                                                                data: {
                                                                                    labels: labels,
                                                                                    datasets: [{
                                                                                            data: data,
                                                                                            backgroundColor: backgroundColor,
                                                                                            borderColor: borderColor,
                                                                                            borderWidth: 2
                                                                                        }]
                                                                                },
                                                                                options: {
                                                                                    responsive: true,
                                                                                    maintainAspectRatio: false,
                                                                                    plugins: {
                                                                                        legend: {
                                                                                            position: 'bottom',
                                                                                            labels: {
                                                                                                padding: 15,
                                                                                                font: {
                                                                                                    size: 12
                                                                                                }
                                                                                            }
                                                                                        },
                                                                                        tooltip: {
                                                                                            callbacks: {
                                                                                                label: function (context) {
                                                                                                    let label = context.label || '';
                                                                                                    if (label) {
                                                                                                        label += ': ';
                                                                                                    }
                                                                                                    label += context.parsed + ' cita(s)';
                                                                                                    return label;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            });
                                                                        }

                                                                        // ========== GRÁFICO DE LÍNEA (MESES) ==========
                                                                        const ctxMeses = document.getElementById('graficoMeses');

                                                                        if (ctxMeses) {
                                                                            new Chart(ctxMeses.getContext('2d'), {
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
                                                                                            tension: 0.4,
                                                                                            pointRadius: 5,
                                                                                            pointHoverRadius: 7,
                                                                                            pointBackgroundColor: 'rgba(0, 123, 255, 1)',
                                                                                            pointBorderColor: '#fff',
                                                                                            pointBorderWidth: 2
                                                                                        }]
                                                                                },
                                                                                options: {
                                                                                    responsive: true,
                                                                                    maintainAspectRatio: false,
                                                                                    plugins: {
                                                                                        legend: {
                                                                                            display: false
                                                                                        },
                                                                                        tooltip: {
                                                                                            callbacks: {
                                                                                                label: function (context) {
                                                                                                    return 'Citas: ' + context.parsed.y;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    },
                                                                                    scales: {
                                                                                        y: {
                                                                                            beginAtZero: true,
                                                                                            ticks: {
                                                                                                stepSize: 1,
                                                                                                callback: function (value) {
                                                                                                    return Number.isInteger(value) ? value : '';
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            });
                                                                        }
                                                                    }
</script>
