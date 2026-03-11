<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RMS_SCREEN.aspx.cs" Inherits="restaurants_management_system.RMS_SCREEN" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Professional POS System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        :root { --pink: #f06292; --dark-blue: #2c3e50; --header-bg: #bdc3c7; --sidebar-bg: #2c3e50; }
        body, html { margin: 0; padding: 0; height: 100vh; font-family: 'Segoe UI', sans-serif; overflow: hidden; }
        form { display: flex; flex-direction: column; height: 100%; }
        /* Container ko set karein */
.table-selection-container {
    background: #1a1a2e; 
    padding: 10px;
    overflow: hidden; /* Bahar nikalne wala content chhupayein */
}

.tables-grid {
    display: flex;
    overflow-x: auto;
    /* Isay auto rakhein taaki refresh par jhatka na lage */
    scroll-behavior: auto !important; 
    -webkit-overflow-scrolling: touch; /* Mobile ke liye behtar scroll */
}

/* Chrome, Safari aur Edge ke liye scrollbar design */
.tables-grid::-webkit-scrollbar {
    height: 8px; /* Bar ki unchai */
}

.tables-grid::-webkit-scrollbar-track {
    background: #1a1a2e; /* Track ka color */
}

.tables-grid::-webkit-scrollbar-thumb {
    background-color: #00b4ff; /* Scrollbar ka color (Blue) */
    border-radius: 10px;
    border: 1px solid #1a1a2e;
}

