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
    // Check if member_type parameter is set in the URL
    if (isset($_GET['member_type'])) {
        $member_type = mysqli_real_escape_string($conn, $_GET['member_type']);

        $meetingname = "SELECT * FROM meeting WHERE member_type='$member_type'";
    } else {
        $meetingname = "SELECT * FROM meeting";
    }

    $meetingResult = mysqli_query($conn, $meetingname);
    if ($meetingResult && mysqli_num_rows($meetingResult) > 0) {
        $meeting = array();
        while ($row = mysqli_fetch_assoc($meetingResult)) {
            $meeting[] = $row;
        }
        echo json_encode($meeting);
    } else {
        echo json_encode(array("message" => "No meeting found"));
    }
}

mysqli_close($conn);
?>
