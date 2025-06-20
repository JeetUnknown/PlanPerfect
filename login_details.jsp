<%@ page import="java.sql.*" %>

<%
    String user_id = request.getParameter("user_id");
    String password = request.getParameter("password");

    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String db_user = "jeet";
    String db_pass = "codec";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, db_user, db_pass);

        String sql = "SELECT password from login_details where user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("password");
            if (storedPassword.equals(password)) {
                session.setAttribute("user_id", user_id); //setting the user id for the session
                %>
                <script>
                alert("Login successful!");
                window.location.href="home.jsp";
                </script>
                <%
            } else {
                %>
                <script>
                alert("Incorrect password.");
                window.location.href="login.html";
                </script>
                <%
            }
        } else {
            %>
            <script>
                alert("User ID does not exist.");
                window.location.href="login.html";
            </script>
            <%
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
    finally {
        rs.close();
        pstmt.close();
        conn.close();
    }
%>
<!-- <button onclick="history.back()">Home</button>
<form method="post" action="../home.jsp">
    <input type="hidden" name="user_id" value="<%=user_id%>">
</form> -->