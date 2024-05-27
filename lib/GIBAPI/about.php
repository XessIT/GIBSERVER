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
   $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "about_gib") {
            $aboutlist = "SELECT DISTINCT * FROM about_gib";
            $aboutResult = mysqli_query($conn, $aboutlist);
            if ($aboutResult && mysqli_num_rows($aboutResult) > 0) {
                $abouts = array();
                while ($row = mysqli_fetch_assoc($aboutResult)) {
                    $abouts[] = $row;
                }
                echo json_encode($abouts);
            } else {
                echo json_encode(array("message" => "No about found"));
            }
    }elseif($table == "about_vision"){

            $aboutlist = "SELECT * FROM about_vision ";
                 $aboutResult = mysqli_query($conn, $aboutlist);
                 if ($aboutResult && mysqli_num_rows($aboutResult) > 0) {
                     $abouts = array();
                     while ($row = mysqli_fetch_assoc($aboutResult)) {
                         $abouts[] = $row;
                     }
                     echo json_encode($abouts);
                 } else {
                     echo json_encode(array("message" => "No about found"));
                 }

    }
     elseif ($table == "about_mission") {
                   $aboutlist = "SELECT * FROM about_mission ";
                                  $aboutResult = mysqli_query($conn, $aboutlist);
                                  if ($aboutResult && mysqli_num_rows($aboutResult) > 0) {
                                      $abouts = array();
                                      while ($row = mysqli_fetch_assoc($aboutResult)) {
                                          $abouts[] = $row;
                                      }
                                      echo json_encode($abouts);
                                  } else {
                                      echo json_encode(array("message" => "No about found"));
                                  }

}}
/*
else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

        $id = mysqli_real_escape_string($conn, $data->id);
        $gib_content_1 = mysqli_real_escape_string($conn, $data->gib_content_1);
        $gib_content_2 = mysqli_real_escape_string($conn, $data->gib_content_2);
        $gib_content_3 = mysqli_real_escape_string($conn, $data->gib_content_3);

        $updateBlockStatusQuery = "UPDATE `about_gib` SET `content_1`='$content_1', `content_2`='$content_2', `content_3`='$content_3'  WHERE `id`='$id'";
        $updateBlockStatusResult = mysqli_query($conn, $updateBlockStatusQuery);

        if ($updateBlockStatusResult) {
            echo "about_gib updated successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }

}
 */
elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

    $table = isset($_GET['table']) ? $_GET['table'] : "";

    if ($table == "about_gib") {
        $id = mysqli_real_escape_string($conn, $data->id);
        $gib_content_1 = mysqli_real_escape_string($conn, $data->gib_content_1);
        $gib_content_2 = mysqli_real_escape_string($conn, $data->gib_content_2);
        $gib_content_3 = mysqli_real_escape_string($conn, $data->gib_content_3);

        $updateQuery = "UPDATE `about_gib` SET `gib_content_1`='$gib_content_1', `gib_content_2`='$gib_content_2', `gib_content_3`='$gib_content_3' WHERE `id`='$id'";
    } elseif ($table == "about_vision") {
        $id = mysqli_real_escape_string($conn, $data->id);
        $vision_content_1 = mysqli_real_escape_string($conn, $data->vision_content_1);

        $updateQuery = "UPDATE `about_vision` SET `vision_content_1`='$vision_content_1' WHERE `id`='$id'";
    } elseif ($table == "about_mission") {
        $id = mysqli_real_escape_string($conn, $data->id);
        $mission_content_1 = mysqli_real_escape_string($conn, $data->mission_content_1);
        $mission_content_2 = mysqli_real_escape_string($conn, $data->mission_content_2);

        $updateQuery = "UPDATE `about_mission` SET `mission_content_1`='$mission_content_1', `mission_content_2`='$mission_content_2' WHERE `id`='$id'";
    } else {
        echo json_encode(array("message" => "Invalid table"));
        exit;
    }

    $updateResult = mysqli_query($conn, $updateQuery);

    if ($updateResult) {
        echo json_encode(array("message" => "Update successful"));
    } else {
        echo json_encode(array("message" => "Update failed"));
    }
}



mysqli_close($conn);
?>