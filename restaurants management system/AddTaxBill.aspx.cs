using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class AddTaxBill : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTaxRecords();
                txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void LoadTaxRecords()
        {
            DataTable dt = MAINClass.loadDataTable_DS("SELECT * FROM TaxDatabase ORDER BY TaxID DESC");
            gvTax.DataSource = dt;
            gvTax.DataBind();
        }

        protected void btnSaveTax_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtPercentage.Text)) return;

            string query = "";
            if (string.IsNullOrEmpty(hfTaxID.Value)) // Insert
            {
                query = $@"INSERT INTO TaxDatabase (TaxName, TaxPercentage, EffectiveFrom) 
                          VALUES ('{ddlTaxType.SelectedValue}', {txtPercentage.Text}, '{txtDate.Text}')";
            }
            else // Update
            {
                query = $@"UPDATE TaxDatabase SET TaxName='{ddlTaxType.SelectedValue}', 
                          TaxPercentage={txtPercentage.Text}, EffectiveFrom='{txtDate.Text}' 
                          WHERE TaxID={hfTaxID.Value}";
            }

            MAINClass.ExecuteQuery(query);
            ResetForm();
            LoadTaxRecords();
        }

        protected void gvTax_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                hfTaxID.Value = gvTax.DataKeys[index].Value.ToString();
                ddlTaxType.SelectedValue = gvTax.Rows[index].Cells[1].Text;
                txtPercentage.Text = gvTax.Rows[index].Cells[2].Text;
                // Date parsing logic if needed
                btnSaveTax.Text = "Update Tax Record";
            }
            else if (e.CommandName == "DeleteRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                MAINClass.ExecuteQuery($"DELETE FROM TaxDatabase WHERE TaxID={id}");
                LoadTaxRecords();
            }
        }

        private void ResetForm()
        {
            hfTaxID.Value = "";
            txtPercentage.Text = "";
            btnSaveTax.Text = "Save Tax Record";
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
    }
}