<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="billlistuser.aspx.cs" Inherits="restaurants_management_system.billlistuser" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill List - Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" />
    <style>
body { 
    background-color: #f8f9fa; 
    padding: 20px; 
    font-family: 'Segoe UI', sans-serif; 
}


.card { 
    border-radius: 15px; 
    box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
    border: none; 
}


.table-header { 
    background: #2c3e50; 
    color: white; 
}


.badge-pending { 
    background-color: #ffc107; 
    color: #000; 
}
.badge-complete { 
    background-color: #198754; 
    color: #fff; 
}


.table-responsive {
    overflow-x: auto;
}


.btn-sm {
    margin-bottom: 5px;
}


@media (max-width: 768px) {
    .card {
        padding: 15px;
    }
    .btn-sm {
        display: block;
        width: 100%;
    }
    .gv-style td, .gv-style th {
        font-size: 13px;
        padding: 8px 10px;
    }
}


@media (max-width: 480px) {
    h3 {
        font-size: 1.2rem;
    }
    .badge {
        font-size: 12px;
        padding: 4px 6px;
    }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container mt-4">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0">Order History & Bills</h3>
                    <asp:LinkButton ID="btnBack" runat="server" PostBackUrl="~/RMS_SCREEN.aspx" CssClass="btn btn-outline-secondary">Back to POS</asp:LinkButton>
                </div>

                <asp:UpdatePanel ID="upnlBills" runat="server">
                    <ContentTemplate>
                        
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle" 
                            OnRowCommand="gvOrders_RowCommand" DataKeyNames="MainID">
                            <HeaderStyle CssClass="table-header" />
                            <Columns>
                                <asp:BoundField DataField="MainID" HeaderText="Order #" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy HH:mm}" />
                                <asp:BoundField DataField="OrderType" HeaderText="Type" />
                                <asp:TemplateField HeaderText="Customer">
                                    <ItemTemplate>
                                        <%# (Eval("OrderType").ToString() == "Take Away" || Eval("OrderType").ToString() == "Delivery") 
                                            ? Eval("userName").ToString() + " (" + Eval("userPhone").ToString() + ")" 
                                            : "" %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="Rs. {0:N2}" />

                                <asp:TemplateField HeaderText="Table">
                                    <ItemTemplate>
                                        <%# Eval("tableName") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("Status").ToString() == "Pending" ? "badge-pending" : "badge-complete" %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditOrder" 
                                            CommandArgument='<%# Eval("MainID") %>' CssClass="btn btn-sm btn-primary">Edit</asp:LinkButton>
                                        
                                        <asp:LinkButton ID="btnComplete" runat="server" 
                                            CommandName="CompleteOrder" 
                                            CommandArgument='<%# Eval("MainID") %>' 
                                            CssClass="btn btn-sm btn-success"
                                            >
                                            Complete
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelOrder"
                                            CommandArgument='<%# Eval("MainID") %>' CssClass="btn btn-sm btn-danger"
                                            OnClientClick="return confirm('Are you sure you want to cancel this order?');">
                                            Cancel
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="LinkButton2" runat="server" 
                                            CommandName="DelOrder"
                                            CommandArgument='<%# Eval("MainID") %>' 
                                            CssClass="btn btn-sm btn-dark"
                                            OnClientClick="return confirm('Permanent delete this order?');">
                                            Remove
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="LinkButton1" runat="server" 
                                            CommandName="PrintOrder"
                                            CommandArgument='<%# Eval("MainID") %>' 
                                            CssClass="btn btn-sm btn-info">
                                            Print 
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                        <asp:Timer ID="tmrRefresh" runat="server" Interval="5000" OnTick="timerRefresh_Tick"></asp:Timer>

                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
        </div>
    </form>
</body>
</html>