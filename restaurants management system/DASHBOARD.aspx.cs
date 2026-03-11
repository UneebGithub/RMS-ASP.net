using System;
using System.Data;
using System.Web.UI;

namespace restaurants_management_system
{
    public partial class DASHBOARD : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                // =========================
                // 1. Gross Revenue from BillHistory
                // =========================
                DataTable dtGross = MAINClass.loadDataTable_DS(@"SELECT SUM(NetTotal) AS TotalGross FROM BillHistory");
                double grossRevenue = (dtGross.Rows.Count > 0 && dtGross.Rows[0]["TotalGross"] != DBNull.Value)
                                      ? Convert.ToDouble(dtGross.Rows[0]["TotalGross"]) : 0;
                lblTotalOrders.Text = "Rs. " + grossRevenue.ToString("N2");

                // =========================
                // 2. Stock Investment from StockPurchase
                // =========================
                DataTable dtStock = MAINClass.loadDataTable_DS(@"SELECT SUM(buyingCost) AS TotalStock FROM Stock");
                double stockCost = (dtStock.Rows.Count > 0 && dtStock.Rows[0]["TotalStock"] != DBNull.Value)
                                   ? Convert.ToDouble(dtStock.Rows[0]["TotalStock"]) : 0;
                lblStockCost.Text = "Rs. " + stockCost.ToString("N2");

                // =========================
                // 3. Staff Salaries
                // =========================
                DataTable dtStaff = MAINClass.loadDataTable_DS(@"SELECT SUM(staffSalary) AS TotalSalary, COUNT(staffID) AS StaffCount FROM Staff");
                double salaries = (dtStaff.Rows.Count > 0 && dtStaff.Rows[0]["TotalSalary"] != DBNull.Value)
                                  ? Convert.ToDouble(dtStaff.Rows[0]["TotalSalary"]) : 0;
                lblStaffSalary.Text = "Rs. " + salaries.ToString("N2");
                lblStaffCount.Text = (dtStaff.Rows.Count > 0) ? dtStaff.Rows[0]["StaffCount"].ToString() : "0";

                // =========================
                // 4. Net Profit = Gross Revenue - StockCost - Salaries
                // =========================
                double netProfit = grossRevenue - stockCost - salaries;
                lblFinalProfit.Text = "Rs. " + netProfit.ToString("N2");
                lblFinalProfit.ForeColor = (netProfit < 0) ? System.Drawing.Color.Red : System.Drawing.Color.Black;

                // =========================
                // 5. Inventory Alerts
                // =========================
                DataTable dtExpired = MAINClass.loadDataTable_DS("SELECT COUNT(*) FROM Stock WHERE expiryDate < GETDATE()");
                lblExpiredCount.Text = dtExpired.Rows[0][0].ToString();

                DataTable dtLow = MAINClass.loadDataTable_DS("SELECT COUNT(*) FROM Stock WHERE totalQty <= 5");
                lblLowStockCount.Text = dtLow.Rows[0][0].ToString();

                // =========================
                // 6. Best Selling Product
                // =========================
                DataTable dtBest = MAINClass.loadDataTable_DS(@"SELECT TOP 1 p.proName 
                                                        FROM OrderDetails od 
                                                        JOIN Products p ON od.productID = p.proID 
                                                        GROUP BY p.proName 
                                                        ORDER BY COUNT(od.productID) DESC");
                lblBestSelling.Text = (dtBest.Rows.Count > 0) ? dtBest.Rows[0][0].ToString() : "No Sales Yet";

                // =========================
                // 7. Useless Products
                // =========================
                DataTable dtUseless = MAINClass.loadDataTable_DS(@"SELECT TOP 1 proName FROM Products 
                                                          WHERE proID NOT IN (SELECT productID FROM OrderDetails)");
                lblUselessItems.Text = (dtUseless.Rows.Count > 0) ? dtUseless.Rows[0][0].ToString() : "All items selling";
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading dashboard: " + ex.Message + "');</script>");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("ADMINLOGIN.aspx");
        }
    }
}