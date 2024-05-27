<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = new mysqli("207.174.212.202", "kanin7w7_gibErode", "Kanxtl@6868#", "kanin7w7_gibErode");

if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

$id = isset($_GET['id']) ? $_GET['id'] : null;
$admin_rights = isset($_GET['admin_rights']) ? $_GET['admin_rights'] : null;
$referer_mobile = isset($_GET['referrer_mobile']) ? $_GET['referrer_mobile'] : null;
$member_id = isset($_GET['member_id']) ? $_GET['member_id'] : null;
$mobile = isset($_GET['mobile']) ? $_GET['mobile'] : null;

$result = array();

// Query based on ID
if ($id !== null) {
    $sqlId = "SELECT * FROM registration WHERE id = ?";
    $stmtId = $con->prepare($sqlId);

    if (!$stmtId) {
        die("Prepare failed: " . $con->error);
    }

    $stmtId->bind_param("s", $id);
    $stmtId->execute();
    $resId = $stmtId->get_result();

    if ($resId === false) {
        die("ID query failed: " . $con->error);
    }

    while ($row = $resId->fetch_assoc()) {
        $result[] = $row;
    }

    $stmtId->close();
}

// Query based on referer_mobile and admin_rights
if ($referer_mobile !== null && $admin_rights !== null) {
    $sqlRefererMobileAndRights = "SELECT * FROM registration WHERE referrer_mobile = ? AND admin_rights = ?";
    $stmtRefererMobileAndRights = $con->prepare($sqlRefererMobileAndRights);

    if (!$stmtRefererMobileAndRights) {
        die("Prepare failed: " . $con->error);
    }

    $stmtRefererMobileAndRights->bind_param("ss", $referer_mobile, $admin_rights);
    $stmtRefererMobileAndRights->execute();
    $resRefererMobileAndRights = $stmtRefererMobileAndRights->get_result();

    if ($resRefererMobileAndRights === false) {
        die("Referer mobile and admin rights query failed: " . $con->error);
    }

    while ($row = $resRefererMobileAndRights->fetch_assoc()) {
        $result[] = $row;
    }

    $stmtRefererMobileAndRights->close();
}


 if ($mobile !== null) {
     $sqlMobile = "SELECT member_id FROM registration WHERE mobile = ?";
     $stmtMobile = $con->prepare($sqlMobile);

     if (!$stmtMobile) {
         die("Prepare failed: " . $con->error);
     }

     $stmtMobile->bind_param("s", $mobile);
     $stmtMobile->execute();
     $resMobile = $stmtMobile->get_result();

     if ($resMobile === false) {
         die("ID query failed: " . $con->error);
     }

     while ($row = $resMobile->fetch_assoc()) {
         $result[] = $row;
     }

     $stmtMobile->close();
 }

 if ($member_id !== null) {
      $sqlMemberId = "SELECT mobile FROM registration WHERE member_id = ?";
      $stmtMemberId = $con->prepare($sqlMemberId);

      if (!$stmtMemberId) {
          die("Prepare failed: " . $con->error);
      }

      $stmtMemberId->bind_param("s", $MemberId);
      $stmtMemberId->execute();
      $resMemberId = $stmtMemberId->get_result();

      if ($resMemberId === false) {
          die("ID query failed: " . $con->error);
      }

      while ($row = $resMemberId->fetch_assoc()) {
          $result[] = $row;
      }

      $stmtMemberId->close();
  }

$con->close();

// Output the JSON-encoded result
echo json_encode($result);
?>
