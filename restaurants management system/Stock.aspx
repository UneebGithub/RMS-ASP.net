<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Stock.aspx.cs" Inherits="restaurants_management_system.Stock" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Stock Management | RMS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #9e5a12;
            --hover: #7d460e;
            --bg: #fdf2e9;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Poppins', sans-serif; }
        body { background: var(--bg); min-height: 100vh; display: flex; overflow-x: hidden; }
        form { width: 100%; display: flex; }

        
        .sidebar {
            width: 280px;
            background: var(--primary);
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px;
            flex-shrink: 0;
            height: 100vh;
            position: sticky;
            top: 0;
            z-index: 1000; /* Content ke upar rakhta hai */
        }
        .sidebar h2 { font-size: 1.8rem; text-align: center; margin-bottom: 40px; font-weight: 800; }
        .nav-item { padding: 15px 20px; color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; }
        .nav-item:hover { background: linear-gradient(90deg, #9e5a12 0%, #d48011 100%); }
        .nav-item.active { background: white; color: var(--primary); font-weight: 600; }

        /* Main content */
        .main-content { flex: 1; padding: 40px; width: 100%; position: relative; z-index: 1; }
        .page-title { color: #5c4033; margin-bottom: 25px; font-weight: 600; border-bottom: 2px solid #9e5a1233; padding-bottom: 10px; }

        /* Form Card */
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .form-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 20px; }
        .input-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--primary); font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; font-size: 0.9rem; }
        .readonly-box { background: #f0f0f0; border: 1px solid var(--primary); font-weight: bold; color: var(--primary); }

        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 35px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; height: 48px; }
        .btn-save:hover { background: var(--hover); transform: translateY(-2px); }

        /* GridView */
        .table-container { background: white; border-radius: 12px; padding: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow-x: auto; }
        .gv-style { width: 100%; border-collapse: collapse; }
        .gv-style th { background: #f8f9fa; color: var(--primary); padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        .gv-style td { padding: 12px 15px; border-bottom: 1px solid #f1f1f1; }

        /* Responsive - Z-index fixed for Mobile */
        .mobile-header { display: none; background: var(--primary); color: white; padding: 15px 20px; justify-content: space-between; align-items: center; position: fixed; top: 0; width: 100%; z-index: 2000; }
        .menu-toggle { font-size: 20px; cursor: pointer; }

        @media (max-width: 768px) {
            .mobile-header { display: flex; }
            .sidebar { position: fixed; left: -280px; z-index: 3000; transition: 0.3s ease; }
            .sidebar.active { left: 0; }
            .main-content { padding: 80px 20px 20px; }
            .form-row { grid-template-columns: 1fr; }
            .overlay.active { display: block; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2500; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="mobile-header">
            <span style="font-weight: 800; font-size: 1.2rem;">RMS ADMIN</span>
            <div class="menu-toggle" onclick="toggleMenu()"><i class="fas fa-bars"></i></div>
        </div>

        <div class="overlay" onclick="toggleMenu()"></div>

      

        <div class="main-content">
            <h2 class="page-title">Stock Management</h2>
            <div class="card">
                <div class="form-row">
                    <div class="input-group"><label>Item Name</label><asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" /></div>
 <div class="input-group"><label>Category</label>
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Category --" Value="" />
        </asp:DropDownList>
    </div>                    <div class="input-group"><label>Cartons</label><asp:TextBox ID="txtCartons" runat="server" CssClass="form-control" TextMode="Number" onkeyup="calculateStock()" /></div>
                    <div class="input-group"><label>Qty Per Carton</label><asp:TextBox ID="txtQtyPer" runat="server" CssClass="form-control" TextMode="Number" onkeyup="calculateStock()" /></div>
                </div>
                <div class="form-row">
                    <div class="input-group"><label>Total Buying Cost</label><asp:TextBox ID="txtBuyingCost" runat="server" CssClass="form-control" TextMode="Number" onkeyup="calculateStock()" /></div>
                    <div class="input-group"><label>Total Pieces (Auto)</label><asp:TextBox ID="txtTotalQty" runat="server" CssClass="form-control readonly-box" ReadOnly="true" /></div>
                    <div class="input-group"><label>Unit Cost (Buying)</label><asp:TextBox ID="txtUnitCost" runat="server" CssClass="form-control readonly-box" ReadOnly="true" /></div>
                    <div class="input-group"><label>Selling Price</label><asp:TextBox ID="txtSellingPrice" runat="server" CssClass="form-control" TextMode="Number" onkeyup="calculateStock()" /></div>
                </div>
                <div class="form-row">
                    <div class="input-group"><label>Profit</label><asp:TextBox ID="txtProfit" runat="server" CssClass="form-control readonly-box" ReadOnly="true" style="color: green;" /></div>
                    <div class="input-group"><label>Expiry Date</label><asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" TextMode="Date" /></div>
                    <div class="input-group"><label>Low Stock Level</label><asp:TextBox ID="txtLowStock" runat="server" CssClass="form-control" TextMode="Number" Text="5" /></div>
                </div>
                <asp:HiddenField ID="hfStockID" runat="server" />
                <asp:Button ID="btnSave" runat="server" Text="Save Stock Item" CssClass="btn-save" OnClick="btnSave_Click" />
            </div>

          <div class="table-container">
    <asp:GridView ID="gvStock" runat="server" AutoGenerateColumns="False" CssClass="gv-style" 
        DataKeyNames="stockID" OnRowCommand="gvStock_RowCommand" OnRowDataBound="gvStock_RowDataBound">
        <Columns>
            <asp:BoundField DataField="itemName" HeaderText="Item Name" />
            <asp:BoundField DataField="totalQty" HeaderText="Total Qty" />
            <asp:BoundField DataField="unitCost" HeaderText="Buy Rate" />
            <asp:BoundField DataField="sellingPrice" HeaderText="Sell Rate" />
            
    
            <asp:BoundField DataField="expiryDate" HeaderText="Expiry Date" DataFormatString="{0:dd-MMM-yyyy}" />
            
            <asp:TemplateField HeaderText="Status / Remaining">
                <ItemTemplate>
                    <asp:Label ID="lblDaysLeft" runat="server" Font-Bold="true"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Container.DataItemIndex %>' ForeColor="Orange" style="margin-right:10px;"><i class="fa fa-edit"></i></asp:LinkButton>
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("stockID") %>' ForeColor="Red" OnClientClick="return confirm('Delete this item?')"><i class="fa fa-trash"></i></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
        </div>
    </form>

    <script type="text/javascript">
        function toggleMenu() {
            document.getElementById('sidebar').classList.toggle('active');
            document.querySelector('.overlay').classList.toggle('active');
        }
        function calculateStock() {
            let cartons = parseFloat(document.getElementById('<%= txtCartons.ClientID %>').value) || 0;
            let qtyPer = parseFloat(document.getElementById('<%= txtQtyPer.ClientID %>').value) || 0;
            let buyTotal = parseFloat(document.getElementById('<%= txtBuyingCost.ClientID %>').value) || 0;
            let sellPrice = parseFloat(document.getElementById('<%= txtSellingPrice.ClientID %>').value) || 0;
            let totalPieces = (cartons > 0) ? (cartons * qtyPer) : qtyPer;
            let unitCost = (totalPieces > 0) ? (buyTotal / totalPieces) : 0;
            let profit = (sellPrice > 0) ? (sellPrice - unitCost) : 0;
            document.getElementById('<%= txtTotalQty.ClientID %>').value = totalPieces;
            document.getElementById('<%= txtUnitCost.ClientID %>').value = unitCost.toFixed(2);
            document.getElementById('<%= txtProfit.ClientID %>').value = profit.toFixed(2);
        }
    </script>
</body>
</html>