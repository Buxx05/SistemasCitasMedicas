<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS para las horas -->
<style>
    .hora-slot {
        display: inline-block;
        width: 90px;
        padding: 10px;
        margin: 5px;
        border: 2px solid #ddd;
        border-radius: 5px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: bold;
    }

    .hora-slot.disponible {
        background-color: #d4edda;
        border-color: #28a745;
        color: #155724;
    }

    .hora-slot.disponible:hover {
        background-color: #28a745;
        color: white;
        transform: scale(1.05);
    }

    .hora-slot.ocupada {
        background-color: #f8d7da;
        border-color: #dc3545;
        color: #721c24;
        cursor: not-allowed;
        opacity: 0.6;
    }

    .hora-slot.seleccionada {
        background-color: #007bff;
        border-color: #0056b3;
        color: white;
        transform: scale(1.1);
    }

    #horasContainer {
        min-height: 100px;
        padding: 15px;
        border: 1px dashed #ddd;
        border-radius: 5px;
        text-align: center;
    }
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-redo mr-2"></i>
                    Crear Cita de Seguimiento
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet">Mis Citas</a>
                    </li>
                    <li class="breadcrumb-item active">Crear Re-cita</li>
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
            <div class="col-md-10 offset-md-1">

                <!-- Información de la cita original -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-info-circle mr-2"></i>
                            Cita Original
                        </h3>
                    </div>
                    <div class="card-body">
                        <dl class="row">
                            <dt class="col-sm-3">Paciente:</dt>
                            <dd class="col-sm-9">${paciente.nombreCompleto}</dd>

                            <dt class="col-sm-3">DNI:</dt>
                            <dd class="col-sm-9">${paciente.dni}</dd>

                            <dt class="col-sm-3">Fecha Cita Original:</dt>
                            <dd class="col-sm-9">${citaOriginal.fechaCita}</dd>

                            <dt class="col-sm-3">Motivo Original:</dt>
                            <dd class="col-sm-9">${citaOriginal.motivoConsulta}</dd>
                        </dl>
                    </div>
                </div>

                <!-- Formulario de re-cita -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-plus mr-2"></i>
                            Nueva Cita de Seguimiento
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                          method="post" 
                          id="recitaForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="crearRecita">
                        <input type="hidden" name="idCitaOriginal" value="${citaOriginal.idCita}">
                        <input type="hidden" name="idPaciente" value="${paciente.idPaciente}">
                        <input type="hidden" name="origen" value="${param.origen != null ? param.origen : 'dashboard'}">
                        <!-- ✅ Campo oculto para la hora seleccionada -->
                        <input type="hidden" name="horaCita" id="horaCitaInput" required>

                        <div class="card-body">

                            <!-- Fecha -->
                            <div class="form-group">
                                <label for="fechaCita">
                                    <i class="far fa-calendar mr-1"></i>
                                    Fecha <span class="text-danger">*</span>
                                </label>
                                <input type="date" 
                                       class="form-control form-control-lg" 
                                       id="fechaCita" 
                                       name="fechaCita" 
                                       required>
                                <small class="form-text text-muted">
                                    Selecciona una fecha para ver las horas disponibles
                                </small>
                            </div>

                            <!-- ✅ Selector de Horas Disponibles -->
                            <div class="form-group">
                                <label>
                                    <i class="far fa-clock mr-1"></i>
                                    Hora Disponible <span class="text-danger">*</span>
                                </label>
                                <div id="horasContainer">
                                    <p class="text-muted">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        Selecciona una fecha para ver las horas disponibles
                                    </p>
                                </div>
                                <small class="form-text text-muted">
                                    <span class="badge badge-success">Verde</span> = Disponible &nbsp;
                                    <span class="badge badge-danger">Rojo</span> = Ocupado
                                </small>
                            </div>

                            <!-- Motivo -->
                            <div class="form-group">
                                <label for="motivoConsulta">
                                    <i class="fas fa-notes-medical mr-1"></i>
                                    Motivo de la Cita de Seguimiento <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" 
                                          id="motivoConsulta" 
                                          name="motivoConsulta" 
                                          rows="3" 
                                          placeholder="Ejemplo: Evaluación de resultados de exámenes, control post-tratamiento..."
                                          required></textarea>
                            </div>

                            <!-- Observaciones -->
                            <div class="form-group">
                                <label for="observaciones">
                                    <i class="fas fa-sticky-note mr-1"></i>
                                    Observaciones Adicionales
                                </label>
                                <textarea class="form-control" 
                                          id="observaciones" 
                                          name="observaciones" 
                                          rows="2" 
                                          placeholder="Notas internas o instrucciones especiales..."></textarea>
                            </div>

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle mr-2"></i>
                                <strong>Nota:</strong> El paciente recibirá una notificación de la nueva cita de seguimiento.
                            </div>

                        </div>

                        <!-- Botones -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg" id="btnSubmit">
                                <i class="fas fa-save mr-2"></i>
                                Crear Re-cita
                            </button>
                            <button type="button" class="btn btn-secondary btn-lg" onclick="confirmarCancelar()">
                                <i class="fas fa-times mr-2"></i>
                                Cancelar
                            </button>
                        </div>

                    </form>
                </div>

            </div>
        </div>

    </div>
</section>

<!-- ✅ Script con SweetAlert2 -->
<script>
const contextPath = '${pageContext.request.contextPath}';
const idProfesional = ${idProfesional};
let horaSeleccionada = null;

