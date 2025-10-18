<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${pageTitle != null ? pageTitle : 'Sistema de Citas Médicas'}</title>

        <!-- Google Font: Source Sans Pro -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <!-- AdminLTE 3 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css" rel="stylesheet"/>

        <!-- ✅ MOVER JQUERY AQUÍ -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- CSS Personalizado (descomenta si existe) -->
        <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css"> -->
    </head>
    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">

            <!-- Header/Navbar -->
            <jsp:include page="/componentes/header.jsp"/>

            <!-- Sidebar -->
            <jsp:include page="/componentes/sidebar.jsp"/>

            <!-- Content Wrapper -->
            <div class="content-wrapper">

                <!-- Alertas (mensajes de error, éxito, etc.) -->
                <jsp:include page="/componentes/alert.jsp"/>

                <!-- Contenido dinámico de la página -->
                <c:if test="${contentPage != null}">
                    <jsp:include page="${contentPage}"/>
                </c:if>

                <!-- Mensaje por defecto si no hay contenido -->
                <c:if test="${contentPage == null}">
                    <section class="content">
                        <div class="container-fluid">
                            <div class="alert alert-warning mt-3">
                                <i class="fas fa-exclamation-triangle mr-2"></i>
                                No se ha definido el contenido de la página.
                            </div>
                        </div>
                    </section>
                </c:if>

            </div>

            <!-- Footer -->
            <jsp:include page="/componentes/footer.jsp"/>

        </div>

        <!-- ❌ ELIMINAR jQuery de aquí (ya está en el head) -->

        <!-- Bootstrap 4 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- AdminLTE 3 -->
        <script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

    </body>
</html>
