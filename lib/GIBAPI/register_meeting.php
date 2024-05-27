 <?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 $servername = "207.174.212.202";
  $username = "kanin7w7_gibErode";
  $password = "Kanxtl@6868#";
  $dbname = "kanin7w7_gibErode";

 // Create connection
 $conn = mysqli_connect($servername, $username, $password, $dbname);




 if ($_SERVER['REQUEST_METHOD'] === 'GET') {
     $user_id = isset($_GET['user_id']) ? mysqli_real_escape_string($conn, $_GET['user_id']) : "";
     $meeting_id = isset($_GET['meeting_id']) ? mysqli_real_escape_string($conn, $_GET['meeting_id']) : "";

     $register_meetinglist = "SELECT * FROM register_meeting WHERE user_id ='$user_id' AND meeting_id ='$meeting_id'";
     $register_meetingResult = mysqli_query($conn, $register_meetinglist);

     $register_meeting = array(); // Initialize the array

     if ($register_meetingResult) {
         while ($row = mysqli_fetch_assoc($register_meetingResult)) {
             $register_meeting[] = $row;
         }
     }

     echo json_encode($register_meeting); // Always encode the array
 }

else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
   $data = json_decode(file_get_contents("php://input"));

       // Define upload directory and path

   $meeting_id = mysqli_real_escape_string($conn, $data->meeting_id);
   $meeting_name = mysqli_real_escape_string($conn, $data->meeting_name);
   $meeting_type = mysqli_real_escape_string($conn, $data->meeting_type);
   $meeting_date = mysqli_real_escape_string($conn, $data->meeting_date);
   $meeting_place = mysqli_real_escape_string($conn, $data->meeting_place);
   $user_id = mysqli_real_escape_string($conn, $data->user_id);
   $user_type = mysqli_real_escape_string($conn, $data->user_type);
   $status = mysqli_real_escape_string($conn, $data->status);


                  $insertUserQuery = "INSERT INTO `register_meeting`( `meeting_date`, `meeting_type`, `meeting_id`, `user_id`, `user_type`, `meeting_place`, `status`)
                  VALUES ('$meeting_date','$meeting_type','$meeting_id','$user_id','$user_type','$meeting_place','$status')";
                  $insertUserResult = mysqli_query($conn, $insertUserQuery);

      if ($insertUserResult) {
          echo json_encode(["success" => true, "message" => "RegisterMeeting stored successfully"]);
      } else {
          echo json_encode(["success" => false, "message" => "Error: " . mysqli_error($conn)]);
      }

}


mysqli_close($conn);
?>