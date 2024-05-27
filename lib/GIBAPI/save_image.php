<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');

$servername = "207.174.212.202";
 $username = "kanin7w7_gibErode";
 $password = "Kanxtl@6868#";
 $dbname = "kanin7w7_gibErode";
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


if (isset($_POST["data"])) {
    $data = $_POST["data"];
} else {
    die(json_encode(["success" => false, "error" => "Data not set."]));
}
if (isset($_POST["name"])) {
    $name = $_POST["name"];
} else {
    die(json_encode(["success" => false, "error" => "Name not set."]));
}
if (isset($_POST["mobile"])) {
    $mobile = $_POST["mobile"];
} else {
    die(json_encode(["success" => false, "error" => "mobile not set."]));
}
if (isset($_POST["password"])) {
    $password = $_POST["password"];
} else {
    die(json_encode(["success" => false, "error" => "password not set."]));
}
if (isset($_POST["email"])) {
    $email = $_POST["email"];
} else {
    die(json_encode(["success" => false, "error" => "email not set."]));
}
if (isset($_POST["member_type"])) {
    $member_type = $_POST["member_type"];
} else {
    die(json_encode(["success" => false, "error" => "member_type not set."]));
}
if (isset($_POST["first_name"])) {
    $first_name = $_POST["first_name"];
} else {
    die(json_encode(["success" => false, "error" => "first_name not set."]));
}
if (isset($_POST["last_name"])) {
    $last_name = $_POST["last_name"];
} else {
    die(json_encode(["success" => false, "error" => "last_name not set."]));
}
if (isset($_POST["company_name"])) {
    $company_name = $_POST["company_name"];
} else {
    die(json_encode(["success" => false, "error" => "company_name not set."]));
}

if (isset($_POST["blood_group"])) {
    $blood_group = $_POST["blood_group"];
} else {
    die(json_encode(["success" => false, "error" => "blood_group not set."]));
}
if (isset($_POST["place"])) {
    $place = $_POST["place"];
} else {
    die(json_encode(["success" => false, "error" => "place not set."]));
}
if (isset($_POST["pin"])) {
    $pin = $_POST["pin"];
} else {
    die(json_encode(["success" => false, "error" => "pin not set."]));
}
if (isset($_POST["place"])) {
    $place = $_POST["place"];
} else {
    die(json_encode(["success" => false, "error" => "place not set."]));
}
if (isset($_POST["referrer_mobile"])) {
    $referrer_mobile = $_POST["referrer_mobile"];
} else {
    die(json_encode(["success" => false, "error" => "referrer_mobile not set."]));
}
if (isset($_POST["OTP"])) {
    $OTP = $_POST["OTP"];
} else {
    die(json_encode(["success" => false, "error" => "OTP not set."]));
}
if (isset($_POST["block_status"])) {
    $block_status = $_POST["block_status"];
} else {
    die(json_encode(["success" => false, "error" => "block_status not set."]));
}
if (isset($_POST["admin_rights"])) {
    $admin_rights = $_POST["admin_rights"];
} else {
    die(json_encode(["success" => false, "error" => "admin_rights not set."]));
}
if (isset($_POST["type"])) {
    $type = $_POST["type"];
} else {
    die(json_encode(["success" => false, "error" => "type not set."]));
}
if (isset($_POST["district"])) {
    $district = $_POST["district"];
} else {
    die(json_encode(["success" => false, "error" => "district not set."]));
}
if (isset($_POST["chapter"])) {
    $chapter = $_POST["chapter"];
} else {
    die(json_encode(["success" => false, "error" => "chapter not set."]));
}

if (isset($_POST["koottam"])) {
    $koottam = $_POST["koottam"];
} else {
    die(json_encode(["success" => false, "error" => "koottam not set."]));
}
if (isset($_POST["marital_status"])) {
    $marital_status = $_POST["marital_status"];
} else {
    die(json_encode(["success" => false, "error" => "marital_status not set."]));
}
if (isset($_POST["business_type"])) {
    $business_type = $_POST["business_type"];
} else {
    die(json_encode(["success" => false, "error" => "business_type not set."]));
}if (isset($_POST["company_address"])) {
    $company_address = $_POST["company_address"];
} else {
    die(json_encode(["success" => false, "error" => "company_address not set."]));
}
if (isset($_POST["business_keywords"])) {
    $business_keywords = $_POST["business_keywords"];
} else {
    die(json_encode(["success" => false, "error" => "business_keywords not set."]));
}
if (isset($_POST["education"])) {
    $education = $_POST["education"];
} else {
    die(json_encode(["success" => false, "error" => "education not set."]));
}

