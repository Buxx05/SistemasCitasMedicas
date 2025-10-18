<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${empty historial ? 'Nueva Entrada' : 'Editar Entrada'}" scope="request"/>
<c:set var="pageActive" value="pacientes" scope="request"/>
<c:set var="contentPage" value="/profesional/historial-form-content.jsp" scope="request"/>

<jsp:include page="/componentes/layout.jsp"/>
