<%@ WebHandler Language="C#" Class="ProductImage" %>

using System;
using System.Web;
using System.IO;

public class ProductImage : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            // Get filename from query string
           // string fileName = context.Request.QueryString["file"];
string fileName = context.Request.QueryString["file"];
            if (string.IsNullOrEmpty(fileName))
            {
                SendPlaceholder(context);
                return;
            }

            // Build full path inside project

string filePath = context.Server.MapPath("~/Uploads/Products/" + fileName);
            //string filePath = context.Server.MapPath("~/Uploads/Products/" + fileName);

            if (File.Exists(filePath))
            {
                string ext = Path.GetExtension(filePath).ToLower();
                string contentType = "image/jpeg";

                switch (ext)
                {
                    case ".png": contentType = "image/png"; break;
                    case ".gif": contentType = "image/gif"; break;
                    case ".jpg":
                    case ".jpeg": contentType = "image/jpeg"; break;
                }

                context.Response.Clear();
                context.Response.ContentType = contentType;
                context.Response.TransmitFile(filePath);
                context.Response.End();
            }
            else
            {
                SendPlaceholder(context);
            }
        }
        catch
        {
            SendPlaceholder(context);
        }
    }

    private void SendPlaceholder(HttpContext context)
    {
        // Show a simple "No image" placeholder (50x50 gray)
        byte[] pngData = Convert.FromBase64String(
            "iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAAGXRFWHRTb2Z0d2Fy" +
            "ZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAiBJREFUeNrs1kEOgCAQBdF3//zkuVR" +
            "w6zZop4Lk9nLw3DoD9Fkc8Wjxv1+qYQwUK2TLMp4ykJUwAIAAAQIECBAgAABAgQI" +
            "CBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBA" +
            "gAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBwB5lAABBgAH1XqgG" +
            "v3q0wAAAABJRU5ErkJggg==");

        context.Response.Clear();
        context.Response.ContentType = "image/png";
        context.Response.OutputStream.Write(pngData, 0, pngData.Length);
        context.Response.End();
    }

    public bool IsReusable { get { return false; } }
}