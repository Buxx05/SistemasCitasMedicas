<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${tituloFormulario != null ? tituloFormulario : 'Formulario de Profesional'}" scope="request" />
<c:set var="pageActive" value="profesionales" scope="request"/>
<c:set var="contentPage" value="/admin/profesionales-form-content.jsp" scope="request" />

<jsp:include page="/componentes/layout.jsp" />
