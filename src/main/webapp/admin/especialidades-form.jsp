<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${tituloFormulario != null ? tituloFormulario : 'Formulario de Especialidad'}" scope="request"/>
<c:set var="pageActive" value="especialidades" scope="request"/>
<c:set var="contentPage" value="/admin/especialidades-form-content.jsp" scope="request"/>

<jsp:include page="/componentes/layout.jsp"/>
