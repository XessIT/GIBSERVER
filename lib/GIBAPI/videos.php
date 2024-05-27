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

// Check if a video file was uploaded
if (isset($_FILES['video'])) {
    // Get information about the uploaded file
    $videoName = $_FILES['video']['name'];
    $videoTmpName = $_FILES['video']['tmp_name'];
    $videoSize = $_FILES['video']['size'];
    $userId = $_GET['userId']; // Assuming userId is sent along with the request

    // Define the directory where videos will be stored on the server
    $uploadDir = 'videos/';
        // Set a maximum file size limit (10MB)



    // Validate file type (MP4)
    $fileType = strtolower(pathinfo($videoName, PATHINFO_EXTENSION));
    if ($fileType !== 'mp4') {
        die('Only MP4 videos are allowed.');
    }

    // Set a maximum file size limit (e.g., 100MB)
    $maxFileSize = 10 * 1024 * 1024; // 100MB in bytes
    if ($videoSize > $maxFileSize) {
        die('File size exceeds the maximum limit of 100MB.');
    }

    // Move the uploaded video file to the designated directory
    $videoPath = $uploadDir . $videoName;
    if (move_uploaded_file($videoTmpName, $videoPath)) {
        // Insert metadata about the video into the database
        $insertQuery = "INSERT INTO videos (video_name, video_path, user_id) VALUES (?, ?, ?)";
        $statement = $conn->prepare($insertQuery);
        $statement->bind_param('sss', $videoName, $videoPath, $userId);

        if ($statement->execute()) {
            echo 'Video uploaded successfully.';
        } else {
            echo 'Failed to insert video details into the database: ' . $conn->error;
        }

        $statement->close();
    } else {
        echo 'Failed to move video file to the server.';
    }
} else {
    echo 'No video file uploaded.';
}

// Close database connection
$conn->close();
?>
