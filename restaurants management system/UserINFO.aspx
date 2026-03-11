<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserINFO.aspx.cs" Inherits="restaurants_management_system.UserINFO" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
      /* Body & page */
body {
    background-color: #f8f9fa;
    padding: 20px;
    font-family: 'Poppins', sans-serif;
}

/* Cards */
.card {
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border-radius: 12px;
    transition: 0.3s;
}

.card:hover {
    box-shadow: 0 8px 20px rgba(0,0,0,0.12);
}

/* Search input and buttons */
input.form-control {
    border-radius: 8px;
    box-shadow: none;
    transition: 0.2s;
}

input.form-control:focus {
    border-color: #198754;
    box-shadow: 0 0 0 0.2rem rgba(25,135,84,.25);
}

/* Buttons */
.btn {
    border-radius: 8px;
    font-weight: 500;
    transition: 0.3s;
}

.btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.12);
}

/* GridView / Table Styling */
table.table {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

table.table th {
    background-color: #ffffff;
    color: #198754;
    font-weight: 600;
    border-bottom: 2px solid #e9ecef;
}

table.table td {
    vertical-align: middle;
}

/* Action buttons in GridView */
table.table .btn-sm {
    padding: 3px 8px;
    font-size: 0.8rem;
}

table.table .btn-sm.btn-warning:hover {
    background-color: #ffc107;
    color: #212529;
}

table.table .btn-sm.btn-danger:hover {
    background-color: #dc3545;
    color: #fff;
}

table.table .btn-sm.btn-success:hover {
    background-color: #198754;
    color: #fff;
}

/* Modal Styling */
.modal-content {
    border-radius: 12px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    padding: 15px;
}

.modal-header {
    border-bottom: none;
}

.modal-title {
    font-weight: 600;
    color: #198754;
}

.modal-footer {
    border-top: none;
}


@media (max-width: 576px) {
    .card .row.g-3 {
        flex-direction: column;
    }
    .col-md-2,
    .col-md-4 {
        text-align: start !important;
        width: 100%;
    }
    .col-md-2 .btn,
    .col-md-4 .btn {
        width: 100%;
    }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2 class="text-center mb-4">User Information System</h2>

            <div class="card p-4 mb-4">
                <div class="row g-3">
                    <div class="col-md-6">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by Name or Phone..."></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary w-100" OnClick="btnSearch_Click" />
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            + Add New User
                        </button>
                    </div>
                </div>
            </div>

            <div class="card p-3">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-striped" DataKeyNames="userID" OnRowCommand="gvUsers_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="userID" HeaderText="ID" />
                        <asp:BoundField DataField="userName" HeaderText="Name" />
                        <asp:BoundField DataField="userPhone" HeaderText="Phone" />
                        <asp:BoundField DataField="userAddress" HeaderText="Address" />
                        <asp:BoundField DataField="totalOrders" HeaderText="Total Orders" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditUser" CommandArgument='<%# Eval("userID") %>' CssClass="btn btn-sm btn-warning">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("userID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?');">Del</asp:LinkButton>
                                        <asp:LinkButton ID="btnUse" runat="server" CommandName="UseUser"
            CommandArgument='<%# Eval("userID") %>' CssClass="btn btn-sm btn-success">Use</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="modal fade" id="addUserModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add New User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Full Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Phone</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddUser" runat="server" Text="Save User" CssClass="btn btn-success" OnClick="btnAddUser_Click" />
                    </div>



  
                </div>
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>