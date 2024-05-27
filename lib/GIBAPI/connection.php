<?php
$conn = new mysqli("localhost","root","","test");
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $con->connect_error);
} else {
    echo "Connected successfully";
}

// Rest of your code goes here...

// Close the connection when you're done with it
$conn->close();