if (isset($_POST["dob"])) {
    $dob = $_POST["dob"];
} else {
    die(json_encode(["success" => false, "error" => "dob not set."]));
}
if (isset($_POST["native"])) {
    $native = $_POST["native"];
} else {
    die(json_encode(["success" => false, "error" => "native not set."]));
}
if (isset($_POST["kovil"])) {
    $kovil = $_POST["kovil"];
} else {
    die(json_encode(["success" => false, "error" => "kovil not set."]));
}
if (isset($_POST["s_name"])) {
    $s_name = $_POST["s_name"];
} else {
    die(json_encode(["success" => false, "error" => "s_name not set."]));
}
if (isset($_POST["WAD"])) {
    $WAD = $_POST["WAD"];
} else {
    die(json_encode(["success" => false, "error" => "WAD not set."]));
}
if (isset($_POST["s_blood"])) {
    $s_blood = $_POST["s_blood"];
} else {
    die(json_encode(["success" => false, "error" => "s_blood not set."]));
}

if (isset($_POST["s_father_koottam"])) {
    $s_father_koottam = $_POST["s_father_koottam"];
} else {
    die(json_encode(["success" => false, "error" => "s_father_koottam not set."]));
}
if (isset($_POST["s_father_kovil"])) {
    $s_father_kovil = $_POST["s_father_kovil"];
} else {
    die(json_encode(["success" => false, "error" => "s_father_kovil not set."]));
}
if (isset($_POST["past_experience"])) {
    $past_experience = $_POST["past_experience"];
} else {
    die(json_encode(["success" => false, "error" => "past_experience not set."]));
}
if (isset($_POST["website"])) {
    $website = $_POST["website"];
} else {
    die(json_encode(["success" => false, "error" => "website not set."]));
}
if (isset($_POST["b_year"])) {
    $b_year = $_POST["b_year"];
} else {
    die(json_encode(["success" => false, "error" => "b_year not set."]));
}
if (isset($_POST["referrer_id"])) {
    $referrer_id = $_POST["referrer_id"];
} else {
    die(json_encode(["success" => false, "error" => "referrer_id not set."]));
}





$path = "upload/$name";
$query = "INSERT INTO `registration`(
`mobile`,
`password`,
`email`,
`member_type`,
`profile_image`,
`first_name`,
`last_name`,
`company_name`,
`blood_group`,
`place`,
`pin`,
`referrer_mobile`,
`OTP`,
`block_status`,
`admin_rights`,
`type`,
`district`,
`chapter`,
`koottam`,
`marital_status`,
`business_type`,
`company_address`,
`business_keywords`,
`education`,
`dob`,
`native`,
`kovil`,
`s_name`,
`WAD`,
`s_blood`,
`s_father_koottam`,
`s_father_kovil`,
`past_experience`,
`website`,
`b_year`,
`referrer_id`
)
VALUES (
'$mobile',
'$password',
'$email',
'$member_type',
'$path',
'$first_name',
'$last_name',
'$company_name',
'$blood_group',
'$place',
'$pin',
'$referrer_mobile',
'$OTP',
'$block_status',
'$admin_rights',
'$type',
'$district',
'$chapter',
'$koottam',
'$marital_status',
'$business_type',
'$company_address',
'$business_keywords',
'$education',
'$dob',
'$native',
'$kovil',
'$s_name',
'$WAD',
'$s_blood',
'$s_father_koottam',
'$s_father_kovil',
'$past_experience',
'$website',
'$b_year',
'$referrer_id'
)";
file_put_contents($path, base64_decode($data));
$arr = [];
$exe = mysqli_query($conn, $query);

if ($exe) {
    $arr["success"] = true;
} else {
    $arr["success"] = false;
}

echo json_encode($arr);

?>
