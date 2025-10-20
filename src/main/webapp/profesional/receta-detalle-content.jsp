<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- CSS personalizado -->
<style>
    .badge-lg {
        font-size: 1rem;
        padding: 0.5rem 0.75rem;
    }

    .codigo-receta {
        font-family: 'Courier New', monospace;
        font-size: 1.2rem;
        font-weight: bold;
        letter-spacing: 2px;
    }

    /* Estilos para impresión */
    @media print {
        /* Ocultar elementos no necesarios */
        .content-header,
        .breadcrumb,
        .card-footer,
        .btn,
        .alert,
        .info-box {
            display: none !important;
        }

        /* Optimizar espacios */
        body {
            font-size: 11pt;
        }

        .card {
            border: none !important;
            box-shadow: none !important;
            margin: 0 !important;
            padding: 0 !important;
        }

        .card-body {
            padding: 10px !important;
        }

        .card-header {
            background: none !important;
            border: none !important;
            padding: 5px 0 !important;
        }

        /* Header compacto */
        .header-receta {
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #000;
        }

        /* Secciones más compactas */
        .seccion-receta {
            margin-bottom: 8px;
            padding: 5px;
            border-left: 3px solid #007bff;
            background: #f8f9fa;
        }

        .seccion-receta h6 {
            margin: 0 0 3px 0;
            font-size: 10pt;
            font-weight: bold;
        }

        .seccion-receta p {
            margin: 0;
            font-size: 10pt;
        }

        /* Firma compacta */
        .firma-receta {
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px solid #000;
        }

        /* Símbolo Rx más pequeño */
        .rx-symbol {
            font-size: 2.5rem !important;
            margin: 5px 0 !important;
        }

        /* Datos del paciente en tabla */
        .tabla-paciente {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }

        .tabla-paciente td {
            padding: 3px 5px;
            border: 1px solid #ddd;
            font-size: 10pt;
        }

        .tabla-paciente td:first-child {
            background: #f0f0f0;
            font-weight: bold;
            width: 30%;
        }
    }

    @media screen {
        .header-receta {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid #007bff;
        }
    }
</style>

<!-- Validar que la receta existe -->
<c:if test="${empty receta}">
    <section class="content">
        <div class="container-fluid">
            <div class="alert alert-warning mt-3">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                La receta no existe o ha sido eliminada.
                <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" class="alert-link">
                    Volver al listado
                </a>
            </div>
        </div>
    </section>
</c:if>

