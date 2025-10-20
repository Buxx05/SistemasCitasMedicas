<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- noUiSlider CSS -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.css" rel="stylesheet">

<!-- CSS personalizado -->
<style>
    /* Estilos del slider */
    .horario-dia-card {
        margin-bottom: 25px;
        border: 2px solid #e0e0e0;
        transition: all 0.3s ease;
    }

    .horario-dia-card.activo {
        border-color: #007bff;
        background-color: #f8f9ff;
    }

    .slider-container {
        padding: 30px 20px;
        margin: 20px 0;
    }

    .slider-horario {
        height: 12px;
    }

    .noUi-connect {
        background: #007bff;
    }

    .noUi-handle {
        border-radius: 50%;
        width: 28px;
        height: 28px;
        top: -8px;
    }

    .horario-valores {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
        font-size: 1.1rem;
    }

    .hora-display {
        background: #007bff;
        color: white;
        padding: 8px 15px;
        border-radius: 20px;
        font-weight: bold;
    }

    .duracion-info {
        background-color: #e7f3ff;
        border-left: 4px solid #007bff;
        padding: 15px;
        margin: 20px 0;
    }

    .custom-switch-lg .custom-control-label {
        padding-left: 1rem;
        font-size: 1.1rem;
    }

    .custom-switch-lg .custom-control-label::before {
        height: 1.5rem;
        width: 3rem;
        border-radius: 3rem;
    }

    .custom-switch-lg .custom-control-label::after {
        width: 1.2rem;
        height: 1.2rem;
        border-radius: 3rem;
    }

    .custom-switch-lg .custom-control-input:checked ~ .custom-control-label::after {
        transform: translateX(1.5rem);
    }
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas ${empty horario ? 'fa-plus' : 'fa-edit'} mr-2"></i>
                    ${empty horario ? 'Nuevo Horario' : 'Editar Horario'}
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet">Horarios</a>
                    </li>
                    <li class="breadcrumb-item active">
                        ${empty horario ? 'Nuevo' : 'Editar'}
                    </li>
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

        <div class="row">
            <div class="col-md-10 offset-md-1">

                <!-- Formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-clock mr-2"></i>
                            Configuración de Horario de Atención
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                          method="POST" 
                          id="horarioForm">

                        <!-- Campos ocultos -->
                        <input type="hidden" name="accion" value="${empty horario ? 'crear' : 'actualizar'}"/>
                        <c:if test="${not empty horario}">
                            <input type="hidden" name="idHorario" value="${horario.idHorario}"/>
                        </c:if>

                        <div class="card-body">

                            <!-- Día de la Semana -->
                            <div class="form-group">
                                <label for="diaSemana">
                                    <i class="far fa-calendar mr-1"></i>
                                    Día de la Semana <span class="text-danger">*</span>
                                </label>
                                <select class="form-control form-control-lg" 
                                        id="diaSemana" 
                                        name="diaSemana" 
                                        required>
                                    <option value="">-- Seleccione un día --</option>
                                    <option value="LUNES" ${not empty horario && horario.diaSemana == 'LUNES' ? 'selected' : ''}>Lunes</option>
                                    <option value="MARTES" ${not empty horario && horario.diaSemana == 'MARTES' ? 'selected' : ''}>Martes</option>
                                    <option value="MIERCOLES" ${not empty horario && horario.diaSemana == 'MIERCOLES' ? 'selected' : ''}>Miércoles</option>
                                    <option value="JUEVES" ${not empty horario && horario.diaSemana == 'JUEVES' ? 'selected' : ''}>Jueves</option>
                                    <option value="VIERNES" ${not empty horario && horario.diaSemana == 'VIERNES' ? 'selected' : ''}>Viernes</option>
                                    <option value="SABADO" ${not empty horario && horario.diaSemana == 'SABADO' ? 'selected' : ''}>Sábado</option>
                                    <option value="DOMINGO" ${not empty horario && horario.diaSemana == 'DOMINGO' ? 'selected' : ''}>Domingo</option>
                                </select>
                            </div>

                            <!-- ✅ SLIDER DE RANGO DE HORAS -->
                            <div class="horario-dia-card card">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0">
                                        <i class="fas fa-sliders-h mr-2"></i>
                                        Rango de Atención
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Slider -->
                                    <div class="slider-container">
                                        <label class="mb-3">
                                            <i class="fas fa-clock mr-1"></i>
                                            Arrastra para seleccionar tu horario de atención:
                                        </label>
                                        <div id="slider-horario" class="slider-horario"></div>

                                        <!-- Valores visuales -->
                                        <div class="horario-valores">
                                            <div>
                                                <small class="text-muted d-block">Inicio</small>
                                                <span class="hora-display" id="hora-inicio-display">08:00</span>
                                            </div>
                                            <div>
                                                <small class="text-muted d-block">Fin</small>
                                                <span class="hora-display" id="hora-fin-display">17:00</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Inputs hidden para enviar al servlet -->
                                    <input type="hidden" name="horaInicio" id="horaInicio" value="08:00" required/>
                                    <input type="hidden" name="horaFin" id="horaFin" value="17:00" required/>

                                    <!-- Info visual -->
                                    <div class="duracion-info">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        <strong>Horario seleccionado:</strong>
                                        <span id="resumen-horario">08:00 - 17:00 (9 horas)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Duración de Consulta -->
                            <div class="form-group">
                                <label for="duracionConsulta">
                                    <i class="fas fa-hourglass-half mr-1"></i>
                                    Duración por Consulta <span class="text-danger">*</span>
                                </label>
                                <select class="form-control form-control-lg" 
                                        id="duracionConsulta" 
                                        name="duracionConsulta" 
                                        required>
                                    <option value="">-- Seleccione duración --</option>
                                    <option value="15" ${not empty horario && horario.duracionConsulta == 15 ? 'selected' : ''}>15 minutos</option>
                                    <option value="20" ${not empty horario && horario.duracionConsulta == 20 ? 'selected' : ''}>20 minutos</option>
                                    <option value="30" ${not empty horario && horario.duracionConsulta == 30 ? 'selected' : ''} selected>30 minutos (Recomendado)</option>
                                    <option value="45" ${not empty horario && horario.duracionConsulta == 45 ? 'selected' : ''}>45 minutos</option>
                                    <option value="60" ${not empty horario && horario.duracionConsulta == 60 ? 'selected' : ''}>60 minutos (1 hora)</option>
                                </select>
                                <small class="form-text text-muted">
                                    <i class="fas fa-lightbulb mr-1"></i>
                                    Se generarán <strong id="num-citas">18</strong> espacios de citas con este horario
                                </small>
                            </div>

                            <!-- Estado Activo -->
                            <div class="form-group">
                                <div class="custom-control custom-switch custom-switch-lg">
                                    <input type="checkbox" 
                                           class="custom-control-input" 
                                           id="activo" 
                                           name="activo"
                                           ${empty horario || horario.activo ? 'checked' : ''}>
                                    <label class="custom-control-label" for="activo">
                                        <i class="fas fa-toggle-on mr-1"></i>
                                        <strong>Horario Activo</strong>
                                    </label>
                                </div>
                                <small class="form-text text-muted">
                                    Solo los horarios activos estarán disponibles para agendar citas
                                </small>
                            </div>

                            <!-- Información adicional -->
                            <div class="alert alert-info">
                                <h5><i class="icon fas fa-info-circle"></i> Información:</h5>
                                <ul class="mb-0">
                                    <li>Horario de atención: <strong>8:00 AM - 5:00 PM</strong></li>
                                    <li>Los bloques horarios se generan automáticamente según la duración</li>
                                    <li>Los horarios no pueden solaparse en el mismo día</li>
                                    <li>Puedes configurar múltiples bloques para el mismo día (ej: mañana y tarde)</li>
                                </ul>
                            </div>

                        </div>

                        <!-- Card Footer -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                ${empty horario ? 'Crear Horario' : 'Guardar Cambios'}
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

