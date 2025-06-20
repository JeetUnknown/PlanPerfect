<%@ page import="java.sql.*, java.util.Date, java.sql.Timestamp" %>
<%
    String title;
    String startDate="";
    String endDate="";
    String note, reminder;

    Connection con= null;

    try {
        title= request.getParameter("title");
        endDate= request.getParameter("deadline");
        note= request.getParameter("note");
        //reminder.getParameter("reminder");

        Class.forName("oracle.jdbc.driver.OracleDriver");
        con= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "database", "database");
        PreparedStatement ps= null;

        Date currentDate= new Date();
        Timestamp current_date= new Timestamp(currentDate.getTime());
        Timestamp deadline= null;

        if (endDate!= null && !endDate.isEmpty()) {
            endDate= endDate.replace("T", " ") + ":00";
            deadline= Timestamp.valueOf(endDate);
        }

        ps= con.prepareStatement("INSERT INTO TASK (title, start_time, deadline, last_complete, note) VALUES (?, ?, ?, ?, ?)");

        ps.setString(1, title);
        ps.setTimestamp(2, current_date);
        ps.setTimestamp(3, deadline);
        ps.setTimestamp(4, current_date);
        ps.setString(5,note);
        ps.executeUpdate();

        %><script>
            alert('Task created');
            window.location.replace("home.jsp");
        </script><%

    } 
    catch (Exception e) {
        out.println(e);
    }
    finally {
        con.close();
    }
%>