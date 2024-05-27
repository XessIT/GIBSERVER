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
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['member_type']) && isset($_GET['chapter']) && isset($_GET['district']) &&isset($_GET['id']) ) {
        $member_type = mysqli_real_escape_string($conn, $_GET['member_type']);
        $chapter = mysqli_real_escape_string($conn, $_GET['chapter']);
        $district = mysqli_real_escape_string($conn, $_GET['district']);
        $id = mysqli_real_escape_string($conn, $_GET['id']);

        $userlist = "SELECT * FROM registration WHERE member_type = '$member_type'AND id !='$id' AND district = '$district' AND  chapter = '$chapter'";
        $userResult = mysqli_query($conn, $userlist);
        if ($userResult && mysqli_num_rows($userResult) > 0) {
            $users = array();
            while ($row = mysqli_fetch_assoc($userResult)) {
                $users[] = $row;
            }
            echo json_encode($users);
        } else {
            echo json_encode(array("message" => "No users found"));
        }
    } else {
        $userlist = "SELECT * FROM registration";
        $userResult = mysqli_query($conn, $userlist);
        if ($userResult && mysqli_num_rows($userResult) > 0) {
            $users = array();
            while ($row = mysqli_fetch_assoc($userResult)) {
                $users[] = $row;
            }
            echo json_encode($users);
        } else {
            echo json_encode(array("message" => "No users found"));
        }
    }
}

mysqli_close($conn);
?>
