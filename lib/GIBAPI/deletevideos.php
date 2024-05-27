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

// Check if video_id is set
if (isset($_GET['video_id'])) {
    $videoId = $_GET['video_id'];

    // Fetch video path from the database
    $sql = "SELECT video_path FROM videos WHERE id = '$videoId'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $videoPath = $row['video_path'];

        // Delete the video file from the server
        if (unlink($videoPath)) {
            // Delete the video record from the database
            $deleteSql = "DELETE FROM videos WHERE id = '$videoId'";
            if (mysqli_query($conn, $deleteSql)) {
                echo "Video deleted successfully.";
            } else {
                echo "Failed to delete video record from the database: " . mysqli_error($conn);
            }
        } else {
            echo "Failed to delete video file from the server.";
        }
    } else {
        echo "Video not found in the database.";
    }
} else {
    echo "Invalid request.";
}

// Close database connection
mysqli_close($conn);
?>
