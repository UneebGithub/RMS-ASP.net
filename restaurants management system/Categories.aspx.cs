using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class Categories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();

            }
        }

        private void LoadData()
        {
            // GridView ko fresh data se load karne ke liye
            string query = "SELECT catID, catName, catStatus, catImage FROM Categories ORDER BY catID DESC";
            MAINClass.loadData(query, gvCategories);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCatName.Text)) return;

            string query = "";
            var parameters = new Dictionary<string, object>();
            parameters.Add("@name", txtCatName.Text.Trim());
            parameters.Add("@status", ddStatus.SelectedValue);

            string imageName = "default.png";

            if (fuImage.HasFile)
            {
                imageName = Guid.NewGuid().ToString() + Path.GetExtension(fuImage.FileName);
                string path = Server.MapPath("~/Uploads/Categories/");
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                fuImage.SaveAs(path + imageName);
                parameters.Add("@img", imageName);
            }

            if (string.IsNullOrEmpty(hfCatID.Value))
            {
                // Agar ID nahi hai to INSERT karein
                if (!fuImage.HasFile) parameters.Add("@img", "default.png");
                query = "INSERT INTO Categories (catName, catStatus, catImage) VALUES (@name, @status, @img)";
            }
            else
            {
                // Agar ID hai to UPDATE karein
                parameters.Add("@id", hfCatID.Value);
                if (fuImage.HasFile)
                    query = "UPDATE Categories SET catName=@name, catStatus=@status, catImage=@img WHERE catID=@id";
                else
                    query = "UPDATE Categories SET catName=@name, catStatus=@status WHERE catID=@id";
            }

            if (MAINClass.SQL(query, parameters) > 0)
            {
                ClearForm();
                LoadData();
            }
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                // MAINClass ka loadDataTable use karke DB se fresh data uthayein
                string query = "SELECT * FROM Categories WHERE catID = @id";
                var param = new Dictionary<string, object> { { "@id", id } };
                DataTable dt = MAINClass.loadDataTable(query, param);

                if (dt.Rows.Count > 0)
                {
                    hfCatID.Value = dt.Rows[0]["catID"].ToString();
                    txtCatName.Text = dt.Rows[0]["catName"].ToString();
                    ddStatus.SelectedValue = dt.Rows[0]["catStatus"].ToString();
                    btnSave.Text = "Update Category"; // Button ka text change karein
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                string query = "DELETE FROM Categories WHERE catID=@id";
                var parameters = new Dictionary<string, object> { { "@id", id } };
                MAINClass.SQL(query, parameters);
                LoadData(); // Grid refresh karein
            }
        }

        private void ClearForm()
        {
            txtCatName.Text = "";
            ddStatus.SelectedIndex = 0;
            hfCatID.Value = "";
            btnSave.Text = "Save Category";
        }
    }
}