$(document).ready(function () {
    // Establecer fecha mínima (hoy)
    const today = new Date().toISOString().split('T')[0];
    $('#fechaCita').attr('min', today);

    // ✅ Cuando cambia la fecha, cargar horas disponibles
    $('#fechaCita').on('change', function () {
        const fecha = $(this).val();

        if (!fecha)
            return;

        cargarHorasDisponibles(fecha);
    });

    // ✅ Validación del formulario con SweetAlert2
    $('#recitaForm').submit(function (e) {
        const fecha = $('#fechaCita').val();
        const hora = $('#horaCitaInput').val();
        const motivo = $('#motivoConsulta').val().trim();

        if (!fecha) {
            e.preventDefault();
            Swal.fire({
                icon: 'warning',
                title: 'Fecha requerida',
                text: 'Debe seleccionar una fecha para la cita',
                confirmButtonColor: '#ffc107'
            });
            $('#fechaCita').focus();
            return false;
        }

        if (!hora) {
            e.preventDefault();
            Swal.fire({
                icon: 'warning',
                title: 'Hora requerida',
                text: 'Debe seleccionar una hora disponible',
                confirmButtonColor: '#ffc107'
            });
            return false;
        }

        if (motivo.length < 10) {
            e.preventDefault();
            Swal.fire({
                icon: 'warning',
                title: 'Motivo incompleto',
                text: 'El motivo debe tener al menos 10 caracteres',
                confirmButtonColor: '#ffc107'
            });
            $('#motivoConsulta').focus();
            return false;
        }
    });
});

/**
 * ✅ Confirmar cancelación con SweetAlert2
 */
function confirmarCancelar() {
    const fecha = $('#fechaCita').val();
    const motivo = $('#motivoConsulta').val().trim();
    const observaciones = $('#observaciones').val().trim();
    
    const hayCambios = fecha !== '' || motivo !== '' || observaciones !== '' || horaSeleccionada !== null;
    
    if (hayCambios) {
        Swal.fire({
            title: '¿Cancelar sin guardar?',
            html: 'Tienes cambios sin guardar en la re-cita.<br>¿Estás seguro de que deseas salir?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#6c757d',
            cancelButtonColor: '#007bff',
            confirmButtonText: '<i class="fas fa-times"></i> Sí, salir',
            cancelButtonText: '<i class="fas fa-arrow-left"></i> Continuar editando',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                const origen = '${param.origen}';
                window.location.href = contextPath + '/' + (origen === 'citas' ? 'CitaProfesionalServlet' : 'DashboardProfesionalServlet');
            }
        });
    } else {
        const origen = '${param.origen}';
        window.location.href = contextPath + '/' + (origen === 'citas' ? 'CitaProfesionalServlet' : 'DashboardProfesionalServlet');
    }
}

/**
 * Carga las horas disponibles mediante AJAX
 */
function cargarHorasDisponibles(fecha) {
    const container = $('#horasContainer');

    // Mostrar loading
    container.html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Cargando horas disponibles...</p></div>');

    $.ajax({
        url: contextPath + '/ObtenerHorasDisponiblesServlet',
        method: 'GET',
        data: {
            idProfesional: idProfesional,
            fecha: fecha
        },
        dataType: 'json',
        success: function (response) {
            if (response.success) {
                mostrarHorasDisponibles(response.horas);
            } else {
                container.html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle mr-2"></i>' + response.message + '</div>');
            }
        },
        error: function (xhr, status, error) {
            console.error('Error AJAX:', error);
            container.html('<div class="alert alert-danger"><i class="fas fa-times-circle mr-2"></i>Error al cargar las horas. Intenta de nuevo.</div>');
            
            Swal.fire({
                icon: 'error',
                title: 'Error de conexión',
                text: 'No se pudieron cargar las horas disponibles. Por favor, intenta de nuevo.',
                confirmButtonColor: '#dc3545'
            });
        }
    });
}

/**
 * Muestra las horas disponibles como botones
 */
function mostrarHorasDisponibles(horas) {
    const container = $('#horasContainer');
    container.empty();

    if (horas.length === 0) {
        container.html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle mr-2"></i>No hay horas disponibles para esta fecha</div>');
        return;
    }

    horas.forEach(function (slot) {
        const claseDisponible = slot.disponible ? 'disponible' : 'ocupada';
        const disabled = !slot.disponible;

        const boton = $('<div>')
                .addClass('hora-slot ' + claseDisponible)
                .text(slot.hora)
                .data('hora', slot.hora)
                .attr('data-disponible', slot.disponible);

        if (slot.disponible) {
            boton.on('click', function () {
                seleccionarHora($(this));
            });
        }

        container.append(boton);
    });
}

/**
 * Selecciona una hora
 */
function seleccionarHora(boton) {
    // Quitar selección anterior
    $('.hora-slot').removeClass('seleccionada');

    // Marcar como seleccionada
    boton.addClass('seleccionada');

    // Guardar hora
    horaSeleccionada = boton.data('hora');
    $('#horaCitaInput').val(horaSeleccionada + ':00');

    console.log('Hora seleccionada:', horaSeleccionada);
    
    // ✅ Feedback visual con toast
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 2000,
        timerProgressBar: true
    });
    
    Toast.fire({
        icon: 'success',
        title: 'Hora seleccionada: ' + horaSeleccionada
    });
}
</script>
