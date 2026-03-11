using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class Staff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindStaff();
            }
        }

 
        private void BindStaff()
        {
            string query = @"SELECT * FROM Staff";
            MAINClass.loadData(query, gvStaff);
        }

        protected void btnSaveStaff_Click(object sender, EventArgs e)
        {
            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>
                {
                    {"@name", txtStaffName.Text.Trim() },
                    {"@role", ddStaffRole.SelectedValue },
                    {"@phone", txtStaffPhone.Text.Trim() },
                    {"@salary", txtStaffSalary.Text.Trim() },
                    {"@status", ddStaffStatus.SelectedValue }
                };

                string query = "";

                if (string.IsNullOrEmpty(hfStaffID.Value))
                {
                 
                    query = @"INSERT INTO Staff (staffName, staffRole, staffPhone, staffSalary, staffStatus)
                              VALUES (@name, @role, @phone, @salary, @status)";
                }
                else
                {
                  
                    query = @"UPDATE Staff SET
                                staffName=@name,
                                staffRole=@role,
                                staffPhone=@phone,
                                staffSalary=@salary,
                                staffStatus=@status
                              WHERE staffID=@id";

                    param.Add("@id", hfStaffID.Value);
                }

                int res = MAINClass.SQL(query, param);
                if (res > 0)
                {
                    BindStaff();
                    ClearForm();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

    
        protected void gvStaff_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteRow")
            {
                string query = "DELETE FROM Staff WHERE staffID=@id";
                Dictionary<string, object> param = new Dictionary<string, object> { { "@id", id } };
                MAINClass.SQL(query, param);
                BindStaff();
            }
            else if (e.CommandName == "EditRow")
            {
                LoadStaff(id);
            }
        }

    
        private void LoadStaff(int id)
        {
            string query = "SELECT * FROM Staff WHERE staffID=@id";
            Dictionary<string, object> param = new Dictionary<string, object> { { "@id", id } };

            DataTable dt = MAINClass.loadDataTable(query, param);

            if (dt.Rows.Count > 0)
            {
                txtStaffName.Text = dt.Rows[0]["staffName"].ToString();
                ddStaffRole.SelectedValue = dt.Rows[0]["staffRole"].ToString();
                txtStaffPhone.Text = dt.Rows[0]["staffPhone"].ToString();
                txtStaffSalary.Text = dt.Rows[0]["staffSalary"].ToString();
                ddStaffStatus.SelectedValue = dt.Rows[0]["staffStatus"].ToString();
                hfStaffID.Value = dt.Rows[0]["staffID"].ToString();
                btnSaveStaff.Text = "Update Staff";
            }
        }

    
        private void ClearForm()
        {
            txtStaffName.Text = "";
            ddStaffRole.SelectedIndex = 0;
            txtStaffPhone.Text = "";
            txtStaffSalary.Text = "";
            ddStaffStatus.SelectedIndex = 0;
            hfStaffID.Value = "";
            btnSaveStaff.Text = "Save Staff";
        }
    }
}
