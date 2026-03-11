<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginHistory.aspx.cs" Inherits="restaurants_management_system.LoginHistory" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Users</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f0f2f5; margin: 0; padding: 20px; }
        .pos-header { background: #ec407a; color: white; padding: 15px 25px; border-radius: 50px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(236, 64, 122, 0.3); }
        
        
        .edit-panel { background: #fff; padding: 25px; border-radius: 20px; margin-bottom: 20px; border: 2px solid #ec407a; display: none; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .edit-panel.active { display: block; animation: fadeIn 0.4s; }
        .input-group { display: inline-block; margin-right: 15px; margin-bottom: 10px; }
        .input-group label { display: block; font-size: 0.8rem; color: #ec407a; font-weight: bold; margin-bottom: 5px; }
        .form-control { padding: 10px 15px; border-radius: 10px; border: 1px solid #ddd; width: 200px; }
        
        .btn-add-new { background: white; color: #ec407a; padding: 8px 20px; border-radius: 20px; border: none; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-add-new:hover { background: #fce4ec; transform: scale(1.05); }

        .card { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .gv-style { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .gv-style th { color: #78909c; font-weight: 600; padding: 15px; text-align: left; }
        .gv-style td { padding: 15px; background: #ffffff; border-top: 1px solid #f0f2f5; border-bottom: 1px solid #f0f2f5; }
        .btn-action { width: 35px; height: 35px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; border: none; cursor: pointer; color: white; text-decoration: none; }
        .btn-edit { background: #42a5f5; margin-right: 10px; }
        .btn-del { background: #ef5350; }
        .btn-save { background: #ec407a; color: white; padding: 10px 30px; border-radius: 15px; border: none; cursor: pointer; font-weight: bold; }
        
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 768px) {
    .input-group { width: 100%; margin-right: 0; }
    .form-control { width: 100%; }
    .gv-style th, .gv-style td { font-size: 0.8rem; padding: 8px; }
    .btn-action { width: 30px; height: 30px; font-size: 0.8rem; }
    .pos-header { flex-direction: column; gap: 10px; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="pos-header">
            <h2 style="margin:0;"><i class="fa fa-users"></i> LOGINREST MANAGEMENT</h2>
            <asp:Button ID="btnOpenAdd" runat="server" Text="+ Add New User" CssClass="btn-add-new" OnClick="btnOpenAdd_Click" />
        </div>

        <asp:Panel ID="pnlEdit" runat="server" CssClass="edit-panel">
            <h3 style="margin-top:0; color:#ec407a;">
                <asp:Literal ID="litTitle" runat="server" Text="Add New User"></asp:Literal>
            </h3>
            <asp:HiddenField ID="hfID" runat="server" />
            <div class="input-group">
                <label>Username</label>
                <asp:TextBox ID="txtUser" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
            </div>
            <div class="input-group">
                <label>Password</label>
                <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" placeholder="Enter password"></asp:TextBox>
            </div>
            <div class="input-group">
                <label>Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                    <asp:ListItem>Admin</asp:ListItem>
                    <asp:ListItem>RMS_SCREEN</asp:ListItem>
                    <asp:ListItem>Kitchen</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div style="margin-top:10px;">
                <asp:Button ID="btnSave" runat="server" Text="Save User" CssClass="btn-save" OnClick="btnSave_Click" />
                <asp:LinkButton ID="btnCancel" runat="server" OnClick="btnCancel_Click" style="margin-left:15px; color:#777; text-decoration:none;">Cancel</asp:LinkButton>
            </div>
        </asp:Panel>

        <div class="card">
            <asp:GridView ID="gvUsers" runat="server" CssClass="gv-style" AutoGenerateColumns="False" 
                DataKeyNames="LoginID" OnRowDeleting="gvUsers_RowDeleting" OnRowCommand="gvUsers_RowCommand" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="LoginID" HeaderText="ID" />
                    <asp:BoundField DataField="UserName" HeaderText="USER NAME" />
                    <asp:BoundField DataField="Password" HeaderText="PASSWORD" />
                    <asp:BoundField DataField="Role" HeaderText="ROLE" />
                    <asp:BoundField DataField="CreatedAt" HeaderText="CREATED AT" DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:TemplateField HeaderText="ACTIONS">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditUser" CommandArgument='<%# Container.DisplayIndex %>' CssClass="btn-action btn-edit">
                                <i class="fa fa-edit"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" OnClientClick="return confirm('User delete kar doon?')" CssClass="btn-action btn-del">
                                <i class="fa fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>

    <script>
    function toggleEditPanel(show) {
        var panel = document.getElementById('<%= pnlEdit.ClientID %>');
        if(show) {
            panel.classList.add('active');
        } else {
            panel.classList.remove('active');
        }
    }
    </script>
</body>
</html>