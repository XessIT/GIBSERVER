<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
//include "connection.php";

// Create a new mysqli connection
$con = new mysqli("207.174.212.202", "kanin7w7_gibErode", "Kanxtl@6868#", "kanin7w7_gibErode");

// Check if the connection is successful
if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

$sql = "SELECT DISTINCT district FROM district ORDER BY district";
$result = array();
$res = $con->query($sql);

// Check if the query was successful
if ($res === false) {
    die("Query failed: " . $con->error);
}

// Check if there are rows returned
if ($res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        $result[] = $row;
    }
}

// Close the database connection
$con->close();

// Output the JSON-encoded result
echo json_encode($result);

