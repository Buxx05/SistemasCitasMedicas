<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${empty receta ? 'Nueva Receta Médica' : 'Editar Receta Médica'}" scope="request"/>
<c:set var="pageActive" value="recetas" scope="request"/>
<c:set var="contentPage" value="/profesional/receta-form-content.jsp" scope="request"/>

<jsp:include page="/componentes/layout.jsp"/>
