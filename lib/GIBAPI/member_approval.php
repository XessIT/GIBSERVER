<?php
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
     $first_name = isset($_GET['first_name']) ? mysqli_real_escape_string($conn, $_GET['first_name']) : "";
     $email = isset($_GET['email']) ? mysqli_real_escape_string($conn, $_GET['email']) : "";
     $mobile = isset($_GET['mobile']) ? mysqli_real_escape_string($conn, $_GET['mobile']) : "";
     $company_name = isset($_GET['company_name']) ? mysqli_real_escape_string($conn, $_GET['company_name']) : "";
     $admin_rights = isset($_GET['admin_rights']) ? mysqli_real_escape_string($conn, $_GET['admin_rights']) : "";
     $referrer_mobile = isset($_GET['referrer_mobile']) ? mysqli_real_escape_string($conn, $_GET['referrer_mobile']) : "";
     $id = isset($_GET['id']) ? mysqli_real_escape_string($conn, $_GET['id']) : "";


      if(isset($_GET['admin_rights'])){
    $userlist = "SELECT * FROM registration where admin_rights='$admin_rights'";
    }else{
    $userlist ="SELECT * FROM registration order by member_id desc limit 1";
    }

    $userResult = mysqli_query($conn, $userlist);
    if ($userResult && mysqli_num_rows($userResult) > 0) {
            $user = array();
            while ($row = mysqli_fetch_assoc($userResult)) {
                $user[] = $row;
            }
            echo json_encode($user);
        } else {
            echo json_encode(array("message" => "No offers found"));
        }
 }
 // Handle PUT request for updating data
 else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
     // Parse JSON payload from the request
     $data = json_decode(file_get_contents("php://input"));

     // Escape and sanitize data
     $admin_rights = mysqli_real_escape_string($conn, $data->admin_rights);
     $id = mysqli_real_escape_string($conn, $data->id);


     // Update query
     if($admin_rights=="Pending"){
     $updateQuery = "UPDATE registration SET admin_rights = '$admin_rights' WHERE id = $id";
      }elseif ($admin_rights == "Approved") {
                   // Assuming $member_id comes from $data
                   if (isset($data->member_id)) {
                       $member_id = mysqli_real_escape_string($conn, $data->member_id);
                       $updateQuery = "UPDATE registration SET admin_rights = '$admin_rights', member_id='$member_id' WHERE id = $id";
                   }
               }


     if (mysqli_query($conn, $updateQuery)) {
         echo "Record updated successfully";
     } else {
         echo "Error updating record: " . mysqli_error($conn);
     }
 }

 else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
     // Handle the insert/update/delete actions
 $data = json_decode(file_get_contents("php://input"));
 $name = mysqli_real_escape_string($conn, $data->name);
 $discount = mysqli_real_escape_string($conn, $data->discount);
 $user_id = mysqli_real_escape_string($conn, $data->user_id);
 $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
 $validity = mysqli_real_escape_string($conn, $data->validity);

       $insertUserQuery = "INSERT INTO `offers`(`user_id`, `offer_type`, `name`, `discount`, `validity`) VALUES ('$user_id','$offer_type','$name','$discount','$validity')";
       $insertUserResult = mysqli_query($conn, $insertUserQuery);

       if ($insertUserResult) {
         echo "Offers stored successful";
       } else {
         echo "Error: " . mysqli_error($conn);
       }

 }

 mysqli_close($conn);
 ?>