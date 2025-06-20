<%@ page import="java.sql.*" %>
<%
    Connection con= null;
    try {
        int id= Integer.parseInt(request.getParameter("delete_id"));
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "database", "database");
        PreparedStatement ps= null;

        ps= con.prepareStatement("DELETE EVENT WHERE ID= ?");
        ps.setInt(1, id);
        ps.executeQuery();

        %><script>
            alert('Event deleted !!');
            window.location.href = "home.jsp";
        </script><%

    } 
    catch (Exception e) {
        out.println(e);
    }
    finally {
        con.close();
    }
%>