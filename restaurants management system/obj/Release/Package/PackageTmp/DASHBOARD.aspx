<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DASHBOARD.aspx.cs" Inherits="restaurants_management_system.DASHBOARD" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="refresh" content="5">
    <title>Advanced Dashboard | RMS Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: 'Poppins', sans-serif; background-color: #fdf2e9; display: flex; height: 100vh; overflow: hidden; }
        form { display: flex; width: 100%; }

        
        .sidebar { width: 280px; background: #9e5a12; color: white; display: flex; flex-direction: column; padding: 20px; flex-shrink: 0; }
        .sidebar h2 { font-size: 1.8rem; text-align: center; margin-bottom: 40px; font-weight: 800; }
        .nav-item { padding: 15px 20px; color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; }
        .nav-item:hover { background: rgba(255,255,255,0.1); }
        .nav-item.active { background: white; color: #9e5a12; font-weight: 600; }

        .main-content { flex: 1; padding: 30px; overflow-y: auto; background-color: #fdf2e9; }
        
        
        .stats-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 20px; }
        .card { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card h3 { color: #888; font-size: 0.85rem; margin: 0; text-transform: uppercase; }
        .card .value { font-size: 1.8rem; font-weight: 800; color: #9e5a12; display: block; margin: 10px 0; }
        
        
        .alert-card { border-left: 5px solid #e74c3c; background: #fff5f5; }
        .warning-card { border-left: 5px solid #f39c12; background: #fffaf0; }
        .profit-card { background: #2ecc71; color: white; }
        .profit-card .value, .profit-card h3 { color: white; }

        
        .dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-top: 30px; }
        .info-panel { background: white; padding: 20px; border-radius: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .info-panel h2 { font-size: 1.2rem; color: #5c4033; margin-top: 0; border-bottom: 2px solid #fdf2e9; padding-bottom: 10px; }

        .list-item { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; font-size: 0.9rem; }
        .badge { padding: 2px 8px; border-radius: 5px; font-weight: bold; font-size: 0.8rem; }
        .badge-red { background: #ffcccc; color: #cc0000; }
        .badge-green { background: #ccffcc; color: #006600; }

        .btn-logout { margin-top: auto; background: #e74c3c; text-align: center; font-weight: bold; }



@media (max-width: 992px) {
    body { flex-direction: column; overflow-y: auto; }
    form { flex-direction: column; }


    .sidebar {
        width: 100%;
        height: auto;
        flex-direction: row;
        overflow-x: auto;
        padding: 10px;
    }
    .sidebar h2 { display: none; }
    .nav-item { flex: 0 0 auto; margin-right: 5px; margin-bottom: 0; }

    .main-content { padding: 15px; }
    .stats-container { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 10px; }
    .dashboard-grid { grid-template-columns: 1fr; gap: 15px; margin-top: 20px; }
    .info-panel { padding: 15px; border-radius: 12px; }
    .card { padding: 15px; border-radius: 12px; }
}


@media (max-width: 480px) {
    .stats-container { grid-template-columns: 1fr; gap: 10px; }
    .card h3 { font-size: 0.75rem; }
    .card .value { font-size: 1.3rem; }
    .list-item { font-size: 0.8rem; }
    .badge { font-size: 0.7rem; padding: 2px 6px; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="sidebar">
            <h2>RMS<br/>ADMIN</h2>
    <a href="DASHBOARD.aspx" class="nav-item active" target="_blank"><i class="fas fa-th-large"></i> Dashboard</a>
<a href="Categories.aspx" class="nav-item" target="_blank"><i class="fas fa-utensils"></i> Category</a>
<a href="Products.aspx" class="nav-item" target="_blank"><i class="fas fa-box"></i> Products</a>
<a href="Stock.aspx" class="nav-item" target="_blank"><i class="fas fa-layer-group"></i> Stock</a>
<a href="Staff.aspx" class="nav-item" target="_blank"><i class="fas fa-users"></i> Staff</a>
<a href="Tables.aspx" class="nav-item" target="_blank">
    <i class="fas fa-table"></i> Table
</a>

<a href="AddTaxBill.aspx" class="nav-item" target="_blank">
    <i class="fas fa-percentage"></i> Add Tax
</a>


<a href="History.aspx" class="nav-item" target="_blank">
    <i class="fas fa-file-invoice-dollar"></i> Bill History Details
</a>
           
            <a href="PassHis.aspx" class="nav-item" target="_blank">
    <i class="fas fa-file-invoice-dollar"></i> Change Passwords
</a>
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-item btn-logout" OnClick="btnLogout_Click">
                <i class="fas fa-sign-out-alt"></i> Logout
            </asp:LinkButton>
        </div>

        <div class="main-content">
            <div class="header-section">
                <h1 style="color: #5c4033; font-weight: 800; margin:0;">Dashboard Analytics</h1>
                <p style="color: #d48011; margin:0;">Monthly Performance Overview</p>
            </div>

            <div class="stats-container">
                <div class="card">
                    <h3>Gross Revenue</h3>
                    <asp:Label ID="lblTotalOrders" runat="server" CssClass="value" Text="Rs. 0"></asp:Label>
                </div>
                <div class="card warning-card">
                    <h3>Stock Purchase</h3>
                    <asp:Label ID="lblStockCost" runat="server" CssClass="value" Text="Rs. 0" ForeColor="#f39c12"></asp:Label>
                </div>
                <div class="card alert-card">
                    <h3>Staff Salaries</h3>
                    <asp:Label ID="lblStaffSalary" runat="server" CssClass="value" Text="Rs. 0" ForeColor="#e74c3c"></asp:Label>
                </div>
                <div class="card profit-card">
                    <h3>Net Final Profit</h3>
                    <asp:Label ID="lblFinalProfit" runat="server" CssClass="value" Text="Rs. 0"></asp:Label>
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="info-panel">
                    <h2><i class="fas fa-exclamation-triangle"></i> Inventory Alerts</h2>
                    <div class="list-item">
                        <span>Items Expired</span>
                        <asp:Label ID="lblExpiredCount" runat="server" CssClass="badge badge-red" Text="0"></asp:Label>
                    </div>
                    <div class="list-item">
                        <span>Low Stock Items (Alert)</span>
                        <asp:Label ID="lblLowStockCount" runat="server" CssClass="badge badge-red" Text="0"></asp:Label>
                    </div>
                    <div class="list-item">
                        <span>Best Selling Product</span>
                        <asp:Label ID="lblBestSelling" runat="server" CssClass="badge badge-green" Text="N/A"></asp:Label>
                    </div>
                    <div class="list-item">
                        <span>Useless (Slow Moving) Items</span>
                        <asp:Label ID="lblUselessItems" runat="server" CssClass="badge" Text="N/A"></asp:Label>
                    </div>
                </div>

                <div class="info-panel">
                    <h2><i class="fas fa-chart-line"></i> Quick Info</h2>
                    <p style="font-size: 0.85rem; color: #666;">System last updated: <br /><b><%= DateTime.Now.ToString("F") %></b></p>
                    <hr />
                    <p style="font-size: 0.85rem; color: #666;">Total Active Staff: <asp:Label ID="lblStaffCount" runat="server" Text="0" Font-Bold="true"></asp:Label></p>
                </div>
            </div>
        </div>
    </form>

   
</body>
</html>
