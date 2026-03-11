using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace restaurants_management_system
{
    public partial class Tables : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTables();
            }
        }

        private void LoadTables()
        {
         
            string qry = "SELECT tableID, tableName, tableStatus, capacity FROM [RESTTables]";
            MAINClass.loadData(qry, gvTables);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtTableName.Text) || string.IsNullOrWhiteSpace(txtCapacity.Text))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please fill all fields');", true);
                    return;
                }

                string qry;
                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("@name", txtTableName.Text.Trim());
                parameters.Add("@status", ddStatus.SelectedValue);
                parameters.Add("@cap", txtCapacity.Text.Trim());

                if (string.IsNullOrEmpty(hfTableID.Value))
                {
                   
                    qry = "INSERT INTO [RESTTables] (tableName, tableStatus, capacity) VALUES (@name, @status, @cap)";
                }
                else
                {
                   
                    qry = "UPDATE [RESTTables] SET tableName=@name, tableStatus=@status, capacity=@cap WHERE tableID=@id";
                    parameters.Add("@id", hfTableID.Value);
                }

                int result = MAINClass.SQL(qry, parameters);

                if (result > 0)
                {
                   // ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Data Saved Successfully!');", true);
                    ClearAll();
                    LoadTables();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('SQL Execution failed. Check if connection is open.');", true);
                }
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "");
                ScriptManager.RegisterStartupScript(this, GetType(), "exception", $"alert('Database Error: {msg}');", true);
            }
        }

        protected void gvTables_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                hfTableID.Value = gvTables.DataKeys[index].Value.ToString();
                GridViewRow row = gvTables.Rows[index];

                txtTableName.Text = row.Cells[1].Text.Replace("&nbsp;", "");

                
                Label lblStatus = (Label)row.FindControl("lblStatus");
                if (lblStatus != null)
                {
                   
                    if (ddStatus.Items.FindByValue(lblStatus.Text) != null)
                        ddStatus.SelectedValue = lblStatus.Text;
                }

                
                txtCapacity.Text = row.Cells[3].Text.Replace("&nbsp;", "");

                btnSave.Text = "Update Table";
            }
            else if (e.CommandName == "DeleteRow")
            {
                string id = e.CommandArgument.ToString();

                
                string qry = "DELETE FROM [RESTTables] WHERE tableID=@id";

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("@id", id);

                MAINClass.SQL(qry, parameters);
                LoadTables();

               // ScriptManager.RegisterStartupScript(this, GetType(), "delSuccess", "alert('Table Deleted Successfully!');", true);
            }
        }

        private void ClearAll()
        {
            txtTableName.Text = "";
            txtCapacity.Text = "";
            ddStatus.SelectedIndex = 0;
            hfTableID.Value = "";
            btnSave.Text = "Save Table";
        }
    }
}