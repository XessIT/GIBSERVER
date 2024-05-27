<?php
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

// Fetch the count of images associated with the given userId
$userId = $_GET['userId'];
$countQuery = "SELECT COUNT(*) AS count FROM mygallery WHERE user_id = '$userId'";
$countResult = $conn->query($countQuery);

if ($countResult && $countResult->num_rows > 0) {
    $countData = $countResult->fetch_assoc();
    $imageCount = $countData['count'];

    // Check if the image count is less than 5
    if ($imageCount < 5) {
        // Decode the base64 image data
        $imageData = base64_decode($_POST['image']);

        // Generate a unique file name
        $imageName = uniqid() . '.jpg';

        // Set the file path
        $filePath = $uploadDir . $imageName;

        // Save the image to the server
        if (file_put_contents($filePath, $imageData)) {
            // Insert the image details into the database
            $imageInsertQuery = "INSERT INTO mygallery (image_name, image_path, user_id) VALUES (?, ?, ?)";
            $statement = $conn->prepare($imageInsertQuery);
            $statement->bind_param('sss', $imageName, $filePath, $userId);

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
        echo 'Maximum limit of 5 images reached.';
    }
} else {
    echo 'Failed to fetch image count.';
}

// Close database connection
$conn->close();
?>
