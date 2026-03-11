using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class billlistuser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        // ================================
        // LOAD ALL ORDERS WITH TABLE
        // ================================
        private void LoadOrders()
        {
            try
            {
                string query = @"
SELECT om.MainID,
       om.OrderDate,
       om.OrderType,
       om.TotalAmount,
       om.Status,
       t.tableName,
       u.userName,
       u.userPhone
FROM OrderMain om
LEFT JOIN RESTTables t ON om.TableID = t.tableID
LEFT JOIN Users u ON om.UserID = u.userID
ORDER BY om.MainID DESC";

                DataTable dtOrders = MAINClass.loadDataTable_DS(query);

                if (dtOrders != null)
                {
                    gvOrders.DataSource = dtOrders;
                    gvOrders.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Optionally handle errors
                ShowError(ex.Message);
            }
        }

        // ================================
        // GRIDVIEW COMMAND (EDIT / COMPLETE / CANCEL / DELETE)
        // ================================

        protected void timerRefresh_Tick(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int orderID = Convert.ToInt32(e.CommandArgument);




            try
            {
                switch (e.CommandName)
                {
                    case "EditOrder":
                    case "CompleteOrder":
                        Session["EditOrderID"] = orderID;
                        Response.Redirect("RMS_SCREEN.aspx");
                        break;

                    case "CancelOrder":
                        MAINClass.ExecuteQuery($@"
                    UPDATE OrderMain 
                    SET Status = 'Cancelled' 
                    WHERE MainID = {orderID}");
                        LoadOrders();
                        ScriptManager.RegisterStartupScript(this, GetType(), "success",
                            "alert('Order cancelled successfully');", true);
                        break;

                    case "DelOrder":
                        // -------------------------------
                        // Check if order exists
                        // -------------------------------
                        DataTable dtOrder = MAINClass.loadDataTable_DS($@"
                    SELECT COUNT(*) AS CountOrder 
                    FROM OrderMain 
                    WHERE MainID = {orderID}");

                        if (dtOrder != null && dtOrder.Rows.Count > 0 && Convert.ToInt32(dtOrder.Rows[0]["CountOrder"]) > 0)
                        {
                            // -------------------------------
                            // Delete OrderDetails first
                            // -------------------------------
                            DataTable dtDetails = MAINClass.loadDataTable_DS($@"
                        SELECT COUNT(*) AS CountDetails 
                        FROM OrderDetails 
                        WHERE OrderID = {orderID}");

                            if (dtDetails != null && dtDetails.Rows.Count > 0 && Convert.ToInt32(dtDetails.Rows[0]["CountDetails"]) > 0)
                            {
                                MAINClass.ExecuteQuery($@"
                            DELETE FROM OrderDetails 
                            WHERE OrderID = {orderID}");
                            }

                            // -------------------------------
                            // Delete OrderMain
                            // -------------------------------
                            MAINClass.ExecuteQuery($@"
                        DELETE FROM OrderMain 
                        WHERE MainID = {orderID}");

                            LoadOrders();
                            ScriptManager.RegisterStartupScript(this, GetType(), "success",
                                "alert('Order removed permanently!');", true);
                        }


                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "info",
                                "alert('Order not found.');", true);
                        }
                        break;
                    case "PrintOrder":
                        PrintBill(orderID); 
                        break;

                }
                   

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                    $"alert('Error: {ex.Message}');", true);
            }
        }
        private void PrintBill(int orderID)
        {
            try
            {
                
                string qryMain = $@"
            SELECT om.MainID, om.OrderDate, om.TableID, om.WaiterID, om.OrderType, om.TotalAmount, om.Status,
                   t.tableName, s.staffName AS WaiterName
            FROM OrderMain om
            LEFT JOIN RESTTables t ON om.TableID = t.tableID
            LEFT JOIN Staff s ON om.WaiterID = s.staffID
            WHERE om.MainID = {orderID}";
                DataTable dtMain = MAINClass.loadDataTable_DS(qryMain);
                if (dtMain == null || dtMain.Rows.Count == 0) return;

                DataRow order = dtMain.Rows[0];
                string waiterName = order["WaiterName"]?.ToString() ?? "-";
                string tableName = order["tableName"]?.ToString() ?? "-";
                string orderType = order["OrderType"].ToString();

                
                string customerName = "-";
                string customerPhone = "-";
                if (orderType == "Take Away" || orderType == "Delivery")
                {
                    DataTable dtCustomer = MAINClass.loadDataTable_DS($@"
                SELECT userName, userPhone 
                FROM Users 
                WHERE userID = (SELECT UserID FROM OrderMain WHERE MainID = {orderID})");
                    if (dtCustomer != null && dtCustomer.Rows.Count > 0)
                    {
                        customerName = dtCustomer.Rows[0]["userName"].ToString();
                        customerPhone = dtCustomer.Rows[0]["userPhone"].ToString();
                    }
                }

                
                string taxName = "Tax";
                decimal taxPercent = 0;
                DataTable dtTax = MAINClass.loadDataTable_DS("SELECT TOP 1 TaxName, TaxPercentage FROM TaxDatabase ORDER BY TaxID DESC");
                if (dtTax != null && dtTax.Rows.Count > 0)
                {
                    taxName = dtTax.Rows[0]["TaxName"].ToString();
                    taxPercent = Convert.ToDecimal(dtTax.Rows[0]["TaxPercentage"]);
                }

                
                string qryDetails = $@"
            SELECT od.ProductID, od.Qty, p.prodName, od.Price, (od.Qty * od.Price) AS Amount
            FROM OrderDetails od
            INNER JOIN Products p ON od.ProductID = p.prodID
            WHERE od.OrderID = {orderID}";
                DataTable dtDetails = MAINClass.loadDataTable_DS(qryDetails);

                decimal grossTotal = dtDetails.AsEnumerable().Sum(r => Convert.ToDecimal(r["Amount"]));
                decimal discountPercent = 0; 
                decimal discountAmount = 0;
                decimal taxAmount = grossTotal * taxPercent / 100;
                decimal netTotal = grossTotal + taxAmount - discountAmount;

                
                string billHtml = "<html><head><title>Receipt</title><style>" +
                    "body { font-family:'Segoe UI', monospace; width:300px; margin:0; padding:10px; color:#000; }" +
                    "h2 { text-align:center; font-size:16px; margin:5px 0; }" +
                    "p { font-size:12px; margin:2px 0; }" +
                    "table { width:100%; border-collapse:collapse; margin-top:5px; font-size:12px; }" +
                    "th, td { border-bottom:1px dashed #000; padding:4px; text-align:left; }" +
                    ".totals td { font-weight:bold; text-align:right; }" +
                    "footer { text-align:center; font-size:10px; margin-top:10px; }" +
                    "</style></head><body>";

                billHtml += $"<h2>HOTEL / SOFTWARE NAME</h2>";
                billHtml += $"<p>Bill #: {order["MainID"]}</p>";
                billHtml += $"<p>Date: {Convert.ToDateTime(order["OrderDate"]).ToString("dd-MMM-yyyy HH:mm")}</p>";
                if (orderType == "Dine In")
                {
                    billHtml += $"<p>Waiter: {waiterName} | Table: {tableName}</p>";
                }
                else if (orderType == "Delivery")
                {
                    billHtml += $"<p>Rider: {waiterName}</p>";

                }
                billHtml += $"<p>Order Type: {orderType}</p>";

                if (orderType == "Take Away" || orderType == "Delivery")
                    billHtml += $"<p>Customer: {customerName} | Phone: {customerPhone}</p>";

                billHtml += "<table><tr><th>Qty</th><th>Description</th><th>Rate</th><th>Amount</th></tr>";
                foreach (DataRow row in dtDetails.Rows)
                {
                    billHtml += $"<tr><td>{row["Qty"]}</td><td>{row["prodName"]}</td><td>{row["Price"]}</td><td>{row["Amount"]}</td></tr>";
                }

                billHtml += $"<tr class='totals'><td colspan='3'>Gross Total</td><td>{grossTotal:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'>{taxName} @{taxPercent}%</td><td>{taxAmount:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'>Discount @{discountPercent}%</td><td>{discountAmount:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'><b>NET BILL</b></td><td><b>{netTotal:N2}</b></td></tr></table>";

                billHtml += @"<footer>Generated by: YOUR NAME | RMS SYSTEM</footer>";
                billHtml += "</body></html>";

                string safeHtml = billHtml.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
                ScriptManager.RegisterStartupScript(this, GetType(), "printBill",
                    $"var w = window.open('', '_blank'); w.document.write('{safeHtml}'); w.document.close(); w.print();", true);

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        private void ShowError(string message)
        {
            Response.Write("<script>alert('Error: " + message.Replace("'", "") + "');</script>");
        }
    }
}