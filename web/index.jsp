<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Forward root/default entry request directly to /home controller
    request.getRequestDispatcher("/home").forward(request, response);
%>
