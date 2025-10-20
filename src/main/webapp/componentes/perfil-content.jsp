<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS personalizado -->
<style>
.badge-lg {
    font-size: 1rem;
    padding: 0.5rem 0.75rem;
}
</style>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-user-circle mr-2"></i>
                    Mi Perfil
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/${sessionScope.usuario.idRol == 1 ? 'DashboardAdminServlet' : 'DashboardProfesionalServlet'}">
                            Inicio
                        </a>
                    </li>
                    <li class="breadcrumb-item active">Mi Perfil</li>
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

            <!-- Columna Izquierda: Info del Perfil -->
            <div class="col-md-4">

                <!-- Card de Perfil -->
                <div class="card card-primary card-outline">
                    <div class="card-body box-profile">

                        <div class="text-center">
                            <c:choose>
                                <c:when test="${not empty usuarioPerfil.fotoPerfil}">
                                    <img class="profile-user-img img-fluid img-circle"
                                         src="${pageContext.request.contextPath}/uploads/perfiles/${usuarioPerfil.fotoPerfil}"
                                         alt="Foto de perfil"
                                         style="width: 100px; height: 100px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img class="profile-user-img img-fluid img-circle"
                                         src="https://via.placeholder.com/100"
                                         alt="Avatar por defecto"
                                         style="width: 100px; height: 100px;">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h3 class="profile-username text-center">${usuarioPerfil.nombreCompleto}</h3>

                        <p class="text-muted text-center">
                            <c:choose>
                                <c:when test="${usuarioPerfil.idRol == 1}">
                                    <span class="badge badge-danger badge-lg">Administrador</span>
                                </c:when>
                                <c:when test="${usuarioPerfil.idRol == 2}">
                                    <span class="badge badge-primary badge-lg">Profesional Médico</span>
                                </c:when>
                                <c:when test="${usuarioPerfil.idRol == 3}">
                                    <span class="badge badge-info badge-lg">Profesional No Médico</span>
                                </c:when>
                            </c:choose>
                        </p>

                        <ul class="list-group list-group-unbordered mb-3">
                            <li class="list-group-item">
                                <b><i class="fas fa-envelope mr-2"></i>Email</b>
                                <span class="float-right">${usuarioPerfil.email}</span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-phone mr-2"></i>Teléfono</b>
                                <span class="float-right">
                                    ${not empty usuarioPerfil.telefono ? usuarioPerfil.telefono : 'No especificado'}
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-map-marker-alt mr-2"></i>Dirección</b>
                                <span class="float-right text-muted">
                                    ${not empty usuarioPerfil.direccion ? usuarioPerfil.direccion : 'No especificada'}
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-id-card mr-2"></i>DNI</b>
                                <span class="float-right">
                                    ${not empty usuarioPerfil.dni ? usuarioPerfil.dni : 'No especificado'}
                                </span>
                            </li>
                            <li class="list-group-item">
                                <b><i class="fas fa-toggle-on mr-2"></i>Estado</b>
                                <span class="float-right badge ${usuarioPerfil.activo ? 'badge-success' : 'badge-danger'}">
                                    ${usuarioPerfil.activo ? 'Activo' : 'Inactivo'}
                                </span>
                            </li>
                        </ul>

                        <a href="${pageContext.request.contextPath}/PerfilServlet?accion=editar" 
                           class="btn btn-primary btn-block">
                            <i class="fas fa-edit mr-2"></i>Editar Perfil
                        </a>

                        <button type="button" 
                                class="btn btn-warning btn-block"
                                data-toggle="modal"
                                data-target="#modalCambiarPassword">
                            <i class="fas fa-key mr-2"></i>Cambiar Contraseña
                        </button>
                    </div>
                </div>

                <!-- Card de Información Adicional -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-info-circle mr-2"></i>
                            Información Adicional
                        </h3>
                    </div>
                    <div class="card-body">
                        <strong><i class="far fa-calendar-alt mr-2"></i> Fecha de Registro</strong>
                        <p class="text-muted">
                            <!-- ✅ Validar substring -->
                            ${not empty usuarioPerfil.fechaRegistro && usuarioPerfil.fechaRegistro.length() >= 10 ? usuarioPerfil.fechaRegistro.substring(0, 10) : usuarioPerfil.fechaRegistro}
                        </p>
                        <hr/>
                        <strong><i class="far fa-clock mr-2"></i> Última Actualización</strong>
                        <p class="text-muted mb-0">
                            ${not empty usuarioPerfil.fechaActualizacion ? usuarioPerfil.fechaActualizacion : 'N/A'}
                        </p>
                    </div>
                </div>

            </div>

            <!-- Columna Derecha: Detalles -->
            <div class="col-md-8">

                <!-- Biografía Personal -->
                <c:if test="${not empty usuarioPerfil.biografia}">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-user-edit mr-2"></i>
                                Sobre Mí
                            </h3>
                        </div>
                        <div class="card-body">
                            <p>${usuarioPerfil.biografia}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Información Profesional (Solo para Profesionales - Roles 2 y 3) -->
                <c:if test="${usuarioPerfil.idRol == 2 || usuarioPerfil.idRol == 3}">
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-user-md mr-2"></i>
                                Información Profesional
                            </h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty profesional}">
                                <dl class="row">
                                    <dt class="col-sm-4">
                                        <i class="fas fa-briefcase-medical mr-2"></i>
                                        Especialidad:
                                    </dt>
                                    <dd class="col-sm-8">
                                        ${not empty profesional.nombreEspecialidad ? profesional.nombreEspecialidad : 'No especificada'}
                                    </dd>

                                    <dt class="col-sm-4">
                                        <i class="fas fa-certificate mr-2"></i>
                                        N° Colegiatura:
                                    </dt>
                                    <dd class="col-sm-8">
                                        <!-- ✅ Usar el campo correcto según tu modelo -->
                                        ${not empty profesional.numeroLicencia  ? profesional.numeroLicencia : 'No especificado'}
                                    </dd>

                                    <c:if test="${not empty profesional.aniosExperiencia && profesional.aniosExperiencia > 0}">
                                        <dt class="col-sm-4">
                                            <i class="fas fa-award mr-2"></i>
                                            Experiencia:
                                        </dt>
                                        <dd class="col-sm-8">${profesional.aniosExperiencia} años</dd>
                                    </c:if>
                                </dl>

                                <c:if test="${not empty profesional.biografiaProfesional}">
                                    <hr/>
                                    <strong><i class="fas fa-file-alt mr-2"></i>Biografía Profesional:</strong>
                                    <p class="text-muted mt-2">
                                        ${profesional.biografiaProfesional}
                                    </p>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Card de Estadísticas -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="info-box bg-info">
                            <span class="info-box-icon"><i class="fas fa-calendar-check"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Miembro Desde</span>
                                <span class="info-box-number">
                                    <!-- ✅ Validar substring -->
                                    ${not empty usuarioPerfil.fechaRegistro && usuarioPerfil.fechaRegistro.length() >= 10 ? usuarioPerfil.fechaRegistro.substring(0, 10) : 'N/A'}
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-box bg-success">
                            <span class="info-box-icon"><i class="fas fa-shield-alt"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Cuenta</span>
                                <span class="info-box-number">Verificada</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-box bg-warning">
                            <span class="info-box-icon"><i class="fas fa-star"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Nivel</span>
                                <span class="info-box-number">
                                    <c:choose>
                                        <c:when test="${usuarioPerfil.idRol == 1}">Admin</c:when>
                                        <c:otherwise>Profesional</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</section>

