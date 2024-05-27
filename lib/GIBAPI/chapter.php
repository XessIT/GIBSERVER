<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Create a new mysqli connection
$con = new mysqli("207.174.212.202", "kanin7w7_gibErode", "Kanxtl@6868#", "kanin7w7_gibErode");

// Check if the connection is successful
if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

// Assuming $district is the variable holding the district value
$district = $_GET['district']; // You may need to adjust this based on your application's requirements

$sql = "SELECT chapter FROM chapter WHERE district = ? ORDER BY chapter";
$result = array();

// Use prepared statement
$stmt = $con->prepare($sql);
$stmt->bind_param("s", $district);
$stmt->execute();
$res = $stmt->get_result();

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

// Close the statement and database connection
$stmt->close();
$con->close();

// Output the JSON-encoded result
echo json_encode($result);
?>
