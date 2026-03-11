using System;
using System.Collections.Generic;
using System.Data;

namespace restaurants_management_system
{
    public partial class ADMINLOGIN : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack) { lblMessage.Text = ""; }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txtUser.Text.Trim();
            string pass = txtPass.Text.Trim();
            string role = ddlRole.SelectedValue;

            
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass) || role == "")
            {
                lblMessage.Text = "Username, Password aur Role select karein!";
                return;
            }

            
            string query = "SELECT Role FROM LOGINREST WHERE UserName = @u AND Password = @p AND Role = @r";

            Dictionary<string, object> parameters = new Dictionary<string, object>();
            parameters.Add("@u", user);
            parameters.Add("@p", pass);
            parameters.Add("@r", role);

            
            DataTable dt = MAINClass.loadDataTable(query, parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
            
                string dbRole = dt.Rows[0]["Role"].ToString();

                Session["User"] = user;
                Session["Role"] = dbRole;

            
                if (dbRole == "Admin")
                {
                    Response.Redirect("Dashboard.aspx");
                }
                else if (dbRole == "RMS_SCREEN")
                {
                    Response.Redirect("RMS_SCREEN.aspx");
                }
                else if (dbRole == "Kitchen")
                {
                    Response.Redirect("KIT.aspx");
                }
            }
            else
            {
                lblMessage.Text = "Login fail! User ya Password galat hai.";
            }
        }
    }
}