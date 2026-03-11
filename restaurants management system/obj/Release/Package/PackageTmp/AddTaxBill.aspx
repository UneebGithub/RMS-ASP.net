<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddTaxBill.aspx.cs" Inherits="restaurants_management_system.AddTaxBill" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Taxes | RMS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root { 
    --primary: #9e5a12; 
    --hover: #7d460e; 
    --bg: #fdf2e9; 
    --text-dark: #333;
}

* { 
    box-sizing: border-box; 
    margin: 0; 
    padding: 0; 
    font-family: 'Inter', sans-serif; 
}

body { 
    background: var(--bg); 
    color: var(--text-dark); 
}

.main-content { 
    padding: 40px; 
    max-width: 1200px; 
    margin: auto; 
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

.form-control { 
    width: 100%; 
    padding: 12px; 
    border: 1px solid #ddd; 
    border-radius: 8px; 
    font-size: 14px; 
}

.form-control:focus { 
    border-color: var(--primary); 
    outline: none; 
    box-shadow: 0 0 5px rgba(158, 90, 18, 0.2); 
}

.btn-save { 
    background: var(--primary); 
    color: white; 
    border: none; 
    padding: 12px 25px; 
    border-radius: 4px; 
    cursor: pointer; 
    margin-top: 25px; 
    font-weight: 600; 
    transition: 0.3s; 
}

.btn-save:hover { 
    background: var(--hover); 
}

.table-container { 
    background: white; 
    border-radius: 12px; 
    padding: 20px; 
    box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
    overflow-x: auto; 
    position: relative;
}

.table-container::after {
    content: "⇨ Scroll horizontally";
    position: absolute;
    right: 10px;
    bottom: 5px;
    font-size: 12px;
    color: #999;
    pointer-events: none;
}

.table-container table {
    min-width: 600px; /* ensures horizontal scroll on mobile */
}

.gv-style { 
    width: 100%; 
    border-collapse: collapse; 
}

.gv-style th { 
    background: #f8f9fa; 
    color: var(--primary); 
    padding: 15px; 
    text-align: left; 
    border-bottom: 2px solid #eee; 
}

.gv-style td { 
    padding: 12px 15px; 
    border-bottom: 1px solid #f1f1f1; 
}

.action-btn { 
    display: inline-block; 
    font-size: 16px; 
    margin-right: 15px; 
    text-decoration: none; 
    transition: 0.2s; 
}

.edit-icon { color: #f39c12; }
.delete-icon { color: #e74c3c; }

@media (max-width: 768px) {
    .form-row { grid-template-columns: 1fr; }
    .main-content { padding: 20px; }
}

@media (max-width: 480px) {
    .form-card { padding: 20px; }
    .input-group label { font-size: 0.85rem; }
    .btn-save { width: 100%; padding: 12px 0; font-size: 14px; }
    .action-btn { font-size: 16px; margin-right: 8px; }
    .gv-style th, .gv-style td { padding: 10px 8px; font-size: 13px; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-content">
            <h2 class="page-title">Tax Configuration (SST / GST)</h2>
            
            <div class="form-card">
                <div class="form-row">
                    <div class="input-group">
                        <label>Tax Type</label>
                        <asp:DropDownList ID="ddlTaxType" runat="server" CssClass="form-control">
                            <asp:ListItem>SST</asp:ListItem>
                            <asp:ListItem>GST</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="input-group">
                        <label>Percentage (%)</label>
                        <asp:TextBox ID="txtPercentage" runat="server" CssClass="form-control" placeholder="e.g. 13.00" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                    
                    <div class="input-group">
                        <label>Effective Date</label>
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
                
                <asp:HiddenField ID="hfTaxID" runat="server" />
                <asp:Button ID="btnSaveTax" runat="server" Text="Save Tax Record" CssClass="btn-save" OnClick="btnSaveTax_Click" />
            </div>

            <div class="table-container">
                <asp:GridView ID="gvTax" runat="server" AutoGenerateColumns="False" CssClass="gv-style" DataKeyNames="TaxID" OnRowCommand="gvTax_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="TaxID" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="TaxName" HeaderText="Tax Name" />
                        <asp:BoundField DataField="TaxPercentage" HeaderText="Percentage (%)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="EffectiveFrom" HeaderText="Effective Date" DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Container.DataItemIndex %>' CssClass="action-btn edit-icon">
                                    <i class="far fa-edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDel" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("TaxID") %>' CssClass="action-btn delete-icon" OnClientClick="return confirm('Delete this tax record?')">
                                    <i class="far fa-trash-alt"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>