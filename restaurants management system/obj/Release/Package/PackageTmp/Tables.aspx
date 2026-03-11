<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tables.aspx.cs" Inherits="restaurants_management_system.Tables" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Tables | RMS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root { 
            --primary: #9e5a12; 
            --hover: #7d460e; 
            --bg: #fdf2e9; 
            --text-dark: #333;
            --text-muted: #666;
        }

        * { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; 
        }

        body { background: var(--bg); color: var(--text-dark); overflow-x: hidden; }
        
        form { display: flex; width: 100%; min-height: 100vh; }
        
        .sidebar {
       width: 280px;
       background: #9e5a12;
       color: white;
       display: flex;
       flex-direction: column;
       padding: 20px;
       flex-shrink: 0;
       transition: 0.3s;
       z-index: 1000;
   }

   .sidebar h2 { font-size: 1.8rem; text-align: center; margin-bottom: 40px; font-weight: 800; }

   .nav-item {
       padding: 15px 20px;
       color: white;
       text-decoration: none;
       display: flex;
       align-items: center;
       gap: 15px;
       border-radius: 12px;
       margin-bottom: 8px;
       transition: 0.3s;
   }

  .nav-item:hover { background: linear-gradient(90deg, #9e5a12 0%, #d48011 100%); }
/* .nav-item.active { background: white; color: var(--primary); font-weight: 600; }*/


        
        .mobile-header {
            display: none;
            background: var(--primary);
            color: white;
            padding: 15px 20px;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1001;
        }

        .menu-toggle { font-size: 20px; cursor: pointer; }

       
        
        
        .main-content { flex: 1; padding: 40px; width: 100%; overflow-x: auto; }
/*        h2 { font-weight: 600; color: #222; letter-spacing: -0.5px; }*/
        .page-title { color: #5c4033; margin-bottom: 25px; font-weight: 600; border-bottom: 2px solid #9e5a1233; padding-bottom: 10px; }


       
        .form-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .form-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .input-group label { display: block; font-weight: 600; margin-bottom: 8px; color: #9e5a12; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; }
        .form-control:focus { border-color: var(--primary); }
        
        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 25px; border-radius: 4px; cursor: pointer; margin-top: 25px; font-weight: 600; font-size: 14px; }
        .btn-save:hover { background: var(--hover); }

        
        .table-container { background: white; border-radius: 12px; padding: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow-x: auto; }
        .gv-style { width: 100%; border-collapse: collapse; min-width: 600px; }
        .gv-style th { background: #f8f9fa; color: var(--primary); padding: 15px; text-align: left; }
        .gv-style td { padding: 12px 15px; border-bottom: 1px solid #f1f1f1; }
        
        .action-btn { font-size: 16px; margin-right: 15px; text-decoration: none; opacity: 0.8; transition: 0.2s; }
        .action-btn:hover { opacity: 1; }
        .edit-icon { color: #f39c12; }
        .delete-icon { color: #e74c3c; }

        .status-text { font-weight: 500; color: #444; }

        
        @media (max-width: 768px) {
            form { flex-direction: column; }
            .mobile-header { display: flex; }
            .sidebar { 
                position: fixed; 
                left: -260px; 
                top: 50px; 
                width: 260px; 
                height: calc(100vh - 50px);
            }
            .sidebar.active { left: 0; }
            .main-content { padding: 80px 20px 20px 20px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="mobile-header">
            <span>RMS</span>
            <div class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </div>
        </div>

      
     


        <div class="main-content">
            <h2 style="margin-bottom:25px;">Manage Dining Tables</h2>
            
            <div class="form-card">
                <div class="form-row">
                    <div class="input-group">
                        <label>Table Name/No</label>
                        <asp:TextBox ID="txtTableName" runat="server" CssClass="form-control" placeholder="e.g. Table 01" />
                    </div>
                    <div class="input-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddStatus" runat="server" CssClass="form-control">
                            <asp:ListItem>Free</asp:ListItem>
                            <asp:ListItem>Occupied</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="input-group">
                        <label>Capacity</label>
                        <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" TextMode="Number" placeholder="4" />
                    </div>
                </div>
                <asp:HiddenField ID="hfTableID" runat="server" />
                <asp:Button ID="btnSave" runat="server" Text="Save Table" CssClass="btn-save" OnClick="btnSave_Click" />
            </div>

            <div class="table-container">
                <asp:GridView ID="gvTables" runat="server" AutoGenerateColumns="False" CssClass="gv-style" OnRowCommand="gvTables_RowCommand" DataKeyNames="tableID" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="tableID" HeaderText="ID" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="tableName" HeaderText="Table Name" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("tableStatus") %>' CssClass="status-text"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Container.DataItemIndex %>' CssClass="action-btn edit-icon">
                                    <i class="far fa-edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDel" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("tableID") %>' CssClass="action-btn delete-icon" OnClientClick="return confirm('Delete this table?')">
                                    <i class="far fa-trash-alt"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>

    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('active');
        }
    </script>
</body>
</html>