/* Tables ka size fix rakhein taaki wo sikre nahi */
.table-circle {
    flex: 0 0 45px; /* Width ko fix rakhega */
    height: 35px;
    border-radius: 20px;
    background: white;
    border: 2px solid #00b4ff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

        
        .top-nav { background: var(--header-bg); height: 60px; display: flex; align-items: center; padding: 0 15px; gap: 10px; flex-shrink: 0; }
        .nav-btn { background: var(--pink); color: white; border: none; padding: 8px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; cursor: pointer; }
        .search-container { flex: 1; margin: 0 20px; }
        .search-input { width: 50%; padding: 10px 25px; border-radius: 30px; border: 1px solid #ccc; outline: none;margin-left:45%; }

        
        .main-container { display: flex; flex: 1; overflow: hidden; background: #e9ecef; }

        
        .sidebar { width: 100px; background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; overflow-y: auto; }
        .cat-item { color: #bdc3c7; padding: 20px 5px; text-align: center; text-decoration: none; border-bottom: 1px solid #34495e; transition: 0.3s; }
        .cat-item i { display: block; font-size: 24px; margin-bottom: 8px; }
        .cat-item:hover { background: var(--pink); color: white; }


        .product-section { flex: 1; padding: 20px; overflow-y: auto; display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 15px; align-content: flex-start; }
        
        
        .product-link { text-decoration: none; color: inherit; display: block; }
        .prod-card { background: white; border-radius: 8px; padding: 15px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border: 2px solid transparent; transition: 0.2s; height: 180px; }
        .prod-card:hover { border-color: var(--pink); transform: translateY(-3px); }
        .prod-card:active { transform: scale(0.95); background: #fff5f8; }
        .prod-card img { width: 80px; height: 80px; object-fit: contain; pointer-events: none; }
        .prod-name { font-size: 13px; font-weight: bold; margin-top: 10px; height: 35px; overflow: hidden; pointer-events: none; }

        
        .billing-section { width: 400px; background: white; border-left: 2px solid #ccc; display: flex; flex-direction: column; flex-shrink: 0; }
        .cart-header { background: #5d5fef; color: white; display: grid; grid-template-columns: 40px 1fr 100px 70px 70px; padding: 12px 5px; font-size: 12px; text-align: center; font-weight: bold; }
        .cart-list { flex: 1; overflow-y: auto; }
        .cart-row { display: grid; grid-template-columns: 40px 1fr 100px 70px 70px; padding: 10px 5px; border-bottom: 1px solid #eee; align-items: center; font-size: 13px; text-align: center; }
        .qty-btn { background: #f1f2f6; border: 1px solid #ccc; padding: 2px 8px; border-radius: 4px; text-decoration: none; color: #333; font-weight: bold; }

        
        .billing-footer { background: #f8f9fa; border-top: 1px solid #ddd; padding: 15px; }
        .calc-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; font-size: 14px; font-weight: bold; }
        .input-box { width: 80px; padding: 5px; text-align: right; border: 1px solid #ccc; border-radius: 4px; }
        .grand-total-bar { background: #95a5a6; padding: 15px; display: flex; justify-content: space-between; align-items: center; font-size: 24px; font-weight: bold; color: #333; }
        .btn-checkout { background: var(--pink); color: white; border: none; padding: 15px; width: 100%; font-size: 18px; font-weight: bold; cursor: pointer; }
       
        

@media (max-width: 768px) {
    
    .top-nav {
        flex-wrap: wrap;
        height: auto;
        padding: 10px;
        gap: 5px;
    }

    .search-input {
        width: 90%;
        margin-left: 0;
        margin-top: 5px;
    }

    
    .main-container {
        flex-direction: column;
        overflow-y: auto;
    }

    .sidebar {
        width: 100%;
        display: flex;
        flex-direction: row;
        overflow-x: auto;
        padding: 5px 0;
    }

    .cat-item {
        flex: 0 0 auto;
        padding: 10px 15px;
        border-bottom: none;
        border-right: 1px solid #34495e;
        text-align: center;
    }

    .product-section {
        grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
        padding: 10px;
        gap: 10px;
    }

    .billing-section {
        width: 100%;
        border-left: none;
        border-top: 2px solid #ccc;
        margin-top: 10px;
    }

    .cart-header, .cart-row {
        grid-template-columns: 25px 1fr 60px 50px 50px;
        font-size: 11px;
    }

    .prod-card {
        height: auto;
        padding: 10px;
    }

    .prod-card img {
        width: 60px;
        height: 60px;
    }

    .table-circle {
        width: 30px;
        height: 30px;
        font-size: 10px;
    }

   .tables-grid {
    display: grid;
    grid-template-columns: repeat(10, 1fr);
    gap: 8px;
    padding: 0 10px;
    margin-bottom: 15px;
    max-height: 200px;
    overflow-y: auto;
} 

    .table-filters {
        flex-wrap: wrap;
        gap: 5px;
    }

    .grand-total-bar {
        flex-direction: column;
        font-size: 18px;
        gap: 5px;
        text-align: center;
    }

    .btn-checkout {
        font-size: 16px;
        padding: 12px;
    }
}

    
.table-selection-container {
    background: #1a1a2e; 
    padding: 10px;
}

.table-header {
    background: #00b4ff; 
    color: white;
    padding: 8px 15px;
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 15px;
}

.tables-grid {
    display: grid;
    grid-template-columns: repeat(10, 1fr); 
    gap: 8px;
    padding: 0 10px;
    margin-bottom: 15px;
}

.table-circle {
    width: 41px;
    height: 30px;
    border-radius: 50%;
    background: white;
    border: 2px solid #00b4ff;
    color: #333;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
    text-decoration: none;
}

.table-circle:hover {
    background: #00b4ff;
    color: white;
}


.table-filters {
    display: flex;
    gap: 10px;
    padding: 0 10px 10px;
}

.filter-btn {
    background: #e0f2fe;
    border: 1px solid #ccc;
    padding: 5px 15px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
}

/* RESPONSIVE */
@media (max-width: 768px) {
    .top-nav {
        flex-wrap: wrap;
        height: auto;
        padding: 10px;
        gap: 5px;
    }

    .search-input {
        width: 90%;
        margin-left: 0;
        margin-top: 5px;
    }

    .main-container {
        flex-direction: column;
        overflow-y: auto;
    }

    .sidebar {
        width: 100%;
        display: flex;
        flex-direction: row;
        overflow-x: auto;
        padding: 5px 0;
    }

    .cat-item {
        flex: 0 0 auto;
        padding: 10px 15px;
        border-bottom: none;
        border-right: 1px solid #34495e;
    }

    .product-section {
        grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
        padding: 10px;
        gap: 10px;
    }

    .billing-section {
        width: 100%;
        border-left: none;
        border-top: 2px solid #ccc;
        margin-top: 10px;
    }

    .cart-header, .cart-row {
        grid-template-columns: 25px 1fr 60px 50px 50px;
        font-size: 11px;
    }

    .prod-card {
        height: auto;
        padding: 10px;
    }

    .prod-card img {
        width: 60px;
        height: 60px;
    }

    .table-circle {
        width: 30px;
        height: 30px;
        font-size: 10px;
    }

    .tables-grid {
        display: grid;
        grid-template-columns: repeat(10, 1fr);
        gap: 8px;
        padding: 0 10px;
        margin-bottom: 15px;
        max-height: 150px;
        overflow-y: auto;
    }

    .grand-total-bar {
        flex-direction: column;
        font-size: 18px;
        gap: 5px;
        text-align: center;
    }

    .btn-checkout {
        font-size: 16px;
        padding: 12px;
    }
}



    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top-nav">
            <span style="font-weight:900; color:white; background:#333; padding:5px 10px; border-radius:5px;">POS</span>
<button type="button" class="nav-btn" onclick="window.open('RMS_SCREEN.aspx', '_blank');">
    NEW
</button>      <asp:Button ID="ButtonUserInfo" runat="server" 
    Text="USER INFO" 
    CssClass="nav-btn"
    OnClick="ButtonUserInfo_Click" />


<asp:Button ID="btnbilllist" runat="server" 
    Text="Bill List" 
    CssClass="nav-btn" 
    OnClick="btnBill_List" 
    CommandArgument="Bill List" />         
            <asp:Button ID="btnDelivery" runat="server" 
    Text="DELIVERY" 
    CssClass="nav-btn" 
    OnClick="btnType_Click" 
    CommandArgument="Delivery"  BackColor="Goldenrod"/>
<asp:Button ID="btnDineIn" runat="server" Text="DINE IN" CssClass="nav-btn" OnClick="btnType_Click" CommandArgument="Dine In"  BackColor="Goldenrod"/>
<asp:Button ID="btnTakeAway" runat="server" Text="TAKE AWAY" CssClass="nav-btn" OnClick="btnType_Click" CommandArgument="Take Away" BackColor="Goldenrod" />
<asp:Button ID="btnKOT" runat="server" Text="KOT" CssClass="nav-btn" OnClick="btnKOT_Click" style="background:#2ecc71;" />

           <asp:Panel ID="pnlWaiter" runat="server" Visible="false" style="display:inline-block; margin-left:10px;">
        <asp:DropDownList ID="ddlWaiters" runat="server" CssClass="filter-btn" 
            style="height:30px; padding:0 10px; border-radius:25px; background:white;">
        </asp:DropDownList>
    </asp:Panel>

            <div class="search-container">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search dish here..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
            </div>
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="nav-btn" 
    style="background:#ef4444; color:white; text-decoration:none; padding:8px 20px; border-radius:20px; font-weight:bold; border:none; display:inline-block; cursor:pointer;">
    <i class="fa fa-sign-out-alt"></i> LOG OUT
</asp:LinkButton>
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


        <div class="main-container">
            <div class="sidebar">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnCat" runat="server" CssClass="cat-item" OnClick="btnCat_Click" CommandArgument='<%# Eval("catID") %>'>
                            <i class="fa fa-utensils"></i><%# Eval("catName") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="product-section">
                <asp:Repeater ID="rptProducts" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSelectProd" runat="server" OnClick="AddProduct_Click" CommandArgument='<%# Eval("prodID") %>' CssClass="product-link">
                            <div class="prod-card">
                                
                                     <ItemTemplate>
         <img src='<%# "Uploads/Products/" + Eval("prodImage") %>' class="prod-img" 
              onerror="this.src='https://via.placeholder.com/50';" />
     </ItemTemplate>
                                <div class="prod-name"><%# Eval("prodName") %></div>
                                <div style="color:var(--pink); font-weight:bold;">Rs. <%# Eval("prodPrice") %></div>
                            </div>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="billing-section">
<asp:Panel ID="pnlCustomerInfo" runat="server" Visible="false">
    <div style="padding:10px; background:#f8f9fa; border-bottom:1px solid #ddd;">
        
        <asp:TextBox ID="txtCustomerName" runat="server"
            CssClass="form-control"
            Placeholder="Customer Name"
            style="margin-bottom:5px;" />

        <asp:TextBox ID="txtCustomerPhone" runat="server"
            CssClass="form-control"
            Placeholder="Customer Phone"
            style="margin-bottom:5px;" />

        <asp:TextBox ID="txtCustomerAddress" runat="server"
            CssClass="form-control"
            Placeholder="Customer Address" />

    </div>
</asp:Panel>

                <div class="cart-header">
                    <span>#</span><span>NAME</span><span>QTY</span><span>PRICE</span><span>TOTAL</span>
                </div>
                <div class="cart-list">
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-row">
                                <span><%# Container.ItemIndex + 1 %></span>
                                <span style="text-align:left;"><%# Eval("Name") %></span>
                                <span>
                                    <asp:LinkButton runat="server" CommandName="Minus" CommandArgument='<%# Eval("ID") %>' CssClass="qty-btn">-</asp:LinkButton>
                                    <span style="margin:0 5px;"><%# Eval("Qty") %></span>
                                    <asp:LinkButton runat="server" CommandName="Plus" CommandArgument='<%# Eval("ID") %>' CssClass="qty-btn">+</asp:LinkButton>
                                </span>
                                <span><%# Eval("Price") %></span>
                                <span><%# Eval("Total") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                


<div class="table-selection-container">
    <div class="table-header">TABLE NUMBERS</div>
        <div class="tables-grid">


    
    <asp:UpdatePanel ID="upnlTables" runat="server" UpdateMode="Always">
        <ContentTemplate>
                    <asp:HiddenField ID="hfScrollPos" runat="server" Value="0" />

        <div class="tables-grid" id="tableContainer" onscroll="saveScrollPos(this)">
                <asp:Repeater ID="rptTables" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnTable" runat="server" 
                            CssClass="table-circle" 
                            OnClick="btnTable_Click"
                            CommandArgument='<%# Eval("tableID") %>'
                            style='<%# 
                                Eval("tableID").ToString() == (ViewState["SelectedTableID"] != null ? ViewState["SelectedTableID"].ToString() : "") 
                                ? "background-color: #2c3e50; color: white; border-color: #f06292;" 
                                : (Eval("tableStatus").ToString() == "Occupied" ? "background-color: #ff4d4d; color: white;" : "background-color: white;") 
                            %>'
                            ToolTip='<%# Eval("tableStatus") %>'>
                            <%# Eval("tableName") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
                    <asp:Timer ID="Timer1" runat="server" Interval="3000" OnTick="tmrTablesRefresh_Tick" />

                
            </div>

            <div class="table-filters">
                <asp:Button ID="btnAll" runat="server" Text="All" CssClass="filter-btn" OnClick="FilterTables" CommandArgument="All" />
                <asp:Button ID="btnOccupied" runat="server" Text="Occupied" CssClass="filter-btn" OnClick="FilterTables" CommandArgument="Occupied" />
                <asp:Button ID="btnPending" runat="server" Text="Pending" CssClass="filter-btn" OnClick="FilterTables" CommandArgument="Pending" />
            </div>

            </div>
            <asp:Timer ID="tmrTablesRefresh" runat="server" Interval="3000" OnTick="tmrTablesRefresh_Tick" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>

                <div class="billing-footer">
                    <div class="calc-row">
                        <span>Discount (%)</span>
                        <asp:TextBox ID="txtDiscount" runat="server" CssClass="input-box" Text="" AutoPostBack="true" OnTextChanged="CalculateFinalTotal"></asp:TextBox>
                    </div>
                    <div class="calc-row">
                        <span>Received</span>
                        <asp:TextBox ID="txtReceived" runat="server" CssClass="input-box" AutoPostBack="true" OnTextChanged="CalculateFinalTotal"></asp:TextBox>
                    </div>
                    <div class="calc-row">
                        <span>Change</span>
                        <asp:Label ID="lblChange" runat="server" Text="0.00" ForeColor="Green" Font-Size="Large"></asp:Label>
                    </div>
                    <div class="calc-row">
          
                </div>

                <div class="grand-total-bar">
                    <span>TOTAL</span>
                    <asp:Label ID="lblGrandTotal" runat="server" Text="0.00"></asp:Label>
                </div>
                <asp:Button ID="Button1" runat="server" Text="CHECK OUT" CssClass="btn-checkout" OnClick="btnCheckOut_Click" />
            </div>
        </div>
            </div>


    </form>

   <script type="text/javascript">
       // 1. Jab user scroll kare toh position HiddenField mein save karo
       function saveScrollPos(el) {
           var hf = document.getElementById('<%= hfScrollPos.ClientID %>');
        if (hf) {
            hf.value = el.scrollLeft;
        }
    }

    // 2. Refresh ke baad position wapas set karne ka function
    function restoreScroll() {
        var hf = document.getElementById('<%= hfScrollPos.ClientID %>');
           var container = document.getElementById('tableContainer');
           if (hf && container) {
               container.scrollLeft = hf.value;
           }
       }

       // 3. UpdatePanel refresh ke baad isay dobara chalayein
       var prm = Sys.WebForms.PageRequestManager.getInstance();
       prm.add_endRequest(function () {
           restoreScroll();
       });

       // 4. Pehli dafa page load hone par bhi check karein
       window.onload = restoreScroll;
   </script>
    <script type="text/javascript">
    function doSearch() {
        
        __doPostBack('<%= txtSearch.UniqueID %>', '');
    }
    </script>
</body>
</html>