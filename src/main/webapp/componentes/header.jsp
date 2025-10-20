<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
        <!-- Toggle Sidebar -->
        <li class="nav-item">
            <a class="nav-link" data-widget="pushmenu" href="#" role="button" aria-label="Toggle navigation">
                <i class="fas fa-bars"></i>
            </a>
        </li>

        <!-- ✅ Link Dinámico a Dashboard -->
        <li class="nav-item d-none d-sm-inline-block">
            <a href="${pageContext.request.contextPath}/${sessionScope.usuario.idRol == 1 ? 'DashboardAdminServlet' : 'DashboardProfesionalServlet'}" 
               class="nav-link">
                <i class="fas fa-home mr-1"></i>Inicio
            </a>
        </li>
    </ul>

    <ul class="navbar-nav ml-auto">

        <!-- ========== NOTIFICACIONES ========== -->
        <li class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#" aria-label="Notificaciones">
                <i class="far fa-bell"></i>
                <!-- ✅ Solo mostrar badge si hay notificaciones -->
                <c:if test="${notificaciones != null && notificaciones > 0}">
                    <span class="badge badge-warning navbar-badge">${notificaciones}</span>
                </c:if>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                <span class="dropdown-item dropdown-header">
                    ${notificaciones != null && notificaciones > 0 ? notificaciones : 'Sin'} Notificaciones
                </span>
                <div class="dropdown-divider"></div>

                <!-- ✅ Mensaje cuando no hay notificaciones -->
                <c:choose>
                    <c:when test="${notificaciones != null && notificaciones > 0}">
                        <a href="#" class="dropdown-item">
                            <i class="fas fa-calendar mr-2"></i> Nueva cita pendiente
                            <span class="float-right text-muted text-sm">5 min</span>
                        </a>
                        <div class="dropdown-divider"></div>
                        <a href="#" class="dropdown-item dropdown-footer">Ver todas las notificaciones</a>
                    </c:when>
                    <c:otherwise>
                        <span class="dropdown-item text-muted text-center">
                            <i class="fas fa-check-circle mr-2"></i>No hay notificaciones nuevas
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </li>

        <!-- ========== USUARIO ========== -->
        <li class="nav-item dropdown">
            <a class="nav-link d-flex align-items-center" data-toggle="dropdown" href="#" aria-label="Menú de usuario">
                <!-- ✅ Foto de perfil dinámica -->
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                        <img src="${pageContext.request.contextPath}/uploads/perfiles/${sessionScope.usuario.fotoPerfil}" 
                             class="img-circle elevation-2" 
                             alt="Foto de perfil"
                             style="width: 25px; height: 25px; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <i class="far fa-user-circle"></i>
                    </c:otherwise>
                </c:choose>
                <span class="d-none d-md-inline ml-2">${sessionScope.usuario.nombreCompleto}</span>
                <i class="fas fa-caret-down ml-2 d-none d-md-inline"></i>
            </a>

            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                <!-- Header con foto y rol -->
                <div class="dropdown-item dropdown-header bg-primary text-white">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/uploads/perfiles/${sessionScope.usuario.fotoPerfil}" 
                                 class="img-circle elevation-2 mb-2" 
                                 alt="Foto de perfil"
                                 style="width: 80px; height: 80px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <i class="far fa-user-circle fa-3x mb-2"></i>
                        </c:otherwise>
                    </c:choose>
                    <p class="mb-0 font-weight-bold">${sessionScope.usuario.nombreCompleto}</p>
                    <small>
                        <c:choose>
                            <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                            <c:when test="${sessionScope.usuario.idRol == 2}">Profesional Médico</c:when>
                            <c:when test="${sessionScope.usuario.idRol == 3}">Profesional No Médico</c:when>
                            <c:otherwise>Usuario</c:otherwise>
                        </c:choose>
                    </small>
                </div>

                <div class="dropdown-divider"></div>

                <!-- Mi Perfil -->
                <a href="${pageContext.request.contextPath}/PerfilServlet" class="dropdown-item">
                    <i class="fas fa-user mr-2 text-primary"></i> Mi Perfil
                </a>

                <div class="dropdown-divider"></div>

                <!-- Cerrar Sesión -->
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="dropdown-item text-danger">
                    <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
                </a>
            </div>
        </li>

        <!-- Botón Fullscreen (opcional) -->
        <li class="nav-item">
            <a class="nav-link" data-widget="fullscreen" href="#" role="button" aria-label="Pantalla completa">
                <i class="fas fa-expand-arrows-alt"></i>
            </a>
        </li>
    </ul>
</nav>
