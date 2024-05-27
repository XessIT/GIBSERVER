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

// Assuming you are receiving data from the client, you can use $_POST for simplicity
$id = $_POST['id'];
$fname = $_POST['first_name'];
$mobile = $_POST['mobile'];
$lname = $_POST['last_name'];
$district = $_POST['district'];
$chapter = $_POST['chapter'];
$place = $_POST['place'];
$dob = $_POST['dob'];
$wad = $_POST['WAD'];
$koottam = $_POST['koottam'];
$kovil = $_POST['kovil'];
$blood = $_POST['blood_group'];
$email = $_POST['email'];
$s_name = $_POST['s_name'];
$native = $_POST['native'];
$skoottam = $_POST['s_father_koottam'];
$skovil = $_POST['s_father_kovil'];
$education = $_POST['education'];
$pexe = $_POST['past_experience'];
$company_name = $_POST['company_name'];
$company_address = $_POST['company_address'];
$business_type = $_POST['business_type'];
$website = $_POST['website'];
$business_keywords = $_POST['business_keywords'];
$marital_status = $_POST['marital_status'];
$b_year = $_POST['b_year'];
$member_type =$_POST['member_type'];
$gender =$_POST['gender'];
$role =$_POST['role'];

// Update data in the 'Registration' table
// $sql = "UPDATE Registration SET
//         first_name = '$fname',
//         last_name = '$lname',
//         mobile = '$mobile',
//         district = '$district',
//         chapter = '$chapter',
//         place = '$place',
//         dob = '$dob',
//         WAD = '$wad',
//         koottam = '$koottam',
//         kovil = '$kovil',
//         blood_group = '$blood',
//         email = '$email',
//         s_name = '$s_name',
//         native = '$native',
//         s_father_koottam = '$skoottam',
//         s_father_kovil = '$skovil',
//         education = '$education',
//          past_experience = '$pexe'
//         company_name = '$company_name'
//         company_address = '$company_address'
//         business_keywords = '$business_keywords'
//         business_type = '$business_type'
//         marital_status = '$marital_status'
//         website = '$website'
//         b_year = '$b_year'
//
//         WHERE id = '$id'";

// Update data in the 'Registration' table
$sql = "UPDATE registration SET
        first_name = '$fname',
        last_name = '$lname',
        mobile = '$mobile',
        district = '$district',
        chapter = '$chapter',
        place = '$place',
        dob = '$dob',
        WAD = '$wad',
        koottam = '$koottam',
        kovil = '$kovil',
        blood_group = '$blood',
        email = '$email',
        s_name = '$s_name',
        native = '$native',
        s_father_koottam = '$skoottam',
        s_father_kovil = '$skovil',
        education = '$education',
        past_experience = '$pexe',
        company_name = '$company_name',
        company_address = '$company_address',
        business_keywords = '$business_keywords',
        business_type = '$business_type',
        marital_status = '$marital_status',
        website = '$website',
        b_year = '$b_year',
        member_type ='$member_type',
        gender ='$gender',
        role ='$role'
        WHERE id = '$id'";

$result = $con->query($sql);

// Check if the query was successful
if ($result === false) {
    die("Query failed: " . $con->error);
}

// Close the database connection
$con->close();

// Output a success message or any relevant response
echo json_encode(array("message" => "User updated successfully"));
?>
