<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
                    <i class="fas fa-prescription mr-2"></i>
                    Mis Recetas Médicas
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet">Inicio</a>
                    </li>
                    <li class="breadcrumb-item active">Recetas Médicas</li>
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

        <!-- Info Boxes -->
        <div class="row">
            <div class="col-md-6">
                <div class="info-box bg-gradient-info">
                    <span class="info-box-icon"><i class="fas fa-prescription-bottle-alt"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Total de Recetas Emitidas</span>
                        <span class="info-box-number">${not empty totalRecetas ? totalRecetas : 0}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-box bg-gradient-success">
                    <span class="info-box-icon"><i class="fas fa-check-circle"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Recetas Vigentes</span>
                        <span class="info-box-number">${not empty recetasVigentes ? recetasVigentes : 0}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recetas Card -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Listado de Recetas Emitidas
                </h3>
                <div class="card-tools">
                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva" 
                       class="btn btn-success btn-sm">
                        <i class="fas fa-plus mr-1"></i> Nueva Receta
                    </a>
                </div>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty recetas}">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover" id="recetasTable">
                                <thead>
                                    <tr>
                                        <th>Código</th>
                                        <th>Fecha Emisión</th>
                                        <th>Paciente</th>
                                        <th>Medicamentos</th>
                                        <th>Vigencia</th>
                                        <th>Estado</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="receta" items="${recetas}">
                                        <!-- ✅ Calcular si está vigente -->
                                        <jsp:useBean id="fechaActual" class="java.util.Date"/>
                                        <c:set var="vigente" value="false"/>
                                        <c:if test="${not empty receta.fechaVigencia}">
                                            <fmt:parseDate value="${receta.fechaVigencia}" pattern="yyyy-MM-dd" var="fechaVig"/>
                                            <c:if test="${fechaVig >= fechaActual}">
                                                <c:set var="vigente" value="true"/>
                                            </c:if>
                                        </c:if>

                                        <tr>
                                            <!-- Código de Receta -->
                                            <td>
                                                <span class="badge badge-secondary badge-lg">
                                                    <i class="fas fa-file-prescription mr-1"></i>
                                                    ${receta.codigoReceta}
                                                </span>
                                            </td>

                                            <!-- Fecha Emisión -->
                                            <td>
                                                <i class="far fa-calendar mr-1 text-primary"></i>
                                                <c:choose>
                                                    <c:when test="${not empty receta.fechaEmision}">
                                                        <fmt:parseDate value="${receta.fechaEmision}" pattern="yyyy-MM-dd" var="fechaParseada"/>
                                                        <fmt:formatDate value="${fechaParseada}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificada</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Paciente -->
                                            <td>
                                                <div>
                                                    <strong>${not empty receta.nombrePaciente ? receta.nombrePaciente : 'No especificado'}</strong>
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fas fa-id-badge mr-1"></i>
                                                    ${receta.codigoPaciente}
                                                    <c:if test="${not empty receta.dniPaciente}">
                                                        | DNI: ${receta.dniPaciente}
                                                    </c:if>
                                                </small>
                                            </td>

                                            <!-- Medicamentos (truncado) -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty receta.medicamentos}">
                                                        <c:set var="medicamentos" value="${receta.medicamentos}"/>
                                                        <c:choose>
                                                            <c:when test="${fn:length(medicamentos) > 50}">
                                                                <span data-toggle="tooltip" title="${medicamentos}">
                                                                    ${fn:substring(medicamentos, 0, 50)}...
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${medicamentos}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Fecha Vigencia -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty receta.fechaVigencia}">
                                                        <i class="far fa-calendar-check mr-1"></i>
                                                        <fmt:parseDate value="${receta.fechaVigencia}" pattern="yyyy-MM-dd" var="fechaVigParseada"/>
                                                        <fmt:formatDate value="${fechaVigParseada}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Sin vigencia</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Estado -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${vigente}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check-circle mr-1"></i>
                                                            Vigente
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-times-circle mr-1"></i>
                                                            Vencida
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Acciones -->
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <!-- Ver -->
                                                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=ver&id=${receta.idReceta}" 
                                                       class="btn btn-info" 
                                                       title="Ver detalle"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-eye"></i>
                                                    </a>

                                                    <!-- Editar -->
                                                    <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=editar&id=${receta.idReceta}" 
                                                       class="btn btn-primary" 
                                                       title="Editar"
                                                       data-toggle="tooltip">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <!-- Eliminar -->
                                                    <button type="button" 
                                                            class="btn btn-danger" 
                                                            onclick="eliminarReceta(${receta.idReceta})"
                                                            title="Eliminar"
                                                            data-toggle="tooltip">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Mensaje vacío -->
                        <div class="text-center py-5">
                            <i class="fas fa-prescription-bottle fa-4x mb-3 text-muted d-block"></i>
                            <h5 class="text-muted">No has emitido recetas médicas aún</h5>
                            <p class="text-muted mb-3">Las recetas que emitas aparecerán aquí</p>
                            <a href="${pageContext.request.contextPath}/RecetaMedicaServlet?accion=nueva" 
                               class="btn btn-success btn-lg">
                                <i class="fas fa-plus mr-1"></i> Crear Primera Receta
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Card Footer -->
            <div class="card-footer">
                <div class="row">
                    <div class="col-md-6">
                        <small class="text-muted">
                            <i class="fas fa-info-circle mr-1"></i>
                            Las recetas médicas tienen una vigencia predeterminada de 30 días
                        </small>
                    </div>
                    <div class="col-md-6 text-right">
                        <c:if test="${not empty recetas}">
                            <small class="text-muted">
                                <i class="fas fa-prescription mr-1"></i>
                                Mostrando <strong>${recetas.size()}</strong> receta(s)
                            </small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card Informativa -->
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Información sobre Recetas Médicas
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <h5><i class="fas fa-check-circle text-success mr-2"></i>Vigente</h5>
                        <p class="small">La receta está dentro del período de validez y puede ser dispensada.</p>
                    </div>
                    <div class="col-md-4">
                        <h5><i class="fas fa-times-circle text-danger mr-2"></i>Vencida</h5>
                        <p class="small">La fecha de vigencia ha expirado. No puede ser dispensada.</p>
                    </div>
                    <div class="col-md-4">
                        <h5><i class="fas fa-file-prescription text-primary mr-2"></i>Código</h5>
                        <p class="small">Identificador único para trazabilidad y validación.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

