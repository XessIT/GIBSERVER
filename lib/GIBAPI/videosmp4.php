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
    die("Connection failed: " . mysqli_connect_error());
}

// Handle thumbnail generation
<?php
// Handle thumbnail generation
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['video_path'])) {
    // Get the video path from the query parameters
    $videoPath = $_GET['video_path'];

    // Assuming FFmpeg is installed on your server
    $thumbnailPath = 'thumbnails/' . basename($videoPath) . '.jpg'; // Adjust the path as needed

    // Generate thumbnail using FFmpeg
    exec("ffmpeg -i $videoPath -ss 00:00:01 -vframes 1 $thumbnailPath");

    // Output the thumbnail image
    header('Content-Type: image/jpeg');
    readfile($thumbnailPath);
    exit; // Stop further execution
}


// For other CRUD operations like uploading videos and fetching videos, you can use POST and GET respectively, as before.

// Close database connection
mysqli_close($conn);
?>
