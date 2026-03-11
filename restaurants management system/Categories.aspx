<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="restaurants_management_system.Categories" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Categories</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>

:root {
    --primary: #9e5a12;
    --hover: #7d460e;
    --bg: #fdf2e9;
}


* { box-sizing: border-box; margin: 0; padding: 0; }
body {
    font-family: 'Poppins', sans-serif;
    background: var(--bg);
    min-height: 100vh;
}
form { display: flex; min-height: 100vh; width: 100%; }


.sidebar {
    width: 280px;
    background: var(--primary);
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


.mobile-header {
    display: none;
    background: var(--primary);
    color: white;
    padding: 15px;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    z-index: 1001;
}
.menu-btn { font-size: 24px; cursor: pointer; }


.main-content { 
    flex: 1; 
    padding: 40px; 
    width: 100%; 
    overflow-x: auto; 
}
.page-title { 
    color: #5c4033; 
    margin-bottom: 25px; 
    font-weight: 600; 
    border-bottom: 2px solid #9e5a1233; 
    padding-bottom: 10px; 
}
.form-card { 
    background: white; 
    padding: 30px; 
    border-radius: 12px; 
    box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
    margin-bottom: 30px; 
}
.form-row { 
    display: grid; 
    grid-template-columns: repeat(3, 1fr); 
    gap: 20px; 
}
.input-group label { 
    display: block; 
    font-weight: 600; 
    margin-bottom: 8px; 
    color: #9e5a12; 
    font-size: 0.9rem; 
}
.form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; }
.button-row { display: flex; justify-content: flex-end; margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px; }
.btn-save { background: var(--primary); color: white; border: none; padding: 12px 35px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; }


.table-container { 
    background: white; 
    border-radius: 12px; 
    padding: 15px; 
    box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
    overflow-x: auto; 
}
.gv-style { 
    width: 100%; 
    border-collapse: collapse; 
    min-width: 600px; 
}
.gv-style th { 
    background: #f8f9fa; 
    color: var(--primary); 
    padding: 15px; 
    text-align: left; 
}
.gv-style td { 
    padding: 12px 15px; 
    border-bottom: 1px solid #f1f1f1; 
}
.cat-img { 
    width: 50px; 
    height: 50px; 
    object-fit: cover; 
    border-radius: 8px; 
}


@media (max-width: 768px) {
    form { flex-direction: column; }
    .mobile-header { display: flex; }

    
    .sidebar {
        position: fixed;
        left: -280px;
        height: 100%;
        width: 280px;
    }
    .sidebar.active { left: 0; }

    .form-row { grid-template-columns: 1fr; }
    .main-content { padding: 20px; }
    .button-row { justify-content: stretch; }
    .btn-save { width: 100%; }


    .table-container { overflow-x: auto; }
    .gv-style th, .gv-style td { font-size: 13px; padding: 10px; }
}


@media (max-width: 480px) {
    .page-title { font-size: 1.2rem; }
    .form-card { padding: 20px; }
    .cat-img { width: 40px; height: 40px; }
    .btn-save { padding: 10px; font-size: 0.95rem; }
    .gv-style th, .gv-style td { font-size: 12px; padding: 8px; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="mobile-header">
            <span>RMS ADMIN</span>
            <div class="menu-btn" onclick="toggleMenu()">
                <i class="fas fa-bars"></i>
            </div>
        </div>

    

        <div class="main-content">
            <h2 class="page-title">Food Categories</h2>

            <div class="form-card">
                <div class="form-row">
                    <div class="input-group">
                        <label class="l1">Category Name</label>
                        <asp:TextBox ID="txtCatName" runat="server" CssClass="form-control" placeholder="Enter Category" />
                    </div>
                    <div class="input-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddStatus" runat="server" CssClass="form-control">
                            <asp:ListItem>Active</asp:ListItem>
                            <asp:ListItem>Inactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="input-group">
                        <label>Category Image (Optional)</label>
                        <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="button-row">
                    <asp:HiddenField ID="hfCatID" runat="server" />
                    <asp:Button ID="btnSave" runat="server" Text="Save Category" CssClass="btn-save" OnClick="btnSave_Click" />
                </div>
            </div>

            <div class="table-container">
                <asp:GridView ID="gvCategories" runat="server" CssClass="gv-style" AutoGenerateColumns="False" DataKeyNames="catID" GridLines="None" OnRowCommand="gvCategories_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="catID" HeaderText="ID" />
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <img src='<%# ResolveUrl("~/Uploads/Categories/" + Eval("catImage")) %>' class="cat-img" onerror="this.src='https://via.placeholder.com/50';" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="catName" HeaderText="Category Name" />
                        <asp:BoundField DataField="catStatus" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("catID") %>' Style="color:#d48011;"><i class="fa fa-edit"></i></asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("catID") %>' OnClientClick="return confirm('Delete this category?')" Style="color:#e74c3c;"><i class="fa fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>

    <script>
        function toggleMenu() {
            document.getElementById("sidebar").classList.toggle("active");
        }
    </script>
</body>
</html>