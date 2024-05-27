<?php
header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

$servername = "207.174.212.202";
 $username = "kanin7w7_gibErode";
 $password = "Kanxtl@6868#";
 $dbname = "kanin7w7_gibErode";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Assuming you have a form where you get the new password and registration ID
$password = $_POST['password'];
$id = $_POST['id'];

// Update query
$sql = "UPDATE registration SET password = '$password' WHERE id = '$id'";

if ($conn->query($sql) === TRUE) {
    echo "Password updated successfully";
} else {
    echo "Error updating password: " . $conn->error;
}

// Close connection
$conn->close();
?>
