<?php
// Database connection parameters
$servername = "207.174.212.202";
 $username = "kanin7w7_gibErode";
 $password = "Kanxtl@6868#";
 $dbname = "kanin7w7_gibErode";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Get user ID from the request
$userId = $_GET['userId']; // Assuming userId is sent along with the request

// Fetch videos associated with the user ID
$selectQuery = "SELECT * FROM videos WHERE user_id = ?";
$statement = $conn->prepare($selectQuery);
$statement->bind_param('s', $userId);
$statement->execute();
$result = $statement->get_result();

// Store video details in an array
$videos = array();
while ($row = $result->fetch_assoc()) {
    $videos[] = array(
        'id' => $row['id'],
        'video_name' => $row['video_name'],
        'video_path' => 'http://localhost/GIB/lib/GIBAPI/' . $row['video_path'] // Adjust the server path accordingly
    );
}

// Close statement and database connection
$statement->close();
$conn->close();

// Return JSON response with video details
header('Content-Type: application/json');
echo json_encode($videos);
?>
