<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KIT.aspx.cs" Inherits="restaurants_management_system.KIT" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Kitchen Live Tracking</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #fdf2e9; margin: 20px; }
        .header { text-align: center; color: #9e5a12; margin-bottom: 20px; }
        .order-container { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; }
        .order-card { 
            background: white; border-radius: 15px; width: 320px; 
            padding: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            border-top: 8px solid #d48011; position: relative;
        }
        .order-id { font-weight: 800; color: #d48011; font-size: 1.3rem; display: flex; justify-content: space-between; margin-bottom: 10px; }
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; background:#eee; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 0.9rem; color: #5c4033; }
        .btn-action { width: 100%; padding: 12px; border: none; border-radius: 50px; cursor: pointer; font-weight: 700; margin-top: 10px; transition: 0.3s; }
        .btn-start { background: #d48011; color: white; }
        .btn-done { background: #27ae60; color: white; }
        .btn-print { background: #34495e; color: white; margin-top: 5px; }


@media (max-width: 992px) {
    .order-container { 
        flex-direction: column; 
        align-items: center; 
    }
    .order-card { 
        width: 95%; 
        padding: 15px; 
    }
    .order-id { flex-direction: column; gap: 5px; font-size: 1.1rem; }
    .status-badge { font-size: 0.7rem; padding: 3px 8px; }
    .info-row { font-size: 0.85rem; }
    .btn-action { font-size: 0.9rem; padding: 10px; }
    .btn-print { font-size: 0.85rem; }
}


@media (max-width: 480px) {
    .order-card { width: 100%; padding: 10px; }
    .order-id { font-size: 1rem; }
    .status-badge { font-size: 0.65rem; padding: 2px 6px; }
    .btn-action { font-size: 0.85rem; padding: 8px; }
    .btn-print { font-size: 0.8rem; padding: 8px; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <audio id="notifSound" src="https://www.soundjay.com/buttons/beep-01a.mp3" preload="auto"></audio>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="header">
            <h1>KITCHEN LIVE ORDERS</h1>
        </div>

        <asp:UpdatePanel ID="upnlKitchen" runat="server" UpdateMode="Always">
            <ContentTemplate>
                <div class="order-container">
                    <asp:Repeater ID="rptKitchen" runat="server" OnItemCommand="rptKitchen_ItemCommand">
                        <ItemTemplate>
                            <div class="order-card">
                                <div class="order-id">
                                    <span>#Order <%# Eval("MainID") %></span>
                                    <span class="status-badge"><%# Eval("Status") %></span>
                                </div>
                                
                                <div style="background: #fff8e1; padding: 10px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #ffc107;">
                                    <strong style="color: #5d4037;">Items to Cook:</strong><br />
                                    <span style="font-size: 1.1rem; font-weight: 600; color: #2c3e50;">
                                        <%# Eval("Items") %>
                                    </span>
                                </div>

                                <div class="info-row"><span>Type:</span><strong><%# Eval("OrderType") %></strong></div>
                                
                                <asp:Button ID="btnStatus" runat="server" 
                                    CommandName="ChangeStatus" 
                                    CommandArgument='<%# Eval("MainID") + "|" + Eval("Status") %>'
                                    Text='<%# Eval("Status").ToString() == "Pending" ? "Start Cooking" : "Mark Prepared" %>' 
                                    CssClass='<%# Eval("Status").ToString() == "Pending" ? "btn-action btn-start" : "btn-action btn-done" %>' />
                                
                                <button type="button" class="btn-action btn-print" 
                                    onclick="printSlip('<%# Eval("MainID") %>', '<%# Eval("OrderType") %>', '<%# Eval("Items").ToString().Replace("'", "\\'") %>')">
                                    Print KOT
                                </button>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Timer ID="tmrRefresh" runat="server" Interval="3000" OnTick="tmrRefresh_Tick"></asp:Timer>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script>
        function printSlip(id, type, items) {
            var pWin = window.open('', '', 'width=350,height=500');
            pWin.document.write('<html><body style="font-family:monospace;padding:20px;width:260px;">');
            pWin.document.write('<h2 style="text-align:center;margin:0;">KITCHEN ORDER</h2>');
            pWin.document.write('<hr style="border-top:1px dashed #000;">');
            pWin.document.write('<strong>Order ID:</strong> #' + id + '<br>');
            pWin.document.write('<strong>Type:</strong> ' + type + '<br>');
            pWin.document.write('<hr style="border-top:1px dashed #000;">');
            pWin.document.write('<strong>ITEMS:</strong><br><br>');
            pWin.document.write('<div style="font-size:1.1rem; line-height:1.5;">' + items + '</div>');
            pWin.document.write('<hr style="border-top:1px dashed #000;">');
            pWin.document.write('<p style="text-align:center;">' + new Date().toLocaleString() + '</p>');
            pWin.document.write('</body></html>');
            pWin.document.close();
            setTimeout(function () { pWin.print(); pWin.close(); }, 500);
        }
    </script>
</body>
</html>