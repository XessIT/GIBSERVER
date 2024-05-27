<?php
// Database connection parameters
$servername = "207.174.212.202";
 $username = "kanin7w7_gibErode";
 $password = "Kanxtl@6868#";
 $dbname = "kanin7w7_gibErode";
// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die('Connection failed: ' . mysqli_connect_error());
}

// Check if image_id is set
if (isset($_GET['image_id'])) {
    $imageId = $_GET['image_id'];

    // Fetch image path from the database
    $sql = "SELECT image_path FROM mygallery WHERE id = '$imageId'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $imagePath = $row['image_path'];

        // Delete the image file from the server
        if (unlink($imagePath)) {
            // Delete the image record from the database
            $deleteSql = "DELETE FROM mygallery WHERE id = '$imageId'";
            if (mysqli_query($conn, $deleteSql)) {
                echo "Image deleted successfully.";
            } else {
                echo "Failed to delete image record from the database: " . mysqli_error($conn);
            }
        } else {
            echo "Failed to delete image file from the server.";
        }
    } else {
        echo "Image not found in the database.";
    }
} else {
    echo "Invalid request.";
}

// Close database connection
mysqli_close($conn);
?>
