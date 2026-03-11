using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class UserINFO : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers(string searchTerm = "")
        {
            string query = "SELECT * FROM Users";
            if (!string.IsNullOrEmpty(searchTerm))
            {
                query += $" WHERE userName LIKE '%{searchTerm}%' OR userPhone LIKE '%{searchTerm}%'";
            }

            DataTable dt = MAINClass.loadDataTable_DS(query);
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            string qry = $@"INSERT INTO Users (userName, userPhone, userAddress, totalOrders) 
                           VALUES ('{txtName.Text}', '{txtPhone.Text}', '{txtAddress.Text}', 0)";
            MAINClass.ExecuteQuery(qry);

            // Clear inputs
            txtName.Text = txtPhone.Text = txtAddress.Text = "";
            LoadUsers();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text);
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
           if (e.CommandName == "UseUser")
            {
                int id1;
                if (!int.TryParse(e.CommandArgument.ToString(), out id1))
                    return;

                string query = $"SELECT * FROM Users WHERE userID = {id1}";
                DataTable dt = MAINClass.loadDataTable_DS(query);

                if (dt.Rows.Count > 0)
                {
                    Session["SelectedUserID"] = dt.Rows[0]["userID"].ToString();
                    Session["SelectedUserName"] = dt.Rows[0]["userName"].ToString();
                    Session["SelectedUserPhone"] = dt.Rows[0]["userPhone"].ToString();
                    Session["SelectedUserAddress"] = dt.Rows[0]["userAddress"].ToString();
                }

                Response.Redirect("RMS_SCREEN.aspx");
            }

            if (e.CommandName == "DeleteUser")
                {
                    MAINClass.ExecuteQuery($"DELETE FROM Users WHERE userID = {id}");
                    LoadUsers();
                }
                else if (e.CommandName == "EditUser")
                {
             
                    Response.Write("<script>alert('Edit ID: " + id + "');</script>");
                }
            }
        
    }
}