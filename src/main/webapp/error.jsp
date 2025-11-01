<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - Time Keeper</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            color: white;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
        }
        
        .error-container {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 3rem;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            width: 90%;
        }
        
        .error-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        
        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .error-message {
            background-color: rgba(255, 82, 82, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin: 1.5rem 0;
            border-left: 4px solid #ff5252;
            text-align: left;
            word-wrap: break-word;
        }
        
        .error-details {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-top: 0.5rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 1rem;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #45a049;
        }
        
        .btn-secondary {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 2rem;
                margin: 1rem;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1>Oops! Something Went Wrong</h1>
        
        <%
            // Handle different error scenarios
            String errorMessage = (String) request.getAttribute("errorMessage");
            Exception servletException = (Exception) request.getAttribute("javax.servlet.error.exception");
            Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
            
            if (errorMessage != null) {
        %>
            <div class="error-message">
                <strong>Error:</strong> <%= errorMessage %>
            </div>
        <%
            } else if (servletException != null) {
        %>
            <div class="error-message">
                <strong>Exception:</strong> <%= servletException.getMessage() %>
                <%
                    if (statusCode != null && statusCode != 0) {
                %>
                    <div class="error-details">
                        Status Code: <%= statusCode %><br>
                        <% if (requestUri != null) { %>
                        Request URI: <%= requestUri %>
                        <% } %>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            } else {
                // Check if there's a pageContext exception (for JSP errors)
                Exception pageException = pageContext.getException();
                if (pageException != null) {
        %>
            <div class="error-message">
                <strong>JSP Error:</strong> <%= pageException.getMessage() %>
            </div>
        <%
                } else {
        %>
            <div class="error-message">
                <strong>Error:</strong> An unexpected error has occurred.
                <%
                    String paramMessage = request.getParameter("message");
                    if (paramMessage != null && !paramMessage.trim().isEmpty()) {
                %>
                    <div class="error-details">
                        <%= paramMessage %>
                    </div>
                <%
                    }
                %>
            </div>
        <%
                }
            }
        %>
        
        <p>We apologize for the inconvenience. Please try again or contact support if the problem persists.</p>
        
        <div class="action-buttons">
            <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>
            <a href="dashboard" class="btn btn-primary">🏠 Dashboard</a>
            <a href="login.jsp" class="btn btn-secondary">🔐 Login</a>
        </div>
        
        <%
            if (statusCode != null && statusCode == 404) {
        %>
            <div style="margin-top: 2rem; padding: 1rem; background-color: rgba(255, 255, 255, 0.1); border-radius: 8px;">
                <h3>Page Not Found</h3>
                <p>The page you are looking for doesn't exist or has been moved.</p>
            </div>
        <%
            }
        %>
        
      
        <%
            
            Throwable debugException = null;
            if (servletException != null) {
                debugException = servletException;
            } else if (pageContext.getException() != null) {
                debugException = pageContext.getException();
            }
            
            if (debugException != null) {
                String serverInfo = application.getServerInfo();
                if (serverInfo != null && serverInfo.toLowerCase().contains("development")) {
        %>
            <details style="margin-top: 2rem; text-align: left; cursor: pointer;">
                <summary>Technical Details (Development Only)</summary>
                <div style="background-color: rgba(0, 0, 0, 0.3); padding: 1rem; border-radius: 4px; margin-top: 0.5rem; font-family: monospace; font-size: 0.8rem; overflow-x: auto;">
                    <pre><%
                        java.io.StringWriter sw = new java.io.StringWriter();
                        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                        debugException.printStackTrace(pw);
                        out.print(sw.toString());
                    %></pre>
                </div>
            </details>
        <%
                }
            }
        %>
    </div>

    <script>
    
        <%
            if (servletException != null) {
        %>
            console.error('Application Error:', '<%= servletException.getMessage() %>');
        <%
            } else if (pageContext.getException() != null) {
        %>
            console.error('JSP Error:', '<%= pageContext.getException().getMessage() %>');
        <%
            }
        %>
        
       
        setTimeout(() => {
            window.location.href = 'dashboard';
        }, 10000);
    </script>
</body>
</html>
