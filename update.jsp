<%@ page import="java.sql.*" %>
<%
    String location, title;
    String startDate="", endDate="";
    String type, note, reminder;
    int id=0;
    Connection con= null;

    try {
        id= Integer.parseInt(request.getParameter("search_id"));
        title= request.getParameter("title");
        location= request.getParameter("location");
        startDate= request.getParameter("start_date");
        endDate= request.getParameter("end_date");
        type= request.getParameter("type");
        note= request.getParameter("note");

        Class.forName("oracle.jdbc.driver.OracleDriver");
        con= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "jeet", "codec");
        PreparedStatement ps= null;

        Timestamp start_date= null;
        Timestamp end_date= null;

        start_date= java.sql.Timestamp.valueOf(startDate.replace("T", " ") + ":00");
        if (endDate!= null && !endDate.isEmpty()) {
            endDate= endDate.replace("T", " ") + ":00";
            end_date= Timestamp.valueOf(endDate);
        }

        String sql = "UPDATE EVENT SET TITLE=?, LOCATION=?, START_DATE=?, END_DATE=?, TYPE=?, NOTE=? WHERE ID=?";
        ps= con.prepareStatement(sql);

        ps.setString(1, title);
        ps.setString(2, location);
        ps.setTimestamp(3, start_date);
        ps.setTimestamp(4, end_date);
        ps.setString(5,type);
        ps.setString(6,note);
        ps.setInt(7,id);
        ps.executeUpdate();

        %><script>
            alert('Event has been updated');
            window.location.href = "home.jsp";
        </script><%

    } 
    catch (Exception e) {
         %><script>
            window.location.href = "fail.html";
        </script><%
    }
    finally {
        con.close();
    }
%>