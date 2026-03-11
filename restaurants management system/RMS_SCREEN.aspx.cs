using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class RMS_SCREEN : System.Web.UI.Page
    {
        protected void tmrTablesRefresh_Tick(object sender, EventArgs e)
        {
            LoadTables("All"); 
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();

            
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            
            Response.Redirect("ADMINLOGIN.aspx");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (Session["SelectedUserID"] != null)
                {
                    pnlCustomerInfo.Visible = true;
                    int selectedUserID = Convert.ToInt32(Session["SelectedUserID"]);
                    txtCustomerName.Text = Session["SelectedUserName"].ToString();
                    txtCustomerPhone.Text = Session["SelectedUserPhone"].ToString();
                    txtCustomerAddress.Text = Session["SelectedUserAddress"].ToString();
                }
                else
                {
                    pnlCustomerInfo.Visible = false;  
                }

                LoadTables("All");

                string userRole = Session["UserRole"] != null ? Session["UserRole"].ToString() : "Waiter";




                if (userRole == "Waiter" || userRole == "Admin")
                {
                    pnlWaiter.Visible = true;
                  LoadWaiters();
                }

                LoadCategories();
                LoadProducts("SELECT prodID, prodName, prodPrice, prodImage FROM Products");

                if (Session["EditOrderID"] != null)
                {
                    int editOrderID = Convert.ToInt32(Session["EditOrderID"]);
                    ViewState["EditOrderID"] = editOrderID;  
                    LoadOrderForEdit(editOrderID);
                    Session["EditOrderID"] = null;
                }
                else
                {
                    
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID", typeof(int));
                    dt.Columns.Add("Name", typeof(string));
                    dt.Columns.Add("Qty", typeof(int));
                    dt.Columns.Add("Price", typeof(decimal));
                    dt.Columns.Add("Total", typeof(decimal), "Qty * Price");
                    ViewState["MyCart"] = dt;
                }
            }

        }

        //protected void btnClear_Click(object sender, EventArgs e)
        //{
        //    // 1. Clear GridView
        //    rptCart.DataSource = null;
        //    rptCart.DataBind();

        //    // 2. Clear TextBoxes (replace with your TextBox IDs)
        //    txtDiscount.Text = "0";
        //    txtReceived.Text = "0";

        //    // 3. Clear Labels (replace with your Label IDs)
        //    lblGrandTotal.Text = "0.00";
        //    lblChange.Text = "0.00";

        //    // 4. Reset ViewState or other page-level variables
        //    ViewState["MyCart"] = null;
        //    ViewState["SelectedTableID"] = null;

        //    // 5. Optionally reload orders if you want empty GridView
        //    // LoadOrders();

        //    ScriptManager.RegisterStartupScript(this, GetType(), "info",
        //        "alert('All fields cleared successfully');", true);
        //}

        protected void btnCheckOut_Click(object sender, EventArgs e)
        {
            try
            {
                
                if (ViewState["CurrentOrderID"] == null)
                {
                
                    if (ViewState["EditOrderID"] != null)
                    {
                        ViewState["CurrentOrderID"] = (int)ViewState["EditOrderID"];
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "alert('Please select an order first!');", true);
                        return;
                    }
                }

                int orderID = Convert.ToInt32(ViewState["CurrentOrderID"]);

                ScriptManager.RegisterStartupScript(this, GetType(), "closeRMS_SCREEN",
      "window.open('', '_self'); window.close();", true);
                GenerateBillWithPayment(orderID);
                LoadTables("All");

                
                ViewState["MyCart"] = null;
                ViewState["CurrentOrderID"] = null;

            

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        protected void txtDiscount_TextChanged(object sender, EventArgs e)
        {
            decimal discount = 0;
            if (decimal.TryParse(txtDiscount.Text, out discount))
                ViewState["Discount"] = discount;
            else
                ViewState["Discount"] = 0;
        }
        private void GenerateBillWithPayment(int orderID)
        {
            try
            {
                
                string taxName = "Tax";
                decimal taxPercent = 0;
                DataTable dtTax = MAINClass.loadDataTable_DS("SELECT TOP 1 TaxName, TaxPercentage FROM TaxDatabase ORDER BY TaxID DESC");
                if (dtTax != null && dtTax.Rows.Count > 0)
                {
                    taxName = dtTax.Rows[0]["TaxName"].ToString();
                    taxPercent = Convert.ToDecimal(dtTax.Rows[0]["TaxPercentage"]);
                }

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
                string customerAddress = "-";
                if (orderType == "Take Away" || orderType == "Delivery")
                {
                    DataTable dtCustomer = MAINClass.loadDataTable_DS($@"
    SELECT userName, userPhone, userAddress FROM Users 
    WHERE userID = (SELECT UserID FROM OrderMain WHERE MainID = {orderID})");

                    if (dtCustomer != null && dtCustomer.Rows.Count > 0)
                    {
                        customerName = dtCustomer.Rows[0]["userName"]?.ToString() ?? "-";
                        customerPhone = dtCustomer.Rows[0]["userPhone"]?.ToString() ?? "-";
                        customerAddress = dtCustomer.Rows[0]["userAddress"]?.ToString() ?? "-";
                    }
                }

                
                DataTable dtRiders = MAINClass.loadDataTable_DS("SELECT staffID, staffName FROM Staff WHERE staffRole='Rider'");
                string riderOptions = "";
                foreach (DataRow r in dtRiders.Rows) riderOptions += $"<option value='{r["staffID"]}'>{r["staffName"]}</option>";

                DataTable dtStaff = MAINClass.loadDataTable_DS("SELECT staffID, staffName, staffRole FROM Staff WHERE staffRole='Cashier'");
                string cashierOptions = "";
                foreach (DataRow s in dtStaff.Rows) cashierOptions += $"<option value='{s["staffID"]}'>{s["staffName"]} ({s["staffRole"]})</option>";

                string qryDetails = $@"
        SELECT od.ProductID, od.Qty, p.prodName, od.Price, (od.Qty * od.Price) AS Amount
        FROM OrderDetails od
        INNER JOIN Products p ON od.ProductID = p.prodID
        WHERE od.OrderID = {orderID}";
                DataTable dtDetails = MAINClass.loadDataTable_DS(qryDetails);

                // --- 2. CALCULATIONS WITH DISCOUNT FIX ---
                decimal grossTotal = dtDetails.AsEnumerable().Sum(r => Convert.ToDecimal(r["Amount"]));

                // Front-end TextBox (txtDiscount) se value uthana
                decimal discountPercent = 0;
                if (!string.IsNullOrEmpty(txtDiscount.Text))
                {
                    decimal.TryParse(txtDiscount.Text, out discountPercent);
                }

                decimal taxAmount = (grossTotal * taxPercent) / 100;
                decimal discountAmount = (grossTotal * discountPercent) / 100; // YEH FIX HAI
                decimal netTotal = grossTotal + taxAmount - discountAmount;

                decimal receivedAmount = 0;
                decimal.TryParse(txtReceived.Text, out receivedAmount);
                decimal changeAmount = receivedAmount - netTotal;

                lblChange.Text = changeAmount.ToString("N2");

                // Save Bill
                int billID = 0;
                string insertBill = $@"
        INSERT INTO BillHistory 
        (OrderID, TableID, WaiterID, OrderType, GrossTotal, TaxAmount, DiscountAmount, NetTotal, ReceivedAmount, ChangeAmount)
        VALUES ({orderID}, 
                {(order["TableID"] != DBNull.Value ? order["TableID"].ToString() : "NULL")}, 
                {(order["WaiterID"] != DBNull.Value ? order["WaiterID"].ToString() : "NULL")}, 
                '{orderType}', {grossTotal}, {taxAmount}, {discountAmount}, {netTotal}, {receivedAmount}, {changeAmount});
        SELECT SCOPE_IDENTITY();";

                object billObj = MAINClass.ExecuteScalar(insertBill);
                if (billObj != null) billID = Convert.ToInt32(billObj);

                foreach (DataRow row in dtDetails.Rows)
                {
                    MAINClass.ExecuteQuery($@"INSERT INTO BillHistoryDetails (BillID, ProductID, ProductName, Qty, Price, Amount)
                                    VALUES ({billID}, {row["ProductID"]}, '{row["prodName"]}', {row["Qty"]}, {row["Price"]}, {row["Amount"]})");
                }

                // --- 3. RECEIPT DESIGN (Wahi Purana Style) ---
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
                billHtml += $"<p>Date: {DateTime.Now:dd-MMM-yyyy HH:mm}</p>";
                if (orderType == "Dine In")
                {
                    billHtml += $"<p>Waiter: {waiterName} | Table: {tableName}</p>";
                }
                else if (orderType == "Delivery")
                {
                    billHtml += $"<p>Rider: {waiterName}</p>";
                    billHtml += $"<p>Customer: {customerName} | Phone: {customerPhone} | Address: {customerAddress}</p>";
                }

                billHtml += $"<p>Order Type: {orderType}</p>";

                if (orderType == "Take Away")
                {
                    billHtml += $"<p>Customer: {customerName} | Phone: {customerPhone} | Address: {customerAddress}</p>";
                }

                billHtml += "<table><tr><th>Qty</th><th>Description</th><th>Rate</th><th>Amount</th></tr>";
                foreach (DataRow row in dtDetails.Rows)
                {
                    billHtml += $"<tr><td>{row["Qty"]}</td><td>{row["prodName"]}</td><td>{row["Price"]}</td><td>{row["Amount"]}</td></tr>";
                }

                billHtml += $"<tr class='totals'><td colspan='3'>Gross Total</td><td>{grossTotal:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'>{taxName} @{taxPercent}%</td><td>{taxAmount:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'>Discount @{discountPercent}%</td><td>-{discountAmount:N2}</td></tr>";
                billHtml += $"<tr class='totals'><td colspan='3'><b>NET BILL</b></td><td><b>{netTotal:N2}</b></td></tr></table>";

                billHtml += $"<p>Received: {receivedAmount:N2}</p>";
                billHtml += $"<p>Change: {changeAmount:N2}</p>";
                billHtml += @"<footer>Generated by: YOUR NAME | RMS SYSTEM</footer>";
                billHtml += "</body></html>";

                // Print Script
                string safeHtml = billHtml.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
                ScriptManager.RegisterStartupScript(this, GetType(), "showBill",
                    $"var w = window.open('', '_blank'); w.document.write('{safeHtml}'); w.document.close(); w.print();", true);

                // 4. Update Database
                MAINClass.ExecuteQuery($"UPDATE OrderMain SET Status='Complete' WHERE MainID={orderID}");
                if (orderType == "Dine In" && order["TableID"] != DBNull.Value)
                    MAINClass.ExecuteQuery($"UPDATE RESTTables SET tableStatus='Available' WHERE tableID={order["TableID"]}");

                // Stock Update
                foreach (DataRow row in dtDetails.Rows)
                {
                    MAINClass.ExecuteQuery($"UPDATE Stock SET totalQty = CASE WHEN totalQty - {row["Qty"]} < 0 THEN 0 ELSE totalQty - {row["Qty"]} END WHERE itemName = '{row["prodName"]}'");
                }

                // Reset UI
            //    ClearCart(); // Is function mein UI labels ko 0.00 kar den
            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, GetType(), "err", $"alert('{ex.Message}');", true); }
        }

        private void LoadOrderForEdit(int orderID)
        {
            
            DataTable dtCart = new DataTable();
            dtCart.Columns.Add("ID", typeof(int));
            dtCart.Columns.Add("Name", typeof(string));
            dtCart.Columns.Add("Qty", typeof(int));
            dtCart.Columns.Add("Price", typeof(decimal));
            dtCart.Columns.Add("Total", typeof(decimal), "Qty * Price");

            
            string qry = $@"
        SELECT od.ProductID, p.prodName, od.Qty, od.Price,
               om.TableID, om.WaiterID, om.OrderType
        FROM OrderDetails od
        INNER JOIN Products p ON od.ProductID = p.prodID
        INNER JOIN OrderMain om ON od.OrderID = om.MainID
        WHERE od.OrderID = {orderID}";

            DataTable dt = MAINClass.loadDataTable_DS(qry);

            
            foreach (DataRow row in dt.Rows)
            {
                dtCart.Rows.Add(row["ProductID"], row["prodName"], row["Qty"], row["Price"]);
            }

            
            ViewState["MyCart"] = dtCart;
            BindCart(dtCart);


            if (dt.Rows.Count > 0)
            {
                if (dt.Rows.Count > 0)
                {
                    string tableID = dt.Rows[0]["TableID"].ToString();
                    string staffID = dt.Rows[0]["WaiterID"].ToString();
                    string orderType = dt.Rows[0]["OrderType"].ToString();

                    ViewState["SelectedTableID"] = tableID;
                    ViewState["OldTableID"] = tableID;   
                    ViewState["OrderType"] = orderType;
                    if (orderType == "Dine In")
                    {
                        pnlWaiter.Visible = true;
                        LoadWaiters();

                        LoadWaiters();   // bind first
                        ddlWaiters.SelectedValue = staffID;
                    }
                    else if (orderType == "Delivery")
                    {
                        pnlWaiter.Visible = true;
                        LoadRiders();

                    }
                }
            }
        }
        
        protected void btnType_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            ViewState["OrderType"] = btn.CommandArgument; 

            if (btn.CommandArgument == "Dine In")
            {
                pnlWaiter.Visible = true;
                LoadWaiters();
            }
            else if (btn.CommandArgument == "Delivery")
            {
                pnlWaiter.Visible = true;       
                LoadRiders();
            }
            else
            {
                pnlWaiter.Visible = false;
                ViewState["SelectedTableID"] = "0"; 
            }
        }

        protected void ButtonUserInfo_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "openUserInfo",
                "window.open('UserINFO.aspx', '_blank');", true);
        }
        private void LoadRiders()
        {
            string query = "SELECT staffID, staffName FROM Staff WHERE staffRole = 'Rider'";
            DataTable dt = MAINClass.loadDataTable_DS(query);

            ddlWaiters.DataSource = dt;
            ddlWaiters.DataTextField = "staffName";
            ddlWaiters.DataValueField = "staffID";
            ddlWaiters.DataBind();

            ddlWaiters.Items.Insert(0, new ListItem("Select Rider", "0"));
        }
        protected void btnBill_List(object sender, EventArgs e)
        {
            LoadTables("All");
            string url = "billlistuser.aspx";
            string script = "window.open('" + url + "', '_blank');";
            ClientScript.RegisterStartupScript(this.GetType(), "OpenNewTab", script, true);
        }



        protected void btnTable_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            if (btn.ToolTip == "Occupied")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Table booked hai!');", true);
                return;
            }

            
            ViewState["SelectedTableID"] = btn.CommandArgument;

            
            LoadTables("All");
        }


        protected void btnKOT_Click(object sender, EventArgs e)
        {
            DataTable dtCart = (DataTable)ViewState["MyCart"];

            if (dtCart == null || dtCart.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Opps! Aapka Cart khali hai. Pehle items select karein.');", true);
                return;
            }

            string orderType = ViewState["OrderType"] != null ? ViewState["OrderType"].ToString() : "Take Away";
            if (orderType == "Dine In")
            {
                if (ViewState["SelectedTableID"] == null || ViewState["SelectedTableID"].ToString() == "0")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Pehle Table Number select karein!');", true);
                    return;
                }
            }


            int selectedUserID = Session["SelectedUserID"] != null ? Convert.ToInt32(Session["SelectedUserID"]) : 0;

            if (ViewState["EditOrderID"] != null)
            {
                int editID = (int)ViewState["EditOrderID"];
                UpdateExistingOrder(editID, dtCart);
                ViewState["EditOrderID"] = null;
            }
            else
            {
                SaveOrderToDatabase(dtCart, selectedUserID); 
            }


            Session.Remove("SelectedUserID");
            Session.Remove("SelectedUserName");
            Session.Remove("SelectedUserPhone");
            Session.Remove("SelectedUserAddress");

            pnlCustomerInfo.Visible = false;
        }

        private void UpdateExistingOrder(int orderID, DataTable dt)
        {
            try
            {
                string tableID = ViewState["SelectedTableID"]?.ToString() ?? "0";
                string oldTableID = ViewState["OldTableID"]?.ToString();
                string waiterID = ddlWaiters.SelectedValue;
                string orderType = ViewState["OrderType"]?.ToString() ?? "Take Away";

                decimal total = 0;
                decimal.TryParse(lblGrandTotal.Text, out total);

                
                string qryMain = $@"
            UPDATE OrderMain 
            SET TableID = {tableID}, WaiterID = {waiterID}, OrderType = '{orderType}', TotalAmount = {total} 
            WHERE MainID = {orderID}";
                MAINClass.ExecuteQuery(qryMain);

                
                MAINClass.ExecuteQuery($"DELETE FROM OrderDetails WHERE OrderID = {orderID}");

                
                foreach (DataRow row in dt.Rows)
                {
                    string qryDet = $@"INSERT INTO OrderDetails (OrderID, ProductID, Qty, Price) 
                               VALUES ({orderID}, {row["ID"]}, {row["Qty"]}, {row["Price"]})";
                    MAINClass.ExecuteQuery(qryDet);
                }


                if (orderType == "Dine In")
                {
                    
                    if (!string.IsNullOrEmpty(oldTableID) && oldTableID != tableID)
                    {
                        MAINClass.ExecuteQuery($"UPDATE RESTTables SET tableStatus = 'Available' WHERE tableID = {oldTableID}");
                    }

                    
                    if (tableID != "0")
                    {
                        MAINClass.ExecuteQuery($"UPDATE RESTTables SET tableStatus = 'Occupied' WHERE tableID = {tableID}");
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Order Updated Successfully!'); window.location='RMS_SCREEN.aspx';", true);
                ViewState["EditOrderID"] = null; 
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error: {ex.Message}');", true);
            }
        }


        private void SaveOrderToDatabase(DataTable dt, int userID)
        {
            try
            {
                string tableID = ViewState["SelectedTableID"]?.ToString() ?? "0";
                string oldTableID = ViewState["OldTableID"]?.ToString();
                string waiterID = ddlWaiters.SelectedValue;
                string orderType = ViewState["OrderType"]?.ToString() ?? "Take Away";

                decimal total = 0;
                decimal.TryParse(lblGrandTotal.Text, out total);


                string qryMain = $@"INSERT INTO OrderMain (OrderDate, TableID, WaiterID, OrderType, TotalAmount, Status, UserID) 
                            VALUES (GETDATE(), {tableID}, {waiterID}, '{orderType}', {total}, 'Pending', {(userID > 0 ? userID.ToString() : "NULL")}); 
                            SELECT SCOPE_IDENTITY();";

                object orderID = MAINClass.ExecuteScalar(qryMain);

                if (orderID != null && orderID != DBNull.Value)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        string qryDet = $@"INSERT INTO OrderDetails (OrderID, ProductID, Qty, Price) 
                                   VALUES ({orderID}, {row["ID"]}, {row["Qty"]}, {row["Price"]})";
                        MAINClass.ExecuteQuery(qryDet);
                    }

                    if (orderType == "Dine In" )
                    {
                        
                        if (!string.IsNullOrEmpty(oldTableID) && oldTableID != tableID)
                        {
                            MAINClass.ExecuteQuery($"UPDATE RESTTables SET tableStatus = 'Free' WHERE tableID = {oldTableID}");
                        }

                        
                        if (tableID != "0")
                        {
                            MAINClass.ExecuteQuery($"UPDATE RESTTables SET tableStatus = 'Occupied' WHERE tableID = {tableID}");
                        }
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Order Saved Successfully!'); window.location='RMS_SCREEN.aspx';", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Database Error: Main Order save nahi hua.');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error: {ex.Message}');", true);
            }
        }
        private void LoadWaiters()
        {
         
            string query = "SELECT staffID, staffName FROM Staff WHERE staffRole = 'Waiter'";
            DataTable dt = MAINClass.loadDataTable_DS(query);

            ddlWaiters.DataSource = dt;
            ddlWaiters.DataTextField = "staffName";
            ddlWaiters.DataValueField = "staffID";
            ddlWaiters.DataBind();

            
            ddlWaiters.Items.Insert(0, new ListItem("Select Waiter", "0"));
        }
        private void LoadTables(string status)
        {
            
            string query = "SELECT tableID, tableName, tableStatus FROM RESTTables";

            if (status != "All")
            {
                query += " WHERE tableStatus = '" + status + "'";
            }

            
            DataTable dt = MAINClass.loadDataTable_DS(query);

            if (dt != null)
            {
                rptTables.DataSource = dt;
                rptTables.DataBind();
            }
        }

        protected void FilterTables(object sender, EventArgs e)
        {
            string status = (sender as Button).CommandArgument;
            LoadTables(status);
        }
        private void LoadCategories()
        {
            rptCategories.DataSource = MAINClass.loadDataTable_DS("SELECT catID, catName FROM Categories");
            rptCategories.DataBind();
        }

        private void LoadProducts(string query)
        {
            rptProducts.DataSource = MAINClass.loadDataTable_DS(query);
            rptProducts.DataBind();
        }

        protected void btnCat_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32((sender as LinkButton).CommandArgument);
            LoadProducts("SELECT prodID, prodName, prodPrice, prodImage FROM Products WHERE categoryID = " + id);
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadProducts("SELECT prodID, prodName, prodPrice, prodImage FROM Products WHERE prodName LIKE '%" + txtSearch.Text + "%'");
        }

        protected void AddProduct_Click(object sender, EventArgs e)
        {
            
            LinkButton btn = (LinkButton)sender;
            int id = Convert.ToInt32(btn.CommandArgument);

            DataTable dt = (DataTable)ViewState["MyCart"];
            DataRow[] rows = dt.Select("ID = " + id);

            if (rows.Length > 0)
            {
                rows[0]["Qty"] = (int)rows[0]["Qty"] + 1;
            }
            else
            {
                DataTable info = MAINClass.loadDataTable_DS("SELECT prodName, prodPrice FROM Products WHERE prodID = " + id);
                if (info.Rows.Count > 0)
                {
                    dt.Rows.Add(id, info.Rows[0]["prodName"], 1, info.Rows[0]["prodPrice"]);
                }
            }
            BindCart(dt);
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dt = (DataTable)ViewState["MyCart"];
            int id = Convert.ToInt32(e.CommandArgument);
            DataRow[] rows = dt.Select("ID = " + id);

            if (e.CommandName == "Plus") rows[0]["Qty"] = (int)rows[0]["Qty"] + 1;
            else if (e.CommandName == "Minus")
            {
                rows[0]["Qty"] = (int)rows[0]["Qty"] - 1;
                if ((int)rows[0]["Qty"] <= 0) rows[0].Delete();
            }
            dt.AcceptChanges();
            BindCart(dt);
        }

        private void BindCart(DataTable dt)
        {
            rptCart.DataSource = dt;
            rptCart.DataBind();
            ViewState["MyCart"] = dt;
            CalculateFinalTotal(null, null);
        }
     

    

        protected void CalculateFinalTotal(object sender, EventArgs e)
        {
            DataTable dt = (DataTable)ViewState["MyCart"];
            if (dt == null || dt.Rows.Count == 0)
            {
                lblGrandTotal.Text = "0.00";
                lblChange.Text = "0.00";
                return;
            }

            decimal subTotal = Convert.ToDecimal(dt.Compute("Sum(Total)", ""));
            decimal discPercent = 0;
            decimal.TryParse(txtDiscount.Text, out discPercent);

            decimal finalTotal = subTotal - (subTotal * (discPercent / 100));
            lblGrandTotal.Text = finalTotal.ToString("N2");

            decimal received = 0;
            if (decimal.TryParse(txtReceived.Text, out received))
            {
                decimal change = received - finalTotal;
                lblChange.Text = change.ToString("N2");
                lblChange.ForeColor = change >= 0 ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            }
        }


        private void ClearCart()
        {
            ViewState["MyCart"] = null;
            ViewState["EditOrderID"] = null;
            ViewState["CurrentOrderID"] = null;
            rptCart.DataSource = null;
            rptCart.DataBind();
            txtDiscount.Text = "0";
            txtReceived.Text = "0";
            lblGrandTotal.Text = "0.00";
            lblChange.Text = "0.00";
            pnlCustomerInfo.Visible = false;
            LoadTables("All");
        }

    }
}
