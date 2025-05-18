<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>LuxStay - Register</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    :root {
      --primary-color: #3498db;
      --secondary-color: #2980b9;
      --success-color: #2ecc71;
      --danger-color: #e74c3c;
      --warning-color: #f39c12;
      --light-color: #ecf0f1;
      --dark-color: #2c3e50;
      --gray-color: #95a5a6;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f7fa;
      color: #333;
      line-height: 1.6;
      padding: 0;
    }

    .container {
      max-width: 500px;
      margin: 50px auto;
      background: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }

    .page-header {
      text-align: center;
      margin-bottom: 30px;
    }

    .page-header h1 {
      color: var(--dark-color);
      font-size: 2rem;
      margin-bottom: 10px;
    }

    .page-header p {
      color: var(--gray-color);
      margin-bottom: 20px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      color: var(--dark-color);
      font-weight: 500;
    }

    input[type="text"], input[type="email"], input[type="password"], input[type="tel"] {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 1rem;
      transition: border 0.3s;
    }

    input:focus {
      border-color: var(--primary-color);
      outline: none;
    }

    .btn {
      background-color: var(--primary-color);
      color: white;
      padding: 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      width: 100%;
      font-weight: 500;
      transition: background-color 0.3s;
    }

    .btn:hover {
      background-color: var(--secondary-color);
    }

    .link {
      text-align: center;
      margin-top: 20px;
      color: var(--gray-color);
    }

    .link a {
      color: var(--primary-color);
      text-decoration: none;
      transition: color 0.3s;
    }

    .link a:hover {
      color: var(--secondary-color);
    }
  </style>
</head>
<body>
<div class="container">
  <div class="page-header">
    <h1>Create Your Account</h1>
    <p>Join LuxStay to book your perfect stay</p>
  </div>



  <form action="RegisterServlet" method="post">
    <div class="form-group">
      <label for="firstName">First Name:</label>
      <input type="text" id="firstName" name="firstName" required>
    </div>

    <div class="form-group">
      <label for="lastName">Last Name:</label>
      <input type="text" id="lastName" name="lastName" required>
    </div>

    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required>
    </div>

    <div class="form-group">
      <label for="phone">Phone Number:</label>
      <input type="tel" id="phone" name="phone" required>
    </div>

    <div class="form-group">
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>
    </div>

    <div class="form-group">
      <button type="submit" class="btn">Register</button>
    </div>
  </form>

  <div class="link">
    <p>Already have an account? <a href="login.jsp">Login here</a></p>
  </div>
</div>
</body>
</html>