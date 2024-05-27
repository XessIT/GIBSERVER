<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gib";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle the insert/update/delete actions
    $data = json_decode(file_get_contents("php://input"));
    $met_name = mysqli_real_escape_string($conn, $data->met_name);
    $user_id = mysqli_real_escape_string($conn, $data->user_id);
    $met_company_name = mysqli_real_escape_string($conn, $data->met_company_name);
    $met_number = mysqli_real_escape_string($conn, $data->met_number);
    $date = mysqli_real_escape_string($conn, $data->date);
    $from_time = mysqli_real_escape_string($conn, $data->from_time);
    $to_time = mysqli_real_escape_string($conn, $data->to_time);
    $location = mysqli_real_escape_string($conn, $data->location);
    $first_name = mysqli_real_escape_string($conn, $data->first_name);
    $mobile = mysqli_real_escape_string($conn, $data->mobile);
    $company_name = mysqli_real_escape_string($conn, $data->company_name);

    // Check if the record already exists
    $checkQuery = "SELECT * FROM g2g WHERE date = '$date' AND met_number = '$met_number' AND mobile = '$mobile'";
    $checkResult = mysqli_query($conn, $checkQuery);
    if (mysqli_num_rows($checkResult) > 0) {
        // Record already exists, return an error response
        $response = [
            "success" => false,
            "message" => "Record already exists"
        ];
        echo json_encode($response);
    } else {
        // Insert the record
        $insertQuery = "INSERT INTO g2g (`met_name`, `user_id`, `met_company_name`, `met_number`, `date`, `from_time`, `to_time`, `location`, `first_name`, `mobile`, `company_name`)
                        VALUES ('$met_name', '$user_id', '$met_company_name', '$met_number', '$date', '$from_time', '$to_time', '$location', '$first_name', '$mobile', '$company_name')";
        $insertResult = mysqli_query($conn, $insertQuery);
        if($insertResult) {
            // Record inserted successfully
            $response = [
                "success" => true,
                "message" => "Record inserted successfully"
            ];
            echo json_encode($response);
        } else {
            // Error inserting record
            $response = [
                "success" => false,
                "message" => "Error inserting record: " . mysqli_error($conn)
            ];
            echo json_encode($response);
        }
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "g2g") {
        $offerlist = "SELECT * FROM g2g";
        $offerResult = mysqli_query($conn, $offerlist);
        if ($offerResult && mysqli_num_rows($offerResult) > 0) {
            $offers = array();
            while ($row = mysqli_fetch_assoc($offerResult)) {
                $offers[] = $row;
            }
            echo json_encode($offers);
        } else {
            echo json_encode(array("message" => "No offers found"));
        }
    } else {
        echo json_encode(array("message" => "Invalid table name"));
        exit;
    }
} else {
    echo "Invalid request method";
}

$conn->close();
?>
