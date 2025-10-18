<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String mensaje = (String) request.getAttribute("mensaje");
    String tipoMensaje = (String) request.getAttribute("tipoMensaje");
    
    String errorSession = (String) session.getAttribute("error");
    String mensajeSession = (String) session.getAttribute("mensaje");
    String tipoMensajeSession = (String) session.getAttribute("tipoMensaje");
    
    if (error != null && !error.isEmpty()) {
%>
<div class="alert alert-danger alert-dismissible fade show auto-dismiss" role="alert">
    <i class="fas fa-exclamation-triangle mr-2"></i><%= error %>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<%
    }
    
    if (errorSession != null && !errorSession.isEmpty()) {
%>
<div class="alert alert-danger alert-dismissible fade show auto-dismiss" role="alert">
    <i class="fas fa-exclamation-triangle mr-2"></i><%= errorSession %>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<%
        session.removeAttribute("error");
    }
    
    if (mensaje != null && !mensaje.isEmpty()) {
        String tipo = tipoMensaje != null ? tipoMensaje : "info";
        String icono = "info-circle";
        
        switch (tipo) {
            case "success":
                icono = "check-circle";
                break;
            case "warning":
                icono = "exclamation-circle";
                break;
            case "danger":
                icono = "times-circle";
                break;
        }
%>
<div class="alert alert-<%= tipo %> alert-dismissible fade show auto-dismiss" role="alert">
    <i class="fas fa-<%= icono %> mr-2"></i><%= mensaje %>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<%
    }
    
    if (mensajeSession != null && !mensajeSession.isEmpty()) {
        String tipo = tipoMensajeSession != null ? tipoMensajeSession : "info";
        String icono = "info-circle";
        
        switch (tipo) {
            case "success":
                icono = "check-circle";
                break;
            case "warning":
                icono = "exclamation-circle";
                break;
            case "danger":
                icono = "times-circle";
                break;
        }
%>
<div class="alert alert-<%= tipo %> alert-dismissible fade show auto-dismiss" role="alert">
    <i class="fas fa-<%= icono %> mr-2"></i><%= mensajeSession %>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<%
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }
%>

<!-- Script para auto-cerrar alertas después de 3 segundos -->
<script>
    $(document).ready(function() {
        // Esperar 3 segundos (3000 milisegundos) y luego cerrar las alertas con la clase 'auto-dismiss'
        setTimeout(function() {
            $('.auto-dismiss').fadeOut('slow', function() {
                $(this).alert('close');
            });
        }, 3000);
    });
</script>