<!-- Mostrar detalle si receta existe -->
<c:if test="${not empty receta}">

    <!-- Content Header (solo pantalla) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">
                        <i class="fas fa-prescription mr-2"></i>
                        Receta Médica: <span class="codigo-receta text-primary">${receta.codigoReceta}</span>
                    </h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet">Recetas</a>
                        </li>
                        <li class="breadcrumb-item active">Detalle</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <section class="content">
        <div class="container-fluid">

            <!-- Alertas (solo pantalla) -->
            <jsp:include page="/componentes/alert.jsp"/>

            <div class="row">
                <div class="col-md-10 offset-md-1">

                    <!-- Card Principal -->
                    <div class="card card-outline ${not empty vigente && vigente ? 'card-success' : 'card-danger'}">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-file-prescription mr-2"></i>
                                Receta Médica: <span class="codigo-receta">${receta.codigoReceta}</span>
                            </h3>
                            <div class="card-tools">
                                <c:choose>
                                    <c:when test="${not empty vigente && vigente}">
                                        <span class="badge badge-success badge-lg">
                                            <i class="fas fa-check-circle mr-1"></i>
                                            VIGENTE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger badge-lg">
                                            <i class="fas fa-times-circle mr-1"></i>
                                            VENCIDA
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card-body">

                            <!-- ✅ HEADER PARA IMPRESIÓN -->
                            <div class="header-receta text-center">
                                <h2 style="margin: 0; font-size: 18pt; font-weight: bold;">
                                    CENTRO DE SALUD LA LIBERTAD
                                </h2>
                                <p style="margin: 5px 0 0 0; font-size: 10pt;">
                                    Receta Médica Digital N° <span class="codigo-receta">${receta.codigoReceta}</span>
                                </p>
                            </div>

                            <!-- ✅ DATOS DEL PROFESIONAL (Compacto) -->
                            <div style="margin-bottom: 15px;">
                                <strong style="font-size: 11pt;">
                                    ${not empty receta.nombreProfesional ? receta.nombreProfesional : 'No especificado'}
                                </strong>
                                <br>
                                <span style="font-size: 10pt; color: #666;">
                                    ${not empty receta.nombreEspecialidad ? receta.nombreEspecialidad : 'No especificada'}
                                </span>
                            </div>

                            <!-- ✅ DATOS DEL PACIENTE (Tabla compacta) -->
                            <table class="tabla-paciente">
                                <tr>
                                    <td>Paciente:</td>
                                    <td>${not empty receta.nombrePaciente ? receta.nombrePaciente : 'No especificado'}</td>
                                </tr>
                                <tr>
                                    <td>DNI:</td>
                                    <td>${not empty receta.dniPaciente ? receta.dniPaciente : 'No especificado'}</td>
                                </tr>
                                <tr>
                                    <td>Código Paciente:</td>
                                    <td>${receta.codigoPaciente}</td>
                                </tr>
                                <tr>
                                    <td>Edad:</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty paciente && paciente.edad > 0}">
                                                ${paciente.edad} años
                                            </c:when>
                                            <c:otherwise>
                                                No disponible
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Fecha Emisión:</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty receta.fechaEmision}">
                                                <fmt:parseDate value="${receta.fechaEmision}" pattern="yyyy-MM-dd" var="fechaEmisionParseada"/>
                                                <fmt:formatDate value="${fechaEmisionParseada}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>No especificada</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>

                            <!-- ✅ SÍMBOLO Rx -->
                            <div class="text-center" style="margin: 10px 0;">
                                <h1 class="rx-symbol" style="font-size: 3rem; font-weight: bold; color: #007bff; margin: 10px 0;">℞</h1>
                            </div>

                            <!-- ✅ PRESCRIPCIÓN (Compacta) -->
                            <div class="seccion-receta">
                                <h6><i class="fas fa-capsules mr-1"></i> Medicamentos:</h6>
                                <p>${not empty receta.medicamentos ? receta.medicamentos : 'No especificado'}</p>
                            </div>

                            <div class="row" style="margin-bottom: 8px;">
                                <div class="col-md-6">
                                    <div class="seccion-receta">
                                        <h6><i class="fas fa-prescription-bottle mr-1"></i> Dosis:</h6>
                                        <p>${not empty receta.dosis ? receta.dosis : 'No especificada'}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="seccion-receta">
                                        <h6><i class="fas fa-clock mr-1"></i> Frecuencia:</h6>
                                        <p>${not empty receta.frecuencia ? receta.frecuencia : 'No especificada'}</p>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty receta.duracion}">
                                <div class="seccion-receta">
                                    <h6><i class="fas fa-calendar-alt mr-1"></i> Duración:</h6>
                                    <p>${receta.duracion}</p>
                                </div>
                            </c:if>

                            <div class="seccion-receta">
                                <h6><i class="fas fa-exclamation-triangle mr-1"></i> Indicaciones:</h6>
                                <p>${not empty receta.indicaciones ? receta.indicaciones : 'No especificadas'}</p>
                            </div>

                            <c:if test="${not empty receta.observaciones}">
                                <div class="seccion-receta">
                                    <h6><i class="fas fa-sticky-note mr-1"></i> Observaciones:</h6>
                                    <p>${receta.observaciones}</p>
                                </div>
                            </c:if>

                            <!-- ✅ VIGENCIA (Compacto) -->
                            <div style="margin: 10px 0; padding: 5px; background: ${not empty vigente && vigente ? '#d4edda' : '#f8d7da'}; border-radius: 3px;">
                                <strong>Vigente hasta:</strong>
                                <c:choose>
                                    <c:when test="${not empty receta.fechaVigencia}">
                                        <fmt:parseDate value="${receta.fechaVigencia}" pattern="yyyy-MM-dd" var="fechaVigParseada"/>
                                        <fmt:formatDate value="${fechaVigParseada}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>No especificada</c:otherwise>
                                </c:choose>
                            </div>

                            <!-- ✅ CITA VINCULADA (Compacto) -->
                            <c:if test="${not empty receta.fechaCita}">
                                <div style="margin: 10px 0; padding: 5px; background: #e7f3ff; border-left: 3px solid #007bff; font-size: 9pt;">
                                    <strong>Cita:</strong> ${receta.codigoCita} -
                                    <fmt:parseDate value="${receta.fechaCita}" pattern="yyyy-MM-dd" var="fechaCitaParseada"/>
                                    <fmt:formatDate value="${fechaCitaParseada}" pattern="dd/MM/yyyy"/>
                                    <c:if test="${not empty receta.horaCita && fn:length(receta.horaCita) >= 5}">
                                        ${fn:substring(receta.horaCita, 0, 5)}
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- ✅ FIRMA (Compacta) -->
                            <div class="firma-receta text-right">
                                <p style="margin: 0; font-size: 10pt;">
                                    _________________________________
                                </p>
                                <p style="margin: 2px 0; font-size: 10pt; font-weight: bold;">
                                    ${not empty receta.nombreProfesional ? receta.nombreProfesional : 'Profesional'}
                                </p>
                                <p style="margin: 2px 0; font-size: 9pt; color: #666;">
                                    ${not empty receta.nombreEspecialidad ? receta.nombreEspecialidad : 'Especialidad'}
                                </p>
                                <p style="margin: 2px 0; font-size: 8pt; color: #999;">
                                    Centro de Salud La Libertad
                                </p>
                            </div>

                        </div>

                        <!-- Botones de Acción (solo pantalla) -->
                        <div class="card-footer">
                            <div class="btn-group" role="group">
                                <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=editar&id=${receta.idReceta}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-edit mr-1"></i>
                                    Editar
                                </a>
                                <button type="button" 
                                        class="btn btn-danger"
                                        onclick="eliminarReceta(${receta.idReceta})">
                                    <i class="fas fa-trash mr-1"></i>
                                    Eliminar
                                </button>
                                <button type="button" 
                                        class="btn btn-info"
                                        onclick="window.print()">
                                    <i class="fas fa-print mr-1"></i>
                                    Imprimir
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                               class="btn btn-secondary float-right">
                                <i class="fas fa-arrow-left mr-2"></i>
                                Volver al Listado
                            </a>
                        </div>

                    </div>

                </div>
            </div>

        </div>
    </section>

</c:if>

<!-- ✅ Script con SweetAlert2 -->
<script>
const contextPath = '${pageContext.request.contextPath}';

/**
 * Eliminar receta médica con SweetAlert2
 */
function eliminarReceta(idReceta) {
    Swal.fire({
        title: '¿Eliminar receta médica?',
        html: '¿Estás seguro de eliminar esta receta médica?<br><small class="text-muted">Esta acción no se puede deshacer</small>',
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
                html: 'Eliminando receta médica',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            // Crear y enviar formulario
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = contextPath + '/RecetaMedicaServlet';

            var inputAccion = document.createElement('input');
            inputAccion.type = 'hidden';
            inputAccion.name = 'accion';
            inputAccion.value = 'eliminar';
            form.appendChild(inputAccion);

            var inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'id';
            inputId.value = idReceta;
            form.appendChild(inputId);

            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
