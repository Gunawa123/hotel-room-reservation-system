<%@ page import="modal.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%

    User user = (User) session.getAttribute("USER");
    if (user != null) {
    response.sendRedirect("RoomList.jsp");
    return;
  }

%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LuxStay Hotels</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    :root {
      --primary: #2563eb;
      --accent: #f59e0b;
      --dark: #1e293b;
      --light: #f8fafc;
      --gray: #64748b;
      --radius: 8px;
      --shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    body {
      font-family: 'Inter', sans-serif;
      margin: 0;
      background: var(--light);
    }

    .header {
      background: var(--dark);
      color: white;
      padding: 1rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .logo {
      font-weight: bold;
      font-size: 1.5rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .welcome-section {
      text-align: center;
      margin: 3rem 0;
    }

    .welcome-section h1 {
      font-size: 2.5rem;
      color: var(--dark);
      margin-bottom: 1rem;
    }

    .welcome-section p {
      font-size: 1.2rem;
      color: var(--gray);
      max-width: 600px;
      margin: 0 auto 2rem;
    }

    .container {
      max-width: 1200px;
      margin: 2rem auto;
      padding: 0 1rem;
    }

    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 1.5rem;
      max-width: 700px;
      margin: 0 auto;
    }

    .card {
      background: white;
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: var(--shadow);
      transition: transform 0.3s;
      text-align: center;
      padding: 2rem;
    }

    .card:hover {
      transform: translateY(-5px);
    }

    .card-icon {
      font-size: 3rem;
      color: var(--primary);
      margin-bottom: 1rem;
    }

    .card-content h3 {
      margin: 0 0 1rem 0;
      font-size: 1.5rem;
    }

    .card-content p {
      color: var(--gray);
      margin-bottom: 1.5rem;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1.5rem;
      background: var(--primary);
      color: white;
      text-decoration: none;
      border-radius: var(--radius);
      font-weight: 500;
      font-size: 1rem;
      transition: background 0.3s;
    }

    .btn:hover {
      background: #1d4ed8;
    }

    .btn-secondary {
      background: var(--dark);
    }

    .btn-secondary:hover {
      background: #0f172a;
    }

    @media (max-width: 768px) {
      .header {
        flex-direction: column;
        gap: 1rem;
      }
      .welcome-section h1 {
        font-size: 2rem;
      }
    }
  </style>
</head>
<body>

<div class="welcome-section">
  <h1>Welcome to LuxStay Hotels</h1>
  <p>Experience luxury and comfort with our premium accommodations. Sign in to book your stay or create an account to get started.</p>
</div>

<div class="container">
  <div class="card-grid">
    <div class="card">
      <div class="card-icon">
        <i class="fas fa-sign-in-alt"></i>
      </div>
      <div class="card-content">
        <h3>Existing User</h3>
        <p>Sign in to your account to manage bookings and access exclusive offers.</p>
        <a href="login.jsp" class="btn">
          <i class="fas fa-sign-in-alt"></i> Login
        </a>
      </div>
    </div>

    <div class="card">
      <div class="card-icon">
        <i class="fas fa-user-plus"></i>
      </div>
      <div class="card-content">
        <h3>New User</h3>
        <p>Create an account to enjoy seamless booking and personalized services.</p>
        <a href="Register.jsp" class="btn btn-secondary">
          <i class="fas fa-user-plus"></i> Register
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>