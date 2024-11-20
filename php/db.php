<?php
$host = 'localhost';  // Database host
$dbname = 'taxview360';  // Database name
$username = 'root';  // Database username
$password = '';  // Database password

try {
    // Include port if needed (default is 3306)
    $pdo = new PDO("mysql:host=$host;port=3306;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected to the database successfully!";
} catch (PDOException $e) {
    die("Could not connect to the database: " . $e->getMessage());
}
?>
