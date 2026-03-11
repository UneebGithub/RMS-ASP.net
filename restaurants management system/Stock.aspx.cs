using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class Stock : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { LoadStock(); LoadCategories();
            }
        }

        private void LoadCategories()
        {
            try
            {
                // Fetch active categories from dbo.Categories
                string query = "SELECT catID, catName FROM Categories WHERE catStatus='Active' ORDER BY catName";
                DataTable dt = MAINClass.loadDataTable_DS(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlCategory.DataSource = dt;
                    ddlCategory.DataTextField = "catName";   // What user sees
                    ddlCategory.DataValueField = "catID";    // Value used in code
                    ddlCategory.DataBind();

                    // Optional: Add a default "Select Category" at top
                    ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error loading categories: {ex.Message}');", true);
            }
        }

        private void LoadStock()
        {
            string query = "SELECT * FROM Stock ORDER BY entryDate DESC";
            MAINClass.loadData(query, gvStock);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            
            int cart = string.IsNullOrEmpty(txtCartons.Text) ? 0 : Convert.ToInt32(txtCartons.Text);
            int qp = string.IsNullOrEmpty(txtQtyPer.Text) ? 0 : Convert.ToInt32(txtQtyPer.Text);
            int total = (cart > 0) ? (cart * qp) : qp;
            decimal buyCost = string.IsNullOrEmpty(txtBuyingCost.Text) ? 0 : Convert.ToDecimal(txtBuyingCost.Text);
            decimal uCost = (total > 0) ? (buyCost / total) : 0;
            decimal sPrice = string.IsNullOrEmpty(txtSellingPrice.Text) ? 0 : Convert.ToDecimal(txtSellingPrice.Text);

            string query = "";
            Dictionary<string, object> parameters = new Dictionary<string, object>();

            if (string.IsNullOrEmpty(hfStockID.Value)) 
            {
                query = @"INSERT INTO Stock (itemName, category, cartons, qtyPerCarton, totalQty, buyingCost, unitCost, sellingPrice, lowStockLevel, expiryDate, entryDate) 
                          VALUES (@name, @cat, @c, @qp, @t, @bc, @uc, @sp, @low, @exp, GETDATE())";
            }
            else 
            {
                query = @"UPDATE Stock SET itemName=@name, category=@cat, cartons=@c, qtyPerCarton=@qp, totalQty=@t, 
                          buyingCost=@bc, unitCost=@uc, sellingPrice=@sp, lowStockLevel=@low, expiryDate=@exp WHERE stockID=@id";
                parameters.Add("@id", hfStockID.Value);
            }

            parameters.Add("@name", txtItemName.Text);
            parameters.Add("@cat", ddlCategory.SelectedValue);
            parameters.Add("@c", cart);
            parameters.Add("@qp", qp);
            parameters.Add("@t", total);
            parameters.Add("@bc", buyCost);
            parameters.Add("@uc", uCost);
            parameters.Add("@sp", sPrice);
            parameters.Add("@low", txtLowStock.Text);
            parameters.Add("@exp", txtExpiry.Text);

            if (MAINClass.SQL(query, parameters) > 0)
            {
                ClearFields();
                LoadStock();
              //  Response.Write("<script>alert('Stock record saved successfully!');</script>");
            }
        }

        private void ClearFields()
        {
            txtItemName.Text = "";
            ddlCategory.SelectedIndex = 0; // Reset dropdown to first item
            txtCartons.Text = "";
            txtQtyPer.Text = "";
            txtBuyingCost.Text = "";
            txtTotalQty.Text = "";
            txtUnitCost.Text = "";
            txtSellingPrice.Text = "";
            hfStockID.Value = "";
        }

        protected void gvStock_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string id = gvStock.DataKeys[index].Value.ToString();
                hfStockID.Value = id;

              
                string query = "SELECT * FROM Stock WHERE stockID = @id";
                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("@id", id);

                DataTable dt = MAINClass.loadDataTable(query, parameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                   
                    txtItemName.Text = row["itemName"].ToString();
                    string category = row["category"].ToString();
                    if (ddlCategory.Items.FindByText(category) != null)
                    {
                        ddlCategory.SelectedValue = ddlCategory.Items.FindByText(category).Value;
                    }
                    else
                    {
                        ddlCategory.SelectedIndex = 0; 
                    }
                    txtCartons.Text = row["cartons"].ToString();
                    txtQtyPer.Text = row["qtyPerCarton"].ToString();
                    txtTotalQty.Text = row["totalQty"].ToString();
                    txtBuyingCost.Text = row["buyingCost"].ToString();
                    txtUnitCost.Text = row["unitCost"].ToString();
                    txtSellingPrice.Text = row["sellingPrice"].ToString();
                    txtLowStock.Text = row["lowStockLevel"].ToString();

                    if (row["expiryDate"] != DBNull.Value)
                    {
                        txtExpiry.Text = Convert.ToDateTime(row["expiryDate"]).ToString("yyyy-MM-dd");
                    }

                
                    btnSave.Text = "Update Stock Item";

                
                    ScriptManager.RegisterStartupScript(this, GetType(), "calc", "calculateStock();", true);
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                string id = e.CommandArgument.ToString();
                Dictionary<string, object> par = new Dictionary<string, object>();
                par.Add("@id", id);
                MAINClass.SQL("DELETE FROM Stock WHERE stockID = @id", par);
                LoadStock();
            }
        }

        protected void gvStock_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
              
                object expiryObj = DataBinder.Eval(e.Row.DataItem, "expiryDate");
                Label lblDays = (Label)e.Row.FindControl("lblDaysLeft");

                if (expiryObj != DBNull.Value && expiryObj != null)
                {
                    DateTime expiryDate = Convert.ToDateTime(expiryObj);
                    DateTime today = DateTime.Today;
                    TimeSpan difference = expiryDate - today;
                    int daysLeft = difference.Days;

                    if (daysLeft < 0)
                    {
                        lblDays.Text = "🔴 EXPIRED (" + Math.Abs(daysLeft) + " days ago)";
                        lblDays.ForeColor = System.Drawing.Color.Red;
                    }
                    else if (daysLeft == 0)
                    {
                        lblDays.Text = "⚠️ Expiring Today!";
                        lblDays.ForeColor = System.Drawing.Color.OrangeRed;
                    }
                    else if (daysLeft <= 10)
                    {
                        lblDays.Text = "🟠 " + daysLeft + " days left (Soon)";
                        lblDays.ForeColor = System.Drawing.Color.Orange;
                    }
                    else
                    {
                        lblDays.Text = "🟢 " + daysLeft + " days remaining";
                        lblDays.ForeColor = System.Drawing.Color.Green;
                    }
                }
                else
                {
                    lblDays.Text = "No Expiry Date";
                    lblDays.ForeColor = System.Drawing.Color.Gray;
                }
            }
        }
    }
}