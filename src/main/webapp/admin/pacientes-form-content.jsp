<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">${tituloFormulario}</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/DashboardAdminServlet">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/PacienteServlet">Pacientes</a></li>
                    <li class="breadcrumb-item active">${tituloFormulario}</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main content -->
<section class="content">
    <div class="container-fluid">

        <!-- Alertas -->
        <jsp:include page="/componentes/alert.jsp"/>

        <div class="row">
            <div class="col-md-10 offset-md-1">

                <!-- Card del formulario -->
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-hospital-user mr-2"></i>
                            ${tituloFormulario}
                        </h3>
                    </div>

                    <!-- Formulario -->
                    <form action="${pageContext.request.contextPath}/PacienteServlet" 
                          method="post" 
                          id="pacienteForm">

                        <!-- Campo oculto para la acción -->
                        <input type="hidden" name="accion" value="${accion}">

                        <!-- Campo oculto para el ID (solo en modo editar) -->
                        <c:if test="${accion == 'actualizar'}">
                            <input type="hidden" name="idPaciente" value="${paciente.idPaciente}">
                        </c:if>

                        <div class="card-body">

                            <!-- ========== SECCIÓN: DATOS PERSONALES ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-user mr-2"></i>
                                Datos Personales
                            </h5>

                            <div class="row">
                                <!-- Nombre Completo -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="nombreCompleto">
                                            Nombre Completo <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user"></i>
                                                </span>
                                            </div>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="nombreCompleto" 
                                                   name="nombreCompleto" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.nombreCompleto : ''}" 
                                                   placeholder="Ingrese el nombre completo"
                                                   required>
                                        </div>
                                    </div>
                                </div>

                                <!-- DNI -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="dni">
                                            DNI <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-id-card"></i>
                                                </span>
                                            </div>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="dni" 
                                                   name="dni" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.dni : ''}" 
                                                   placeholder="Ej: 12345678"
                                                   maxlength="20"
                                                   required>
                                        </div>
                                        <small class="form-text text-muted">
                                            Documento único de identidad
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Fecha de Nacimiento -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="fechaNacimiento">
                                            Fecha de Nacimiento
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="far fa-calendar"></i>
                                                </span>
                                            </div>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaNacimiento" 
                                                   name="fechaNacimiento" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.fechaNacimiento : ''}">
                                        </div>
                                    </div>
                                </div>

                                <!-- Género -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="genero">
                                            Género <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-venus-mars"></i>
                                                </span>
                                            </div>
                                            <select class="form-control" id="genero" name="genero" required>
                                                <option value="">Seleccione</option>
                                                <option value="M" ${accion == 'actualizar' && paciente != null && paciente.genero == 'M' ? 'selected' : ''}>
                                                    Masculino
                                                </option>
                                                <option value="F" ${accion == 'actualizar' && paciente != null && paciente.genero == 'F' ? 'selected' : ''}>
                                                    Femenino
                                                </option>
                                                <option value="Otro" ${accion == 'actualizar' && paciente != null && paciente.genero == 'Otro' ? 'selected' : ''}>
                                                    Otro
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Teléfono -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="telefono">
                                            Teléfono
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone"></i>
                                                </span>
                                            </div>
                                            <input type="tel" 
                                                   class="form-control" 
                                                   id="telefono" 
                                                   name="telefono" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.telefono : ''}" 
                                                   placeholder="Ej: +51 999 888 777">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- ========== SECCIÓN: INFORMACIÓN DE CONTACTO ========== -->
                            <h5 class="mb-3">
                                <i class="fas fa-address-book mr-2"></i>
                                Información de Contacto
                            </h5>

                            <div class="row">
                                <!-- Email -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">
                                            Email
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-envelope"></i>
                                                </span>
                                            </div>
                                            <input type="email" 
                                                   class="form-control" 
                                                   id="email" 
                                                   name="email" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.email : ''}" 
                                                   placeholder="correo@ejemplo.com">
                                        </div>
                                    </div>
                                </div>

                                <!-- Dirección -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="direccion">
                                            Dirección
                                        </label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                </span>
                                            </div>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="direccion" 
                                                   name="direccion" 
                                                   value="${accion == 'actualizar' && paciente != null ? paciente.direccion : ''}" 
                                                   placeholder="Calle, número, distrito, ciudad">
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Botones del formulario -->
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-2"></i>
                                ${accion == 'crear' ? 'Registrar Paciente' : 'Guardar Cambios'}
                            </button>
                            <a href="${pageContext.request.contextPath}/PacienteServlet" 
                               class="btn btn-secondary">
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

<!-- Script de validación -->
<script>
    $(document).ready(function () {
        // Validación del formulario
        $('#pacienteForm').submit(function (e) {
            const dni = $('#dni').val().trim();

            // Validar DNI (mínimo 8 caracteres)
            if (dni.length < 8) {
                e.preventDefault();
                alert('El DNI debe tener al menos 8 caracteres');
                $('#dni').focus();
                return false;
            }

            // Validar que el DNI solo contenga números
            if (!/^\d+$/.test(dni)) {
                e.preventDefault();
                alert('El DNI solo debe contener números');
                $('#dni').focus();
                return false;
            }
        });

        // Formatear teléfono automáticamente (opcional)
        $('#telefono').on('input', function () {
            let value = $(this).val().replace(/\D/g, ''); // Solo números
            if (value.length > 9) {
                value = value.substring(0, 9);
            }
            $(this).val(value);
        });
    });
</script>
