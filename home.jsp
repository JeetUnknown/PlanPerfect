<%@ page import="java.sql.*, java.util.Date, java.sql.Timestamp" %>

<%

  String user_id = (String) session.getAttribute("user_id"); //getting the user id for the session

  Connection con= null;
  PreparedStatement upcoming= null;     
  PreparedStatement today= null;    
  PreparedStatement task= null;

  ResultSet upcoming_list= null;
  ResultSet today_list= null;  
  ResultSet task_list= null;  

  String url = "jdbc:oracle:thin:@localhost:1521:xe";
  String db_user = "jeet";
  String db_pass = "codec";

  try {

    // Connect the jdbc with oracle data base
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con= DriverManager.getConnection(url, db_user, db_pass);

    // Get the current system date & time and convert into timestamp data type
    Date currentDate= new Date();
    Timestamp current_date= new Timestamp(currentDate.getTime());

    // Query for getting id, title and the date of the upcoming events....
    upcoming= con.prepareStatement("SELECT ID, TITLE, TO_CHAR(START_DATE, 'DD MON') AS START_DATE FROM EVENT WHERE USER_ID = ? AND TRUNC(START_DATE)> TRUNC(SYSDATE) ORDER BY START_DATE DESC");  

    upcoming.setString(1, user_id);
    
    // Store the result(table) to upcoming_list
    upcoming_list= upcoming.executeQuery();

    // Query for getting id, title and the time of the today's events....
    today= con.prepareStatement("SELECT TITLE, ID, TO_CHAR(START_DATE, 'HH:MI AM') AS START_TIME FROM EVENT WHERE USER_ID = ? AND TRUNC(START_DATE)= TRUNC(SYSDATE) ORDER BY START_DATE");

    today.setString(1, user_id);

    // Store the result(table) to today_list
    today_list= today.executeQuery();

    // Query for getting id, title and the deadline of the task....
    task= con.prepareStatement("SELECT TITLE, ID, TO_CHAR(DEADLINE, 'DD MON') AS DEADLINE FROM TASK WHERE TRUNC(DEADLINE) >= TRUNC(SYSDATE) ORDER BY DEADLINE");

    // Store the result(table) to task_list
    task_list= task.executeQuery();
  }
  catch(Exception e) {
    out.println("something went wrong!!");
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>PlanPerfct</title>
  <link rel="icon" type="image/png" href="logo1.png">
  <link rel="stylesheet" href="home.css" />
</head>

<body>
  <%-- user profile, and app logo --%>
  <div class="dashboard">
    <header class="header1">
      <div style="display: flex;" class="logo">
        <a><img src="logo1.png" alt="Logo"></a>
        <p>PlanPerfect</p>
      </div>
      <div class="user">
        <span id="user"><%=user_id%></span>
        <a id="user_face"><img src="face2.jpg" alt="face" class="face"></a>
      </div>
    </header>

    <%-- rest of the body, includes upcoming, today and assigned task --%>
    <div class="container" id="container">

      <%-- Upcoming event body --%>
      <section class="container_upcoming">
        <h2>Upcoming Events</h2>
        <%-- search box to search upcoming events --%>
        <div class="search-box" id="search-box">
          <input type="search" placeholder="Search..." id="search_ip">
          <button id="search">Search</button>
        </div><br>

        <%-- upcoming event list --%>
        <div class="upcoming-event-list">
          <%-- if there are events, fetch data from upcoming_list in jsp --%>
          <%
            boolean flag_upcoming= false;
            while(upcoming_list.next()) {
              flag_upcoming= true;
              String title= upcoming_list.getString("TITLE");
              int id= upcoming_list.getInt("ID");
              String date= upcoming_list.getString("START_DATE");
            %>
            <%-- store into div --%>
              <div class="upcoming-event-title" id="<%=id%>">
                <strong><%=title%></strong>
                <span></span>
                <p><%=date%></p>
              </div>
            <%
            }

            //if there are no upcoming show the picture
            if(!flag_upcoming) {
            %> 
              <div id="no-u-event">
                <a><img src="noUpcoming.png" class="no-upcoming-event"></a>
              </div>
            <%
            }
          %>

        </div>
      </section>

      <%-- Today event body --%>
      <section class="events">
        <h2>Today's Events</h2><br>

        <%-- list of today events --%>
        <div class="today-event-list">
          <%-- if there any today events add it in div class --%>
          <%
            boolean flag_today= false;
            while(today_list.next()) {
              flag_today= true;
              String title= today_list.getString("TITLE");
              int id= today_list.getInt("ID");
              String time= today_list.getString("START_TIME");
            %>
            <div class="today-event-title" id="<%=id%>">
              <span></span>
              <div>
                <strong><%=title%></strong>
                <p><%=time%></p>
              <div>
            </div>
            <%
            }

            //if there are no today events show the picture
            if(!flag_today) {
            %>
              <div id="no-t-event">
                <a><img src="noTodayEvent.png" class="no-today-event"></a>
              </div>
            <%
            }
          %>
        </div>
      </section>

      <%-- Assigned task body --%>
      <section class="container_assigned">
        <%-- + sign for adding task --%>
        <h2>Assigned Tasks <a href="create_task.html"><img src="plus.jpg" alt="add" class="add"></a></h2>
        <br><br>

        <%-- if there any task add it in div --%>
        <%
        // fetch from data base
        boolean task_flag= false;
        while(task_list.next()) {
          task_flag= true;
          String title= task_list.getString("TITLE");
          int id= task_list.getInt("ID");
          String deadline= task_list.getString("DEADLINE");
        %>
          <div class="task">
            <input type="checkbox">
            <span></span>
            <strong><%=title%></strong>
            <span></span>
            <p><%=deadline%></P>
          </div>
        <%
        }

        // if there are no task, then show the pic
        if(!task_flag) {
        %>
          <div id="no-task">
            <a><img src="noTask.png" class="no-task"></a>
          </div>
        <%
        }
        %>
      </section>
    
    </div>
  </div>

  <%-- button for create event --%>
  <button class="create-event-btn" onclick="window.location.href='create.html'">+ Create Event</button>

  <%-- hidden form to pass id of an event to another jsp page --%>
  <form method="post" action="details.jsp" id="form_detail">
    <input type="hidden" id="detail" name="search_id">
  </form>

  <%-- conect with javascript file --%>
  <script src="home.js"></script>

</body>
</html>