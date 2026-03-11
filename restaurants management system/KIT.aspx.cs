using System;
using System.Data;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class KIT : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        protected void tmrRefresh_Tick(object sender, EventArgs e)
        {
            LoadOrders();
        }

        private void LoadOrders()
        {
            
            string qry = @"SELECT m.MainID, m.OrderType, m.Status, 
                          STUFF((SELECT ', ' + CAST(d.Qty AS VARCHAR) + 'x ' + p.prodName 
                                 FROM OrderDetails d 
                                 INNER JOIN Products p ON d.ProductID = p.prodID 
                                 WHERE d.OrderID = m.MainID 
                                 FOR XML PATH('')), 1, 2, '') as Items
                          FROM OrderMain m
                          WHERE m.Status IN ('Pending', 'Cooking')
                          ORDER BY m.MainID DESC";

            DataTable dt = MAINClass.getData(qry);
            if (dt != null)
            {
                rptKitchen.DataSource = dt;
                rptKitchen.DataBind();
            }
        }

        protected void rptKitchen_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ChangeStatus")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                string id = args[0];
                string currentStatus = args[1];

                // Logic: Pending -> Cooking -> Prepared
                string nextStatus = (currentStatus == "Pending") ? "Cooking" : "Prepared";

                string updateQry = $"UPDATE OrderMain SET Status = '{nextStatus}' WHERE MainID = '{id}'";

                if (MAINClass.ExecuteQuery(updateQry) > 0)
                {
                    LoadOrders(); // Refresh screen
                }
            }
        }
    }
}