<!-- noUiSlider JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.js"></script>

<!-- ✅ Script con SweetAlert2 -->
<script>
                                const contextPath = '${pageContext.request.contextPath}';

// ✅ 1. PRIMERO: Definir todas las funciones auxiliares
                                function minutosAHora(minutos) {
                                    const horas = Math.floor(minutos / 60);
                                    const mins = minutos % 60;
                                    return pad(horas) + ':' + pad(mins);
                                }

                                function horaAMinutos(hora) {
                                    if (!hora || hora === '')
                                        return 0;
                                    const partes = hora.split(':');
                                    return parseInt(partes[0]) * 60 + parseInt(partes[1]);
                                }

                                function pad(num) {
                                    return (num < 10 ? '0' : '') + num;
                                }

                                function calcularDuracion(inicio, fin) {
                                    const minutosInicio = horaAMinutos(inicio);
                                    const minutosFin = horaAMinutos(fin);
                                    const duracionMinutos = minutosFin - minutosInicio;
                                    const horas = Math.floor(duracionMinutos / 60);
                                    const minutos = duracionMinutos % 60;

                                    if (minutos === 0) {
                                        return horas + (horas === 1 ? ' hora' : ' horas');
                                    }
                                    return horas + 'h ' + minutos + 'min';
                                }

                                function calcularNumCitas(inicio, fin, duracion) {
                                    if (!duracion || duracion === '')
                                        return 0;
                                    const minutosInicio = horaAMinutos(inicio);
                                    const minutosFin = horaAMinutos(fin);
                                    const duracionTotal = minutosFin - minutosInicio;
                                    return Math.floor(duracionTotal / parseInt(duracion));
                                }

                                /**
                                 * ✅ Confirmar cancelación con SweetAlert2
                                 */
                                function confirmarCancelar() {
                                    Swal.fire({
                                        title: '¿Cancelar sin guardar?',
                                        html: '¿Estás seguro de que deseas salir sin guardar los cambios?',
                                        icon: 'question',
                                        showCancelButton: true,
                                        confirmButtonColor: '#6c757d',
                                        cancelButtonColor: '#007bff',
                                        confirmButtonText: '<i class="fas fa-times"></i> Sí, salir',
                                        cancelButtonText: '<i class="fas fa-arrow-left"></i> Continuar editando',
                                        reverseButtons: true
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            window.location.href = contextPath + '/HorarioProfesionalServlet';
                                        }
                                    });
                                }

