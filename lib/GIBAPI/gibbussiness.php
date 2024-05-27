<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Create a new mysqli connection
$con = new mysqli("localhost", "root", "", "gib");

// Check if the connection is successful
if ($con->connect_error) {
    die(json_encode(array('error' => 'Connection failed: ' . $con->connect_error)));
}

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "BusinessTotalYear") {
        $sql = "SELECT COUNT(*) AS total_rows FROM business_slip";
        $result = array();
        $res = $con->query($sql);
        // Check if the query was successful
        if ($res === false) {
            die(json_encode(array('error' => 'Query failed: ' . $con->error)));
        }
        // Fetch the row count
        $row = $res->fetch_assoc();
        $totalRows = $row['total_rows'];
        // Return the row count as JSON response
        echo json_encode(array('totalRows' => $totalRows));
    }
    else if ($table == "BusinessCurrentYear") {
        // Assuming the date column is named 'date_column'
        $sql = "SELECT COUNT(*) AS total_rows FROM business_slip WHERE YEAR(createdOn) = YEAR(CURDATE())";
        $result = array();
        $res = $con->query($sql);
        // Check if the query was successful
        if ($res === false) {
            die(json_encode(array('error' => 'Query failed: ' . $con->error)));
        }
        // Fetch the row count
        $row = $res->fetch_assoc();
        $totalRows = $row['total_rows'];
        // Return the row count as JSON response
        echo json_encode(array('totalRows' => $totalRows));
    }
       else if ($table == "g2gBusinessTotalYear") {
            $sql = "SELECT COUNT(*) AS total_rows FROM g2g";
            $result = array();
            $res = $con->query($sql);
            // Check if the query was successful
            if ($res === false) {
                die(json_encode(array('error' => 'Query failed: ' . $con->error)));
            }
            // Fetch the row count
            $row = $res->fetch_assoc();
            $totalRows = $row['total_rows'];
            // Return the row count as JSON response
            echo json_encode(array('totalRows' => $totalRows));
        } else if ($table == "g2gBusinessCurrentYear") {
                 // Assuming the date column is named 'date_column'
                 $sql = "SELECT COUNT(*) AS total_rows FROM g2g WHERE YEAR(date) = YEAR(CURDATE())";
                 $result = array();
                 $res = $con->query($sql);
                 // Check if the query was successful
                 if ($res === false) {
                     die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                 }
                 // Fetch the row count
                 $row = $res->fetch_assoc();
                 $totalRows = $row['total_rows'];
                 // Return the row count as JSON response
                 echo json_encode(array('totalRows' => $totalRows));
             }
             else if ($table == "visitorBusinessTotalYear") {
                         $sql = "SELECT COUNT(*) AS total_rows FROM visitors_slip";
                         $result = array();
                         $res = $con->query($sql);
                         // Check if the query was successful
                         if ($res === false) {
                             die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                         }
                         // Fetch the row count
                         $row = $res->fetch_assoc();
                         $totalRows = $row['total_rows'];
                         // Return the row count as JSON response
                         echo json_encode(array('totalRows' => $totalRows));
                     } else if ($table == "visitorBusinessCurrentYear") {
                              // Assuming the date column is named 'date_column'
                              $sql = "SELECT COUNT(*) AS total_rows FROM visitors_slip WHERE YEAR(date) = YEAR(CURDATE())";
                              $result = array();
                              $res = $con->query($sql);
                              // Check if the query was successful
                              if ($res === false) {
                                  die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                              }
                              // Fetch the row count
                              $row = $res->fetch_assoc();
                              $totalRows = $row['total_rows'];
                              // Return the row count as JSON response
                              echo json_encode(array('totalRows' => $totalRows));
                          }
                         else if ($table == "honorBusinessTotalYear") {
                             $sql = "SELECT SUM(amount) AS total_amount FROM honoring_slip";
                             $result = array();
                             $res = $con->query($sql);
                             // Check if the query was successful
                             if ($res === false) {
                                 die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                             }
                             // Fetch the total amount
                             $row = $res->fetch_assoc();
                             $totalAmount = $row['total_amount'];
                             // Return the total amount as JSON response
                             echo json_encode(array('totalAmount' => $totalAmount));
                         }
                         else if ($table == "honorBusinessCurrentYear") {
                                                        // Assuming the date column is named 'date_column'
                                                        $sql = "SELECT SUM(amount) AS total_amount FROM honoring_slip WHERE YEAR(createdOn) = YEAR(CURDATE())";
                                                        $result = array();
                                                        $res = $con->query($sql);
                                                        // Check if the query was successful
                                                        if ($res === false) {
                                                            die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                                                        }
                                                        // Fetch the row count
                                                        $row = $res->fetch_assoc();
                                                        $totalAmount = $row['total_amount'];
                                                        // Return the row count as JSON response
                                                        echo json_encode(array('totalAmount' => $totalAmount));
                                                    }
                    else if ($table == "MyBusinessTotalYear") {
                         // Ensure user_id is provided and not empty
                         if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
                             $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
                             $sql = "SELECT COUNT(*) AS total_rows FROM business_slip WHERE user_id = '$user_id'";

                             $result = array();
                             $res = $con->query($sql);

                             // Check if the query was successful
                             if ($res === false) {
                                 die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                             }

                             // Fetch the row count
                             $row = $res->fetch_assoc();
                             $totalRows = $row['total_rows'];

                             // Return the row count as JSON response
                             echo json_encode(array('totalRows' => $totalRows));
                         } else {
                             echo json_encode(array('error' => 'Missing or empty user_id parameter'));
                         }
                     }
