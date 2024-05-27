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
    $id = isset($_GET['id']) ? mysqli_real_escape_string($conn, $_GET['id']) : "";
                 // Fetch data from the registration table
                        $registrationlist = "SELECT * FROM registration where id='$id'";
                        $registrationResult = mysqli_query($conn, $registrationlist);
                        if ($registrationResult && mysqli_num_rows($registrationResult) > 0) {
                            $registrations = array();
                            while ($row = mysqli_fetch_assoc($registrationResult)) {
                                $registrations[] = $row;
                            }
                            echo json_encode($registrations);
                        } else {
                            echo json_encode(array("message" => "No registrations found"));
                        }
              /* else {
                       echo json_encode(array("message" => "Invalid table name"));
                       exit;
                   } */
}

else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle the insert/update/delete actions
   $data = json_decode(file_get_contents("php://input"));
   $imagename = mysqli_real_escape_string($conn, $data->imagename);
    echo "Imagename: $imagename";
   $imagedata = mysqli_real_escape_string($conn, $data->imagedata);
   $name = mysqli_real_escape_string($conn, $data->name);
   $discount = mysqli_real_escape_string($conn, $data->discount);
   $user_id = mysqli_real_escape_string($conn, $data->user_id);
   $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
   $validity = mysqli_real_escape_string($conn, $data->validity);
   $first_name = mysqli_real_escape_string($conn, $data->first_name);
   $last_name = mysqli_real_escape_string($conn, $data->last_name);
   $mobile = mysqli_real_escape_string($conn, $data->mobile);
   $company_name = mysqli_real_escape_string($conn, $data->company_name);
   $block_status = mysqli_real_escape_string($conn, $data->block_status);
    $path = "offers/$imagename";
       $insertUserQuery = "INSERT INTO `offers`(`user_id`, `offer_type`, `name`, `discount`, `validity`, `first_name`, `last_name`, `mobile`, `company_name`, `block_status`, `offer_image`)
      VALUES ('$user_id','$offer_type','$name','$discount','$validity', '$first_name', '$last_name', '$mobile', '$company_name', '$block_status', '$path')";
      file_put_contents($path, base64_decode($imagedata));
      $arr = [];
      $insertUserResult = mysqli_query($conn, $insertUserQuery);
      if($insertUserResult) {
         $arr["Success"] = true;
      } else {
         $arr["Success"] = false;
      }
      echo json_encode($arr);

}

else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

       if (isset($data->business_image))
       {
        $business_image = mysqli_real_escape_string($conn, $data->business_image);

        $company_name = mysqli_real_escape_string($conn, $data->company_name);
        $mobile = mysqli_real_escape_string($conn, $data->mobile);
        $id = mysqli_real_escape_string($conn, $data->id);
        $email = mysqli_real_escape_string($conn, $data->email);
        $company_address = mysqli_real_escape_string($conn, $data->company_address);
        $website = mysqli_real_escape_string($conn, $data->website);
        $b_year = mysqli_real_escape_string($conn, $data->b_year);
        $business_keywords = mysqli_real_escape_string($conn, $data->business_keywords);
        $business_type = mysqli_real_escape_string($conn, $data->business_type);

        $updateOfferQuery = "UPDATE `registration` SET
        `business_image`='$business_image',

        `company_name`='$company_name',
        `mobile`='$mobile',
        `email`='$email',
        `company_address`='$company_address',
        `website`='$website',
        `b_year`='$b_year',
        `business_keywords`='$business_keywords',
        `business_type`='$business_type'
         WHERE `id`='$id'";
        $updateOfferResult = mysqli_query($conn, $updateOfferQuery);

        // Modify your PHP code to respond with JSON
        if ($updateOfferResult) {
            echo json_encode(array("message" => "Profile updated successfully"));
        } else {
            echo json_encode(array("error" => "Error updating profile"));
        }}

        else{
         $imagename = mysqli_real_escape_string($conn, $data->imagename);
         $imagedata = mysqli_real_escape_string($conn, $data->imagedata);

        $company_name = mysqli_real_escape_string($conn, $data->company_name);
        $mobile = mysqli_real_escape_string($conn, $data->mobile);
        $id = mysqli_real_escape_string($conn, $data->id);
        $email = mysqli_real_escape_string($conn, $data->email);
        $company_address = mysqli_real_escape_string($conn, $data->company_address);
        $website = mysqli_real_escape_string($conn, $data->website);
        $b_year = mysqli_real_escape_string($conn, $data->b_year);
        $business_keywords = mysqli_real_escape_string($conn, $data->business_keywords);
        $business_type = mysqli_real_escape_string($conn, $data->business_type);
        $path = "upload/$imagename";

        $updateOfferQuery = "UPDATE `registration` SET
        `business_image` = '$path',

        `company_name`='$company_name',
        `mobile`='$mobile',
        `email`='$email',
        `company_address`='$company_address',
        `website`='$website',
        `b_year`='$b_year',
        `business_keywords`='$business_keywords',
        `business_type`='$business_type'
         WHERE `id`='$id'";
        file_put_contents($path, base64_decode($imagedata));

        $updateOfferResult = mysqli_query($conn, $updateOfferQuery);

        // Modify your PHP code to respond with JSON
        if ($updateOfferResult) {
            echo json_encode(array("message" => "Profile updated successfully"));
        } else {
            echo json_encode(array("error" => "Error updating profile"));
        }
        }
}
else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $ID = isset($_GET['ID']) ? $_GET['ID'] : null;

    if (!$ID) {
        echo json_encode(array("error" => "ID is missing in the request"));
        exit;
    }

    $ID = mysqli_real_escape_string($conn, $ID);

    $sql = "DELETE FROM offers WHERE ID = '$ID'";
    $result = $conn->query($sql);

    if ($result === false) {
        echo json_encode(array("error" => "Query failed: " . $conn->error));
    } else {
        echo json_encode(array("message" => "Offer deleted successfully"));
    }
}


mysqli_close($conn);
?>