<?php
// Database connection parameters
// Enable error reporting for debugging
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

// Create uploads directory if it doesn't exist
$uploadDir = 'upload/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true); // Create uploads directory with appropriate permissions
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['profile_image']) && isset($_GET['id'])) {
    // Decode the base64 image data
    $imageData = base64_decode($_POST['profile_image']);
    $id = $_GET['id']; // Get the uid from the URL query parameters

    // Generate a unique file name
    $imageName = uniqid() . '.jpg'; // You can use any desired image extension

    // Set the file path
    $filePath = $uploadDir . $imageName;

    // Save the image to the server
    if (file_put_contents($filePath, $imageData)) {
        // Insert the image details into the database
        $imageInsertQuery = "INSERT INTO registration (	profile_image, id) VALUES (?, ?)";
        $statement = $conn->prepare($imageInsertQuery);
        $statement->bind_param('sss', $imageName, $filePath, $id);

        if ($statement->execute()) {
            echo 'Image uploaded successfully.';
        } else {
            echo 'Failed to insert image details into the database.';
        }

        $statement->close();
    } else {
        echo 'Failed to save image on the server.';
    }
} else {
    echo 'Invalid request.';
}

// Close database connection
$conn->close();
?>
