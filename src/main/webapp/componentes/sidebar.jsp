<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

    <!-- Brand Logo -->
    <a href="${pageContext.request.contextPath}/${sessionScope.usuario.idRol == 1 ? 'DashboardAdminServlet' : 'DashboardProfesionalServlet'}" 
       class="brand-link">
        <i class="fas fa-hospital brand-image ml-3" style="font-size: 2rem;"></i>
        <span class="brand-text font-weight-light">Sistema Citas</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">

        <!-- User Panel -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <!-- ✅ Foto de perfil dinámica -->
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                        <img src="${pageContext.request.contextPath}/uploads/perfiles/${sessionScope.usuario.fotoPerfil}" 
                             class="img-circle elevation-2" 
                             alt="Foto de perfil"
                             style="width: 2.1rem; height: 2.1rem; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <i class="far fa-user-circle fa-2x text-white"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="info">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <a href="${pageContext.request.contextPath}/PerfilServlet" class="d-block">
                            ${sessionScope.usuario.nombreCompleto}
                        </a>
                        <small class="text-muted d-block">
                            <i class="fas fa-circle text-success" style="font-size: 0.5rem;"></i>
                            <c:choose>
                                <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                                <c:when test="${sessionScope.usuario.idRol == 2}">Profesional Médico</c:when>
                                <c:when test="${sessionScope.usuario.idRol == 3}">Profesional No Médico</c:when>
                            </c:choose>
                        </small>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="d-block">
                            Ingresar
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" 
                data-widget="treeview" role="menu" data-accordion="false">

                <!-- ========== MENÚ ADMINISTRADOR ========== -->
                <c:if test="${sessionScope.usuario.idRol == 1}">
                    <li class="nav-header">ADMINISTRACIÓN</li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/DashboardAdminServlet" 
                           class="nav-link ${pageActive == 'dashboard' ? 'active' : ''}">
                            <i class="nav-icon fas fa-tachometer-alt"></i>
                            <p>Dashboard</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/UsuarioServlet" 
                           class="nav-link ${pageActive == 'usuarios' ? 'active' : ''}">
                            <i class="nav-icon fas fa-users"></i>
                            <p>Usuarios</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ProfesionalServlet" 
                           class="nav-link ${pageActive == 'profesionales' ? 'active' : ''}">
                            <i class="nav-icon fas fa-user-md"></i>
                            <p>Profesionales</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/PacienteServlet" 
                           class="nav-link ${pageActive == 'pacientes' ? 'active' : ''}">
                            <i class="nav-icon fas fa-user-injured"></i>
                            <p>Pacientes</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CitaServlet" 
                           class="nav-link ${pageActive == 'citas' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Citas</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/EspecialidadServlet" 
                           class="nav-link ${pageActive == 'especialidades' ? 'active' : ''}">
                            <i class="nav-icon fas fa-briefcase-medical"></i>
                            <p>Especialidades</p>
                        </a>
                    </li>
                </c:if>

                <!-- ========== MENÚ PROFESIONAL MÉDICO ========== -->
                <c:if test="${sessionScope.usuario.idRol == 2}">
                    <li class="nav-header">PANEL MÉDICO</li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet" 
                           class="nav-link ${pageActive == 'dashboard' ? 'active' : ''}">
                            <i class="nav-icon fas fa-tachometer-alt"></i>
                            <p>Dashboard</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                           class="nav-link ${pageActive == 'citas' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Mis Citas</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                           class="nav-link ${pageActive == 'pacientes' ? 'active' : ''}">
                            <i class="nav-icon fas fa-users"></i>
                            <p>Mis Pacientes</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                           class="nav-link ${pageActive == 'recetas' ? 'active' : ''}">
                            <i class="nav-icon fas fa-prescription"></i>
                            <p>Recetas</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                           class="nav-link ${pageActive == 'horarios' ? 'active' : ''}">
                            <i class="nav-icon fas fa-clock"></i>
                            <p>Mis Horarios</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CalendarioServlet" 
                           class="nav-link ${pageActive == 'calendario' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Calendario</p>
                        </a>
                    </li>

                </c:if>

                <!-- ========== MENÚ PROFESIONAL NO MÉDICO ========== -->
                <c:if test="${sessionScope.usuario.idRol == 3}">
                    <li class="nav-header">PANEL PROFESIONAL</li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/DashboardProfesionalServlet" 
                           class="nav-link ${pageActive == 'dashboard' ? 'active' : ''}">
                            <i class="nav-icon fas fa-tachometer-alt"></i>
                            <p>Dashboard</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CitaProfesionalServlet" 
                           class="nav-link ${pageActive == 'citas' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Mis Citas</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/PacienteProfesionalServlet" 
                           class="nav-link ${pageActive == 'pacientes' ? 'active' : ''}">
                            <i class="nav-icon fas fa-users"></i>
                            <p>Mis Pacientes</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/RecetaMedicaServlet" 
                           class="nav-link ${pageActive == 'recetas' ? 'active' : ''}">
                            <i class="nav-icon fas fa-prescription"></i>
                            <p>Recetas</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/HorarioProfesionalServlet" 
                           class="nav-link ${pageActive == 'horarios' ? 'active' : ''}">
                            <i class="nav-icon fas fa-clock"></i>
                            <p>Mis Horarios</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CalendarioServlet" 
                           class="nav-link ${pageActive == 'calendario' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Calendario</p>
                        </a>
                    </li>
                </c:if>

                <!-- ========== MI CUENTA (COMÚN PARA TODOS) ========== -->
                <li class="nav-header">MI CUENTA</li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/PerfilServlet" 
                       class="nav-link ${pageActive == 'perfil' ? 'active' : ''}">
                        <i class="nav-icon fas fa-user-circle"></i>
                        <p>Mi Perfil</p>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link">
                        <i class="nav-icon fas fa-sign-out-alt text-danger"></i>
                        <p>Cerrar Sesión</p>
                    </a>
                </li>

            </ul>
        </nav>
    </div>
</aside>