<!-- ✅ Script con SweetAlert2 -->
<script>
                                                                const contextPath = '${pageContext.request.contextPath}';

                                                                /**
                                                                 * ✅ Función para eliminar una receta médica con SweetAlert2
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

// Inicializar cuando el DOM esté listo
                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    if (typeof jQuery !== 'undefined') {
                                                                        // Activar tooltips
                                                                        $('[data-toggle="tooltip"]').tooltip();

                                                                        // Inicializar DataTables
    <c:if test="${not empty recetas}">
                                                                        if (typeof $.fn.DataTable !== 'undefined') {
                                                                            $('#recetasTable').DataTable({
                                                                                "language": {
                                                                                    "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                                                                                },
                                                                                "order": [[1, "desc"]], // Ordenar por fecha emisión
                                                                                "pageLength": 10,
                                                                                "responsive": true,
                                                                                "columnDefs": [
                                                                                    {"orderable": false, "targets": 6} // Desactivar orden en Acciones
                                                                                ]
                                                                            });
                                                                        } else {
                                                                            console.warn('DataTables no se cargó correctamente');
                                                                            Swal.fire({
                                                                                icon: 'warning',
                                                                                title: 'Advertencia',
                                                                                text: 'La tabla de datos no se cargó correctamente. Algunas funciones pueden no estar disponibles.',
                                                                                toast: true,
                                                                                position: 'top-end',
                                                                                showConfirmButton: false,
                                                                                timer: 3000
                                                                            });
                                                                        }
    </c:if>
                                                                    } else {
                                                                        console.error('jQuery no está cargado');
                                                                        Swal.fire({
                                                                            icon: 'error',
                                                                            title: 'Error de carga',
                                                                            text: 'jQuery no se cargó correctamente. Por favor, recarga la página.',
                                                                            confirmButtonColor: '#dc3545'
                                                                        });
                                                                    }
                                                                });
</script>
