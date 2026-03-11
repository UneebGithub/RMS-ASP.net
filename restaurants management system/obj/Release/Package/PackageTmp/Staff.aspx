<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Staff.aspx.cs" Inherits="restaurants_management_system.Staff" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Staff</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root { --primary: #9e5a12; --hover: #7d460e; --bg: #fdf2e9; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); min-height: 100vh; overflow-x: hidden; }
        form { display: flex; min-height: 100vh; width: 100%; }

        /* Sidebar Styles */
        .sidebar { width: 280px; background: var(--primary); color: white; display: flex; flex-direction: column; padding: 20px; flex-shrink: 0; position: sticky; top: 0; height: 100vh; transition: 0.3s ease; z-index: 1002; }
        .sidebar h2 { font-size: 1.8rem; text-align: center; margin-bottom: 40px; font-weight: 800; }
        .nav-item { padding: 15px 20px; color: rgba(255,255,255,0.8); text-decoration: none; display: flex; align-items: center; gap: 15px; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.2); color: white; font-weight: 600; }

        /* Main Content */
        .main-content { flex: 1; padding: 40px; width: 100%; transition: 0.3s; }
        .page-title { color: #5c4033; margin-bottom: 25px; font-weight: 600; border-bottom: 2px solid #9e5a1233; padding-bottom: 10px; }
        .form-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .form-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px; }
        .input-group label { display: block; font-weight: 600; margin-bottom: 8px; color: #9e5a12; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; font-size: 0.9rem; }
        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 35px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; height: 48px; }
        .btn-save:hover { background: var(--hover); transform: translateY(-2px); }

        .table-container { background: white; border-radius: 12px; padding: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow-x: auto; }
        .gv-style { width: 100%; border-collapse: collapse; min-width: 600px; }
        .gv-style th { background: #f8f9fa; color: var(--primary); padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        .gv-style td { padding: 12px 15px; border-bottom: 1px solid #f1f1f1; }

        /* --- MOBILE VIEW ADDITIONS --- */
        .mobile-header { display: none; background: var(--primary); color: white; padding: 15px 20px; justify-content: space-between; align-items: center; position: fixed; top: 0; width: 100%; z-index: 1001; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .menu-toggle { font-size: 1.5rem; cursor: pointer; }
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1001; }

        @media (max-width: 992px) {
    .form-row { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
    form { flex-direction: column; }
    .mobile-header { display: flex; }
    .sidebar {
        position: fixed;
        left: -280px;
        top: 0;
        height: 100vh;
        box-shadow: 5px 0 15px rgba(0,0,0,0.2);
    }
    .sidebar.active { left: 0; }
    .main-content { padding: 80px 15px 20px; width: 100%; }
    .form-row { grid-template-columns: 1fr; }
    .overlay.active { display: block; }
    .sidebar h2 { margin-top: 20px; }
}
        @media (max-width: 992px) {
            .form-row { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            form { flex-direction: column; }
            .mobile-header { display: flex; }
            .sidebar { position: fixed; left: -280px; top: 0; height: 100vh; box-shadow: 5px 0 15px rgba(0,0,0,0.2); }
            .sidebar.active { left: 0; }
            .main-content { padding: 80px 15px 20px; width: 100%; }
            .form-row { grid-template-columns: 1fr; }
            .overlay.active { display: block; }
            .sidebar h2 { margin-top: 20px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="mobile-header">
            <span style="font-weight: 800; font-size: 1.2rem;">RMS ADMIN</span>
            <div class="menu-toggle" onclick="toggleMenu()"><i class="fas fa-bars"></i></div>
        </div>

        <div class="overlay" id="overlay" onclick="toggleMenu()"></div>

       

        <div class="main-content">
            <h2 class="page-title">Manage Staff</h2>

            <div class="form-card">
                <div class="form-row">
                    <div class="input-group">
                        <label>Staff Name</label>
                        <asp:TextBox ID="txtStaffName" runat="server" CssClass="form-control" placeholder="e.g. Ali Khan" />
                    </div>

                    <div class="input-group">
                        <label>Role</label>
                        <asp:DropDownList ID="ddStaffRole" runat="server" CssClass="form-control">
                            <asp:ListItem>Waiter</asp:ListItem>
                            <asp:ListItem>Cashier</asp:ListItem>
                            <asp:ListItem>Chef</asp:ListItem>
                            <asp:ListItem>Manager</asp:ListItem>
                             <asp:ListItem>Astt.Manager</asp:ListItem>
                            <asp:ListItem>Rider</asp:ListItem>
                            <asp:ListItem>Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="input-group">
                        <label>Phone</label>
                        <asp:TextBox ID="txtStaffPhone" runat="server" CssClass="form-control" placeholder="0300-1234567" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Salary (PKR)</label>
                        <asp:TextBox ID="txtStaffSalary" runat="server" CssClass="form-control" placeholder="0.00" TextMode="Number" />
                    </div>

                    <div class="input-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddStaffStatus" runat="server" CssClass="form-control">
                            <asp:ListItem>Active</asp:ListItem>
                            <asp:ListItem>Inactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="input-group" style="display:flex; align-items:flex-end;">
                        <asp:HiddenField ID="hfStaffID" runat="server" />
                        <asp:Button ID="btnSaveStaff" runat="server" Text="Save Staff" CssClass="btn-save" OnClick="btnSaveStaff_Click" Width="100%" />
                    </div>
                </div>
            </div>

            <div class="table-container">
                <asp:GridView ID="gvStaff" runat="server" CssClass="gv-style" AutoGenerateColumns="False" 
                    DataKeyNames="staffID" GridLines="None" OnRowCommand="gvStaff_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="staffID" HeaderText="ID" />
                        <asp:BoundField DataField="staffName" HeaderText="Name" />
                        <asp:BoundField DataField="staffRole" HeaderText="Role" />
                        <asp:BoundField DataField="staffPhone" HeaderText="Phone" />
                        <asp:BoundField DataField="staffSalary" HeaderText="Salary" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="staffStatus" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("staffID") %>' Style="color:#d48011;">
                                    <i class="fa fa-edit"></i>
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("staffID") %>' 
                                    OnClientClick="return confirm('Delete this staff?')" Style="color:#e74c3c;">
                                    <i class="fa fa-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>

    <script>
        function toggleMenu() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('overlay');
            sidebar.classList.toggle('active');
            overlay.classList.toggle('active');
        }

     
        window.addEventListener('resize', function () {
            if (window.innerWidth > 768) {
                document.getElementById('sidebar').classList.remove('active');
                document.getElementById('overlay').classList.remove('active');
            }
        });
    </script>
</body>
</html>