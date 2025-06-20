<%@ page import="java.sql.*" %>

<%
    String user_name = request.getParameter("user_name");
    String user_id = request.getParameter("user_id");
    String password = request.getParameter("password");
    String con_password = request.getParameter("con_password");

    if (!password.equals(con_password)) {
        out.println("Password mismatch !!");
    } else {
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String db_user = "jeet";
        String db_pass = "codec";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, db_user, db_pass);

            String sql = "INSERT INTO login_details (user_id, password, user_name) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user_id);
            pstmt.setString(2, password);
            pstmt.setString(3, user_name);

            pstmt.executeUpdate();
         %>
            <script>
                alert("Registration successful.");
                window.location.href="index.html";
            </script>
        <%
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>
<!-- <button onclick="history.back()">Back</button> -->
