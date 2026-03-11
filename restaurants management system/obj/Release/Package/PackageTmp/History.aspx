<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="restaurants_management_system.History" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sales History</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #9e5a12; --bg: #fdf2e9; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); display: flex; margin: 0; }
        .sidebar { width: 260px; background: var(--primary); color: white; min-height: 100vh; padding: 20px; position: fixed; }
        .sidebar h2 { text-align: center; margin-bottom: 30px; font-weight: 800; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 10px; }
        .nav-item { padding: 12px 15px; color: white; text-decoration: none; display: flex; align-items: center; gap: 10px; border-radius: 8px; margin-bottom: 5px; }
        .nav-item:hover { background: #7d460e; }
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        .form-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .filter-row { display: flex; align-items: flex-end; gap: 20px; flex-wrap: wrap; }
        .gv-style { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; }
        .gv-style th { background: #f8f9fa; color: var(--primary); padding: 12px; text-align: left; }
        .gv-style td { padding: 10px; border-bottom: 1px solid #eee; }
        .btn-del { color: #e74c3c; border: none; background: none; cursor: pointer; font-size: 1.1rem; }

@media (max-width: 992px) {
    body { flex-direction: column; }
    .sidebar { 
        width: 100%; 
        position: relative; 
        min-height: auto; 
        display: flex; 
        overflow-x: auto; 
        padding: 10px; 
    }
    .sidebar h2 { display: none; }
    .nav-item { flex: 0 0 auto; margin-right: 5px; margin-bottom: 0; }

    .main-content { margin-left: 0; padding: 15px; }
    .filter-row { flex-direction: column; gap: 10px; align-items: stretch; }
    .filter-row .form-control, .filter-row .btn { width: 100%; box-sizing: border-box; }
    .form-card { padding: 15px; }
    .gv-style { font-size: 0.85rem; }
}


@media (max-width: 480px) {
    .gv-style th, .gv-style td { padding: 8px; }
    .btn-del { font-size: 1rem; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">


        <div class="main-content">
            <h2 style="color: #5c4033;">Sales History</h2>
            <div class="form-card">
                <div class="filter-row">
                    <asp:RadioButton ID="rbHistory" runat="server" GroupName="T" Text="Main" Checked="true" AutoPostBack="true" OnCheckedChanged="Filter_Changed" />
                    <asp:RadioButton ID="rbDetails" runat="server" GroupName="T" Text="Details" AutoPostBack="true" OnCheckedChanged="Filter_Changed" />
                    <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="form-control" style="padding:8px; border-radius:5px; border:1px solid #ddd;" />
                    <asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="form-control" style="padding:8px; border-radius:5px; border:1px solid #ddd;" />
                    <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="Filter_Changed" style="background:#9e5a12; color:white; border:none; padding:10px 20px; border-radius:5px; cursor:pointer;" />
                </div>
            </div>

            <asp:GridView ID="gvHistory" runat="server" CssClass="gv-style" AutoGenerateColumns="true" OnRowDeleting="gvHistory_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="Delete" OnClientClick="return confirm('Delete this record?')" CssClass="btn-del"><i class="fa fa-trash"></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>