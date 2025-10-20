<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="description" content="Sistema de Gestión de Citas Médicas">
        <title>${pageTitle != null ? pageTitle : 'Sistema de Citas Médicas'}</title>

        <!-- Favicon -->
        <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🏥</text></svg>">

        <!-- Google Font: Source Sans Pro -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <!-- AdminLTE 3 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap4.min.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.5.2/dist/select2-bootstrap4.min.css" rel="stylesheet"/>

        <!-- SweetAlert2 (opcional) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

        <!-- ✅ jQuery PRIMERO -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- CSS Personalizado -->
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

                <!-- Contenido dinámico de la página -->
                <c:choose>
                    <c:when test="${contentPage != null}">
                        <jsp:include page="${contentPage}"/>
                    </c:when>
                    <c:otherwise>
                        <!-- Mensaje por defecto si no hay contenido -->
                        <section class="content">
                            <div class="container-fluid">
                                <div class="alert alert-warning mt-3">
                                    <i class="fas fa-exclamation-triangle mr-2"></i>
                                    <strong>Advertencia:</strong> No se ha definido el contenido de la página.
                                </div>
                            </div>
                        </section>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- Footer -->
            <jsp:include page="/componentes/footer.jsp"/>

        </div>

        <!-- ========== SCRIPTS ========== -->

        <!-- Bootstrap 4 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- DataTables JS -->
        <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap4.min.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <!-- SweetAlert2 JS (opcional) -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- AdminLTE 3 -->
        <script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

        <!-- Inicialización Global de Select2 (opcional) -->
        <script>
            $(document).ready(function () {
                // Inicializar Select2 automáticamente en todos los selects con clase .select2
                $('.select2').select2({
                    theme: 'bootstrap4',
                    width: '100%'
                });
            });
        </script>

    </body>
</html>