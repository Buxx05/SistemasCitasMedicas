<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${tituloFormulario != null ? tituloFormulario : 'Formulario de Usuario'}" scope="request"/>
<c:set var="pageActive" value="usuarios" scope="request"/>
<c:set var="contentPage" value="/admin/usuarios-form-content.jsp" scope="request"/>

<jsp:include page="/componentes/layout.jsp"/>
