using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public partial class Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                BindProducts();
            }
        }

        private void BindCategories()
        {
            // Yahan Categories table ka column name 'catID' ya 'categoryID' check kar lein
            string query = "SELECT catID, catName FROM Categories";
            MAINClass.loadDropDown(query, ddCategory, "catName", "catID");
        }

        private void BindProducts()
        {
            // Fix: 'categoryID' column name used as per your screenshot
            string query = @"SELECT p.prodID, p.prodName, p.prodPrice, p.prodStatus, p.prodImage, c.catName 
                             FROM Products p 
                             INNER JOIN Categories c ON p.categoryID = c.catID";
            MAINClass.loadData(query, gvProducts);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string imageName = "default.png";
                Dictionary<string, object> param = new Dictionary<string, object>();

                param.Add("@n", txtProdName.Text.Trim());
                param.Add("@c", ddCategory.SelectedValue);
                param.Add("@p", txtPrice.Text.Trim());
                param.Add("@s", ddStatus.SelectedValue);

                if (fuProductImage.HasFile)
                {
                    imageName = Guid.NewGuid() + Path.GetExtension(fuProductImage.FileName);
                    string path = Server.MapPath("~/Uploads/Products/");
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    fuProductImage.SaveAs(path + imageName);
                }
                param.Add("@i", imageName);

                string query = "";
                if (string.IsNullOrEmpty(hfProdID.Value))
                {
                    // Fix: 'categoryID' used here
                    query = "INSERT INTO Products (prodName, categoryID, prodPrice, prodStatus, prodImage) VALUES (@n, @c, @p, @s, @i)";
                }
                else
                {
                    // Fix: Update query with corrected column
                    query = @"UPDATE Products SET prodName=@n, categoryID=@c, prodPrice=@p, prodStatus=@s, 
                              prodImage = CASE WHEN @i='default.png' THEN prodImage ELSE @i END 
                              WHERE prodID=@id";
                    param.Add("@id", hfProdID.Value);
                }

                int result = MAINClass.SQL(query, param);
                if (result > 0) Response.Redirect("Products.aspx");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                DataTable dt = MAINClass.loadDataTable("SELECT * FROM Products WHERE prodID=@id", new Dictionary<string, object> { { "@id", id } });

                if (dt.Rows.Count > 0)
                {
                    txtProdName.Text = dt.Rows[0]["prodName"].ToString();
                    txtPrice.Text = dt.Rows[0]["prodPrice"].ToString();
                    ddCategory.SelectedValue = dt.Rows[0]["categoryID"].ToString(); 
                    ddStatus.SelectedValue = dt.Rows[0]["prodStatus"].ToString();
                    hfProdID.Value = dt.Rows[0]["prodID"].ToString();
                    btnSave.Text = "Update Product";
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                MAINClass.SQL("DELETE FROM Products WHERE prodID=@id", new Dictionary<string, object> { { "@id", id } });
                BindProducts();
            }
        }
    }
}