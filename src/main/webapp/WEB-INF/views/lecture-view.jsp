<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>View Lecture</title>
        <style>
            .video-container {
                width: 80%;
                margin: 20px auto;
                aspect-ratio: 16 / 9;
            }
            .video-container iframe {
                width: 100%;
                height: 100%;
                border: none;
            }
        </style>
    </head>
    <body>
        <h1>Your lesson is here</h1>
        
        <% 
            String embedUrl = (String) request.getAttribute("videoEmbedUrl");
            String errorMsg = (String) request.getAttribute("error");
        %>
        
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <p style="color: red; font-weight: bold;">LỖI: <%= errorMsg %></p>
        <% } else if (embedUrl != null) { %>
            
            <h3>Video</h3>
            <div class="video-container">
                <iframe src="<%= embedUrl %>" 
                        allowfullscreen 
                        sandbox="allow-scripts allow-same-origin allow-presentation">
                </iframe>
            </div>
            
        <% } else { %>
            <p>Video not found</p>
        <% } %>
        
    </body>
</html>