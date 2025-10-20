<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ========================================== -->
<!-- ALERTAS CON SWEETALERT2                   -->
<!-- ========================================== -->
<script>
    $(document).ready(function () {
        // Detectar mensajes de éxito
    <c:if test="${not empty sessionScope.success}">
        Swal.fire({
            icon: 'success',
            title: '¡Éxito!',
            text: '${sessionScope.success}',
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end'
        });
        <c:remove var="success" scope="session"/>
    </c:if>

        // Detectar mensajes de error
    <c:if test="${not empty sessionScope.error}">
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '${sessionScope.error}',
            confirmButtonText: 'Entendido',
            confirmButtonColor: '#dc3545'
        });
        <c:remove var="error" scope="session"/>
    </c:if>

        // Detectar mensajes informativos
    <c:if test="${not empty sessionScope.info}">
        Swal.fire({
            icon: 'info',
            title: 'Información',
            text: '${sessionScope.info}',
            confirmButtonText: 'OK',
            confirmButtonColor: '#17a2b8'
        });
        <c:remove var="info" scope="session"/>
    </c:if>

        // Detectar advertencias
    <c:if test="${not empty sessionScope.warning}">
        Swal.fire({
            icon: 'warning',
            title: 'Advertencia',
            text: '${sessionScope.warning}',
            confirmButtonText: 'Entendido',
            confirmButtonColor: '#ffc107'
        });
        <c:remove var="warning" scope="session"/>
    </c:if>
    });
</script>
