<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "mysql-139adef5-kausalyas673.l.aivencloud.com"; 
$username = "avnadmin";                 
$password = "AVNS_qTmZSaWJRKOWR7fdfCs";                  
$dbname = "user_management";                   
$port = 28464;                              

$conn = new mysqli($servername, $username, $password, $dbname, $port);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Print the POST array for debugging
    echo '<pre>';
    print_r($_POST);
    echo '</pre>';

    // Sanitize inputs
    $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
    $password_raw = trim($_POST['password']);

    // Input validation
    if (empty($email) || empty($password_raw)) {
        die("Error: All fields are required.");
    }

    // Log the sanitized inputs for debugging
    echo "Received Email: $email<br>";

    // Prepare and execute SQL statement
    $stmt = $conn->prepare("SELECT password FROM users WHERE email = ?");
    if ($stmt === false) {
        die("Prepare failed: " . $conn->error);
    }

    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();
    $stmt->bind_result($hashed_password);
    $stmt->fetch();

    // Log the hashed password for debugging
    echo "Hashed Password: $hashed_password<br>";

    // Verify password
    if (password_verify($password_raw, $hashed_password)) {
        echo "success";
    } else {
        echo "failure";
    }

    $stmt->close();
} else {
    echo "Invalid request method.";
}

$conn->close();
?>
