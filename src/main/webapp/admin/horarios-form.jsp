<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${tituloFormulario != null ? tituloFormulario : 'Formulario de Horario'}" scope="request"/>
<c:set var="pageActive" value="citas" scope="request"/>
<c:set var="contentPage" value="/profesional/horarios-form-content.jsp" scope="request"/>

<jsp:include page="/componentes/layout.jsp"/>