else if ($table == "MyBusinessCurrentYear") {
    // Ensure user_id is provided and not empty
    if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
        $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
        // Assuming the date column is named 'createdOn'
        $sql = "SELECT COUNT(*) AS total_rows FROM business_slip WHERE YEAR(createdOn) = YEAR(CURDATE()) AND user_id = '$user_id'";

        $result = array();
        $res = $con->query($sql);

        // Check if the query was successful
        if ($res === false) {
            die(json_encode(array('error' => 'Query failed: ' . $con->error)));
        }

        // Fetch the row count
        $row = $res->fetch_assoc();
        $totalRows = $row['total_rows'];

        // Return the row count as JSON response
        echo json_encode(array('totalRows' => $totalRows));
    } else {
        echo json_encode(array('error' => 'Missing or empty user_id parameter'));
    }
}
                   else if ($table == "Myg2gTotalYear") {
                         // Ensure user_id is provided and not empty
                         if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
                             $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
                             $sql = "SELECT COUNT(*) AS total_rows FROM g2g WHERE user_id = '$user_id'";

                             $result = array();
                             $res = $con->query($sql);

                             // Check if the query was successful
                             if ($res === false) {
                                 die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                             }

                             // Fetch the row count
                             $row = $res->fetch_assoc();
                             $totalRows = $row['total_rows'];

                             // Return the row count as JSON response
                             echo json_encode(array('totalRows' => $totalRows));
                         } else {
                             echo json_encode(array('error' => 'Missing or empty user_id parameter'));
                         }
                     }
else if ($table == "Myg2gCurrentYear") {
    // Ensure user_id is provided and not empty
    if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
        $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
        // Assuming the date column is named 'createdOn'
        $sql = "SELECT COUNT(*) AS total_rows FROM g2g WHERE YEAR(date) = YEAR(CURDATE()) AND user_id = '$user_id'";

        $result = array();
        $res = $con->query($sql);

        // Check if the query was successful
        if ($res === false) {
            die(json_encode(array('error' => 'Query failed: ' . $con->error)));
        }

        // Fetch the row count
        $row = $res->fetch_assoc();
        $totalRows = $row['total_rows'];

        // Return the row count as JSON response
        echo json_encode(array('totalRows' => $totalRows));
    } else {
        echo json_encode(array('error' => 'Missing or empty user_id parameter'));
    }
 }
                    else if ($table == "MyvisitorTotalYear") {
                          // Ensure user_id is provided and not empty
                          if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
                              $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
                              $sql = "SELECT COUNT(*) AS total_rows FROM visitors_slip WHERE user_id = '$user_id'";

                              $result = array();
                              $res = $con->query($sql);

                              // Check if the query was successful
                              if ($res === false) {
                                  die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                              }

                              // Fetch the row count
                              $row = $res->fetch_assoc();
                              $totalRows = $row['total_rows'];

                              // Return the row count as JSON response
                              echo json_encode(array('totalRows' => $totalRows));
                          } else {
                              echo json_encode(array('error' => 'Missing or empty user_id parameter'));
                          }
                      }
 else if ($table == "MyvisitorCurrentYear") {
     // Ensure user_id is provided and not empty
     if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
         $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
         // Assuming the date column is named 'createdOn'
         $sql = "SELECT COUNT(*) AS total_rows FROM visitors_slip WHERE YEAR(date) = YEAR(CURDATE()) AND user_id = '$user_id'";

         $result = array();
         $res = $con->query($sql);

         // Check if the query was successful
         if ($res === false) {
             die(json_encode(array('error' => 'Query failed: ' . $con->error)));
         }
         // Fetch the row count
         $row = $res->fetch_assoc();
         $totalRows = $row['total_rows'];

         // Return the row count as JSON response
         echo json_encode(array('totalRows' => $totalRows));
     } else {
         echo json_encode(array('error' => 'Missing or empty user_id parameter'));
     }
  }
                else if ($table == "MyhonorTotalYear") {
                            // Ensure user_id is provided and not empty
                            if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
                                $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
                                $sql = "SELECT sum(amount) AS total_rows FROM honoring_slip WHERE user_id = '$user_id'";

                                $result = array();
                                $res = $con->query($sql);

                                // Check if the query was successful
                                if ($res === false) {
                                    die(json_encode(array('error' => 'Query failed: ' . $con->error)));
                                }

                                // Fetch the row count
                                $row = $res->fetch_assoc();
                                $totalRows = $row['total_rows'];

                                // Return the row count as JSON response
                                echo json_encode(array('totalRows' => $totalRows));
                            } else {
                                echo json_encode(array('error' => 'Missing or empty user_id parameter'));
                            }
                        }
   else if ($table == "MyhonorCurrentYear") {
       // Ensure user_id is provided and not empty
       if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
           $user_id = $con->real_escape_string($_GET['user_id']); // Sanitize input
           // Assuming the date column is named 'createdOn'
           $sql = "SELECT SUM(amount) AS total_rows FROM honoring_slip WHERE YEAR(createdOn) = YEAR(CURDATE()) AND user_id = '$user_id'";

           $result = array();
           $res = $con->query($sql);

           // Check if the query was successful
           if ($res === false) {
               die(json_encode(array('error' => 'Query failed: ' . $con->error)));
           }
           // Fetch the row count
           $row = $res->fetch_assoc();
           $totalRows = $row['total_rows'];

           // Return the row count as JSON response
           echo json_encode(array('totalRows' => $totalRows));
       } else {
           echo json_encode(array('error' => 'Missing or empty user_id parameter'));
       }
    }
}
else {
    // Return a 405 Method Not Allowed if the request method is not GET
    http_response_code(405); // Method Not Allowed
    echo json_encode(array('error' => 'Method Not Allowed'));
}

// Close the database connection
$con->close();
?>
