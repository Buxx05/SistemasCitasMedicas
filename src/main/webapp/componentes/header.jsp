<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" data-widget="pushmenu" href="#" role="button">
                <i class="fas fa-bars"></i>
            </a>
        </li>
        <li class="nav-item d-none d-sm-inline-block">
            <a href="${pageContext.request.contextPath}/DashboardAdminServlet" class="nav-link">Inicio</a>
        </li>
    </ul>

    <ul class="navbar-nav ml-auto">
        <!-- Notificaciones -->
        <li class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-bell"></i>
                <span class="badge badge-warning navbar-badge">${notificaciones != null ? notificaciones : 0}</span>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                <span class="dropdown-item dropdown-header">
                    ${notificaciones != null ? notificaciones : 0} Notificaciones
                </span>
                <div class="dropdown-divider"></div>
                <a href="#" class="dropdown-item">
                    <i class="fas fa-calendar mr-2"></i> Nueva cita pendiente
                    <span class="float-right text-muted text-sm">5 min</span>
                </a>
                <div class="dropdown-divider"></div>
                <a href="#" class="dropdown-item dropdown-footer">Ver todas las notificaciones</a>
            </div>
        </li>

        <!-- Usuario -->
        <li class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user-circle"></i>
                <span class="d-none d-md-inline ml-2">${sessionScope.usuario.nombreCompleto}</span>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                <div class="dropdown-item dropdown-header bg-primary text-white">
                    <i class="far fa-user-circle fa-3x mb-2"></i>
                    <p class="mb-0">${sessionScope.usuario.nombreCompleto}</p>
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
                <a href="${pageContext.request.contextPath}/PerfilServlet" class="dropdown-item">
                    <i class="fas fa-user mr-2"></i> Mi Perfil
                </a>
                <div class="dropdown-divider"></div>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="dropdown-item">
                    <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
                </a>
            </div>
        </li>
    </ul>
</nav>