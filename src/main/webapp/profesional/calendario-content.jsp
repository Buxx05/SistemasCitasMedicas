<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- FullCalendar CSS -->
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />

<!-- CSS Personalizado -->
<style>
    #calendario {
        max-width: 1200px;
        margin: 0 auto;
    }

    /* Estilos de eventos por estado (COLORES CORRECTOS) */
    .fc-daygrid-event.evento-pendiente,
    .fc-daygrid-event.evento-pendiente .fc-event-main,
    .fc-daygrid-event.evento-confirmada,
    .fc-daygrid-event.evento-confirmada .fc-event-main {
        background-color: #ffc107 !important; /* Amarillo */
        border-color: #ffc107 !important;
        color: #000 !important;
    }

    .fc-daygrid-event.evento-completada,
    .fc-daygrid-event.evento-completada .fc-event-main {
        background-color: #28a745 !important; /* Verde */
        border-color: #28a745 !important;
        color: #fff !important;
    }

    .fc-daygrid-event.evento-cancelada,
    .fc-daygrid-event.evento-cancelada .fc-event-main {
        background-color: #dc3545 !important; /* Rojo */
        border-color: #dc3545 !important;
        color: #fff !important;
    }

    .fc-daygrid-event.evento-default,
    .fc-daygrid-event.evento-default .fc-event-main {
        background-color: #6c757d !important; /* Gris */
        border-color: #6c757d !important;
        color: #fff !important;
    }

    /* Estilos generales de eventos */
    .fc-daygrid-event {
        white-space: normal !important;
        padding: 3px 5px !important;
        margin: 2px 0 !important;
        border-radius: 4px !important;
        font-size: 0.9em !important;
        cursor: pointer !important;
    }

    .fc-daygrid-event:hover {
        opacity: 0.9 !important;
        transform: translateY(-1px);
        transition: all 0.2s;
    }

    .fc-daygrid-event .fc-event-time,
    .fc-daygrid-event .fc-event-title {
        color: inherit !important;
    }

    .fc-daygrid-day-number {
        font-weight: bold;
        padding: 4px;
    }

    .fc-day-today {
        background-color: #fff3cd !important;
    }

    .fc-daygrid-more-link {
        color: #007bff !important;
        font-weight: bold !important;
    }

    /* Modal */
    .modal-header-custom {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .info-row {
        padding: 10px 0;
        border-bottom: 1px solid #f0f0f0;
    }

    .info-row:last-child {
        border-bottom: none;
    }

    .badge-estado {
        font-size: 0.9rem;
        padding: 5px 10px;
    }

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
                    <i class="fas fa-calendar-alt mr-2"></i>
                    Calendario de Citas
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Calendario</li>
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

        <!-- Estadísticas Rápidas -->
        <div class="row">
            <div class="col-md-3 col-6">
                <div class="info-box">
                    <span class="info-box-icon bg-warning"><i class="fas fa-clock"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Pendientes/Confirmadas</span>
                        <span class="info-box-number">${citasPendientes + citasConfirmadas}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="info-box">
                    <span class="info-box-icon bg-success"><i class="fas fa-check"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Completadas</span>
                        <span class="info-box-number">${citasCompletadas}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="info-box">
                    <span class="info-box-icon bg-danger"><i class="fas fa-times"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Canceladas</span>
                        <span class="info-box-number">${citasCanceladas}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="info-box">
                    <span class="info-box-icon bg-info"><i class="fas fa-calendar-day"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Total del Mes</span>
                        <span class="info-box-number">${totalCitas}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card del Calendario -->
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar mr-2"></i>
                    Vista Mensual - ${nombreMes} ${anio}
                </h3>
                <div class="card-tools">
                    <button type="button" class="btn btn-primary btn-sm" id="btnHoy">
                        <i class="fas fa-calendar-day mr-1"></i>Hoy
                    </button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="window.location.reload()">
                        <i class="fas fa-sync mr-1"></i>Actualizar
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div id="calendario"></div>
            </div>
        </div>

        <!-- Leyenda -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Leyenda de Estados
                </h3>
            </div>
            <div class="card-body">
                <span class="badge badge-warning badge-lg mr-3">
                    <i class="fas fa-circle"></i> Pendiente/Confirmada
                </span>
                <span class="badge badge-success badge-lg mr-3">
                    <i class="fas fa-circle"></i> Completada
                </span>
                <span class="badge badge-danger badge-lg mr-3">
                    <i class="fas fa-circle"></i> Cancelada
                </span>
            </div>
        </div>

    </div>
</section>

<!-- Modal Detalle de Cita -->
<div class="modal fade" id="modalDetalleCita" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title">
                    <i class="fas fa-calendar-check mr-2"></i>
                    Detalle de la Cita
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body" id="modalBody">
                <div class="text-center py-5">
                    <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
                    <p class="mt-3">Cargando información...</p>
                </div>
            </div>
            <div class="modal-footer" id="modalFooter">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    Cerrar
                </button>
            </div>
        </div>
    </div>
</div>

<!-- FullCalendar JS -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales/es.global.min.js'></script>

<!-- Script del Calendario -->
<script>
                        const contextPath = '${pageContext.request.contextPath}';
                        const eventosData = ${eventosJson};

                        let calendar;

                        document.addEventListener('DOMContentLoaded', function () {
                            const calendarEl = document.getElementById('calendario');

                            calendar = new FullCalendar.Calendar(calendarEl, {
                                locale: 'es',
                                initialView: 'dayGridMonth',

                                headerToolbar: {
                                    left: 'prev,next today',
                                    center: 'title',
                                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                                },

                                buttonText: {
                                    today: 'Hoy',
                                    month: 'Mes',
                                    week: 'Semana',
                                    day: 'Día'
                                },

                                events: eventosData,

                                displayEventTime: false,
                                displayEventEnd: false,

                                dayMaxEvents: 4,
                                height: 'auto',

                                eventTimeFormat: {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                    hour12: false
                                },

                                slotLabelFormat: {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                    hour12: false
                                },

                                // Aplicar colores correctos
                                eventDidMount: function (info) {
                                    const estado = info.event.extendedProps.estado;

                                    let backgroundColor, borderColor, textColor;

                                    switch (estado) {
                                        case 'PENDIENTE':
                                        case 'CONFIRMADA':
                                            backgroundColor = '#ffc107'; // Amarillo
                                            borderColor = '#ffc107';
                                            textColor = '#000000';
                                            break;
                                        case 'COMPLETADA':
                                            backgroundColor = '#28a745'; // Verde
                                            borderColor = '#28a745';
                                            textColor = '#ffffff';
                                            break;
                                        case 'CANCELADA':
                                            backgroundColor = '#dc3545'; // Rojo
                                            borderColor = '#dc3545';
                                            textColor = '#ffffff';
                                            break;
                                        default:
                                            backgroundColor = '#6c757d'; // Gris
                                            borderColor = '#6c757d';
                                            textColor = '#ffffff';
                                    }

                                    info.el.style.backgroundColor = backgroundColor;
                                    info.el.style.borderColor = borderColor;
                                    info.el.style.color = textColor;

                                    const eventMain = info.el.querySelector('.fc-event-main');
                                    if (eventMain) {
                                        eventMain.style.backgroundColor = backgroundColor;
                                        eventMain.style.color = textColor;
                                    }
                                },

                                eventClick: function (info) {
                                    info.jsEvent.preventDefault();
                                    mostrarDetalleCita(info.event.id);
                                },

                                moreLinkClick: function (info) {
                                    calendar.gotoDate(info.date);
                                    calendar.changeView('timeGridDay');
                                }
                            });

                            calendar.render();

                            // Botón "Hoy"
                            document.getElementById('btnHoy').addEventListener('click', function () {
                                calendar.today();
                            });
                        });

                        /**
                         * Muestra el detalle de una cita en el modal
                         */
                        function mostrarDetalleCita(idCita) {
                            $('#modalDetalleCita').modal('show');

                            $.ajax({
                                url: contextPath + '/CalendarioServlet',
                                method: 'GET',
                                data: {
                                    accion: 'detalle',
                                    idCita: idCita
                                },
                                dataType: 'json',
                                success: function (cita) {
                                    if (cita.error) {
                                        $('#modalBody').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle mr-2"></i>' + cita.error + '</div>');
                                        return;
                                    }

                                    let html = '<div class="container-fluid">';

                                    // Estado con colores correctos
                                    let badgeClass = '';
                                    switch (cita.estado) {
                                        case 'PENDIENTE':
                                        case 'CONFIRMADA':
                                            badgeClass = 'badge-warning';
                                            break;
                                        case 'COMPLETADA':
                                            badgeClass = 'badge-success';
                                            break;
                                        case 'CANCELADA':
                                            badgeClass = 'badge-danger';
                                            break;
                                        default:
                                            badgeClass = 'badge-secondary';
                                    }

                                    html += '<div class="info-row">';
                                    html += '<h5><i class="fas fa-info-circle text-primary mr-2"></i>Estado de la Cita</h5>';
                                    html += '<span class="badge ' + badgeClass + ' badge-estado">' + cita.estado + '</span>';
                                    html += '</div>';

                                    // Información del Paciente
                                    html += '<div class="info-row">';
                                    html += '<h5><i class="fas fa-user text-info mr-2"></i>Información del Paciente</h5>';
                                    html += '<p class="mb-1"><strong>Nombre:</strong> ' + (cita.nombrePaciente || 'N/A') + '</p>';
                                    html += '<p class="mb-1"><strong>DNI:</strong> ' + (cita.dniPaciente || 'N/A') + '</p>';
                                    html += '<p class="mb-1"><strong>Teléfono:</strong> ' + (cita.telefonoPaciente || 'N/A') + '</p>';
                                    html += '<p class="mb-0"><strong>Email:</strong> ' + (cita.emailPaciente || 'N/A') + '</p>';
                                    html += '</div>';

                                    // Detalles de la Cita
                                    html += '<div class="info-row">';
                                    html += '<h5><i class="fas fa-calendar-alt text-success mr-2"></i>Detalles de la Cita</h5>';
                                    html += '<p class="mb-1"><strong>Fecha:</strong> ' + (cita.fechaCita || 'N/A') + '</p>';
                                    html += '<p class="mb-1"><strong>Hora:</strong> ' + (cita.horaCita ? cita.horaCita.substring(0, 5) : 'N/A') + '</p>';
                                    html += '<p class="mb-0"><strong>Motivo:</strong> ' + (cita.motivoConsulta || 'No especificado') + '</p>';
                                    html += '</div>';

                                    // Observaciones (si existen)
                                    if (cita.observaciones) {
                                        html += '<div class="info-row">';
                                        html += '<h5><i class="fas fa-sticky-note text-warning mr-2"></i>Observaciones</h5>';
                                        html += '<p class="mb-0">' + cita.observaciones + '</p>';
                                        html += '</div>';
                                    }

                                    html += '</div>';

                                    $('#modalBody').html(html);

                                    // Botones de acción según estado
                                    let footerHtml = '';

                                    if (cita.estado === 'PENDIENTE' || cita.estado === 'CONFIRMADA') {
                                        footerHtml += '<button type="button" class="btn btn-success" onclick="completarCita(' + cita.idCita + ')">';
                                        footerHtml += '<i class="fas fa-check mr-2"></i>Completar Cita';
                                        footerHtml += '</button>';

                                        footerHtml += '<button type="button" class="btn btn-danger" onclick="cancelarCita(' + cita.idCita + ')">';
                                        footerHtml += '<i class="fas fa-times mr-2"></i>Cancelar Cita';
                                        footerHtml += '</button>';
                                    }

                                    if (cita.estado === 'COMPLETADA') {
                                        footerHtml += '<a href="' + contextPath + '/RecetaMedicaServlet?accion=nueva&idCita=' + cita.idCita + '&idPaciente=' + cita.idPaciente + '" class="btn btn-primary">';
                                        footerHtml += '<i class="fas fa-prescription mr-2"></i>Crear Receta';
                                        footerHtml += '</a>';
                                    }

                                    footerHtml += '<button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>';

                                    $('#modalFooter').html(footerHtml);
                                },
                                error: function () {
                                    $('#modalBody').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle mr-2"></i>Error al cargar los detalles de la cita</div>');
                                }
                            });
                        }

                        /**
                         * ✅ Completa una cita con SweetAlert2
                         */
                        function completarCita(idCita) {
                            // Cerrar el modal primero usando el evento de Bootstrap
                            $('#modalDetalleCita').one('hidden.bs.modal', function () {
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

                                        window.location.href = contextPath + '/CitaProfesionalServlet?accion=completar&id=' + idCita + '&origen=calendario';
                                    }
                                });
                            });

                            $('#modalDetalleCita').modal('hide');
                        }

                        /**
                         * ✅ Cancela una cita con SweetAlert2
                         */
                        function cancelarCita(idCita) {
                            // Cerrar el modal primero usando el evento de Bootstrap
                            $('#modalDetalleCita').one('hidden.bs.modal', function () {
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

                                        window.location.href = contextPath + '/CitaProfesionalServlet?accion=cancelar&id=' + idCita + '&origen=calendario&motivo=' + encodeURIComponent(motivo);
                                    }
                                });
                            });

                            $('#modalDetalleCita').modal('hide');
                        }
</script>
