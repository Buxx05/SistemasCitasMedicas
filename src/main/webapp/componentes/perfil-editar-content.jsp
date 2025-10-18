<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">
                    <i class="fas fa-user-edit mr-2"></i>
                    Editar Mi Perfil
                </h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/${sessionScope.usuario.idRol == 1 ? 'DashboardAdminServlet' : 'DashboardProfesionalServlet'}">
                            Inicio
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/PerfilServlet">Mi Perfil</a>
                    </li>
                    <li class="breadcrumb-item active">Editar</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<section class="content">
    <div class="container-fluid">

        <div class="row">
            <div class="col-md-10 offset-md-1">

                <!-- Card Foto de Perfil -->
                <div class="card card-widget widget-user">
                    <div class="widget-user-header bg-info">
                        <h3 class="widget-user-username">${usuarioPerfil.nombreCompleto}</h3>
                        <h5 class="widget-user-desc">
                            <c:choose>
                                <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                                <c:otherwise>Profesional de Salud</c:otherwise>
                            </c:choose>
                        </h5>
                    </div>
                    <div class="widget-user-image">
                        <c:choose>
                            <c:when test="${not empty usuarioPerfil.fotoPerfil}">
                                <img class="img-circle elevation-2"
                                     src="${pageContext.request.contextPath}/uploads/perfiles/${usuarioPerfil.fotoPerfil}"
                                     alt="Foto"
                                     style="width: 90px; height: 90px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <img class="img-circle elevation-2"
                                     src="https://via.placeholder.com/90"
                                     alt="Avatar"
                                     style="width: 90px; height: 90px;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer">
                        <form action="${pageContext.request.contextPath}/PerfilServlet" 
                              method="POST" 
                              enctype="multipart/form-data"
                              id="formFotoPerfil">
                            <input type="hidden" name="accion" value="subirFoto"/>
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="custom-file">
                                        <input type="file" 
                                               class="custom-file-input" 
                                               id="fotoPerfil" 
                                               name="fotoPerfil"
                                               accept="image/*"/>
                                        <label class="custom-file-label" for="fotoPerfil">
                                            Seleccionar imagen...
                                        </label>
                                    </div>
                                    <small class="form-text text-muted">
                                        Formatos permitidos: JPG, PNG, GIF (Máx. 10MB)
                                    </small>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-info btn-block">
                                        <i class="fas fa-upload mr-2"></i>Subir Foto
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Formulario de Información Personal -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user mr-2"></i>
                            Información Personal
                        </h3>
                    </div>

                    <form action="${pageContext.request.contextPath}/PerfilServlet" 
                          method="POST" 
                          id="formEditarPerfil">

                        <input type="hidden" name="accion" value="actualizar"/>

                        <div class="card-body">

                            <!-- Nombre Completo -->
                            <div class="form-group">
                                <label for="nombreCompleto">
                                    <i class="fas fa-user mr-1"></i>
                                    Nombre Completo <span class="text-danger">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control" 
                                       id="nombreCompleto" 
                                       name="nombreCompleto" 
                                       value="${usuarioPerfil.nombreCompleto}"
                                       required/>
                            </div>

                            <!-- DNI (Solo lectura) -->
                            <div class="form-group">
                                <label for="dni">
                                    <i class="fas fa-id-card mr-1"></i>
                                    DNI
                                </label>
                                <input type="text" 
                                       class="form-control" 
                                       id="dni" 
                                       value="${usuarioPerfil.dni}"
                                       readonly/>
                                <small class="form-text text-muted">
                                    El DNI no puede ser modificado
                                </small>
                            </div>

                            <!-- Email (Solo lectura) -->
                            <div class="form-group">
                                <label for="email">
                                    <i class="fas fa-envelope mr-1"></i>
                                    Correo Electrónico
                                </label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       value="${usuarioPerfil.email}"
                                       readonly/>
                                <small class="form-text text-muted">
                                    Para cambiar el email, contacta al administrador
                                </small>
                            </div>

                            <!-- Teléfono -->
                            <div class="form-group">
                                <label for="telefono">
                                    <i class="fas fa-phone mr-1"></i>
                                    Teléfono <span class="text-danger">*</span>
                                </label>
                                <input type="tel" 
                                       class="form-control" 
                                       id="telefono" 
                                       name="telefono" 
                                       value="${usuarioPerfil.telefono}"
                                       required/>
                            </div>

                            <!-- Dirección -->
                            <div class="form-group">
                                <label for="direccion">
                                    <i class="fas fa-map-marker-alt mr-1"></i>
                                    Dirección <span class="text-danger">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control" 
                                       id="direccion" 
                                       name="direccion" 
                                       value="${usuarioPerfil.direccion}"
                                       required/>
                            </div>

                            <!-- Biografía Personal -->
                            <div class="form-group">
                                <label for="biografia">
                                    <i class="fas fa-align-left mr-1"></i>
                                    Sobre Mí (Biografía Personal)
                                </label>
                                <textarea class="form-control" 
                                          id="biografia" 
                                          name="biografia" 
                                          rows="4"
                                          placeholder="Cuéntanos un poco sobre ti...">${usuarioPerfil.biografia}</textarea>
                                <small class="form-text text-muted">
                                    Describe tu experiencia, intereses o información relevante
                                </small>
                            </div>

                        </div>

                        <!-- Información Profesional (Solo para Profesionales - Roles 2 y 3) -->
                        <c:if test="${sessionScope.usuario.idRol == 2 || sessionScope.usuario.idRol == 3}">
                            <div class="card-header bg-primary">
                                <h3 class="card-title">
                                    <i class="fas fa-briefcase-medical mr-2"></i>
                                    Información Profesional
                                </h3>
                            </div>
                            <div class="card-body">

                                <!-- Años de Experiencia -->
                                <div class="form-group">
                                    <label for="aniosExperiencia">
                                        <i class="fas fa-award mr-1"></i>
                                        Años de Experiencia
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="aniosExperiencia" 
                                           name="aniosExperiencia" 
                                           min="0"
                                           max="50"
                                           value="${not empty profesional ? profesional.aniosExperiencia : 0}"/>
                                </div>

                                <!-- Biografía Profesional -->
                                <div class="form-group">
                                    <label for="biografiaProfesional">
                                        <i class="fas fa-file-alt mr-1"></i>
                                        Biografía Profesional
                                    </label>
                                    <textarea class="form-control" 
                                              id="biografiaProfesional" 
                                              name="biografiaProfesional" 
                                              rows="5"
                                              placeholder="Describe tu trayectoria profesional, especialidades, logros...">${not empty profesional ? profesional.biografiaProfesional : ''}</textarea>
                                    <small class="form-text text-muted">
                                        Esta información será visible para los pacientes
                                    </small>
                                </div>

                            </div>
                        </c:if>

                        <!-- Botones -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save mr-2"></i>
                                Guardar Cambios
                            </button>
                            <a href="${pageContext.request.contextPath}/PerfilServlet" 
                               class="btn btn-secondary btn-lg">
                                <i class="fas fa-times mr-2"></i>
                                Cancelar
                            </a>
                        </div>

                    </form>
                </div>

            </div>
        </div>

    </div>
</section>

<!-- Scripts -->
<script>
    (function () {
        if (typeof jQuery === 'undefined')
            return;

        $(document).ready(function () {
            // Actualizar label del input file
            $('#fotoPerfil').on('change', function () {
                var fileName = $(this).val().split('\\').pop();
                $(this).next('.custom-file-label').html(fileName);
            });

            // Validar formulario
            $('#formEditarPerfil').on('submit', function (e) {
                var nombre = $('#nombreCompleto').val().trim();
                var telefono = $('#telefono').val().trim();

                if (nombre.length < 3) {
                    e.preventDefault();
                    alert('⚠️ El nombre debe tener al menos 3 caracteres');
                    $('#nombreCompleto').focus();
                    return false;
                }

                if (telefono.length < 7) {
                    e.preventDefault();
                    alert('⚠️ Ingresa un teléfono válido');
                    $('#telefono').focus();
                    return false;
                }
            });
        });
    })();
</script>
