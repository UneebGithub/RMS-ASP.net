using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace restaurants_management_system
{
    public partial class LoginHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { LoadUsers(); }
        }

        private void LoadUsers()
        {
            MAINClass.loadData("SELECT * FROM LOGINREST ORDER BY LoginID DESC", gvUsers);
        }

        protected void btnOpenAdd_Click(object sender, EventArgs e)
        {

            hfID.Value = "";
            txtUser.Text = "";
            txtPass.Text = "";
            ddlRole.SelectedIndex = 0;
            litTitle.Text = "Add New User";
            pnlEdit.CssClass = "edit-panel active";
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditUser")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvUsers.Rows[index];

                hfID.Value = row.Cells[0].Text;
                txtUser.Text = row.Cells[1].Text;
                txtPass.Text = row.Cells[2].Text;
                ddlRole.SelectedValue = row.Cells[3].Text;

                litTitle.Text = "Update User Details";
                pnlEdit.CssClass = "edit-panel active";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string qry = "";

            if (string.IsNullOrEmpty(hfID.Value))
            {
                
                qry = $"INSERT INTO LOGINREST (UserName, Password, Role, CreatedAt) VALUES ('{txtUser.Text}', '{txtPass.Text}', '{ddlRole.SelectedValue}', '{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}')";
            }
            else
            {
                
                qry = $"UPDATE LOGINREST SET UserName='{txtUser.Text}', Password='{txtPass.Text}', Role='{ddlRole.SelectedValue}' WHERE LoginID={hfID.Value}";
            }

            if (MAINClass.ExecuteQuery(qry) > 0)
            {
                pnlEdit.CssClass = "edit-panel"; 
                LoadUsers();
                string msg = string.IsNullOrEmpty(hfID.Value) ? "User Added!" : "User Updated!";
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('{msg}');", true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlEdit.CssClass = "edit-panel";
        }

        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string id = gvUsers.DataKeys[e.RowIndex].Value.ToString();
            MAINClass.ExecuteQuery("DELETE FROM LOGINREST WHERE LoginID = " + id);
            LoadUsers();
        }
    }
}