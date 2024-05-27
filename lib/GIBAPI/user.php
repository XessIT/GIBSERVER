<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$servername = "207.174.212.202";
 $username = "kanin7w7_gibErode";
 $password = "Kanxtl@6868#";
 $dbname = "kanin7w7_gibErode";
// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
  http_response_code(500);
  die(json_encode(["error" => "Connection failed: " . mysqli_connect_error()]));
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  if (!isset($_GET['mobile']) || !isset($_GET['password'])) {
    http_response_code(400);
    die(json_encode(["error" => "Mobile and password parameters are required"]));
  }

  // Get data from Flutter app
  $mobile = mysqli_real_escape_string($conn, $_GET['mobile']);
  $password = mysqli_real_escape_string($conn, $_GET['password']);

  // Check if the user exists in the database with the provided mobile and password
  $signInQuery = "SELECT * FROM registration WHERE mobile = '$mobile' AND password = '$password'";
  $signInResult = mysqli_query($conn, $signInQuery);

  if ($signInResult) {
    if (mysqli_num_rows($signInResult) > 0) {
      $userData = mysqli_fetch_assoc($signInResult);
      $userId = $userData['id'];
      $image = file_exists($userData['profile_image']) ? base64_encode(file_get_contents($userData['profile_image'])) : '';

      if ($userData['admin_rights'] == 'Accepted' && $userData['block_status'] == 'UnBlock') {
        echo json_encode([
          "status" => "Authentication successful",
          "member_type" => $userData['member_type'],
          "first_name" => $userData['first_name'],
          "last_name" => $userData['last_name'],
          "district" => $userData['district'],
          "chapter" => $userData['chapter'],
          "native" => $userData['native'],
          "dob" => $userData['dob'],
          "koottam" => $userData['koottam'],
          "kovil" => $userData['kovil'],
          "blood_group" => $userData['blood_group'],
          "s_name" => $userData['s_name'],
          "s_blood" => $userData['s_blood'],
          "WAD" => $userData['WAD'],
          "place" => $userData['place'],
          "s_father_koottam" => $userData['s_father_koottam'],
          "s_father_kovil" => $userData['s_father_kovil'],
          "past_experience" => $userData['past_experience'],
          "website" => $userData['website'],
          "b_year" => $userData['b_year'],
          "email" => $userData['email'],
          "referrer_id" => $userData['referrer_id'],
          "education" => $userData['education'],
          "mobile" => $userData['mobile'],
          'profile_image' => $image,
          'id' => $userId,
          'company_name' => $userData['company_name'],
          'company_address' => $userData['company_address'],
          'business_type' => $userData['business_type'],
          'business_keywords' => $userData['business_keywords'],
        ]);
      } elseif ($userData['admin_rights'] == 'Rejected') {
        http_response_code(403);
        echo json_encode(["error" => "You are Account has been Rejected"]);
      } elseif ($userData['block_status'] == 'Block') {
        http_response_code(403);
        echo json_encode(["error" => "Your Number has been Blocked"]);
      }elseif ($userData['admin_rights'] == 'Waiting') {
        http_response_code(403);
        echo json_encode(["error" => "Your account has not been activated"]);
       }
       else {
        http_response_code(400);
        echo json_encode(["error" => "Invalid conditions for login"]);
      }
    } else {
      http_response_code(401);
      echo json_encode(["error" => "Invalid username or password"]);
    }
  } else {
    http_response_code(500);
    echo json_encode(["error" => "Error: " . mysqli_error($conn)]);
  }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
  // Check if the required parameters are provided
  $putParams = json_decode(file_get_contents("php://input"), true);
  if (!isset($putParams['mobile']) || !isset($putParams['password'])) {
    http_response_code(400);
    die(json_encode(["error" => "Mobile and password parameters are required"]));
  }

  // Get data from Flutter app
  $mobile = mysqli_real_escape_string($conn, $putParams['mobile']);
  $newPassword = mysqli_real_escape_string($conn, $putParams['password']);

  // Use prepared statement to prevent SQL injection
  $updateQuery = "UPDATE registration SET password = ? WHERE mobile = ?";
  $stmt = mysqli_prepare($conn, $updateQuery);
  mysqli_stmt_bind_param($stmt, "ss", $newPassword, $mobile);
  $updateResult = mysqli_stmt_execute($stmt);

  if ($updateResult) {
    echo json_encode(["status" => "Password updated successfully"]);
  } else {
    http_response_code(500);
    echo json_encode(["error" => "Error updating password: " . mysqli_error($conn)]);
  }
}

mysqli_close($conn);
?>
