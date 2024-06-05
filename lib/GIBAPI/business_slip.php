 <?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 $servername = "localhost";
 $username = "root";
 $password = "";
 $dbname = "gib";

 // Create connection
 $conn = mysqli_connect($servername, $username, $password, $dbname);

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "business_slip") {
        $mobile = isset($_GET['mobile']) ? mysqli_real_escape_string($conn, $_GET['mobile']) : "";
        $status = isset($_GET['status']) ? mysqli_real_escape_string($conn, $_GET['status']) : "";
        $offerlist = "SELECT * FROM business_slip WHERE (Tomobile='$mobile' OR referrer_mobile='$mobile') AND status='$status'";
            $offerResult = mysqli_query($conn, $offerlist);
            if ($offerResult && mysqli_num_rows($offerResult) > 0)
            {
                $offers = array();
                while ($row = mysqli_fetch_assoc($offerResult)) {
                    $offers[] = $row;
                }
                echo json_encode($offers);
            } else {
                echo json_encode(array("message" => "No offers found"));
            }
    }
    elseif ($table == "BlockOffers") {
                $offerlist = "SELECT * FROM offers where block_status='Block'";
                $offerResult = mysqli_query($conn, $offerlist);
                if ($offerResult && mysqli_num_rows($offerResult) > 0) {
                    $offers = array();
                    while ($row = mysqli_fetch_assoc($offerResult)) {
                        $offers[] = $row;
                      /*    while ($row = mysqli_fetch_assoc($offerResult)) {
                                        $row['offer_image'] = base64_encode(file_get_contents($row['offer_image'])); // Encode image data to base64
                                        $offers[] = $row;
                                    } */
                    }
                    echo json_encode($offers);
                } else {
                    echo json_encode(array("message" => "No offers found"));
                }
        }
    elseif ($table == "registration") {
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
             } else {
                       echo json_encode(array("message" => "Invalid table name"));
                       exit;
                   }
}

else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle the insert/update/delete actions
   $data = json_decode(file_get_contents("php://input"));
   $type = mysqli_real_escape_string($conn, $data->type);
   $Toname = mysqli_real_escape_string($conn, $data->Toname);
   $Tomobile = mysqli_real_escape_string($conn, $data->Tomobile);
   $Tocompanyname = mysqli_real_escape_string($conn, $data->Tocompanyname);
   $purpose = mysqli_real_escape_string($conn, $data->purpose);
   $referree_name = mysqli_real_escape_string($conn, $data->referree_name);
   $referree_mobile = mysqli_real_escape_string($conn, $data->referree_mobile);
   $referrer_name = mysqli_real_escape_string($conn, $data->referrer_name);
   $referrer_mobile = mysqli_real_escape_string($conn, $data->referrer_mobile);
   $referrer_company = mysqli_real_escape_string($conn, $data->referrer_company);
   $status = mysqli_real_escape_string($conn, $data->status);
   $district = mysqli_real_escape_string($conn, $data->district);
   $chapter = mysqli_real_escape_string($conn, $data->chapter);
   $user_id = mysqli_real_escape_string($conn, $data->user_id);

       $insertUserQuery = "INSERT INTO `business_slip`(`type`, `Toname`, `Tomobile`, `Tocompanyname`, `purpose`, `referree_name`, `referree_mobile`, `referrer_name`, `referrer_mobile`, `referrer_company`, `status`, `district`, `chapter`, `user_id`)
      VALUES ('$type','$Toname','$Tomobile','$Tocompanyname','$purpose', '$referree_name', '$referree_mobile', '$referrer_name', '$referrer_mobile', '$referrer_company', '$status', '$district', '$chapter', '$user_id')";
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

    // Check if block_status is provided
    if(isset($data->block_status)) {
        $ID = mysqli_real_escape_string($conn, $data->ID);
        $block_status = mysqli_real_escape_string($conn, $data->block_status);

        $updateBlockStatusQuery = "UPDATE `offers` SET `block_status`='$block_status' WHERE `ID`='$ID'";
        $updateBlockStatusResult = mysqli_query($conn, $updateBlockStatusQuery);

        if ($updateBlockStatusResult) {
            echo "Offer blocked/unblocked successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }
    }
    elseif(isset($data->offer_image)) {
                 $offer_image = mysqli_real_escape_string($conn, $data->offer_image);
                 $name = mysqli_real_escape_string($conn, $data->name);
                 $discount = mysqli_real_escape_string($conn, $data->discount);
                 $ID = mysqli_real_escape_string($conn, $data->ID);
                 $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
                 $validity = mysqli_real_escape_string($conn, $data->validity);

                $updateOfferQuery = "UPDATE `offers` SET
                `offer_type`='$offer_type',
                `name`='$name',
                `discount`='$discount',
                `validity`='$validity',
                `offer_image`='$offer_image' WHERE `ID`='$ID'";
                $updateBlockStatusResult = mysqli_query($conn, $updateOfferQuery);

                if ($updateBlockStatusResult) {
                    echo "Offer blocked/unblocked successfully";
                } else {
                    echo "Error: " . mysqli_error($conn);
                }
            }

     else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
         $data = json_decode(file_get_contents("php://input"));

         // Check if status and reason are provided
         if(isset($data->status) && isset($data->reason)) {
             $id = mysqli_real_escape_string($conn, $data->id);
             $status = mysqli_real_escape_string($conn, $data->status);
             $reason = mysqli_real_escape_string($conn, $data->reason);

             $updateBusinessSlipQuery = "UPDATE `business_slip` SET `status`='$status', `reason`='$reason' WHERE `id`='$id'";
             $updateBusinessSlipResult = mysqli_query($conn, $updateBusinessSlipQuery);

             if ($updateBusinessSlipResult) {
                 echo "Business slip updated successfully";
             } else {
                 echo "Error: " . mysqli_error($conn);
             }
         } else {
             echo "Status and Reason are required fields";
         }
     }


    else {
        // Handle the insert/update actions for editing an offer
        $imagename = mysqli_real_escape_string($conn, $data->imagename);
        $imagedata = mysqli_real_escape_string($conn, $data->imagedata);
        $name = mysqli_real_escape_string($conn, $data->name);
        $discount = mysqli_real_escape_string($conn, $data->discount);
        $ID = mysqli_real_escape_string($conn, $data->ID);
        $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
        $validity = mysqli_real_escape_string($conn, $data->validity);
        $path = "offers/$imagename";
        $updateOfferQuery = "UPDATE `offers` SET `offer_type`='$offer_type', `name`='$name', `discount`='$discount', `validity`='$validity', `offer_image`='$path' WHERE `ID`='$ID'";
        file_put_contents($path, base64_decode($imagedata));
        $updateOfferResult = mysqli_query($conn, $updateOfferQuery);
        if ($updateOfferResult) {
            echo "Offer updated successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
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