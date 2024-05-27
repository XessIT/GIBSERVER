<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers for CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Database connection parameters
 $servername = "207.174.212.202";
  $username = "kanin7w7_gibErode";
  $password = "Kanxtl@6868#";
  $dbname = "kanin7w7_gibErode";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Fetch image data from the database
$userId = $_GET['userId']; // Get the userId from the URL query parameters

$sql = "SELECT offer_image, id FROM offers WHERE user_id = '$userId' ORDER BY id DESC LIMIT ";
$result = $conn->query($sql);

$imageData = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $imageData[] = array(
            'offer_image' => $row['offer_image'],
            'id' => $row['id']
        );
    }
    echo json_encode($imageData);
} else {
    echo json_encode(array('error' => 'Image not found.'));
}

// Close database connection
$conn->close();
?>
