<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ADMINLOGIN.aspx.cs" Inherits="restaurants_management_system.ADMINLOGIN" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Restaurants Management System - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
     body {
    margin: 0;
    padding: 0;
    font-family: 'Poppins', sans-serif;
    background-color: #fdf2e9; 
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    overflow-x: hidden;
}

@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes slideInLeft {
    from { opacity: 0; transform: translateX(-50px); }
    to { opacity: 1; transform: translateX(0); }
}

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.bg-strip {
    position: absolute;
    left: 18%;
    top: 0;
    width: 160px;
    height: 100%;
    background-color: #f2dcc8;
    z-index: 1;
}

.container {
    width: 90%;
    max-width: 1200px;
    display: flex;
    position: relative;
    z-index: 2;
    align-items: center;
    padding: 20px;
}

.image-side {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 20px;
    animation: slideInLeft 1s ease-out;
}

.food-img {
    width: 200px;
    height: 200px;
    border-radius: 50%;
    object-fit: cover;
    box-shadow: 20px 20px 40px rgba(0,0,0,0.1);
    animation: float 4s ease-in-out infinite;
}

.pos-1 { margin-left: -40px; animation-delay: 0.2s; }
.pos-2 { margin-left: 80px; animation-delay: 0.5s; }
.pos-3 { margin-left: -20px; animation-delay: 0.8s; }

.login-side {
    flex: 1.2;
    padding-left: 50px;
    animation: fadeInUp 1s ease-out;
}

.gradient-title {
    font-size: clamp(2.5rem, 8vw, 4rem); 
    font-weight: 800;
    margin: 0;
    background: linear-gradient(90deg, #9e5a12 0%, #d48011 50%, #e6a04d 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    letter-spacing: -1px;
}

.sub-text {
    color: #5c4033;
    font-size: 1.2rem;
    margin-bottom: 30px;
}

.form-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
    max-width: 400px;
}

.input-box {
    padding: 16px 25px;
    border: 1.5px solid #d48011;
    border-radius: 50px;
    outline: none;
    font-size: 1rem;
    background-color:#fdf2e9;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.input-box:hover {
    border-color: #9e5a12;
    transform: translateY(-2px);
}

.input-box:focus {
    box-shadow: 0 10px 20px rgba(212, 128, 17, 0.15);
    background-color: #fff;
    transform: scale(1.02);
}

.btn-login {
    background: linear-gradient(to right, #d48011, #b56d0e);
    color: white;
    border: none;
    padding: 15px 50px;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 8px 20px rgba(212, 128, 17, 0.4);
    transition: 0.3s;
    width: fit-content;
}

.btn-login:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 25px rgba(212, 128, 17, 0.6);
}

.ddl-role {
    -webkit-appearance: none; 
    -moz-appearance: none;    
    appearance: none;         
    padding: 16px 25px;
    border: 1.5px solid #d48011;
    border-radius: 50px;
    outline: none;
    font-size: 1rem;
    background-color: #fdf2e9;
    background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16'%3E%3Cpath fill='%239e5a12' d='M4 6l4 4 4-4z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 15px center;
    background-size: 12px;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    cursor: pointer;
}

.ddl-role:hover {
    border-color: #9e5a12;
    transform: translateY(-2px);
}

.ddl-role:focus {
    box-shadow: 0 10px 20px rgba(212, 128, 17, 0.15);
    background-color: #fff;
    transform: scale(1.02);
}


@media (max-width: 900px) {
    body { overflow-y: auto; }
    .bg-strip, .image-side { display: none; }
    .container { justify-content: center; text-align: center; padding-top: 50px; }
    .login-side { padding-left: 0; width: 100%; }
    .form-container { max-width: 100%; margin: 0 auto; }
    .btn-login { width: 100%; }
}


@media (max-width: 480px) {
    .gradient-title { font-size: 2rem; }
    .sub-text { font-size: 1rem; }
    .input-box, .ddl-role { padding: 14px 20px; font-size: 0.95rem; }
    .btn-login { padding: 14px 0; font-size: 1rem; }
}
    </style>
</head>
<body>
    <div class="bg-strip"></div>
    <form id="form1" runat="server">
        <div class="container">
            <div class="image-side">
                <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400" class="food-img pos-1" alt="Pizza" />
                <img src="https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400" class="food-img pos-2" alt="Healthy" />
                <img src="https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400" class="food-img pos-3" alt="Cake" />
            </div>
            <div class="login-side">
                <h1 class="gradient-title">Access the Master Menu</h1>
                <p class="sub-text">Let's get you started!</p>
                <div class="form-container">
                    <asp:TextBox ID="txtUser" runat="server" placeholder="Username" class="input-box"></asp:TextBox>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" placeholder="Password" class="input-box"></asp:TextBox>
                     
<asp:DropDownList ID="ddlRole" runat="server" CssClass="input-box ddl-role">
    <asp:ListItem Text="Select Role" Value=""></asp:ListItem>
    <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
    <asp:ListItem Text="RMS_SCREEN" Value="RMS_SCREEN"></asp:ListItem>
    <asp:ListItem Text="Kitchen" Value="Kitchen"></asp:ListItem>
</asp:DropDownList>
<asp:Button ID="btnLogin" runat="server" Text="Login" class="btn-login" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblMessage" runat="server" Style="display: block; margin-top: 10px; font-weight: bold; text-align: center; color: #e74c3c;"></asp:Label> 
                </div>

              
              
            </div>
        </div>
    </form>
</body>
</html>