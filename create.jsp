<%@ page import="java.sql.*" %>
<%
    String location, title;
    String startDate="", endDate="";
    String type, note, reminder;
    String user_id = (String) session.getAttribute("user_id"); //getting the user id for the session

    Connection con= null;


    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String db_user = "jeet";
    String db_pass = "codec";

    try {
        title= request.getParameter("title");
        location= request.getParameter("location");
        startDate= request.getParameter("start_date");
        endDate= request.getParameter("end_date");
        type= request.getParameter("type");
        note= request.getParameter("note");
        //reminder.getParameter("reminder");

        Class.forName("oracle.jdbc.driver.OracleDriver");
        con= DriverManager.getConnection(url, db_user, db_pass);
        PreparedStatement ps= null;

        Timestamp start_date= null;
        Timestamp end_date= null;

        start_date= java.sql.Timestamp.valueOf(startDate.replace("T", " ") + ":00");
        if (endDate!= null && !endDate.isEmpty()) {
            endDate= endDate.replace("T", " ") + ":00";
            end_date= Timestamp.valueOf(endDate);
        }

        ps= con.prepareStatement("INSERT INTO event (title, location, start_date, end_date, type, note, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)");

        ps.setString(1, title);
        ps.setString(2, location);
        ps.setTimestamp(3, start_date);
        ps.setTimestamp(4, end_date);
        ps.setString(5, type);
        ps.setString(6, note);
        ps.setString(7, user_id);
        ps.executeUpdate();

        %><script>
            alert('Event has been created successfully');
            window.location.replace("home.jsp");
        </script><%

    } 
    catch (Exception e) {
        //  %><script>
        //    window.location.replace("fail.html");
        // </script><%
        out.println(e);
    }
    finally {
        con.close();
    }
%>