// ✅ 2. DESPUÉS: Inicializar cuando el DOM esté listo
                                document.addEventListener('DOMContentLoaded', function () {
                                    // Verificar jQuery
                                    if (typeof jQuery === 'undefined') {
                                        console.error('jQuery no está cargado');
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error de carga',
                                            text: 'jQuery no se cargó correctamente. Por favor, recarga la página.',
                                            confirmButtonColor: '#dc3545'
                                        });
                                        return;
                                    }

                                    // Verificar noUiSlider
                                    if (typeof noUiSlider === 'undefined') {
                                        console.error('noUiSlider no está cargado');
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error de carga',
                                            text: 'La librería noUiSlider no se cargó correctamente. Por favor, recarga la página.',
                                            confirmButtonColor: '#dc3545'
                                        });
                                        return;
                                    }

                                    const sliderElement = document.getElementById('slider-horario');

                                    if (!sliderElement) {
                                        console.error('Elemento slider-horario no encontrado');
                                        return;
                                    }

                                    // Valores iniciales (8 AM a 5 PM en minutos desde medianoche)
                                    let inicioDefault = 480;  // 8:00 AM
                                    let finDefault = 1020;    // 5:00 PM

                                    // ✅ Si está editando, usar valores existentes
    <c:if test="${not empty horario}">
                                    try {
        <c:if test="${not empty horario.horaInicio && horario.horaInicio.length() >= 5}">
                                        const horaInicioStr = '${horario.horaInicio.substring(0, 5)}';
                                        if (horaInicioStr && horaInicioStr !== '') {
                                            inicioDefault = horaAMinutos(horaInicioStr);
                                        }
        </c:if>
        <c:if test="${not empty horario.horaFin && horario.horaFin.length() >= 5}">
                                        const horaFinStr = '${horario.horaFin.substring(0, 5)}';
                                        if (horaFinStr && horaFinStr !== '') {
                                            finDefault = horaAMinutos(horaFinStr);
                                        }
        </c:if>
                                    } catch (e) {
                                        console.error('Error al parsear horarios existentes:', e);
                                    }
    </c:if>

                                    // Validar que los valores sean números válidos
                                    if (isNaN(inicioDefault) || inicioDefault < 480)
                                        inicioDefault = 480;
                                    if (isNaN(finDefault) || finDefault > 1020)
                                        finDefault = 1020;
                                    if (finDefault <= inicioDefault)
                                        finDefault = inicioDefault + 60;

                                    console.log('Inicializando slider con valores:', inicioDefault, finDefault);

                                    // Crear slider
                                    try {
                                        noUiSlider.create(sliderElement, {
                                            start: [inicioDefault, finDefault],
                                            connect: true,
                                            range: {
                                                'min': 480, // 8:00 AM
                                                'max': 1020   // 5:00 PM (17:00)
                                            },
                                            step: 30, // Incrementos de 30 minutos
                                            tooltips: false
                                        });

                                        // Actualizar valores cuando cambia el slider
                                        sliderElement.noUiSlider.on('update', function (values, handle) {
                                            try {
                                                // values ya vienen como números (minutos)
                                                const minutosInicio = Math.round(values[0]);
                                                const minutosFin = Math.round(values[1]);

                                                // Convertir a formato HH:mm
                                                const inicio = minutosAHora(minutosInicio);
                                                const fin = minutosAHora(minutosFin);

                                                // Actualizar displays visuales
                                                document.getElementById('hora-inicio-display').textContent = inicio;
                                                document.getElementById('hora-fin-display').textContent = fin;

                                                // Actualizar inputs hidden
                                                document.getElementById('horaInicio').value = inicio;
                                                document.getElementById('horaFin').value = fin;

                                                // Actualizar resumen
                                                const duracion = calcularDuracion(inicio, fin);
                                                document.getElementById('resumen-horario').textContent = inicio + ' - ' + fin + ' (' + duracion + ')';

                                                // Actualizar número de citas
                                                actualizarNumCitas();
                                            } catch (e) {
                                                console.error('Error en update del slider:', e);
                                            }
                                        });

                                        console.log('Slider inicializado correctamente');

                                    } catch (e) {
                                        console.error('Error al crear el slider:', e);
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error al inicializar',
                                            text: 'Error al inicializar el selector de horario. Por favor, recarga la página.',
                                            confirmButtonColor: '#dc3545'
                                        });
                                    }

                                    // Función para actualizar número de citas
                                    function actualizarNumCitas() {
                                        try {
                                            const inicio = document.getElementById('horaInicio').value;
                                            const fin = document.getElementById('horaFin').value;
                                            const duracion = document.getElementById('duracionConsulta').value;

                                            if (duracion && inicio && fin) {
                                                const numCitas = calcularNumCitas(inicio, fin, duracion);
                                                document.getElementById('num-citas').textContent = numCitas;
                                            } else {
                                                document.getElementById('num-citas').textContent = '0';
                                            }
                                        } catch (e) {
                                            console.error('Error al actualizar número de citas:', e);
                                            document.getElementById('num-citas').textContent = '0';
                                        }
                                    }

                                    // Actualizar número de citas cuando cambia duración
                                    $('#duracionConsulta').on('change', function () {
                                        actualizarNumCitas();
                                    });

                                    // ✅ Validar formulario con SweetAlert2
                                    $('#horarioForm').on('submit', function (e) {
                                        const horaInicio = $('#horaInicio').val();
                                        const horaFin = $('#horaFin').val();
                                        const duracion = $('#duracionConsulta').val();
                                        const dia = $('#diaSemana').val();

                                        if (!dia) {
                                            e.preventDefault();
                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'Campo requerido',
                                                text: 'Debe seleccionar un día de la semana',
                                                confirmButtonColor: '#ffc107'
                                            });
                                            $('#diaSemana').focus();
                                            return false;
                                        }

                                        if (!duracion) {
                                            e.preventDefault();
                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'Campo requerido',
                                                text: 'Debe seleccionar la duración de consulta',
                                                confirmButtonColor: '#ffc107'
                                            });
                                            $('#duracionConsulta').focus();
                                            return false;
                                        }

                                        if (!horaInicio || !horaFin) {
                                            e.preventDefault();
                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'Horario inválido',
                                                text: 'Debe seleccionar el rango de horario usando el deslizador',
                                                confirmButtonColor: '#ffc107'
                                            });
                                            return false;
                                        }

                                        if (horaFin <= horaInicio) {
                                            e.preventDefault();
                                            Swal.fire({
                                                icon: 'error',
                                                title: 'Error en horario',
                                                text: 'La hora de fin debe ser mayor que la hora de inicio',
                                                confirmButtonColor: '#dc3545'
                                            });
                                            return false;
                                        }

                                        return true;
                                    });

                                    // Inicializar número de citas por primera vez
                                    setTimeout(function () {
                                        actualizarNumCitas();
                                    }, 100);
                                });
</script>
