<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>CSS Test Page</title>
    <!-- Include the CSS to test if it loads -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/login.css"
    />
  </head>
  <body>
    <h1>CSS Test Page</h1>
    <p>Context Path: ${pageContext.request.contextPath}</p>
    <p>
      Login CSS Path: ${pageContext.request.contextPath}/assets/css/login.css
    </p>
    <div style="padding: 20px; border: 1px solid black; margin: 20px">
      <p>This should have styling from login.css if it loads correctly:</p>
      <div class="form-box">
        <div class="login-container">
          <header>Welcome</header>
        </div>
      </div>
    </div>
  </body>
</html>
