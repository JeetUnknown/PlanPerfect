<%@ page import="java.sql.*" %>
<%
    Connection con= null;
    PreparedStatement search= null;
    int id=0;

    String title= null;
    Timestamp startDate= null;
    Timestamp endDate= null;
    String location= null;
    String type= null;
    String note= null; 
    String endDateStr= null;
    String endDateString= "";
    String startDateString= "";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "jeet", "codec");

        id= Integer.parseInt(request.getParameter("search_id"));

        search= con.prepareStatement("SELECT * FROM EVENT WHERE ID= ?");
        search.setInt(1, id);
        ResultSet res= search.executeQuery();

        if (res.next()) {
            title= res.getString("TITLE");
            startDate= res.getTimestamp("START_DATE");
            startDateString= startDate.toLocalDateTime().toString().substring(0, 16);
            endDate= res.getTimestamp("END_DATE");
            if (endDate!= null)
                endDateString= endDate.toLocalDateTime().toString().substring(0, 16);
            location= res.getString("LOCATION");   
            if(location== null)
                location="";
            type= res.getString("TYPE");
            note= res.getString("NOTE");   
            if(note== null)
                note=""; 
        }
        else {
            throw new Exception();
        }
    } 
    catch (Exception e) {
        out.println("Error: " +e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>View Event</title>
  <link rel="icon" type="image/png" href="logo1.png">
  <link rel="stylesheet" href="form.css">
</head>
<body>
  <div class="container">
    <h2>Event Details</h2>
    <form method="post" action="update.jsp" class="form">
      <input type="hidden" name="search_id" id="search" value="<%=id%>">
      
      <label for="title">Title:</label>
      <input type="text" class="track" id="title" name="title" minlength="5" maxlength="23" value="<%=title%>" required>

      <label for="start">Start Date:</label>
      <input type="datetime-local" class="track" id="start_date" name="start_date" value="<%=startDateString%>" required>

      <label for="end">End Date:</label>
      <input type="datetime-local" class="track" id="end_date" name="end_date" value="<%=endDateString%>">

      <label for="location">Location/venue:</label>
      <input type="text" class="track" id="location" name="location" minlength="3" maxlength="30" value="<%=location%>">

      <label for="type">Type:</label>
      <div class="select-group track">
        <!-- Display input, not part of form submission -->
        <input type="text" class="track" id="type_display" value="<%=type%>" readonly>

        <!-- Actual select dropdown for form submission -->
        <select name="type" id="type_select" class="track" style="display: none;" required>
          <option value="Others">Others</option>
          <option value="Birthday">Birthday</option>
          <option value="Anniversary">Anniversary</option>
          <option value="Meeting">Meeting</option>
          <option value="Appointment">Appointment</option>
          <option value="Seminar">Seminar</option>
          <option value="Festival">Festival</option>
          <option value="Match">Match</option>
          <option value="Workshop">Workshop</option>
          <option value="Camps">Camps</option>
          <option value="Movies">Movies</option>
        </select>
      </div>


      <label for="notes">Notes:</label>
      <textarea id="note" class="track" placeholder="Add Notes" name="note" maxlength="200"><%=note%></textarea>

      <label for="reminder">Set reminder?</label>
      <select id="reminder" name="reminder" class="track">
        <option>7 days before</option>
        <option>1 day before</option>
        <option>1 hour before</option>
        <option>30 min before</option>
        <option>set no reminder</option>
      </select>

      <div class="buttons">
        <button type="button" class="reset-btn" id="delete">Delete</button>
        <button type="submit" class="create-btn" id="button_submit" disabled>Update</button>
      </div>
    </form>

    <form method="post" action="delete.jsp" id="form_delete">
        <input type="hidden" name="delete_id" id="delete_id" value="<%=id%>">
    </form>
  </div>
  <script src="detail.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const input = document.getElementById("type_display");
      const select = document.getElementById("type_select");

      // Set the select to the current value
      for (let option of select.options) {
        if (option.value === input.value) {
          option.selected = true;
          break;
        }
      }

      input.addEventListener("click", function () {
        input.style.display = "none";
        select.style.display = "block";
        select.focus();
      });

      select.addEventListener("change", function () {
        input.value = select.value;
        input.style.display = "block";
        select.style.display = "none";
      });
    });
  </script>

</body>
</html>
