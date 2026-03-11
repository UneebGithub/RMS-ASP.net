using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace restaurants_management_system
{
    public class MAINClass
    {
        public static string GetConnectionString()
        {
            return @"Data Source=192.168.18.7, 1433;Initial Catalog=RestaurantDB;User ID=sa;Password=123;";
        }
        public static int Execute(string query, object[] parameters = null)
        {
            int res = 0;
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(query, con);
                    if (parameters != null)
                    {
                        for (int i = 0; i < parameters.Length; i += 2)
                            cmd.Parameters.AddWithValue(parameters[i].ToString(), parameters[i + 1] ?? DBNull.Value);
                    }
                    if (con.State == System.Data.ConnectionState.Closed) con.Open();
                    res = cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("<script>alert('SQL Error: " + ex.Message.Replace("'", "") + "');</script>");
                    res = 0;
                }
            }
            return res;
        }



        public static object Scalar(string query, object[] parameters = null)
        {
            object res = null;
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(query, con);
                    if (parameters != null)
                    {
                        for (int i = 0; i < parameters.Length; i += 2)
                            cmd.Parameters.AddWithValue(parameters[i].ToString(), parameters[i + 1] ?? DBNull.Value);
                    }
                    if (con.State == System.Data.ConnectionState.Closed) con.Open();
                    res = cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("<script>alert('Scalar Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
            return res;
        }
        public static int SQL(string query, Dictionary<string, object> parameters)
        {
            int res = 0;
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(query, con);
                    foreach (var p in parameters)
                    {
                        cmd.Parameters.AddWithValue(p.Key, p.Value ?? DBNull.Value);
                    }
                    if (con.State == ConnectionState.Closed) con.Open();
                    res = cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    // Sirf ye line update ki hai taake asli error nazar aaye
                    System.Web.HttpContext.Current.Response.Write("<script>alert('SQL Error: " + ex.Message.Replace("'", "") + "');</script>");
                    res = 0;
                }
            }
            return res;
        }

        public static void loadData(string query, GridView gv)
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gv.DataSource = dt;
                    gv.DataBind();
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("<script>alert('LoadData Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }


        public static object ExecuteScalar(string query)
        {
            object res = null;
            try
            {
                SqlConnection con = new SqlConnection(GetConnectionString()); // Aapka connection string
                SqlCommand cmd = new SqlCommand(query, con);
                if (con.State == ConnectionState.Closed) con.Open();
                res = cmd.ExecuteScalar();
                con.Close();
            }
            catch (Exception) { res = null; }
            return res;
        }


        public static void loadDropDown(string query, DropDownList dd, string text, string value)
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dd.DataSource = dt;
                    dd.DataTextField = text;
                    dd.DataValueField = value;
                    dd.DataBind();
                    dd.Items.Insert(0, new ListItem("Select Category", "0"));
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("<script>alert('DropDown Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }

        public static DataTable getData(string qry)
        {
            DataTable dt = new DataTable();
            try
            {
              
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    SqlCommand cmd = new SqlCommand(qry, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                // Agar error aaye to console ya alert mein show ho jaye
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
            return dt;
        }

        public static int ExecuteQuery(string qry)
        {
            int res = 0;
            try
            {
                // Connection string wahi use karein jo loadDataTable mein hai
                SqlConnection con = new SqlConnection(GetConnectionString());
                SqlCommand cmd = new SqlCommand(qry, con);
                if (con.State == ConnectionState.Closed) { con.Open(); }
                res = cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception)
            {
                res = 0;
            }
            return res;
        }
        public static DataTable loadDataTable(string query, Dictionary<string, object> parameters)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(query, con);
                    foreach (var p in parameters)
                    {
                        cmd.Parameters.AddWithValue(p.Key, p.Value ?? DBNull.Value);
                    }
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("<script>alert('DataTable Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
            return dt;
        }

        public static DataTable loadDataTable_DS(string query)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        if (con.State == ConnectionState.Closed)
                            con.Open();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Web.HttpContext.Current.Response.Write("<script>alert('loadDataTable_DS Error: " + ex.Message.Replace("'", "") + "');</script>");
                    }
                }
            }
            return dt;
        }

    }
}