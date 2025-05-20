<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modal.Service" %>
<%@ page import="modal.ServiceRequest" %>
<%@ page import="utils.ServiceRequestHandle" %>
<%@ page import="utils.ServiceHandle" %>
<%@ page import="modal.User" %>

<%
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String serviceId = request.getParameter("serviceId");
    Service service = ServiceHandle.findServiceById(serviceId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Service Payment Details</title>
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
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
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

        .service-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-weight: 600;
            color: var(--dark-color);
        }

        .payment-form {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-color);
        }

        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 1rem;
        }

        .price-summary {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .price-total {
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 1.1rem;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            background: var(--success-color);
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
            width: 100%;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1>Service Payment Details</h1>
        <p>Complete your service request by providing payment information</p>
    </div>

    <div class="service-summary">
        <h3><i class="fas fa-concierge-bell"></i> Service Request Summary</h3>
        <div class="summary-item">
            <span class="summary-label">Service ID:</span>
            <span><%= service.getServiceId() %></span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Service Name:</span>
            <span><%=service.getServiceName()%></span>
        </div>
    </div>

    <form action="ServiceRequestServlet" method="post" class="payment-form">
        <input type="hidden" name="action" value="createServiceRequest" />
        <input type="hidden" name="serviceId" value="<%=service.getServiceId()%>">

        <div class="form-group">
            <label for="paymentMethod"><i class="fas fa-credit-card"></i> Payment Method:</label>
            <select id="paymentMethod" name="paymentMethod" required>
                <option value="">Select Payment Method</option>
                <option value="credit_card">Credit Card</option>
                <option value="debit_card">Debit Card</option>
            </select>
        </div>

        <div class="price-summary">
            <h3><i class="fas fa-receipt"></i> Payment Summary</h3>
            <div class="price-row">
                <span>Service Cost:</span>
                <span>Rs. <%= service.getServicePrice() %></span>
            </div>
            <div class="price-total">
                <span>Total:</span>
                <span>Rs. <%= service.getServicePrice() %></span>
            </div>
        </div>

        <button type="submit" class="btn">
            <i class="fas fa-check-circle"></i> Confirm Service Request
        </button>
    </form>
</div>
</body>
</html>