<!-- Modal Cambiar Contraseña -->
<div class="modal fade" id="modalCambiarPassword" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-key mr-2"></i>
                    Cambiar Contraseña
                </h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>

            <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST" id="formCambiarPassword">
                <input type="hidden" name="accion" value="actualizarPassword"/>

                <div class="modal-body">

                    <div class="form-group">
                        <label for="passwordAntigua">
                            Contraseña Actual <span class="text-danger">*</span>
                        </label>
                        <input type="password" 
                               class="form-control" 
                               id="passwordAntigua" 
                               name="passwordAntigua" 
                               required/>
                    </div>

                    <div class="form-group">
                        <label for="passwordNueva">
                            Nueva Contraseña <span class="text-danger">*</span>
                        </label>
                        <input type="password" 
                               class="form-control" 
                               id="passwordNueva" 
                               name="passwordNueva" 
                               minlength="6"
                               required/>
                        <small class="form-text text-muted">Mínimo 6 caracteres</small>
                    </div>

                    <div class="form-group">
                        <label for="passwordConfirmar">
                            Confirmar Nueva Contraseña <span class="text-danger">*</span>
                        </label>
                        <input type="password" 
                               class="form-control" 
                               id="passwordConfirmar" 
                               name="passwordConfirmar" 
                               minlength="6"
                               required/>
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        Por seguridad, ingresa tu contraseña actual antes de establecer una nueva.
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        Cancelar
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-save mr-2"></i>Cambiar Contraseña
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Script -->
<script>
$(document).ready(function () {
    if (typeof jQuery === 'undefined') {
        console.error('jQuery no está cargado');
        return;
    }
    
    // Validar que las contraseñas coincidan
    $('#formCambiarPassword').on('submit', function (e) {
        var passwordNueva = $('#passwordNueva').val();
        var passwordConfirmar = $('#passwordConfirmar').val();

        if (passwordNueva !== passwordConfirmar) {
            e.preventDefault();
            alert('⚠️ Las contraseñas no coinciden');
            $('#passwordConfirmar').focus();
            return false;
        }

        if (passwordNueva.length < 6) {
            e.preventDefault();
            alert('⚠️ La contraseña debe tener al menos 6 caracteres');
            $('#passwordNueva').focus();
            return false;
        }
    });
});
</script>
