using System;
using System.Data;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class History : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default date range (Today)
                txtFrom.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadHistory();
            }
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            LoadHistory();
        }

        private void LoadHistory()
        {
            string query = "";
            string dateFilter = $" WHERE CAST(BillDate AS DATE) BETWEEN '{txtFrom.Text}' AND '{txtTo.Text}'";

            if (rbHistory.Checked)
            {
                // Table name is BillHistory
                query = "SELECT BillID, OrderID, BillDate, OrderType, GrossTotal, TaxAmount FROM BillHistory" + dateFilter;
            }
            else
            {
                // YAHAN CHANGE HAI: BillDetails ki jagah BillHistoryDetails likhna hai
                query = @"SELECT d.BillID, d.ProductName, d.Qty, d.Price, d.Amount, h.BillDate 
                  FROM BillHistoryDetails d 
                  INNER JOIN BillHistory h ON d.BillID = h.BillID" + dateFilter;
            }

            MAINClass.loadData(query, gvHistory);
        }

        protected void gvHistory_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // BillID Cell 1 mein hota hai default columns ke sath
                string billId = gvHistory.Rows[e.RowIndex].Cells[1].Text;

                if (rbHistory.Checked)
                {
                    // Pehle details delete karein kyunke wo BillHistory se connected hain
                    MAINClass.ExecuteQuery("DELETE FROM BillHistoryDetails WHERE BillID = " + billId);
                    MAINClass.ExecuteQuery("DELETE FROM BillHistory WHERE BillID = " + billId);
                }
                else
                {
                    // Details view mein delete
                    MAINClass.ExecuteQuery("DELETE FROM BillHistoryDetails WHERE BillID = " + billId);
                }
                LoadHistory();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }
    }
}