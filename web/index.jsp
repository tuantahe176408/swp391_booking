<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect root request to /home controller
    response.sendRedirect(request.getContextPath() + "/home");
%>
