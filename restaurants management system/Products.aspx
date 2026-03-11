<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="restaurants_management_system.Products" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root { --primary: #9e5a12; --hover: #7d460e; --bg: #fdf2e9; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); min-height: 100vh; }
        
        form { display: flex; min-height: 100vh; width: 100%; }

       
        .sidebar { width: 280px; background: var(--primary); color: white; display: flex; flex-direction: column; padding: 20px; flex-shrink: 0; position: sticky; top: 0; height: 100vh; transition: 0.3s ease; }
        .sidebar h2 { font-size: 1.8rem; text-align: center; margin-bottom: 40px; font-weight: 800; }
        .nav-item { padding: 15px 20px; color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; }
        .nav-item:hover { background: linear-gradient(90deg, #9e5a12 0%, #d48011 100%); }
/*      .nav-item.active { background: white; color: var(--primary); font-weight: 600; }*/

        
        .main-content { flex: 1; padding: 40px; width: 100%; }
        .page-title { color: #5c4033; margin-bottom: 25px; font-weight: 600; border-bottom: 2px solid #9e5a1233; padding-bottom: 10px; }
        .form-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .form-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px; }
        .input-group label { display: block; font-weight: 600; margin-bottom: 8px; color: #9e5a12; font-size: 0.9rem; }
        
       
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; font-size: 0.9rem; }
        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 35px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; height: 48px; }
        .btn-save:hover { background: var(--hover); transform: translateY(-2px); }

      
        .table-container { background: white; border-radius: 12px; padding: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow-x: auto; }
        .gv-style { width: 100%; border-collapse: collapse; }
        .gv-style th { background: #f8f9fa; color: var(--primary); padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        .gv-style td { padding: 12px 15px; border-bottom: 1px solid #f1f1f1; }
        .prod-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }

      
        .mobile-header { display: none; background: var(--primary); color: white; padding: 15px 20px; justify-content: space-between; align-items: center; position: fixed; top: 0; width: 100%; z-index: 1001; }
        @media (max-width: 768px) {
            form { flex-direction: column; }
            .mobile-header { display: flex; }
            .sidebar { position: fixed; left: -280px; z-index: 1002; }
            .sidebar.active { left: 0; }
            .main-content { padding: 80px 20px 20px; }
            .form-row { grid-template-columns: 1fr; }
            .overlay.active { display: block; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1001; }
        }



        
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


.overlay {
    display: none;
}


@media (max-width: 768px) {
    form {
        flex-direction: column;
    }

    .mobile-header {
        display: flex;
    }

    .sidebar {
        position: fixed;
        left: -280px;
        z-index: 1002;
        transition: 0.3s;
    }

    .sidebar.active {
        left: 0;
    }

    .overlay.active {
        display: block;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 1001;
    }

    .main-content {
        padding: 80px 20px 20px;
    }

    .form-row {
        grid-template-columns: 1fr;
    }

    .gv-style th, .gv-style td {
        font-size: 0.8rem;
        padding: 8px;
    }

    .prod-img {
        width: 40px;
        height: 40px;
    }

    .btn-save {
        font-size: 1rem;
        padding: 12px;
    }
}
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="mobile-header">
            <span style="font-weight: 800; font-size: 1.2rem;">RMS ADMIN</span>
            <div class="menu-toggle" onclick="toggleMenu()"><i class="fas fa-bars"></i></div>
        </div>

        <div class="overlay" onclick="toggleMenu()"></div>

     

        <div class="main-content">
            <h2 class="page-title">Manage Food Products</h2>

            <div class="form-card">
                <div class="form-row">
                    <div class="input-group">
                        <label>Product Name</label>
                        <asp:TextBox ID="txtProdName" runat="server" CssClass="form-control" placeholder="e.g. Zinger Burger" />
                    </div>

                    <div class="input-group">
                        <label>Category</label>
                        <asp:DropDownList ID="ddCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>

                    <div class="input-group">
                        <label>Price (PKR)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="0.00" TextMode="Number" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddStatus" runat="server" CssClass="form-control">
                            <asp:ListItem>Available</asp:ListItem>
                            <asp:ListItem>Out of Stock</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="input-group">
                        <label>Product Image</label>
                        <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" />
                    </div>

                    <div class="input-group" style="display:flex; align-items: flex-end;">
                         <asp:HiddenField ID="hfProdID" runat="server" />
                         <asp:Button ID="btnSave" runat="server" Text="Save Product" CssClass="btn-save" OnClick="btnSave_Click" Width="100%" />
                    </div>
                </div>
            </div>

            <div class="table-container">
                <asp:GridView ID="gvProducts" runat="server" CssClass="gv-style" AutoGenerateColumns="False" 
                    DataKeyNames="prodID" GridLines="None" OnRowCommand="gvProducts_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="prodID" HeaderText="ID" />
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <img src='<%# "Uploads/Products/" + Eval("prodImage") %>' class="prod-img" 
                                     onerror="this.src='https://via.placeholder.com/50';" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="prodName" HeaderText="Product" />
                        <asp:BoundField DataField="catName" HeaderText="Category" />
                        <asp:BoundField DataField="prodPrice" HeaderText="Price" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="prodStatus" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("prodID") %>' Style="color:#d48011;">
                                    <i class="fa fa-edit"></i>
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("prodID") %>' 
                                    OnClientClick="return confirm('Delete this product?')" Style="color:#e74c3c;">
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
            document.getElementById('sidebar').classList.toggle('active');
            document.querySelector('.overlay').classList.toggle('active');
        }
    </script>
</body>
</html>